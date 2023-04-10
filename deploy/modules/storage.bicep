param storageAccountName string
param location string

resource r_StorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    isHnsEnabled: true
    supportsHttpsTrafficOnly: true
  }
}

resource r_StorageAccountBlobSvc 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: r_StorageAccount
}

resource r_storageStreamingContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'rawdatabatch'
  parent: r_StorageAccountBlobSvc
  }

resource r_storageBatchContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'rawdatastream'
  parent: r_StorageAccountBlobSvc
  }
 
resource r_storageDeltaContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'externaldatadbx'
  parent: r_StorageAccountBlobSvc
  }

resource r_storageAdxContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'externaldataadx'
  parent: r_StorageAccountBlobSvc
  }
