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
> [win 10 iso](https://www.microsoft.com/en-us/software-download/windows10ISO)  
> [win 11 iso](https://www.microsoft.com/software-download/windows11)  
### 3. Virtual Machine Manager 
Enable 
> [Edit > Preferences > General > Enable XML Editing]  
> [Edit > Connection Details > Overview > Basic Details > autoconnect]  
> [Edit > Connection Details > Virtual Networks > default > Autostart > On Boot]  

### 4. New VM
> [File > New Virtual Machine]  
Step 1 - Skip, click forward  
Step 2 - Choose ISO and os you will use, auto sucks  
Step 3 - Change memory to your liking and set CPUs to 1  
Step 4 - Create virtual disk, you can have multiple or disable storage for VM and passthough 2nd disk if you have one  
Step 5 - Change the name to something you will remember for example "win11", and check customize configuration before install  
Step 6 - Remove network interface and change CPU topology, dont use all cores and threads, Threads are per core so for example if you are going to use 4 cores and 8 threads set `4 CORES and 2 THREADS`  
Step 7 - Click begin installation   
