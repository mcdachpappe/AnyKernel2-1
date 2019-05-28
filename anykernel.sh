# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus3
device.name2=oneplus3
device.name3=oneplus3t
device.name4=OnePlus3T
supported.versions=8.1.0,9
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;


## Alert of unsupported OOS
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname);
if [ $oos_ver ]; then
    ui_print " ";
    ui_print "  Warning: incompatible ROM detected.";
    ui_print " ";
    ui_print "  This Kernel version does not support";
    ui_print "  OxygenOS. Please select the OxygenOS";
    ui_print "  version of this Kernel to proceed.";
    ui_print " ";
    ui_print "  - Installer will abort now.";
    exit 0;
fi;


## AnyKernel install
dump_boot;


# Install the boot image
write_boot;
