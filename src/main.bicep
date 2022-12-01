@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param storageAccountType string = 'Standard_LRS'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the function app')
param functionAppName string = 'fnapp${uniqueString(resourceGroup().id)}'

@description('The name of the API Management service instance')
param apiManagementServiceName string = 'apiservice${uniqueString(resourceGroup().id)}'

@description('The email address of the owner of the service')
@minLength(1)
param publisherEmail string = 'keiranbatten1998@gmail.com'

@description('The name of the owner of the service')
@minLength(1)
param publisherName string = 'Keiran Batten'

var storageAccountName = '${uniqueString(resourceGroup().id)}azfunctions'

module storageAccount '../modules/storage-account/main.bicep' = {
  name: 'storage-account'
  params: {
    storageAccountType: storageAccountType
    location: location
    storageAccountName: storageAccountName
  }
}

module applicationInsights '../modules/application-insights/main.bicep' = {
  name: 'application-insights'
  params: {
    applicationInsightsName: functionAppName
    location: location
  }
}

module functionApp '../modules/function-app/main.bicep' = {
  name: 'function-app'
  params: {
    appName: functionAppName
    location: location
    appInsightsInstrumentationKey: applicationInsights.outputs.appInsightsInstrumentationKey
    storageAccountName: storageAccountName
  }
  dependsOn: [storageAccount, applicationInsights]
}

// module apiManagementService '../modules/api-management/main.bicep' = {
//   name: 'api-management'
//   params: {
//     apiManagementServiceName: apiManagementServiceName
//     publisherEmail: publisherEmail
//     publisherName: publisherName
//     location: location
//   }
// }
