# Created by BJ Rutledge 
# 9/12/2022
# Living with Conviction 


function Set-MachineConfiguration{
    <#
        .DESCRIPTION 
            Configure your machine to interact with Azure. 
        .EXAMPLE
            Set-MachineConfigureation 
    #>
    function output {
        Write-Host 'To do so, run:'
        Write-Host 'Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned '
        [string]$startPs7 = Read-Host 'You will now need to launch Powershell Version 7. Would you like me to open if for you?' 
        if($startPs7.ToLower() -eq 'yes' -or $startPs7.ToLower() -eq 'y'){
            Start-Process 'C:\Program Files\PowerShell\7\pwsh.exe'
        }
        
    }
    if((Get-ChildItem -ErrorAction SilentlyContinue 'C:\Program Files\PowerShell\7\pwsh.exe').Length -gt 0){
        Write-Host 'It looks like you already have PowerShell Version 7 on your machine. You will have to enable scripts in version 7.'
        output
    }
    try {
        #Search for the latest version of PowerShell
        # winget search Microsoft.PowerShell
        Write-Host 'We will now load the latest version of powershell to your machine.'
        winget install --id Microsoft.Powershell --source winget
        winget install --id Microsoft.Powershell.Preview --source winget
        Write-Host 'Now that we have the latest powershell, you will need to start the new version and enable scripts.'
        output 
    }
    catch {
        {1:<#It looks like we hit a snag. Please contact your system admin for assistance.#>}
    }
}