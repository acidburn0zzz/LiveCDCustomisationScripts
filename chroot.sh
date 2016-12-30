#!/bin/bash

#Ok, I made some scripts to make LiveCDTmp easier to do post-filesystem building, the other script also fixes a bug that causes the system to be non-installable due to excluding '/boot' from the filesystem file. Anyways, here's what you have to do:
#Hit Ctrl+H in Gedit to access Find And Replace, and do the following:
#In Find, enter 'LiveCDTmpFolderLocation'
#In Replace, enter the location of where you placed 'livecdtmp' earlier (Tip: Copy the folder and paste it in the window, and it'll paste the location of the folder)
#Finally, proceed into the 'Make ISO.sh' file, and follow the instructions there.

#Enter The LiveCDTmp Folder
cd 'LiveCDTmpFolderLocation'
#Mount Drives neccesary to Internet Access, Installing packages without throwing up warnings, etc
sudo mount -o bind /run/ edit/run
sudo mount --bind /dev/ edit/dev
sudo chroot edit mount -t proc none /proc;sudo chroot edit mount -t sysfs none /sys;sudo chroot edit mount -t devpts none /dev/pts
#Croot the Filesystem
echo "You are now inside the bash shell of the filesystem contained in the edit folder! Do as you wish, and when you're done, type 'exit' to exit the chroot shell..."
sudo chroot edit
#Now chroot has been exited, shrink the filesystem slightly by removing unneeded things ready for ISO creation and then unmount drives that were needed just for chrooting properly..
cd 'LiveCDTmpFolderLocation'
sudo chroot edit apt-get clean
cd 'LiveCDTmpFolderLocation'
sudo chroot edit apt-get autoremove
cd 'LiveCDTmpFolderLocation'
sudo chroot edit aptitude clean
cd 'LiveCDTmpFolderLocation'
sudo chroot edit rm -rf /tmp/* ~/.bash_history
cd 'LiveCDTmpFolderLocation'
sudo chroot edit rm /var/lib/dbus/machine-id
cd 'LiveCDTmpFolderLocation'
sudo chroot edit rm /sbin/initctl
cd 'LiveCDTmpFolderLocation'
sudo chroot edit dpkg-divert --rename --remove /sbin/initctl
cd 'LiveCDTmpFolderLocation'
sudo chroot edit umount /proc || sudo chroot edit umount -lf /proc
cd 'LiveCDTmpFolderLocation'
sudo chroot edit umount /sys
cd 'LiveCDTmpFolderLocation'
sudo chroot edit umount /dev/pts
cd 'LiveCDTmpFolderLocation'
sudo umount edit/dev
sudo umount edit/run
#The Script is finished, you'll now be returned to the normal bash prompt of your proper OS
