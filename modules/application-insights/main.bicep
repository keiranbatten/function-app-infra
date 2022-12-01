@description('Name of the app insights')
param applicationInsightsName string

@description('Location for the application insights')
param location string

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}

output appInsightsId string = applicationInsights.id
output appInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey
