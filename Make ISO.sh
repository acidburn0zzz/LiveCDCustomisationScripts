#!/bin/bash

#Ok, I made some scripts to make LiveCDTmp easier to do post-filesystem building, the other script also fixes a bug that causes the system to be non-installable due to excluding '/boot' from the filesystem file. Anyways, here's what you have to do:
#Hit Ctrl+H in Gedit to access Find And Replace, and do the following:
#Replace 'LiveCDTmpFolderLocation' with the location of where you placed 'livecdtmp' earlier
#Replace 'DistroName' with whatever you want the disc/ISO to identify itself as
#Replace 'FinishedISOOutputFile' with the location you want the created ISO to be saved
#and Replace 'username' with your lower case, no spaces user name. 
#(Tip: Copy the folder and paste it in the window, and it will paste the location of the folder)

#Checks and makes sure the dependencies are installed before proceeding with the script:
sudo apt-get install squashfs-tools genisoimage -y
cd 'LiveCDTmpFolderLocation'
#Deletes and creates a new filesystem.squashfs file with the new contents of 'edit':
sudo rm -rf 'LiveCDTmpFolderLocation/extract-cd/casper/filesystem.squashfs'
sudo mksquashfs 'LiveCDTmpFolderLocation/edit' 'LiveCDTmpFolderLocation/extract-cd/casper/filesystem.squashfs' -comp xz -always-use-fragments -b 4096
#Get the size of the filesystem, this is a step in LiveCDCustomisation:
sudo printf $(du -sx --block-size=1 'LiveCDTmpFolderLocation/edit' | cut -f1) > 'LiveCDTmpFolderLocation/extract-cd/casper/filesystem.size'
#Delete and make the file that holds the MD5Sums of the contents of the ISO
sudo rm 'LiveCDTmpFolderLocation/extract-cd/md5sum.txt'
cd './extract-cd'
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt
#Delete the old and make the new ISO file
sudo rm -rf 'FinishedISOOutputFile'
sudo mkisofs -D --allow-limited-size -r -V "DistroName" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o 'FinishedISOOutputFile' .
#Change Permissions of the ISO file and its owner, remember: you made this ISO with the root user account!
sudo chmod 755 'FinishedISOOutputFile'
sudo chown -h username:username 'FinishedISOOutputFile'
