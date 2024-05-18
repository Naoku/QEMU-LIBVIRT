# QEMU-LIBVIRT
my qemu-libvirt, looking-glass setup

## this is 2 gpu setup in my case iGPU and dGPU

# 1. install all packages
```
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs
```
# 2. install hook manager
```
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu
```
