 #Add space to the virtual disk in VMWare (can be done on-line)
 #Create VMWare snapshot - please note that you will be unable to change disk size with snapshot, so create snapshot after you changed disk size
 # Rescan disk to see the added space:
 echo 1>/sys/class/block/sda/device/rescan
 #Check that the disk now is seen by PS as a new size:
 fdisk -l
 # Create a new pripary partition that will be used to extend logical volume 
 fdisk /dev/sda
 # press n to create a new partition
 # press p for primary partition
 # press 3 or enter for default 
 # press Enter for default lowest posstion
 # press Enter for default last posstion
 # press t to select the partition type
 # press 3 to select the new partision
 # press L to see a list of types
 # press 8e for LVM
 # press w to write the changes
 sudo reboot
 # Now turn the new partition to physical volume
 pvcreate /dev/sda3
 # See the Voloume groups names to find out the one you need to resize
 vgdisplay
 # Extend the Volume group on the physical disk
 vgextend cl_sfws-gen /dev/sda3
 # Check it with the VG info
 vgdisplay
 # Now see the all Logical Volumes names - you will need to logical volume extend command
 lvdisplay
 #Check all physical vloumes with the disks
 pvscan
 # Now expand the logical volume
 lvextend -l +100%FREE /dev/cl_sfws-gen/root
 #O R 
 lvextend -L+39G /dev/cl_sfws-gen/root
 # Check that the size is not added to the / root file system mount point
 df -h
 vgdisplay
 lvdisplay
 # Now you need to extend the file system
 xfs_growfs /dev/cl_sfws-gen/root
 # Now check that the / root file system was increased
 df -h
