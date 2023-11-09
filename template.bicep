param connections_servicenow_name string = 'S4MSCServiceNowTest'
param region string = 'uksouth'
param tenantId string = ''
param clientId string = ''
param secret string = ''
param snowInstance string = ''
param snowUsername string = ''
param snowPassword string = ''

var workflows_SearchConnectorSetup_name_var = 'la-${connections_servicenow_name}-setup'
var workflows_SearchConnectorSearch_name_var = 'la-${connections_servicenow_name}-search'
var graphConnectorUrl = 'https://graph.microsoft.com/beta/external/connections/${connections_servicenow_name}'

resource service_now 'Microsoft.Web/connections@2016-06-01' = {
  name: 'service-now'
  location: region
  kind: 'V1'
  properties: {
    displayName: 'ServiceNow'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {}
    api: {
      name: 'service-now'
      displayName: 'ServiceNow'
      description: 'ServiceNow is an online social networking service that enables users to send and receive short messages called \'tweets\'. Connect to ServiceNow to manage your tweets. You can perform various actions such as send tweet, search, view followers, etc.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1473/1.0.1473.2431/servicenow/icon.png'
      brandColor: '#5fa9dd'
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${region}/managedApis/service-now'
      type: 'Microsoft.Web/locations/managedApis'
    }
    parameterValues: {
      instance: snowInstance
      username: snowUsername
      password: snowPassword
    }
    testLinks: []
  }
}

resource workflows_SearchConnectorSetup_name 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_SearchConnectorSetup_name_var
  location: region
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      actions: {
        Check_ServiceNowSearchConnector_exists: {
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              clientId: clientId
              secret: secret
              tenant: tenantId
              type: 'ActiveDirectoryOAuth'
            }
            method: 'GET'
            uri: graphConnectorUrl
          }
          runAfter: {}
          type: 'Http'
        }
        Check_schema_exists: {
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              clientId: clientId
              secret: secret
              tenant: tenantId
              type: 'ActiveDirectoryOAuth'
            }
            method: 'GET'
            uri: '${graphConnectorUrl}/schema'
          }
          runAfter: {
            'Create_S4MSC-ServiceNowSearchConnector_if_not_exist': [
              'Succeeded'
              'Skipped'
            ]
          }
          type: 'Http'
        }
        'Create_S4MSC-ServiceNowSearchConnector_if_not_exist': {
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              clientId: clientId
              secret: secret
              tenant: tenantId
              type: 'ActiveDirectoryOAuth'
            }
            body: {
              description: 'Connector for showing key tweets'
              id: connections_servicenow_name
              name: 'ServiceNow Connector'
              state: 'ready'
              enabledContentExperiences: 'search'
              configuration: {
                authorizedApps: [
                  clientId
                ]
                authorizedAppIds: [
                  clientId
                ]
              }
              searchSettings: {
                searchResultTemplates: [
                  {
                    id: connections_servicenow_name
                    layout: {
                      type: 'AdaptiveCard'
                      version: '1.3'
                      body: [
                        {
                          type: 'ColumnSet'
                          columns: [
                            {
                              type: 'Column'
                              width: 'auto'
                              items: [
                                {
                                  type: 'Image'
                                  url: 'https://searchuxcdn.blob.core.windows.net/designerapp/images/DefaultMRTIcon.png'
                                  size: 'Small'
                                  horizontalAlignment: 'Center'
                                  description: 'Thumbnail image'
                                }
                              ]
                              height: 'stretch'
                            }
                            {
                              type: 'Column'
                              width: 8
                              horizontalAlignment: 'Center'
                              spacing: 'Medium'
                              items: [
                                {
                                  type: 'TextBlock'
                                  text: 'https://dev165113.service-now.com/'
                                  weight: 'Bolder'
                                  color: 'Accent'
                                  size: 'Medium'
                                  maxLines: 3
                                }
                                {
                                  type: 'TextBlock'
                                  text: '\${description}'
                                  wrap: true
                                  maxLines: 3
                                  spacing: 'Medium'
                                }
                              ]
                            }
                            {
                              type: 'Column'
                              width: 2
                              items: [
                                {
                                  type: 'Image'
                                  url: '\${image}'
                                  description: '\${description}'
                                  horizontalAlignment: 'Center'
                                }
                              ]
                              '$when': '\${image != \'\'}'
                            }
                          ]
                        }
                      ]
                      '$schema': 'http://adaptivecards.io/schemas/adaptive-card.json'
                    }
                    priority: 0
                  }
                ]
              }
            }
            method: 'POST'
            uri: 'https://graph.microsoft.com/beta/external/connections'
          }
          runAfter: {
            Check_ServiceNowSearchConnector_exists: [
              'Failed'
            ]
          }
          type: 'Http'
        }
        Create_schema_if_it_not_exists: {
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              clientId: clientId
              secret: secret
              tenant: tenantId
              type: 'ActiveDirectoryOAuth'
            }
            body: {
              baseType: 'microsoft.graph.externalItem'
              properties: [
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'price'
                  type: 'double'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'productid'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'group'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'order'
                  type: 'double'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'image'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'workflow'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'active'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'name'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'shortdescription'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'icon'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'description'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'vendor'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: true
                  name: 'sccatalogs'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'cost'
                  type: 'double'
                }
              ]
            }
            method: 'POST'
            uri: '${graphConnectorUrl}/schema'
          }
          runAfter: {
            Check_schema_exists: [
              'Failed'
            ]
          }
          type: 'Http'
        }
      }
      contentVersion: '1.0.0.0'
      outputs: {}
      parameters: {}
      triggers: {
        manual: {
          inputs: {
            schema: {}
          }
          kind: 'Http'
          type: 'Request'
        }
      }
    }
    parameters: {}
  }
  dependsOn: [
    service_now
  ]
}

