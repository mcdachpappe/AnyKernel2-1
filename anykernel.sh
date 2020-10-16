# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus6
device.name2=enchilada
device.name3=OnePlus6T
device.name4=fajita
supported.versions=10 - 11
'; } # end properties

# shell variables
block=boot;
is_slot_device=1;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel install
dump_boot;

# Clean up other kernels' ramdisk overlay files
rm -rf $ramdisk/overlay;

# Get string to detect OxygenOS
str_oos="$(grep "^ro.oxygen.version" /system/build.prop | cut -d= -f2)";

# Reset cmdline
patch_cmdline "is_custom_rom" "";

# Patch cmdline if OxygenOS is not present
if [ -z "$str_oos" ]; then
   patch_cmdline "is_custom_rom" "is_custom_rom";
fi;

# Install the boot image
write_boot;

## end install

