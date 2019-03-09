#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

# macro to write pids to system-background cpuset
function writepid_sbg() {
    until [ ! "$1" ]; do
        echo -n $1 > /dev/cpuset/system-background/tasks;
        shift;
    done;
}

function writepid_top_app() {
    until [ ! "$1" ]; do
        echo -n $1 > /dev/cpuset/top-app/tasks;
        shift;
    done;
}
################################################################################

{

sleep 10

# Disable thermal hotplug to switch governor
write /sys/module/msm_thermal/core_control/enabled 0

# Set sync wakee policy tunable
write /proc/sys/kernel/sched_prefer_sync_wakee_to_waker 1

# Bring back main cores CPU 0,2
write /sys/devices/system/cpu/cpu0/online 1
write /sys/devices/system/cpu/cpu2/online 1

# Configure governor settings for little cluster
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "schedutil"
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us 500
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us 20000
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable 1

# Configure governor settings for big cluster
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor "schedutil"
write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us 500
write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us 20000
write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/iowait_boost_enable 1

# CPUFreq control
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 307200
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1593600
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 307200

# Re-enable thermal hotplug
write /sys/module/msm_thermal/core_control/enabled 1

# Dynamic Stune Boost during sched_boost
write /dev/stune/top-app/schedtune.sched_boost 10

# Set default schedTune value for foreground/top-app
write /dev/stune/foreground/schedtune.prefer_idle 1
write /dev/stune/top-app/schedtune.boost 1
write /dev/stune/top-app/schedtune.prefer_idle 1

# Touchboost configuration
write /sys/module/msm_performance/parameters/touchboost 0

# Input boost configuration
write /sys/module/cpu_boost/parameters/input_boost_enabled 0
write /sys/module/cpu_boost/parameters/input_boost_freq "0:844800 1:0 2:691200 3:0"
write /sys/module/cpu_boost/parameters/input_boost_ms 100
write /sys/module/cpu_boost/parameters/dynamic_stune_boost 50
write /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms 500

# Configure governor for devfreq/kgsl
write /sys/class/devfreq/soc:qcom,cpubw/governor "bw_hwmon"
write /sys/class/kgsl/kgsl-3d0/devfreq/governor "msm-adreno-tz"

# Enable Adaptive LMK
write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 1
write /sys/module/lowmemorykiller/parameters/vmpressure_file_min 81250

## write pids to system-background cpuset

QSEECOMD=`pidof qseecomd`
THERMAL-ENGINE=`pidof thermal-engine`
TIME_DAEMON=`pidof time_daemon`
IMSQMIDAEMON=`pidof imsqmidaemon`
IMSDATADAEMON=`pidof imsdatadaemon`
DASHD=`pidof dashd`
CND=`pidof cnd`
DPMD=`pidof dpmd`
RMT_STORAGE=`pidof rmt_storage`
TFTP_SERVER=`pidof tftp_server`
NETMGRD=`pidof netmgrd`
IPACM=`pidof ipacm`
QTI=`pidof qti`
LOC_LAUNCHER=`pidof loc_launcher`
QSEEPROXYDAEMON=`pidof qseeproxydaemon`
IFAADAEMON=`pidof ifaadaemon`
LOGCAT=`pidof logcat`
LMKD=`pidof lmkd`

writepid_sbg $QSEECOMD
writepid_sbg $THERMAL-ENGINE
writepid_sbg $TIME_DAEMON
writepid_sbg $IMSQMIDAEMON
writepid_sbg $IMSDATADAEMON
writepid_sbg $DASHD
writepid_sbg $CND
writepid_sbg $DPMD
writepid_sbg $RMT_STORAGE
writepid_sbg $TFTP_SERVER
writepid_sbg $NETMGRD
writepid_sbg $IPACM
writepid_sbg $QTI
writepid_sbg $LOC_LAUNCHER
writepid_sbg $QSEEPROXYDAEMON
writepid_sbg $IFAADAEMON
writepid_sbg $LOGCAT
writepid_sbg $LMKD

## end write pids to system-background cpuset

write /dev/kmsg "mcd power executed"

}&
