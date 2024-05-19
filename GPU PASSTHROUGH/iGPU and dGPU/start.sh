set -x # debugging

systemctl stop display-manager.service # stop display-manager
pkill kwin_wayland # stop kde (xwayland process)

sleep 2 # stop race condition


# unload all nvidia drivers
modprobe -r nvidia_uvm
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia
modprobe -r i2c_nvidia_gpu
modprobe -r drm_kms_helper
modprobe -r drm

sleep 10 # stop race condition

# make gpu free!
virsh nodedev-detach pci_0000_01_00_0 # GPU IDS CHANGE IT 
virsh nodedev-detach pci_0000_01_00_1
virsh nodedev-detach pci_0000_01_00_2
virsh nodedev-detach pci_0000_01_00_3

sleep 3 # stop race condition

# load vfio drivers  
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

sleep 1 # stop race condition, again

systemctl start display-manager.service # start display manager on iGPU or 2nd GPU, KDE will load after logging in
