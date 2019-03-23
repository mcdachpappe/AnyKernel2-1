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
device.name1=OnePlus3
device.name2=oneplus3
device.name3=OnePlus3T
device.name4=oneplus3t
device.name5=
supported.versions=8.1.0 - 9
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
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname)
if [ "$oos_ver" != "" ]; then
    ui_print "  This kernel version was not designed for";
    ui_print "  OxygenOS. Please select the OxygenOS";
    ui_print "  version of this kernel to proceed.";
    exit 9
fi


## start system changes
mount -o rw,remount -t auto /system >/dev/null;


# insert custom inits
if [ -f /system/vendor/etc/init/hw/init.qcom.rc ]; then
    ui_print " ";
    ui_print "  Injecting in /vendor/etc/init/hw/init.qcom.rc...";
    # import mcd.rc
    cp /tmp/anykernel/ramdisk/init.mcd.rc /system/vendor/etc/init/hw/init.mcd.rc;
    insert_line /system/vendor/etc/init/hw/init.qcom.rc "init.mcd.rc" after "import /vendor/etc/init/hw/init.qcom.usb.rc" "import /vendor/etc/init/hw/init.mcd.rc";
    # chmod
    chmod 644 /system/vendor/etc/init/hw/init.mcd.rc;
fi
## end system changes


## AnyKernel install
dump_boot;


## begin ramdisk changes
if [ ! -f /system/vendor/etc/init/hw/init.qcom.rc ]; then
    ui_print " ";
    ui_print "  Injecting in /init.rc...";
    insert_line /init.rc "init.mcd.rc" after "import /init.usb.configfs.rc" "import /init.mcd.rc";
fi
## end ramdisk changes


## sepolicy
$bin/magiskpolicy --load sepolicy --save sepolicy \
    "allow { audioserver system_server location sensors } diag_device chr_file { read write }" \
    "allow { init modprobe } rootfs system module_load" \
    "allow { msm_irqbalanced hal_perf_default } { rootfs kernel } file { getattr read open }" \
    "allow { msm_irqbalanced hal_perf_default } { rootfs kernel } dir { getattr read open }" \
    "allow init { system_file vendor_file vendor_configs_file } file mounton" \
    "allow init rootfs file execute_no_trans" \
    "allow hal_perf_default hal_perf_default capability { kill }" \
    "allow hal_perf_default hal_graphics_composer_default process { signull }" \
    "allow hal_perf_default kernel dir { read search open }" \
    "allow hal_iop_default priv_app dir { search }" \
    "allow hal_memtrack_default qti_debugfs file { read open getattr }" \
    "allow mediaserver mediaserver_tmpfs file { read write execute }" \
    "allow healthd proc_stat file { read open getattr }" \
    "allow healthd healthd capability { sys_ptrace }" \
    "allow dumpstate fuse dir search" \
    "allow dumpstate fuse file getattr" \
    "allow dumpstate theme_data_file file { read open getattr }" \
    "allow priv_app { cache_private_backup_file unlabeled } dir getattr" \
    "allow shell dalvikcache_data_file dir write" \
    "allow untrusted_app proc_stat file { read open getattr }" \
    "allow untrusted_app rootfs file { read open getattr }" \
    "allow untrusted_app atrace_exec file { read open getattr }" \
    "allow untrusted_app audioserver_exec file { read open getattr }" \
    "allow untrusted_app blkid_exec file { read open getattr }" \
    "allow untrusted_app bootanim_exec file { read open getattr }" \
    "allow untrusted_app bootstat_exec file { read open getattr }" \
    "allow untrusted_app cameraserver_exec file { read open getattr }" \
    "allow untrusted_app cgroup dir { read open getattr }" \
    "allow untrusted_app qti_debugfs dir { search }" \
    "allow untrusted_app hal_memtrack_hwservice hwservice_manager { find }" \
    "allow untrusted_app sysfs_kgsl dir { read write getattr open }" \
    "allow untrusted_app sysfs_kgsl file { read write getattr open }" \
    "allow untrusted_app sysfs dir { read write getattr open }" \
    "allow untrusted_app sysfs file { read write getattr open }" \
    "allow untrusted_app sysfs_leds dir search" \
    "allow untrusted_app sysfs_leds lnk_file read" \
    "allow untrusted_app sysfs_zram dir search" \
    "allow untrusted_app sysfs_zram file { read open getattr }" \
    "allow vold logd dir read" \
    "allow vold logd lnk_file getattr" \
    ;


write_boot;

## end install
