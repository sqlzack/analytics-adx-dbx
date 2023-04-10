@description('The name of the logic app to create.')
param logicAppName string

@description('bastionName')
param bastionName string

@description('subscriptionId')
param subscriptionId string = subscription().id

@description('Location for all resources.')
param location string = resourceGroup().location

param rg string = resourceGroup().name

@description('The hours you want the logic apps to run Daily')
param hours array = [18]

var frequency = 'Day'
var interval = '1'
var type = 'recurrence'
var actionType = 'http'
var method = 'DELETE'
var workflowSchema = 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
var deleteUri = 'https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${rg}/providers/Microsoft.Network/bastionHosts/${bastionName}/?api-version=2020-06-01'

resource r_LogicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  identity:{
    type: 'SystemAssigned'
  }
  properties: {
    definition: {
      '$schema': workflowSchema
      contentVersion: '1.0.0.0'
      parameters: {}
      triggers: {
        recurrence: {
          type: type
          recurrence: {
            frequency: frequency
            interval: interval
            schedule: {
              hours: hours
            }
          }
        }
      }
      actions: {
        actionType: {
          type: actionType
          inputs: {
            authentication: {
              type: 'ManagedServiceIdentity'
            }
            method: method
            uri: deleteUri
          }
        }
      }
    }
  }
}
