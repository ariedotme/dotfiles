# Encrypting an USB

1. We'll need **cryptsetup** installed:
  `yay -S cryptsetup` or `pacman -S cryptsetup`

2. With the USB already connected use `lsblk` and find the the USB partition (Ex. /sdb)

3. (Optionally) wipe data
  `sudo dd if=/dev/zero of=/dev/sdb bs=1M status=progress`

4. Encrypt USB with luksFormat, type `YES` to confirm and choose a strong password
  `sudo cryptsetup luksFormat /dev/sdb`

5. Open the encrypted device, this creates a virtual device
  `sudo cryptsetup open /dev/sdb encrypted_usb`
  The location of the virtual device for that command is /dev/mapper/encrypted_usb

6. Format encrypted usb
  `sudo mkfs.ext4 /dev/mapper/encrypted_usb`


# Using encrypted USB

1. If there's no /media/usb/ folder create it 
  `sudo mkdir /media/usb`

2. Open encrypted device 
  `sudo cryptsetup open /dev/sdb encrypted_usb`

3. Mount it 
  `sudo mkdir -p /media/usb`
  `sudo mount /dev/mapper/encrypted_usb /media/usb`

4. Go to the mounted folder and put anything you want in there 

5. Umount and close after
  `sudo umount /media/usb`
  `sudo cryptsetup close encrypted_usb`

