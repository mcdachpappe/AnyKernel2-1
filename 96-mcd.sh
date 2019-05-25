#!/system/bin/sh
# Kernel Setup Assistant
# all credits to @0ctobot for this installer script!

## Wait until /data is ready
while [ ! mountpoint -q /data ]; do
	sleep 1;
done

## Initiate self-destruct sequence if this kernel isn't installed
if [ ! grep -q mcd-op6 /proc/version ]; then
	rm -f /data/adb/magisk_simple/vendor/etc/msm_irqbalance.conf;
	stop vendor.msm_irqbalance;
	start vendor.msm_irqbalance;
	rm -f /data/adb/service.d/96-mcd.sh;
	rm -f /data/adb/service.d/96-mcd-power.sh;
	exit 0;
fi

## Wait for boot completion
while [ "$(getprop sys.boot_completed)" != 1 ]; do
	sleep 2;
done

sleep 2;

## Apply Kernel Settings
# Update msm_irqbalance configuration
	stop vendor.msm_irqbalance;
	start vendor.msm_irqbalance;

sleep 10;

# Disable CAF task placement for Big Cores
	echo 0 > /proc/sys/kernel/sched_walt_rotate_big_tasks;

# Setup Schedutil Governor
	# CPU0
	echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor;
	echo 500 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us;
	echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us;
	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable;
	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl;
	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq;
	# CPU4
	echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor;
	echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor;
	echo 500 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us;
	echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us;
	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable;
	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl;
	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq;

# Setup EAS cpusets values for better load balancing
	echo 0-7 > /dev/cpuset/top-app/cpus;
# Since we are not using core rotator, lets load balance
	echo 0-3,6-7 > /dev/cpuset/foreground/cpus;
	echo 0-1 > /dev/cpuset/background/cpus;
	echo 0-3  > /dev/cpuset/system-background/cpus;
# For better screen off idle
	echo 0-3 > /dev/cpuset/restricted/cpus;

# Input boost [cpu-boost]
	#echo 500 > /sys/module/cpu_boost/parameters/input_boost_ms;
	#echo 15 > /sys/module/cpu_boost/parameters/dynamic_stune_boost;
	#echo 1500 > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms;

# Custom boost values [cpu-input-boost]
	# Input boosting
	echo 500 > /sys/module/cpu_input_boost/parameters/input_boost_duration; # [default 500]
	echo 902400 > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp; # [default 902400]
	echo 1056000 > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp; # [default 1056000]
	## Max-boost frequency (while input boosting)
	echo 1996800 > /sys/module/cpu_input_boost/parameters/max_boost_freq_hp; # [default 1996800]
	echo 1766400 > /sys/module/cpu_input_boost/parameters/max_boost_freq_lp; # [default 1766400]
	## Fallback frequency once the boost is over
	echo 825600 > /sys/module/cpu_input_boost/parameters/remove_input_boost_freq_perf; # [default 825600]
	echo 576000 > /sys/module/cpu_input_boost/parameters/remove_input_boost_freq_lp; # [default 576000]

	# Frame boosting (rendering outside of direct user interaction)
	echo 902400 > /sys/module/cpu_input_boost/parameters/frame_boost_freq_hp; # [default 825600]
	echo 902400 > /sys/module/cpu_input_boost/parameters/frame_boost_freq_lp; # [default 748800]

	# Dynamic stune boost (SchedTune input boost value for top-app)
	echo 20 > /sys/module/cpu_input_boost/parameters/dynamic_stune_boost; #input_stune_boost # [default 20]
	## SchedTune max boost value for top-app
	echo 50 > /sys/module/cpu_input_boost/parameters/max_stune_boost; # [default 50]
	## SchedTune frame boost value for top-app
	echo 10 > /sys/module/cpu_input_boost/parameters/frame_stune_boost; # [default 10]

	# Screen on boost duration
	echo 500 > /sys/module/cpu_input_boost/parameters/wake_boost_duration; # [default 1000]

# MSM-Touchboost
	echo 0 > /sys/module/msm_performance/parameters/touchboost;

# I/O Scheduler
	echo "anxiety" > /sys/block/sda/queue/scheduler;
	echo "anxiety" > /sys/block/sde/queue/scheduler;

# Adjust Read Ahead
	echo 128 > /sys/block/sda/queue/read_ahead_kb;
	echo 128 > /sys/block/dm-0/queue/read_ahead_kb;

# Reset zRAM/Swapspace
	rm /data/vendor/swap/swapfile;
	swapoff /dev/block/zram0;
	echo 1 > /sys/block/zram0/reset;
	echo 1073741824 > /sys/block/zram0/disksize;
	echo 8 > /sys/block/zram0/max_comp_streams;
	mkswap /dev/block/zram0;
	swapon /dev/block/zram0;

# Adjust Virtual Memory
	echo 60 > /proc/sys/vm/swappiness;
	echo 0 > /proc/sys/vm/compact_unevictable_allowed;
	echo 10 > /proc/sys/vm/dirty_background_ratio;
	echo 500 > /proc/sys/vm/dirty_expire_centisecs;
	echo 30 > /proc/sys/vm/dirty_ratio;
	echo 3000 > /proc/sys/vm/dirty_writeback_centisecs;
	echo 0 > /proc/sys/vm/oom_dump_tasks;
	echo 0 > /proc/sys/vm/oom_kill_allocating_task;
	echo 1200 > /proc/sys/vm/stat_interval;
	echo 0 > /proc/sys/vm/swap_ratio;
	echo 60 > /proc/sys/vm/vfs_cache_pressure;

# Exception-trace
	echo 0 > /proc/sys/debug/exception-trace;

# Disable printk log spamming to the console
	echo "0 0 0 0" > /proc/sys/kernel/printk;

# USB fast charge
	echo 1 > /sys/kernel/fast_charge/force_fast_charge;

# PEWQ
	echo Y > /sys/module/workqueue/parameters/power_efficient;

# OTG
	echo 1 > /sys/class/power_supply/usb/otg_switch;
    
# part 1/2 loaded
	echo "mcd: script 1/2 executed" > /dev/kmsg;
