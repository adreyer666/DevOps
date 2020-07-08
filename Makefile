#!/usr/bin/env make

BUILD = default
IMAGE = DevOps_$(BUILD)



build:
	vagrant up --provider=libvirt
	vagrant ssh-config >> ~/.ssh/config
	ssh -X $(BUILD)

run:
	virsh start $(IMAGE)
	ssh -X $(BUILD)

pause:
	virsh managedsave $(IMAGE)

clean:
	-virsh destroy $(IMAGE)
	-vagrant destroy -f

