# Initialize to an empty hashtable to explicitly define the type as hashtable.
# This is needed to avoid the breaking change introduced in PowerShell 7.3 - https://github.com/PowerShell/PowerShell/issues/18524.
# https://github.com/microsoftgraph/msgraph-sdk-powershell/issues/2352
[hashtable]$adaptiveCard = @{}
$adaptiveCard += Get-Content -Path ".\resultLayout.json" -Raw | ConvertFrom-Json -AsHashtable

$externalConnection = @{
    userId     = "9da37739-ad63-42aa-b0c2-06f7b43e3e9e"
    connection = @{
        id               = "waldekblogpowershell"
        name             = "Waldek Mastykarz (blog); PowerShell"
        description      = "Tips and best practices for building applications on Microsoft 365 by Waldek Mastykarz - Microsoft 365 Cloud Developer Advocate"
        activitySettings = @{
            urlToItemResolvers = @(
                @{
                    "@odata.type" = "#microsoft.graph.externalConnectors.itemIdResolver"
                    urlMatchInfo  = @{
                        baseUrls   = @(
                            "https://blog.mastykarz.nl"
                        )
                        urlPattern = "/(?<slug>[^/]+)"
                    }
                    itemId        = "{slug}"
                    priority      = 1
                }
            )
        }
        searchSettings   = @{
            searchResultTemplates = @(
                @{
                    id       = "waldekblogpwsh"
                    priority = 1
                    layout   = @{
                        additionalProperties = $adaptiveCard
                    }
                }
            )
        }
    }
    # https://learn.microsoft.com/graph/connecting-external-content-manage-schema
    schema     = @(
        @{
            name          = "title"
            type          = "String"
            isQueryable   = "true"
            isSearchable  = "true"
            isRetrievable = "true"
            labels        = @(
                "title"
            )
        }
        @{
            name          = "excerpt"
            type          = "String"
            isQueryable   = "true"
            isSearchable  = "true"
            isRetrievable = "true"
        }
        @{
            name          = "imageUrl"
            type          = "String"
            isRetrievable = "true"
        }
        @{
            name          = "url"
            type          = "String"
            isRetrievable = "true"
            labels        = @(
                "url"
            )
        }
        @{
            name          = "date"
            type          = "DateTime"
            isQueryable   = "true"
            isRetrievable = "true"
            isRefinable   = "true"
            labels        = @(
                "lastModifiedDateTime"
            )
        }
        @{
            name          = "tags"
            type          = "StringCollection"
            isQueryable   = "true"
            isRetrievable = "true"
            isRefinable   = "true"
        }
    )
}