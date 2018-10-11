# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=OnePlus 3T
device.name2=OnePlus3T
device.name3=oneplus3t
device.name4=OnePlus3
device.name5=oneplus3
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
chmod -R 755 $ramdisk/sbin;
chown -R root:root $ramdisk/*;


## Alert of unsupported OxygenOS / Android version
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname)
if [ -z $oos_ver ]; then
    ui_print " "
    ui_print "   Only OxygenOS is supported!"
    ui_print "Aborting..."
    ui_print " "
    exit 9
fi
android_ver=$(file_getprop /system/build.prop ro.build.version.release)
if [ $android_ver != "8.0.0" ]; then
    ui_print " "
    ui_print "   Only OxygenOS-Oreo (8.0.0) is supported!"
    ui_print "Aborting..."
    ui_print " "
    exit 9
fi


## AnyKernel install
dump_boot;


# begin ramdisk changes

# Import rz-mcd.rc
remove_line init.rc "init.rz-mcd.rc";
insert_line init.rc "init.rz-mcd.rc" after "import /init.environ.rc" "import /init.rz-mcd.rc";

# sepolicy
$bin/magiskpolicy --load sepolicy --save sepolicy \
    "allow init rootfs file execute_no_trans" \
    "allow { init modprobe } rootfs system module_load" \
    "allow init { system_file vendor_file vendor_configs_file } file mounton" \
    "allow { msm_irqbalanced hal_perf_default } { rootfs kernel } { file dir} { getattr read open search } " \
    ;

# sepolicy_debug
$bin/magiskpolicy --load sepolicy_debug --save sepolicy_debug \
    "allow init rootfs file execute_no_trans" \
    "allow { init modprobe } rootfs system module_load" \
    "allow init { system_file vendor_file vendor_configs_file } file mounton" \
    "allow { msm_irqbalanced hal_perf_default } { rootfs kernel } { file dir} { getattr read open search } " \
    ;

# Give modules in ramdisk appropriate permissions to allow them to be loaded
find $ramdisk/modules -type f -exec chmod 644 {} \;

# end ramdisk changes

write_boot;

## end install
