#TIADC1PDLP01	192.168.103.70	Internal	Production	Primary	>= 2G	8	32	300	600	SAN Storage

$VMname = 'New Virtual Machine'
$Memory = 32GB
$vCPU = 8
$GoldenImageDir = ""
$VMStorage = ""

# Interactive Mode
# $VMname = Read-Host -Prompt "VMname"


# Create a New VM
New-VM -Name $VMname -SwitchName extvswitch -NoVHD -Generation 2 -MemoryStartupBytes $Memory -Path C:\ClusterStorage\Volume1\Hyper-V\


# Copy Syspreped Golden Image
## Create a Virtual Disk Folder
New-Item -ItemType Directory -Path "C:\ClusterStorage\Volume1\Hyper-V\$VMname\Virtual Hard Disks"

#Copy-Item `
#-Path 'C:\source\Hyper-V Golden Image\GoldenImage.vhdx' `
#-Destination "C:\ClusterStorage\Volume1\Hyper-V\$VMname\Virtual Hard Disks\$VMname.vhdx"

# Using BitsTransfer to Copy 
$Destination = "C:\ClusterStorage\Volume1\Hyper-V\$VMname\Virtual Hard Disks\$VMname"+"_disk1.vhdx" 

Start-BitsTransfer `
-Source 'C:\source\Hyper-V Golden Image\GoldenImage.vhdx' `
-Destination $Destination


# Attached the Golden Image to VM
$Path = "C:\ClusterStorage\Volume1\Hyper-V\$VMname\Virtual Hard Disks\$VMname"+"_disk1.vhdx" 
Add-VMHardDiskDrive -VMName $VMname -Path $Path

# Set VM Parameters
#Set-VMMemory -VMName $VMname -DynamicMemoryEnabled $true -MaximumBytes $Memory
Set-VMProcessor -VMName $VMname -Count $vCPU 


