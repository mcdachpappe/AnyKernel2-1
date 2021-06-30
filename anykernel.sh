# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus6
device.name2=enchilada
device.name3=OnePlus6T
device.name4=fajita
supported.versions=10 - 11
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## Trim data partition
$bin/busybox fstrim -v /data;

## AnyKernel boot install
dump_boot;

# Clean up other kernels' ramdisk overlay files
find ./overlay.d -maxdepth 2 -type f ! -name "*magisk*" -exec rm {} \;

write_boot;
## end install
