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
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname)
if [ -z $oos_ver ]; then
    ui_print " ";
    ui_print "  OxygenOS only is supported!";
    ui_print "  - Installer will abort now.";
    exit 0
fi;

## start system changes
mount -o remount,rw /system;

## Alert of insufficient /system space
avail_space=`df -kh /system | grep -v "Filesystem" | awk '{ print $5 }' | cut -d'%' -f1`
if [ "$avail_space" == "100" ]; then
    ui_print " ";
    ui_print "  Warning: your /system partition is full.";
    ui_print " ";
    ui_print "  This Kernel needs at least 10 MB free space";
    ui_print "  on your /system partition."
    ui_print " ";
    ui_print "  Do you want to delete 'G-Play Movies' now?";
    ui_print " ";
    ui_print "  Press: Volume Up [YES] || Volume Down [NO]";
    # keycheck to delete system-app
    /tmp/anykernel/tools/keycheck; KVAR=$?
    if [ $KVAR -eq 41 ]; then
        ui_print " ";
        ui_print "  - Installer will abort now.";
        exit 0
    elif [ $KVAR -eq 42 ]; then
        ui_print " ";
        ui_print "  - Deleting Google Play Movies...";
        rm -rf /system/app/Videos;
        rm -rf /data/data/com.google.android.videos;
        rm -f /data/dalvik-cache/*/*Videos.apk* ;
    fi;
fi;


## AnyKernel install
dump_boot;


## begin ramdisk changes
# Import mcd.rc
remove_line init.rc "init.renderzenith.rc";
remove_line init.rc "init.rz-mcd.rc";
insert_line init.rc "init.mcd.rc" before "import /init.usb.configfs.rc" "import /init.mcd.rc";

## some tweaks
# increase bg-app limits from 32 to 60
insert_line default.prop "ro.sys.fw.bg_apps_limit=60" before "ro.secure" "ro.sys.fw.bg_apps_limit=60";
# Enable 2.4GHz channel bonding
replace_line /system/vendor/etc/wifi/WCNSS_qcom_cfg.ini "gChannelBondingMode24GHz=0" "gChannelBondingMode24GHz=1";

mount -o remount,ro /system;

## end system changes


# sepolicy
$bin/magiskpolicy --load sepolicy --save sepolicy \
    "allow init rootfs file execute_no_trans" \
    "allow { init modprobe } rootfs system module_load" \
    "allow init { system_file vendor_file vendor_configs_file } file mounton" \
    "allow { msm_irqbalanced hal_perf_default } { rootfs kernel } file { getattr read open }" \
    "allow { msm_irqbalanced hal_perf_default } { rootfs kernel } dir { getattr read open }" \
    "allow hal_perf_default hal_perf_default capability { kill }" \
    "allow hal_perf_default hal_graphics_composer_default process { signull }" \
    "allow hal_perf_default kernel dir { read search open }" \
    "allow hal_drm_default oem_prop file { getattr }" \
    "allow hal_iop_default priv_app dir { search }" \
    "allow hal_memtrack_default qti_debugfs file { read open getattr }" \
    "allow healthd proc_stat file { read open getattr }" \
    "allow healthd healthd capability { sys_ptrace }" \
    "allow untrusted_app proc_stat file { read open getattr }" \
    "allow untrusted_app rootfs file { read open getattr }" \
    "allow untrusted_app faceulnative_exec file { read open getattr }" \
    "allow untrusted_app logserver_exec file { read open getattr }" \
    "allow untrusted_app atrace_exec file { read open getattr }" \
    "allow untrusted_app audioserver_exec file { read open getattr }" \
    "allow untrusted_app blkid_exec file { read open getattr }" \
    "allow untrusted_app bootanim_exec file { read open getattr }" \
    "allow untrusted_app bootstat_exec file { read open getattr }" \
    "allow untrusted_app cameraserver_exec file { read open getattr }" \
    "allow untrusted_app cgroup dir { read open getattr }" \
    "allow untrusted_app qti_debugfs dir { search }" \
    "allow untrusted_app hal_memtrack_hwservice hwservice_manager { find }" \
    ;


# Give modules in ramdisk appropriate permissions to allow them to be loaded
find $ramdisk/modules -type f -exec chmod 644 {} \;

# end ramdisk changes

write_boot;

## end install
