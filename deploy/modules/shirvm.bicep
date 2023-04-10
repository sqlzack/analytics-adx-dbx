@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
param OSVersion string

@description('Size of the virtual machine.')
param vmSize string

@description('Name of the virtual machine.')
param vmName string

@description('Id of the NIC in the Virtual Network that is associated with the VM')
param nicId string

@description('Location for all resources.')
param location string = resourceGroup().location


var storageAccountName = 'shirvmdx${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}


resource r_vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stg.properties.primaryEndpoints.blob
      }
    }
  }
}


// resource r_bastionHost 'Microsoft.Network/bastionHosts@2022-07-01' = {
//   name: bastionHostName
//   location: location
//   sku: {
//     name: 'Basic'
//   }
//   properties: {
//     disableCopyPaste: false
//     enableIpConnect: false
//     enableShareableLink: false
//     enableTunneling: false
//     ipConfigurations: [
//       {
//         name: 'bastionIpConf'
//         properties: {
//           publicIPAddress: {
//             id: r_pipBastion.id
//           }
//           subnet: {
//             id: r_bastionSubnet.id
//           }
//         }
//       }
//     ]
//     scaleUnits: 2
//   }
// }
