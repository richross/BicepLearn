@allowed([
    'nonprod'
    'prod'
])
param environmentType string

param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param resourceLocation string = resourceGroup().location

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: resourceLocation
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: resourceLocation
    appServiceAppName: appServiceAppName
    environmentType: environmentType
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
