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
device.name3=OnePlus3T
device.name4=oneplus3t
supported.versions=8.0.0
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


## Alert of unsupported OxygenOS / Android version
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname);
if [ -z $oos_ver ]; then
    ui_print " ";
    ui_print "  OxygenOS only is supported!";
    ui_print "  - Installer will abort now.";
    ui_print " ";
    exit 0;
fi;


## AnyKernel install
dump_boot;


## begin ramdisk changes

# Import mcd.rc
insert_line init.rc "init.mcd.rc" before "import /init.usb.configfs.rc" "import /init.mcd.rc";
insert_line default.prop "ro.sys.fw.bg_apps_limit=60" before "ro.oxygen.version" "ro.sys.fw.bg_apps_limit=60";

## end ramdisk changes


# Give modules in ramdisk appropriate permissions to allow them to be loaded
find $ramdisk/modules -type f -exec chmod 644 {} \;


# Install the boot image
write_boot;
