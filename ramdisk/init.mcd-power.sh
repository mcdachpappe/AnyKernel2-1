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

# zRAM configuration
echo "60" > /proc/sys/vm/swappiness

# Disable thermal hotplug to switch governor
echo "0" > /sys/module/msm_thermal/core_control/enabled

# Bring back main cores CPU 0,2
echo "1" > /sys/devices/system/cpu/cpu0/online
echo "1" > /sys/devices/system/cpu/cpu2/online

# Configure governor settings for little cluster
echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "500" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us
echo "20000" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us
echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable

# Configure governor settings for big cluster
echo "schedutil" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo "500" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us
echo "20000" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us
echo "1" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/iowait_boost_enable

# CPUFreq control
echo "307200" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "1593600" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "307200" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq

# Re-enable thermal hotplug
echo "1" /sys/module/msm_thermal/core_control/enabled

# Dynamic Stune Boost during sched_boost
echo "10" > /dev/stune/top-app/schedtune.sched_boost

# Set default schedTune value for foreground/top-app
echo "1" > /dev/stune/foreground/schedtune.prefer_idle
echo "1" > /dev/stune/top-app/schedtune.boost
echo "1" > /dev/stune/top-app/schedtune.prefer_idle

# Touchboost configuration
echo "0" > /sys/module/msm_performance/parameters/touchboost

# Input boost configuration
echo "1" > /sys/module/cpu_boost/parameters/input_boost_enabled
echo "0:844800 1:0 2:691200 3:0" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "80" > /sys/module/cpu_boost/parameters/input_boost_ms
echo "50" > /sys/module/cpu_boost/parameters/dynamic_stune_boost
echo "300" > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms

# CPU Input boost configuration (sultanxda)
echo "1000" > /sys/module/cpu_input_boost/parameters/wake_boost_duration
echo "0" > /sys/module/cpu_input_boost/parameters/input_boost_duration
echo "748800" > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp
echo "844800" > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp

# Set thermal restrictions
echo "0" > /sys/kernel/msm_thermal/enabled
echo "1593800 2150800 40 38" > /sys/kernel/msm_thermal/zone0
echo "1401600 1785600 41 40" > /sys/kernel/msm_thermal/zone1
echo "1324800 1555200 42 41" > /sys/kernel/msm_thermal/zone2
echo "1228800 1478400 43 42" > /sys/kernel/msm_thermal/zone3
echo "1228800 1401600 44 43" > /sys/kernel/msm_thermal/zone4
echo "1190400 1324800 46 44" > /sys/kernel/msm_thermal/zone5
echo "1190400 1248000 48 46" > /sys/kernel/msm_thermal/zone6
echo "1113600 1190400 53 48" > /sys/kernel/msm_thermal/zone7
echo "940800 1036800 60 53" > /sys/kernel/msm_thermal/zone8
echo "729600 729600 65 60" > /sys/kernel/msm_thermal/zone9
echo "4000" > /sys/kernel/msm_thermal/sampling_ms
echo "1" > /sys/kernel/msm_thermal/enabled

# Configure governor for devfreq/kgsl
echo "bw_hwmon" > /sys/class/devfreq/soc:qcom,cpubw/governor
echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor

# CHOWN
# cpu
chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chown system system /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
chown system system /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
chown system system /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor

# CHMOD
# cpu
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor

# gpu
chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/min_freq

# display kcal calibration
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_cont
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_hue
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_sat
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_val

chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_cont
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_hue
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_sat
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_val

# Set I/O scheduler
setprop sys.io.scheduler "maple"

# Tweak IO performance after boot complete
echo "1" > /sys/block/sda/queue/iostats
echo "1" > /sys/block/sde/queue/iostats
echo "maple" > /sys/block/sda/queue/scheduler
echo "maple" > /sys/block/sde/queue/scheduler
echo "maple" > /sys/block/dm-0/queue/scheduler
echo "maple" > /sys/block/dm-1/queue/scheduler
echo "128" > /sys/block/sda/queue/nr_requests
echo "128" > /sys/block/sde/queue/nr_requests
echo "256" > /sys/block/sda/queue/read_ahead_kb
echo "256" > /sys/block/sde/queue/read_ahead_kb
echo "256" > /sys/block/dm-0/queue/read_ahead_kb
echo "256" > /sys/block/dm-1/queue/read_ahead_kb

# Disable Serial Console
echo "N" > /sys/module/printk/parameters/console_suspend

# Set sync wakee policy tunable
echo "1" > /proc/sys/kernel/sched_prefer_sync_wakee_to_waker

# according to Qcom this legacy value improves first launch latencies
# stock value is 512k
setprop dalvik.vm.heapminfree 2m

## write pids to system-background cpuset

sleep 20

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

echo "mcd-power.sh executed" > /dev/kmsg

}&
