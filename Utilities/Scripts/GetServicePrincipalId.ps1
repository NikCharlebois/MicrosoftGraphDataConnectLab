param(
    [string] [Parameter(Mandatory=$true)] $AppId,
    [string] [Parameter(Mandatory=$true)] $TenantId,
    [string] [Parameter(Mandatory=$true)] $AppToGet
)
$InformationPreference = 'Continue'
Write-Information "Installing Modules..."
Install-Module Microsoft.Graph.Authentication -Force | Out-Null
Import-Module Microsoft.Graph.Authentication -Force | Out-Null
Install-Module Microsoft.Graph.Applications -Force | Out-Null
Import-Module Microsoft.Graph.Applications -Force | Out-Null
Write-Information "Done"

Write-Information "Authenticating to the Microsoft Graph..."
$url = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
$body = @{
    scope = "https://graph.microsoft.com/.default"
    grant_type = "client_credentials"
    client_secret = ${Env:AppSecret}
    client_info = 1
    client_id = $AppId
}

$OAuthReq = Invoke-RestMethod -Uri $url -Method Post -Body $body
$AccessToken = $OAuthReq.access_token
Connect-MgGraph -AccessToken $AccessToken | Out-Null
Write-Information "Done"

Write-Information "Obtaining Service Principal Info..."
$application = Get-MgServicePrincipal -All:$true -Filter "AppID eq '$AppToGet'"
$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['PrincipalId'] = $application.Id
Write-Information "Done {$application.Id}"