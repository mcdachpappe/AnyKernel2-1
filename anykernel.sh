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
device.name3=OnePlus3T
device.name4=oneplus3t
supported.versions=9
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

## Alert of unsupported Android version
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname)
if [ -z $oos_ver ]; then
    ui_print " ";
    ui_print "  Warning: Only OxygenOS is supported!";
    ui_print " ";
    ui_print "  - Installer will abort now.";
    ui_print " ";
    exit 9
fi

## Alert of insufficient /system space
avail_space=`df -kh /system | grep -v "Filesystem" | awk '{ print $5 }' | cut -d'%' -f1`
if [ "$avail_space" == "100" ]; then
    ui_print " ";
    ui_print "  Warning: /system partition is full!";
    ui_print " ";
    ui_print "  This Kernel needs ~6 MB free space.";
    ui_print "  Please delete a System-App proceed";
    ui_print " ";
    ui_print "  - Installer will abort now.";
    ui_print " ";
    exit 9
fi;


## start system changes
mount -o remount,rw /system;

# remove existing spectrum config if present
if [ -f /system/vendor/etc/init/hw/init.spectrum.rc ]; then
    remove_line /system/vendor/etc/init/hw/init.qcom.rc "import /vendor/etc/init/hw/init.spectrum.rc";
    rm -rf /system/vendor/etc/init/hw/init.spectrum.rc;
fi;

# import custom configs
cp -f /tmp/anykernel/ramdisk/init.mcd.rc /system/vendor/etc/init/hw/init.mcd.rc;
cp -f /tmp/anykernel/ramdisk/init.spectrum.rc /system/vendor/etc/init/hw/init.spectrum.rc;
# inject custom config
insert_line /system/vendor/etc/init/hw/init.qcom.rc "init.mcd.rc" after "import /vendor/etc/init/hw/init.qcom.test.rc" "import /vendor/etc/init/hw/init.mcd.rc";
# chmod
chmod 644 /system/vendor/etc/init/hw/init.mcd.rc;
chmod 644 /system/vendor/etc/init/hw/init.spectrum.rc;

# Enable 2.4GHz channel bonding
replace_line /system/vendor/etc/wifi/WCNSS_qcom_cfg.ini "gChannelBondingMode24GHz=0" "gChannelBondingMode24GHz=1";

mount -o remount,ro /system;

## end system changes


## AnyKernel install
dump_boot;

## begin ramdisk changes

# increase bg-app limits from 32 to 60
insert_line default.prop "ro.sys.fw.bg_apps_limit=60" before "ro.secure" "ro.sys.fw.bg_apps_limit=60";

# sepolicy
$bin/magiskpolicy --load sepolicy --save sepolicy \
    "allow init rootfs file execute_no_trans" \
    "allow { init modprobe } rootfs system module_load" \
    "allow init { system_file vendor_file vendor_configs_file } file mounton" \
    "allow { msm_irqbalanced hal_perf_default } { rootfs kernel } file { getattr read open } " \
    "allow { msm_irqbalanced hal_perf_default } { rootfs kernel } dir { getattr read open } " \
    ;

# Give modules in ramdisk appropriate permissions to allow them to be loaded
find $ramdisk/modules -type f -exec chmod 644 {} \;

## end ramdisk changes

write_boot;

## end install
