## Some Notes

### How to create a VM template

1. Create a VM without a drive.
   a. Ensure that you update username, password, dhcp and public key
2. ```
   wget https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img # when in proxmox download the relevant image
   qm set 900 --serial0 socket --vga serial0 # ensure has visual output
   mv ubuntu-22.04-minimal-cloudimg-amd64.img ubuntu-22.04.qcow2 # rename file
   qemu-img resize ubuntu-22.04.qcow2 20G # resize
   qm importdisk 900 ubuntu-22.04.qcow2 local-lvm # import into local storage
   ```

3. After you've installed then add this - ```
   sudo apt install qemu-guest-agent
   reboot # this adds some extra functionality into proxmox.

```

```
