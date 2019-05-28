# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus3
device.name2=oneplus3
device.name3=OnePlus3T
device.name4=oneplus3t
supported.versions=9
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


## Alert of unsupported Android version
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname);
if [ -z $oos_ver ]; then
    ui_print " ";
    ui_print "  Warning: Only OxygenOS is supported!";
    ui_print " ";
    ui_print "  - Installer will abort now.";
    ui_print " ";
    exit 0;
fi;


## AnyKernel install
dump_boot;


# Give modules in ramdisk appropriate permissions to allow them to be loaded
find $ramdisk/modules -type f -exec chmod 644 {} \;


# Install the boot image
write_boot;
