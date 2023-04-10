@description('Name of the Bastion Public IP')
param bastionPublicIpName string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Unique DNS Name for the Public IP used for Bastion Host')
var bastionDnsLabelPrefix = toLower('${bastionPublicIpName}-${uniqueString(resourceGroup().id, bastionPublicIpName)}')

var nicName = 'shirVmNic'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'shirVmSubnet'
var subnetPrefix = '10.0.0.0/24'
var virtualNetworkName = 'shirVmVnet'


resource vn 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: subnetName
  parent:vn
  properties: {
    addressPrefix: subnetPrefix
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          // publicIPAddress: {
          //   id: pip.id
          // }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}


resource r_pipBastion 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: bastionPublicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: bastionDnsLabelPrefix
    }
  }
}

resource r_bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: 'AzureBastionSubnet'
  dependsOn:[subnet]
  parent: vn
    properties: {
      addressPrefix: '10.0.1.0/26'
    }
}

output nicId string = nic.id
output bastionSubnetResourceId string = r_bastionSubnet.id
output publicIpResourceId string = r_pipBastion.id
