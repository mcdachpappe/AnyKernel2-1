#!/system/bin/sh
# Kernel Setup Assistant
# all credits to @0ctobot for this installer script!

## Wait until /data is ready
while [ ! mountpoint -q /data ]; do
	sleep 1;
done

## Initiate self-destruct sequence if this kernel isn't installed
if [ ! grep -q mcd-custom /proc/version ]; then
	rm -f /data/adb/magisk_simple/vendor/etc/perf/perfboostsconfig.xml;
	rm -f /data/adb/service.d/96-mcd.sh;
	rm -f /data/adb/service.d/96-mcd-power.sh;
	exit 0;
fi;

## Wait for post_boot completion
while [ "$(getprop vendor.post_boot.parsed)" != 1 ]; do
	sleep 2;
done

## Apply Kernel Settings

sleep 5;

# CHMOD
	# CPU
	chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	chmod 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
	chmod 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	chmod 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
	# GPU
	chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
	chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
	# KCAL
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_cont
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_hue
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_sat
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_val

# CHOWN
	# CPU
	chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	chown system system /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
	chown system system /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	chown system system /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor

# Disable sched_boost
	echo 0 > /proc/sys/kernel/sched_boost;

# Set default schedTune value for foreground/top-app
	echo 0 > /dev/stune/top-app/schedtune.boost;

# Dynamic Stune Boost during sched_boost
	echo 10 > /dev/stune/top-app/schedtune.sched_boost;

# Stune configuration
	echo 10 > /sys/module/cpu_boost/parameters/dynamic_stune_boost;
	echo 300 > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms;

# Set default schedTune value for foreground/top-app
	echo 1 > /dev/stune/foreground/schedtune.prefer_idle;
	echo 1 > /dev/stune/top-app/schedtune.prefer_idle;

# Bring back main cores CPU 0,2
	echo 1 > /sys/devices/system/cpu/cpu0/online;
	echo 1 > /sys/devices/system/cpu/cpu2/online;

# Configure governor settings for little cluster
	echo schedutil > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	echo 1000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us;
	echo 10000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us;
	echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable;

# Configure governor settings for big cluster
	echo schedutil > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	echo 1000 > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us;
	echo 10000 > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us;
	echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/iowait_boost_enable;

# Update cpusets now that boot is complete and we want better load balancing
	echo "0-3" > /dev/cpuset/top-app/cpus;
	echo "0-3" > /dev/cpuset/foreground/boost/cpus;
	echo "0-3" > /dev/cpuset/foreground/cpus;
	echo "0-3 > /dev/cpuset/background/cpus;
	echo "0-3" > /dev/cpuset/system-background/cpus;

# CPUFreq control
	echo 307200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	echo 1593600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	echo 307200 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	echo 2342400 > sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;

# MSM-Touchboost configuration
	echo 0 > /sys/module/msm_performance/parameters/touchboost;

# Input-Boost configuration
	echo 1 > /sys/module/cpu_boost/parameters/input_boost_enabled;
	echo "0:1036800 2:748800" > /sys/module/cpu_boost/parameters/input_boost_freq;
	echo 100 > /sys/module/cpu_boost/parameters/input_boost_ms;

# CPU-Input-Boost configuration
	echo 0 > /sys/module/cpu_input_boost/parameters/input_boost_duration;
	echo 1000 > /sys/module/cpu_input_boost/parameters/wake_boost_duration;
	echo 844800 > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp;
	echo 748800 > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp;

# Thermal-Simple configuration
	echo 0 > /sys/kernel/msm_thermal/enabled;
	echo "1516800 2246400 41 40" > /sys/kernel/msm_thermal/zone0;
	echo "1440000 2150400 42 41" > /sys/kernel/msm_thermal/zone1;
	echo "1363200 2054400 43 42" > /sys/kernel/msm_thermal/zone2;
	echo "1363200 1977600 44 43" > /sys/kernel/msm_thermal/zone3;
	echo "1286400 1900800 45 44" > /sys/kernel/msm_thermal/zone4;
	echo "1286400 1824000 47 45" > /sys/kernel/msm_thermal/zone5;
	echo "1132800 1670400 49 47" > /sys/kernel/msm_thermal/zone6;
	echo "1056000 1363200 54 49" > /sys/kernel/msm_thermal/zone7;
	echo "902400 1056000 58 54" > /sys/kernel/msm_thermal/zone8;
	echo "844800 902400 60 58" > /sys/kernel/msm_thermal/zone9;
	echo "768000 748800 63 60" > /sys/kernel/msm_thermal/zone10;
	echo 4000 > /sys/kernel/msm_thermal/sampling_ms;
	echo 1 > /sys/kernel/msm_thermal/enabled;

# Configure governor for devfreq/kgsl
	echo "bw_hwmon" > /sys/class/devfreq/soc:qcom,cpubw/governor;
	echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor;

# Set I/O scheduler
	setprop sys.io.scheduler "maple"

# Tweak IO performance after boot complete
	echo 1 > /sys/block/sda/queue/iostats;
	echo 1 > /sys/block/sde/queue/iostats;
	echo "maple" > /sys/block/sda/queue/scheduler;
	echo "maple" > /sys/block/sde/queue/scheduler;
	echo "maple" > /sys/block/dm-0/queue/scheduler;
	echo "maple" > /sys/block/dm-1/queue/scheduler;
	echo 128 > /sys/block/sda/queue/nr_requests;
	echo 128 > /sys/block/sde/queue/nr_requests;
	echo 256 > /sys/block/sda/queue/read_ahead_kb;
	echo 256 > /sys/block/sde/queue/read_ahead_kb;
	echo 256 > /sys/block/dm-0/queue/read_ahead_kb;
	echo 256 > /sys/block/dm-1/queue/read_ahead_kb;

# Enable all LPMs by default
# This will enable C4, D4, D3, E4 and M3 LPMs
	echo N > /sys/module/lpm_levels/parameters/sleep_disabled;

# Disable Serial Console
	echo N > /sys/module/printk/parameters/console_suspend;

# Set sync wakee policy tunable
	echo 1 > /proc/sys/kernel/sched_prefer_sync_wakee_to_waker;

# according to Qcom this legacy value improves first launch latencies
# stock value is 512k
	setprop dalvik.vm.heapminfree 2m

# part 1/2 loaded
	echo "mcd: script 1/2 executed" > /dev/kmsg;
