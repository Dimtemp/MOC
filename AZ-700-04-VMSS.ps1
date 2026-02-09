# minimal PowerShell webserver

# Run as Administrator
$prefix = "http://+:80/"
netsh advfirewall set allprofiles state off
# netsh http add urlacl url=$prefix user="Everyone" | Out-Null

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Listening on $prefix"

while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $resp = $ctx.Response
  $bytes = [Text.Encoding]::UTF8.GetBytes("Hello from $($env:computername)")
  $resp.StatusCode = 200
  $resp.ContentType = "text/plain"
  $resp.OutputStream.Write($bytes, 0, $bytes.Length)
  $resp.Close()
}
