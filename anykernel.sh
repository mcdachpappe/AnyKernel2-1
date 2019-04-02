# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=OnePlus3
device.name2=oneplus3
device.name3=oneplus3t
device.name4=OnePlus3T
supported.versions=8.1.0,9
'; } # end properties

# shell variables
block=/dev/block/platform/soc/624000.ufshc/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;

## end setup

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;

## Alert of unsupported OOS
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname)
if [ "$oos_ver" != "" ]; then
    ui_print "  This kernel version was not designed for";
    ui_print "  OxygenOS. Please select the OxygenOS";
    ui_print "  version of this kernel to proceed.";
    exit 9
fi;

## start system changes
mount -o remount,rw /system;

# insert custom inits
if [ -f /system/vendor/etc/init/hw/init.qcom.rc ]; then
    ui_print " ";
    ui_print "- Injecting in /vendor/etc/init/hw/init.qcom.rc...";
    # import mcd.rc
    cp /tmp/anykernel/ramdisk/init.mcd.rc /system/vendor/etc/init/hw/init.mcd.rc;
    insert_line /system/vendor/etc/init/hw/init.qcom.rc "init.mcd.rc" after "import /vendor/etc/init/hw/init.qcom.usb.rc" "import /vendor/etc/init/hw/init.mcd.rc";
    # import spectrum.rc
    cp /tmp/anykernel/ramdisk/init.spectrum.rc /system/vendor/etc/init/hw/init.spectrum.rc;
    replace_line /system/vendor/etc/init/hw/init.mcd.rc "import /init.spectrum.rc" "import /vendor/etc/init/hw/init.spectrum.rc";
    remove_line /system/vendor/etc/init/hw/init.qcom.rc "import /vendor/etc/init/hw/init.spectrum.rc";
    # chmod
    chmod 644 /system/vendor/etc/init/hw/init.mcd.rc;
    chmod 644 /system/vendor/etc/init/hw/init.spectrum.rc;
fi;

mount -o remount,ro /system;

## end system changes

## AnyKernel install
dump_boot;

# begin ramdisk changes

if [ ! -f /system/vendor/etc/init/hw/init.qcom.rc ]; then
    ui_print " ";
    ui_print "- Injecting in /init.rc...";
    insert_line /init.rc "init.mcd.rc" after "import /init.usb.configfs.rc" "import /init.mcd.rc";
fi;

# end ramdisk changes

write_boot;

## end install
