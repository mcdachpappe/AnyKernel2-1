#!/system/bin/sh

supolicy --live \
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

echo "mcd: sepolicy rules added" > /dev/kmsg;
