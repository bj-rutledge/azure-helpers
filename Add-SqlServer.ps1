# Created by BJ Rutledge 
# 9/11/2022
# Living with Conviction 
function Add-AzureSQLServer{
    <#
        .DESCRIPTION 
        Add-AzureSQLServer Creates an Azure SQL server and virtual network for accessing the server.        
        .EXAMPLE
        Add-AzureSQLServer 
    #>

  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true, 
        ValueFromPipeline=$true, 
        Position=0)]
    [string]$SubscriptionID,

    [Parameter(Mandatory=$true, 
        ValueFromPipeline=$true, 
        Position=1)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true, 
        ValueFromPipeline=$true, 
        Position=2)]
    [string]$location,
    
    [Parameter(Mandatory=$true, 
        ValueFromPipeline=$true, 
        Position=3)]
    [string]$AdminSqlLogin,

    [Parameter(Mandatory=$true, 
        ValueFromPipeline=$true, 
        Position=3)]
    [SecureString]$password,
    
    [Parameter(Mandatory=$true, 
        ValueFromPipeline=$true, 
        Position=4)]
    [string]$serverName,
    
    [Parameter(Mandatory=$true, 
        ValueFromPipeline=$true, 
        Position=5)]
    [string]$databaseName,
    
    [Parameter(Mandatory=$false, 
        ValueFromPipeline=$true, 
        Position=6)]
    [string]$startIp = '0.0.0.0',
    
    [Parameter(Mandatory=$false, 
        ValueFromPipeline=$true, 
        Position=7)]
    [string]$endIp = '0.0.0.0'
  )
  
  process {
    try {
        # # Connect-AzAccount
        # # The SubscriptionId in which to create these objects
        # $SubscriptionId = 'Azure subscription 1'
        # # Set the resource group name and location for your server
        # $ResourceGroupName = "myResourceGroup-$(Get-Random)"
        # $location = "East US"
        # # Set an admin login and password for your server
        # $AdminSqlLogin = "SqlAdmin"
        # $password = "testpassword1@"
        # # Set server name - the logical server name has to be unique in the system
        # $serverName = "server-$(Get-Random)"
        # # The sample database name
        # $databaseName = "mySampleDatabase"
        # # The ip address range that you want to allow to access your server
        # $startIp = "0.0.0.0"
        # $endIp = "0.0.0.0"
        
        # Set subscription 
        Set-AzContext -SubscriptionId $subscriptionId 
        
        # Create a resource group
        $resourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $location
        
        # Create a server with a system wide unique server name
        $server = New-AzSqlServer -ResourceGroupName $ResourceGroupName `
            -ServerName $serverName `
            -Location $location `
            -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AdminSqlLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))
        
        # Create a server firewall rule that allows access from the specified IP range
        $serverFirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName `
            -ServerName $serverName `
            -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp
        
        # Create a blank database with an S0 performance level
        $database = New-AzSqlDatabase  -ResourceGroupName $ResourceGroupName `
            -ServerName $serverName `
            -DatabaseName $databaseName `
            -RequestedServiceObjectiveName "S0" `
            -SampleName "AdventureWorksLT"
        
        
        # Clean up deployment   
        # Remove-AzResourceGroup -ResourceGroupName $ResourceGroupName
        
    }
    catch {
        <#Error#>
        Write-Error Error!!!
    }
    finally {
        <#Action complete#>
        Write-Host 'SQL Server set up!'
        Write-Host 'Resource Group: ' $resourceGroup
        Write-Host 'Server Firewall Rule' $serverFirewallRule
        Write-Host 'Server: ' $server 
        Write-Host 'Database: ' $database
    }
  }

}
