Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$deviceId = "1234567890"
$endpoint = "http://localhost:8080/auth/checkloggedin/$deviceId"

do {
  try {
    $response = Invoke-RestMethod -Uri $endpoint
    if (-not $response.loggedIn) {
      [System.Windows.Forms.MessageBox]::Show("Please login to the ScanCar mobile app.", "Login Required", 'OK', 'Warning')
      Start-Sleep -Seconds 10
    } else {
      break
    }
  } catch {
    [System.Windows.Forms.MessageBox]::Show("Unable to connect to server.", "Network Error", 'OK', 'Error')
    Start-Sleep -Seconds 10
  }
  Start-Sleep -Seconds 5
} while ($true)
