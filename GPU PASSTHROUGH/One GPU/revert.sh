# unload vfio drivers
modprobe -r vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1

sleep 7 # stop race condition

# make GPU free again
virsh nodedev-reattach pci_0000_01_00_0 #GPU IDS CHANGE THIS 
virsh nodedev-reattach pci_0000_01_00_1
virsh nodedev-reattach pci_0000_01_00_2
virsh nodedev-reattach pci_0000_01_00_3

sleep 2 # stop race condition 

# load nvidia drivers
modprobe drm
modprobe drm_kms_helper
modprobe i2c_nvidia_gpu
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_drm
modprobe nvidia_uvm

sleep 3 # stop race condition

systemctl start display-manager.service # start display-manager, KDE will load after logging in
