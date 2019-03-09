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
supported.versions=
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


## Alert of unsupported Android version and OOS plebs
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname)
if [ $oos_ver != "" ]; then
    ui_print "This kernel version was not designed for OxygenOS,"
    ui_print "please select the OxygenOS variant of this kernel"
    exit 9
fi
android_ver=$(file_getprop /system/build.prop ro.build.version.release)
case "$android_ver" in
  "6.0"|"6.0.1"|"7.0"|"7.1"|"7.1.1"|"7.1.2") compatibility_string="your version is unsupported, expect no support from the kernel developer!";;
  "8.0.0"|"8.1.0"|"9") compatibility_string="your version is supported!";;
esac;

ui_print "Android $android_ver detected, $compatibility_string";


## AnyKernel install
dump_boot;


## begin ramdisk changes

# Import mcd.rc
remove_line init.rc "init.mcd.rc";
insert_line init.rc "init.mcd.rc" after "import /init.usb.rc" "import /init.mcd.rc";

## end ramdisk changes

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

# sepolicy_debug
$bin/magiskpolicy --load sepolicy_debug --save sepolicy_debug \
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


write_boot;

## end install
