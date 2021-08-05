Start-Transcript

$computerName= "Virtual Machine Name"
$ipAddress= "192.168.103.59"
$ipPrefix= "24"
$ipGW= "192.168.103.1"
$ipDNS= ("192.168.103.31", "192.168.103.32","192.168.4.31", "8.8.8.8")
$ipIF= (Get-NetAdapter).ifIndex
$ipv6 = (Get-NetAdapterBinding -ComponentID ms_tcpip6).ifAlias

Write-Verbose 'Set Timezone & Usage Location' -Verbose
Set-TimeZone -Id 'China Standard Time'
Set-WinHomeLocation -GeoId 104


# Before Setting Static IP, Dhcp must be disabled first
Write-Verbose 'Disable Dhcp' -Verbose
Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter).interfaceguid)” -Name EnableDHCP -Value 0
#Get-NetIPInterface | Select-Object InterfaceAlias, Dhcp

# Now Setting Static IP
Write-Verbose 'Setting Static IP' -Verbose
New-NetIPAddress -InterfaceIndex $ipIF -IPAddress $ipAddress -PrefixLength $ipPrefix -DefaultGateway $ipGW 
Get-NetIPAddress -ifIndex $ipIF -AddressFamily IPv4

# Now Setting DNS Server IP
Write-Verbose 'Setting DNS Server Address' -Verbose
Set-DNSClientServerAddress –interfaceIndex $ipIF –ServerAddresses $ipDNS

# Now disable IPv6
Write-Verbose 'Disable IPv6' -Verbose
Disable-NetAdapterBinding -Name $ipv6 -ComponentID ms_tcpip6

# Enable remote desktop
Write-Verbose 'Enable Remote Desktop' -Verbose
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" –Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Now Renaming Computer
Write-Verbose 'Renaming Computer' -Verbose
Rename-Computer -NewName $computerName -force
Read-Host "Press any key to restart"
Restart-Computer 
