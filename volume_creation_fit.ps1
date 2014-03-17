

###==== Set Variables ====###

$Source = $na002
$Vfiler = "vffit8x"
$Dest = $fitn09p028

###==== Set Dest aggr ====###

$aggr = "aggr1"

###==== Get Volumes from Source  ====###

$source_vols = Get-NaVol -Controller $Source |  ? {$_.OwningVfiler -eq "$Vfiler"} | ? {$_.CloneParent -eq $null} | ? {$_.Name -ne "vol0"} 

###==== Get volume properties ====###

foreach ($vol in $source_vols) {

    $size = Get-NaVolSize -Controller $Source -Name $vol.Name
    $guarantee = ((Get-NaVolOption -controller $Source -Name $vol.Name) | ? { $_.Name -eq "actual_guarantee" }).Value
    $fracres_percent = ((Get-NaVolOption -Controller $Source -Name $vol.Name) | ? { $_.Name -eq "fractional_reserve" }).Value
    $snapres_percent = (Get-NaSnapshotReserve -Controller $Source -TargetName $vol.Name).Percentage
     
###=== Create the new volume and set guarantees appropriately on Destination System ===###
    New-NaVol -Controller $Dest -Name $vol.Name -Aggregate $aggr -size $size.VolumeSize -SpaceReserve $guarantee }

