# QEMU-LIBVIRT
my qemu-libvirt, looking-glass setup.

In my case intel iGPU UHD Graphics 630 and dGPU nvidia gtx 1660 ti moblie from lenovo. 
this setup gives the VM 10 cores, 12GB of ram and dGPU passthough which can give near native performance with small input lag with help of looking glass.

## general windows VM 
### 1. install these packages
```
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs
```
### 2. install iso from microsoft
[win 10 iso](https://www.microsoft.com/en-us/software-download/windows10ISO)
[win 11 iso](https://www.microsoft.com/software-download/windows11)
### 3. virtual machine manager 
