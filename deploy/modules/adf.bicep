param adfFactoryName string
param location string

resource symbolicname 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: adfFactoryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}
