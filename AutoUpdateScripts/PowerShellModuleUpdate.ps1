Write-Host "Executing local environment update"
# Begin DigitalWinners Powershell repository section
$digitalWinnersPowershellRepository = Get-PSRepository -Name $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME
$azureDevopsPackagingAccessToken = ConvertTo-SecureString $env:AZURE_DEVOPS_PAT -AsPlainText -Force
$credentialsPowershellDigitalWinners = New-Object System.Management.Automation.PSCredential ($env:AZURE_DEVOPS_USERNAME, $azureDevopsPackagingAccessToken)
if ($null -eq $digitalWinnersPowershellRepository) {
    Register-PSRepository -Name $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME -SourceLocation $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_URL -Credential $credentialsPowershellDigitalWinners -InstallationPolicy Trusted
}
# End DigitalWinners Powershell repository section

# Begin Azure credentials provider configuration
$env:VSS_NUGET_EXTERNAL_FEED_ENDPOINTS = "{`"endpointCredentials`": [{`"endpoint`":`"$env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_URL`", `"username`":`"$env:AZURE_DEVOPS_USERNAME`", `"password`":`"$env:AZURE_DEVOPS_PAT`"}]}"
# End Azure credentials provider configuration

Write-Host "Installing Digital Winners Powershell modules"
Install-Module DigitalWinners.ModuleBuilding -Repository $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME -Force -Credential $credentialsPowershellDigitalWinners
Install-Module DigitalWinners.SitePacking -Repository $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME -Force -Credential $credentialsPowershellDigitalWinners
Install-Module DigitalWinners.ContainerOperations -Repository $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME -Force -Credential $credentialsPowershellDigitalWinners
Install-Module DigitalWinners.DatabaseOperations -Repository $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME -Force -Credential $credentialsPowershellDigitalWinners
Install-Module DigitalWinners.SiteBuilding -Repository $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME -Force -Credential $credentialsPowershellDigitalWinners
Install-Module DigitalWinners.DisasterRecovery -Repository $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME -Force -Credential $credentialsPowershellDigitalWinners
Install-Module DigitalWinners.SiteConfiguration -Repository $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME -Force -Credential $credentialsPowershellDigitalWinners
Install-Module DigitalWinners.Utility -Repository $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME -Force -Credential $credentialsPowershellDigitalWinners

Unregister-PSRepository -Name $env:DIGITAL_WINNERS_POWERSHELL_REPOSITORY_NAME

Write-Host "Installing modules from Powershell repository"
Install-Module -Name Transferetto -AllowClobber -Force
Install-Module -Name AWS.Tools.Installer -Force -SkipPublisherCheck
Install-AWSToolsModule AWS.Tools.S3 -Force -SkipPublisherCheck
Write-Host "Finished installation of modules from Powershell repository"
