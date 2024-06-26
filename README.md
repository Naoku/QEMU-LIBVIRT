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

## CPU pinning 
CPU pinning makes that your host pc uses some cores only if it is necessary   
### Finding your cores
use command `lscpu -e`   
if your cpu has more than 1 core and 1 thread you should see list of them all 
Example output of i7-9750H 
```
CPU NODE SOCKET CORE L1d:L1i:L2:L3 ONLINE    MAXMHZ   MINMHZ       MHZ
  0    0      0    0 0:0:0:0          yes 4500.0000 800.0000 4191.3130
  1    0      0    1 1:1:1:0          yes 4500.0000 800.0000 4189.4761
  2    0      0    2 2:2:2:0          yes 4500.0000 800.0000 4195.7422
  3    0      0    3 3:3:3:0          yes 4500.0000 800.0000  800.0000
  4    0      0    4 4:4:4:0          yes 4500.0000 800.0000 4195.7671
  5    0      0    5 5:5:5:0          yes 4500.0000 800.0000 4153.4458
  6    0      0    0 0:0:0:0          yes 4500.0000 800.0000 4172.5459
  7    0      0    1 1:1:1:0          yes 4500.0000 800.0000 4199.1362
  8    0      0    2 2:2:2:0          yes 4500.0000 800.0000 4168.4658
  9    0      0    3 3:3:3:0          yes 4500.0000 800.0000 4118.1348
 10    0      0    4 4:4:4:0          yes 4500.0000 800.0000 4186.9038
 11    0      0    5 5:5:5:0          yes 4500.0000 800.0000 4199.3618
 ```
If you can see some "CPUs" share the same "CORE", thats because this cpu has 6 cores and 12 threads.  
If you want to do cpu pinning you need to pin the whole core with all threads so in this case if i wanted to pin "CPU 3" i would have to pin the "CPU 9" too.  

### Pinning cpus
Right after `<vcpu placement='static'>(number of cores)</vcpu>` you need to add some lines.  
Using the same example as before If i wanted to pin core 3 and core 9 it would look like this.  
```
<cputune>
    <vcpupin vcpu='0' cpuset='3'/>
    <vcpupin vcpu='1' cpuset='9'/>
</cputune>
```

`vcpu` is the core in guest VM and `cpuset` is core in host pc.  


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
Copy [My files](GPU%20PASSTHROUGH/iGPU%20and%20dGPU) 
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
Copy [My files](GPU%20PASSTHROUGH/One%20GPU) 
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

## Looking Glass
Looking Glass makes VM better to use, less input lag etc.   
Looking Glass require 2nd monitor, HDMI or DP dummy plug or Driver that will simulate 2nd monitor 
### Download Looking Glass
Looking glass has to be same version on host and guest pc otherwise it will not work, i would suggest to download it from [aur on host pc](https://aur.archlinux.org/packages/looking-glass) and on VM download version B6 from [Looking glass site](https://looking-glass.io/downloads)

### Edit VM 
run command   
```
sudo EDITOR=nvim virsh edit (VM NAME)
```
and add  
```
  <shmem name='looking-glass'>
    <model type='ivshmem-plain'/>
    <size unit='M'>32</size>
  </shmem>
```
right before  
```
</devices>
```

change video model to none and delete tablet device
```
    <video>
      <model type='none'/>
    </video>
```

### Create file and edit it
```
sudo nvim /etc/tmpfiles.d/10-looking-glass.conf
```
and paste this line to this file replacing user with your username 
```
f	/dev/shm/looking-glass	0660	user	kvm	-
```
and run this command 
```
sudo systemd-tmpfiles --create /etc/tmpfiles.d/10-looking-glass.conf
```

### Config file 
you can create looking glass config, if you want to make your looking glass always fullscreen or something like that create config file `~/.config/looking-glass/client.ini` and use this [site](https://looking-glass.io/docs/B5.0.1/install/)

## Extra fixes  

### Fix for laptop,mobile GPUs  
Create new file, using command bellow in directory you will remember, for me its `/etc/libvirt/hooks/qemu.d`  
```  
echo 'U1NEVKEAAAAB9EJPQ0hTAEJYUENTU0RUAQAAAElOVEwYEBkgoA8AFVwuX1NCX1BDSTAGABBMBi5f
U0JfUENJMFuCTwVCQVQwCF9ISUQMQdAMCghfVUlEABQJX1NUQQCkCh8UK19CSUYApBIjDQELcBcL
cBcBC9A5C1gCCywBCjwKPA0ADQANTElPTgANABQSX0JTVACkEgoEAAALcBcL0Dk=' | base64 -d > SSDT1.dat
```
add this to your VM config 
```
<domain xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0" type="kvm">
  ...
  <qemu:commandline>
    <qemu:arg value="-acpitable"/>
    <qemu:arg value="file=/path/to/your/SSDT1.dat"/>
  </qemu:commandline>
</domain>
```

### looking glass without 2nd monitor or dummy plug 
i got it from [there](https://www.reddit.com/r/VFIO/comments/wj6zhz/gpu_passthrough_looking_glass_no_external/), it works :)  