resource workflows_SearchConnectorSearch_name 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_SearchConnectorSearch_name_var
  location: region
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {}
          }
        }
      }
      actions: {
        For_each: {
          foreach: '@body(\'List_Records\')?[\'result\']'
          actions: {
            Create_index_if_not_exists: {
              runAfter: {
                Get_item_from_index_by_Product_Id: [
                  'Failed'
                ]
              }
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  clientId: clientId
                  secret: secret
                  tenant: tenantId
                  type: 'ActiveDirectoryOAuth'
                }
                body: {
                  acl: [
                    {
                      accessType: 'grant'
                      identitySource: 'azureActiveDirectory'
                      type: 'everyone'
                      value: '43c5e796-f484-4157-8c93-73ac8b1cf7bf'
                    }
                  ]
                  content: {
                    type: 'text'
                    value: '@{items(\'For_each\')?[\'sys_name\']}'
                  }
                  properties: {
                    cost: '@float(items(\'For_each\')?[\'cost\'])'
                    description: '@{items(\'For_each\')?[\'description\']}'
                    group: '@{items(\'For_each\')?[\'group\']}'
                    name: '@{items(\'For_each\')?[\'name\']}'
                    order: '@float(items(\'For_each\')?[\'order\'])'
                    price: '@float(items(\'For_each\')?[\'price\'])'
                    shortdescription: '@{items(\'For_each\')?[\'short_description\']}'
                  }
                  type: 'microsoft.graph.externalItem'
                }
                method: 'PUT'
                uri: '${graphConnectorUrl}/items/@{items(\'For_each\')?[\'sys_id\']}'
              }
            }
            Get_item_from_index_by_Product_Id: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  clientId: clientId
                  secret: secret
                  tenant: tenantId
                  type: 'ActiveDirectoryOAuth'
                }
                method: 'GET'
                uri: '${graphConnectorUrl}/items/@{items(\'For_each\')?[\'sys_id\']}'
              }
            }
          }
          runAfter: {
            List_Records: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
          runtimeConfiguration: {
            concurrency: {
              repetitions: 1
            }
          }
        }
        List_Records: {
          runAfter: {}
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'service-now\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/api/now/v2/table/@{encodeURIComponent(\'pc_product_cat_item\')}'
            queries: {
              sysparm_display_value: false
              sysparm_exclude_reference_link: true
              sysparm_query: 'fields=price,product_id,sys_name,model,state,group,order,image,active,name,vendor_catalog_item,short_description,icon,description,availability,owner,list_price,recurring_price'
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          'service-now': {
            connectionId: service_now.id
            connectionName: 'service-now'
            id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${region}/managedApis/service-now'
          }
        }
      }
    }
  }
}