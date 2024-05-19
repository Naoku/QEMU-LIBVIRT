Libvirt, qemu, looking glass and undetected VM tutorial.

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
>DONT USE CUSTOM ISOs  
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

### 5. Windows setup
If everything went fine you should be greeted with new windows VM! You may notice that mouse and keyboard feel slugish but we will repair it later.  
Choose windows 10/11 pro, it adds some features you may want to use later and dont lie you will either crack the windows with cmd script or buy the key for 1$ on some site.  
After this whole setup you should be greeted with bloated windows 10/11 desktop, i recommend debloating windows before continuing with one of thoese tools; [winaero](https://winaero.com/), [Chris Titus Tool](https://christitus.com/windows-tool/), [Windows10Debloater](https://github.com/Sycnex/Windows10Debloater)   
Install [Cpp Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170)  
And now install [Libvirt Drivers](https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md)  

### 6. Done!
Windows wm is now done and ready to use!   
But you are probably here for gpu passthrough, looking glass and cpu pinning so lets go    

## GPU passthrough!  
There are many way to setup gpu passthrough, it depends if you have iGPU and dGPU, one GPU or 2 dGPUs, in this case i will only explain the first two.   

### 1. dGPU and iGPU  
Step 1 - Install qemu hooks manager  
```
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu
```

Step 2 - Make directories  
```
sudo mkdir -p /etc/libvirt/hooks/qemu.d/(VM NAME)/prepare/begin/
sudo mkdir -p /etc/libvirt/hooks/qemu.d/(VM NAME)/release/end/
```

Step 3 - GPU files  
[My files](GPU%20PASSTHROUGH/iGPU%20and%20dGPU)
change GPU ids in these files using command `lspci`, that number before your gpu is the only thing you need, copy every one that includes your gpu and replace all dots and colons with underscores.  

Paste these files to  
revert.sh to /etc/libvirt/hooks/qemu.d/(VM NAME)/release/end/    
start.sh to /etc/libvirt/hooks/qemu.d/(VM NAME)/prepare/begin/   

Make them executable
```
sudo chmod +x /etc/libvirt/hooks/qemu.d/(VM NAME)/release/end/revert.sh
sudo chmod +x /etc/libvirt/hooks/qemu.d/(VM NAME)/prepare/begin/start.sh
```

Step 4 - Add GPU in Virtual Machine Manager  
Click open on VM, then on the bottom left click `Add Hardware` and add same pci id as in the step 3  

Step 5 - Run VM  
Install Drivers for the GPU, if you gpu is mobile you will have to make extra steps. 

### 2. Only one GPU 
Step 1 - Install qemu hooks manager  
```
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu
```

Step 2 - Make directories  
```
sudo mkdir -p /etc/libvirt/hooks/qemu.d/(VM NAME)/prepare/begin/
sudo mkdir -p /etc/libvirt/hooks/qemu.d/(VM NAME)/release/end/
```

Step 3 - GPU files  
[My files](GPU%20PASSTHROUGH/One%20GPU)
change GPU ids in these files using command `lspci`, that number before your gpu is the only thing you need, copy every one that includes your gpu and replace all dots and colons with underscores.  

Paste these files to  
revert.sh to /etc/libvirt/hooks/qemu.d/(VM NAME)/release/end/    
start.sh to /etc/libvirt/hooks/qemu.d/(VM NAME)/prepare/begin/   

Make them executable
```
sudo chmod +x /etc/libvirt/hooks/qemu.d/(VM NAME)/release/end/revert.sh
sudo chmod +x /etc/libvirt/hooks/qemu.d/(VM NAME)/prepare/begin/start.sh
```

Step 4 - Add GPU in Virtual Machine Manager  
Click open on VM, then on the bottom left click `Add Hardware` and add same pci id as in the step 3  

Step 5 - Run VM  
Install Drivers for the GPU, if you gpu is mobile you will have to make extra steps. 
