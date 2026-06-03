<#
.SYNOPSIS
    Measures the time taken to execute a specific SQL query against a database, and repeats this process for a specified number of iterations.
.EXAMPLE
    .\Test-SQLQuerySpeed.ps1 -username 'Dimitri' -password 'Pa55w.rd' -FQDN 'tstsqldb4.database.windows.net' -database 'test' -query 'SELECT * FROM saleslt.customer'
    This command will execute the specified SQL query against the database, measuring and displaying the time taken for each execution.
#>

[CmdletBinding()]
param(
    [string]
    $username,

    [string]
    $password,

    [string]
    $FQDN,

    [string]
    $database,

    [string]
    $query = 'SELECT * FROM sys.databases',

    [int]
    $iterations = 1000
)


# setup
$connectionString = "Server=$FQDN;Initial Catalog=$database"   # or use Integrated Security=true;

# Create the SqlCredential object
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $securePassword   # Get-Credential
$cred.Password.MakeReadOnly()
$sqlCred = New-Object System.Data.SqlClient.SqlCredential($cred.username,$cred.password)

# connect
$sqlConn = New-Object System.Data.SqlClient.SqlConnection
$sqlConn.ConnectionString = $connectionString
$sqlConn.Credential = $sqlCred
$sqlConn.Open()

$sqlcmd = $sqlConn.CreateCommand()
$sqlcmd.CommandText = $query

# get data
$adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
$data = New-Object System.Data.DataSet

for ($i=0; $i -lt $iterations; $i++) {
    $start = Get-Date
    $adp.Fill($data) | Out-Null
    # $data.Tables   # $data.Tables[0]

    $timespan = New-TimeSpan $start
    $msg = "{0}  Time taken: {1}" -f (Get-Date), $timespan
    if ($timespan.TotalSeconds -gt 1) {
        Write-Host $msg -ForegroundColor Yellow
    } else {
        Write-Host $msg
    }
    Start-Sleep 1
}

$sqlConn.Close()
