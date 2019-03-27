$a = Get-Process
Do {
  Sleep 1
  $b = Get-Process
  Compare-Object $a $b -Property id -passthru | foreach {
    $msg = "{0:hh:mm:ss} {1,5} pid {2,6:N0}MB vm {3,5:N0}MB ws  {4}  {5}" -f (get-date) , $_.id, ($_.vm/1MB), ($_.ws/1MB), $_.name, $_.path
    if ($_.sideIndicator -eq "=>") { Write-Host $msg -foregroundcolor green  }   # new process running
    if ($_.sideIndicator -eq "<=") { Write-Host $msg -foregroundcolor yellow }   # existing process stopped
  } # foreach
  $a = $b
} while ( 1 -eq $true)
