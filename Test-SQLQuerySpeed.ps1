# this script measures time taken on a specific query


# init
$username = 'Dimitri'
$password = 'Pa55w.rd'
$FQDN = 'tst5333535.database.windows.net'
$database = 'test'
$query = 'SELECT * FROM saleslt.customer' # sys.databases
$iterations = 1000


# setup
$connectionString = "Server=$FQDN;Initial Catalog=$database"   # or use Integrated Security=true;
 
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $securePassword   # Get-Credential

# Create the SqlCredential object
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
    $msg = "Time taken: {0}" -f $timespan
    if ($timespan.TotalSeconds -gt 1) {
        Write-Host $msg -ForegroundColor Yellow
    } else {
        Write-Host $msg
    }
    Start-Sleep 1
}

$sqlConn.Close()
