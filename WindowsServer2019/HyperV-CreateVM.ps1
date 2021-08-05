$VMHost = '192.168.103.13'
$VMname = 'TIADC1PSHDB01'
$Memory = 24GB
$vCPU = 4
$SwitchName = 'extvswitch'
$VMDir = 'C:\ClusterStorage\Volume1\Hyper-V\'
$disk1 = 300GB
$disk2 = 150GB

# Create a New VM
New-VM -Name $VMname -SwitchName $SwitchName -NoVHD -Generation 2 -MemoryStartupBytes $Memory -Path $VMDir -ComputerName $VMHost

# Copy Syspreped Golden Image
## Create a Virtual Disk Folder
##New-Item -ItemType Directory -Path "C:\ClusterStorage\Volume1\Hyper-V\$VMname\Virtual Hard Disks"
$fullpath = Join-Path $VMDir -ChildPath $VMname
New-Item -ItemType Directory -Path $fullpath -Name 'Virtual Hard Disks'

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
Resize-VHD -Path $Path -SizeBytes $disk1

# Set VM Parameters
#Set-VMMemory -VMName $VMname -DynamicMemoryEnabled $true -MaximumBytes $Memory
Set-VMProcessor -VMName $VMname -Count $vCPU 

# If need an additional harddisk
# Add additional harddisk
$Path = "C:\ClusterStorage\Volume1\Hyper-V\$VMname\Virtual Hard Disks\$VMname"+"_disk2.vhdx" 
New-VHD -Dynamic -SizeBytes $disk2 -Path $Path
Add-VMHardDiskDrive -VMName $VMname -Path $Path

#Start-VM -Name $VMname

 
