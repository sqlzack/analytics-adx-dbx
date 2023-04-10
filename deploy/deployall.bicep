// Parameters used in multiple 
@description('Region resources will be deployed to')
param location string

// VM Parameters
@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Name of Virtual Machine. Resource Group Unique. 1-15 Alphanumeric or hyphen characters. End with Alphanumeric.')
param vmName string

@description('The version of Windows deployed with the Virtual Machine. All code was tested on the default below.')
param OSVersion string = '2022-datacenter-azure-edition'

@description('The SKU of VM used for the Self Hosted Integration Runtime. All code was tested on the default below.')
param vmSize string ='Standard_D2s_v5'

// Event Hub Parameters
@description('Event Hub Name. Azure Globally Unique. 6-50 Alphanumerics, periods, hyphens, and underscores. End with alphanumeric')
param eventHubNamespaceName string

// Bastion Parameters
@description('Name of Bastion Host. Resource Group Unique.1-80 Alphanumerics, underscores, periods, and hyphens.')
param bastionHostName string

@description('Public IP Name. Resource Group Unique.1-80 Alphanumerics, underscores, periods, and hyphens. End with alphanumeric')
param bastionPublicIpName string

// Logic App Parameters
@description('Name of the Logic App used to deploy Bastion Host. Resource Group Unique. Alphanumerics, hyphens, underscores, periods, and parenthesis.')
param logicAppCreateBastionName string

@description('Name of the Logic App used to delete Bastion Host. Resource Group Unique. Alphanumerics, hyphens, underscores, periods, and parenthesis.')
param logicAppDeleteBastionName string

// Storage Account Parameters
@description('Name of Primary Storage Account used to store data. Global Azure Unique. 3-24 Lowercase letters and numbers.')
param storageAccountName string

// Data Explorer Parameters.
@description('Data Explorer Cluster Name. Global Azure Unique. 4-22 Lowercase letters and numbers. Start with letter.')
param dataExplorerResourceName string

// Key Vault Parameters 
@description('Azure Key Vault Name. Global Azure Unique. 3-24 Alphanumerics and hyphens. Start with letter and end with letter or digit')
param keyVaultName string

// Data Factory Parameters
@description('Azure Data Factory Name. Global Azure Unique. 3-63 Alphanumerics and hyphens. Start and end with alphanumeric.')
param adfFactoryName string

@description('Databricks Workspace Name. Resource Group Unique. 3-64 Alphanumerics, underscores, and hyphens')
param databricksWorkspaceName string

module m_eventHubDeploy 'modules/eventhub.bicep' = {
  name:'eventHubDeploy'
  params: {
    eventHubNamespaceName: eventHubNamespaceName
    location: location
  }
}

module m_adxStandaloneDeploy 'modules/adxStandalone.bicep' = {
  name:'adxDeploy'
  params: {
    dataExplorerResourceName: dataExplorerResourceName
    location: location
  }
}

module m_akvDeploy 'modules/keyvault.bicep' = {
  name: 'keyVaultDeploy'
  params:{
    keyVaultName: keyVaultName
    location: location
  }
}

module m_networkDeploy 'modules/network.bicep' = {
  name:'NetworkDeploy'
  params: {
    bastionPublicIpName: bastionPublicIpName
    location: location
  }
}

module m_storageDeploy 'modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

module m_shirVmDeploy 'modules/shirvm.bicep' = {
  name: 'selfHostedIRDeploy'
  dependsOn: [m_networkDeploy]
  params:{
    adminPassword: adminPassword
    adminUsername: adminUsername
    OSVersion: OSVersion
    vmName: vmName
    vmSize: vmSize
    location: location
    nicId: m_networkDeploy.outputs.nicId
  }
}

module m_logicAppBastionCreate 'modules/logicApp_createBastion.bicep' = {
  name: 'logicApp_createBastion'
  dependsOn:[m_networkDeploy]
  params: {
    location: location
    logicAppName: logicAppCreateBastionName
    publicIpResourceId: m_networkDeploy.outputs.publicIpResourceId
    bastionSubnetResourceId: m_networkDeploy.outputs.bastionSubnetResourceId
    bastionName: bastionHostName
  }
}

module m_logicAppBastionDelete 'modules/logicApp_deleteBastion.bicep' = {
  name: 'logicApp_deleteBastion'
  params: {
    bastionName: bastionHostName
    logicAppName: logicAppDeleteBastionName
    location: location
  }
}

module m_adfDeploy 'modules/adf.bicep' = {
  name: 'adfDeploy'
  params: {
    adfFactoryName: adfFactoryName
    location: location
  }
}

module m_dbxDeploy 'modules/databricks.bicep' = {
  name: 'dbxDeploy'
  params: {
    workspaceName: databricksWorkspaceName
    location: location
  }
}
