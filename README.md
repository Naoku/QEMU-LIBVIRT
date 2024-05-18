# QEMU-LIBVIRT
my qemu-libvirt, looking-glass setup.

In my case intel iGPU UHD Graphics 630 and dGPU nvidia gtx 1660 ti moblie from lenovo. 
this setup gives the VM 10 cores, 12GB of ram and dGPU passthough which can give near native performance with small input lag with help of looking glass.

## general windows VM 
### 1. Required Packages
```
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs
```
### 2. install ISO
> [win 10 iso](https://www.microsoft.com/en-us/software-download/windows10ISO)__
> [win 11 iso](https://www.microsoft.com/software-download/windows11)__
### 3. Virtual Machine Manager 
Enable 
> [Edit > Preferences > General > Enable XML Editing]__
> click on QEMU/KVM and then [Edit > Connection Details > Overview > Basic Details > autoconnect]__
> click on QEMU/KVM and then [Edit > Connection Details > Virtual Networks > default > Autostart > On Boot]__
