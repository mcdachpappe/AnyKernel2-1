# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus6
device.name2=OnePlus6T
device.name3=oneplus6
device.name4=oneplus6t
supported.versions=9
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;


# Define target paths
mount -o rw,remount -t auto /vendor > /dev/null;
target="/vendor/etc/init/hw/init.target.rc";
irq="/vendor/etc/msm_irqbalance.conf";

# Cleanup previous performance additions
for files in "${target}" "${irq}"
do
  restore_file $files;
done


# Systemlessly apply custom settings
mountpoint -q /data && {
  # Install custom IRQ Balance config
  mkdir -p /data/adb/magisk_simple/vendor/etc;
  cp /tmp/anykernel/msm_irqbalance.conf /data/adb/magisk_simple/vendor/etc;

  # Install second-stage late init scripts
  mkdir -p /data/adb/service.d;
  cp /tmp/anykernel/96-mcd.sh /data/adb/service.d;
  cp /tmp/anykernel/96-mcd-power.sh /data/adb/service.d;
  chmod +x /data/adb/service.d/96-mcd.sh;
  chmod +x /data/adb/service.d/96-mcd-power.sh;
}


## AnyKernel install
dump_boot;


# If the kernel image and dtbs are separated in the zip
decompressed_image=/tmp/anykernel/kernel/Image
compressed_image=$decompressed_image.gz
if [ -f $compressed_image ]; then
  # Hexpatch the kernel if Magisk is installed ('skip_initramfs' -> 'want_initramfs')
  if [ -d $ramdisk/.backup ]; then
    ui_print " "; 
    ui_print "  Magisk detected! Patching cmdline so";
    ui_print "  reflashing Magisk is not necessary...";
    ui_print " ";
    $bin/magiskboot --decompress $compressed_image $decompressed_image;
    $bin/magiskboot --hexpatch $decompressed_image 736B69705F696E697472616D667300 77616E745F696E697472616D667300;
    $bin/magiskboot --compress=gzip $decompressed_image $compressed_image;
  fi;

  # Concatenate all of the dtbs to the kernel
  cat $compressed_image /tmp/anykernel/dtbs/*.dtb > /tmp/anykernel/Image.gz-dtb;
fi;


# Clean up other kernels' ramdisk overlay files
rm -rf $ramdisk/overlay;


# Install the boot image
write_boot;
