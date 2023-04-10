@description('The name of the logic app to create.')
param logicAppName string

@description('bastionName')
param bastionName string

@description('Name of the PublicIp for use with Bastion')
param publicIpResourceId string

@description('Name of the subnet Bastion resides in.')
param bastionSubnetResourceId string

@description('subscriptionId')
param subscriptionId string = subscription().id

@description('Location for all resources.')
param location string = resourceGroup().location

param rg string = resourceGroup().name

var ipConfigurations = [
  {
    name:'bastionHostIpConfiguration'
    properties: {
      publicIpAddress: {
        id: publicIpResourceId
      }
      subnet: {
        id: bastionSubnetResourceId
      }
    }
  }
]

// var frequency = 'Day'
// var interval = '1'
// var type = 'recurrence'
var actionType = 'http'
var method = 'PUT'
var workflowSchema = 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
var createUri = 'https://management.azure.com${subscriptionId}/resourceGroups/${rg}/providers/Microsoft.Network/bastionHosts/${bastionName}/?api-version=2020-06-01'

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
        manual: {
          type: 'Request'
          kind: 'http'
          inputs: {
            schema: {
              properties: {
                Action: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      actions: {
        createBastion: {
          type: actionType
          inputs: {
            authentication: {
              type: 'ManagedServiceIdentity'
            }
            body: {
                location: location
                properties: {
                  ipConfigurations: ipConfigurations
                }
              }
            method: method
            uri: createUri
          }
        }
      }
    }
  }
}
