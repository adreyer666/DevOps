#!/usr/bin/env make

BUILD = default
IMAGE = DevOps_$(BUILD)



build:
	vagrant up --provider=libvirt
	vagrant ssh-config >> ~/.ssh/config.d/$(BUILD).conf
	ssh -X $(BUILD)

run:
	virsh start $(IMAGE)
	ssh -X $(BUILD)

pause:
	virsh managedsave $(IMAGE)

clean:
	-rm ~/.ssh/config.d/$(BUILD).conf
	-virsh destroy $(IMAGE)
	-vagrant destroy -f

