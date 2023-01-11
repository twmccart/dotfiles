# Local aliases
#alias scratch='cd /scratch/twmccart'
#alias DATA='cd /DATA/GROUP/twmccart'
alias diff='diff --color=always'
#alias gremlinfind='find /home/twmccart /scratch/twmccart /usr/local /opt'
#alias geany='geanyer'
#alias gopen='gnome-open'


# This function will take an AWS instance ID as an argument and send a startup signal to that instance, wait for it to finish starting, and then create an SSH connection to it.
function awslaunch() {
	instance_id="$1"
	aws ec2 start-instances --instance-ids ${instance_id} &&
	aws ec2 wait instance-status-ok --instance-ids ${instance_id} &&
	ssh -o StrictHostKeyChecking=no -i "~/.ssh/AWS-RSA-key1.pem" ubuntu@$(aws ec2 describe-instances --filters Name=instance-id,Values=${instance_id} | awk '$1 == "INSTANCES" {print $15}')
}

# This function will take an AWS instance ID as an argument and send a startup signal to that instance, wait for it to finish starting, and then print an SSH command that can be used to connect remotely through VS Code.
function awscommand() {
	instance_id="$1"
	aws ec2 start-instances --instance-ids ${instance_id} &&
	aws ec2 wait instance-status-ok --instance-ids ${instance_id} &&
	echo "ssh -o StrictHostKeyChecking=no -i \"~/.ssh/AWS-RSA-key1.pem\" ubuntu@$(aws ec2 describe-instances --filters Name=instance-id,Values=${instance_id} | awk '$1 == "INSTANCES" {print $15}')"
}

# This function will take an AWS instance ID as an argument and send a startup signal to that instance, wait for it to finish starting, and then tunnel a VNC connection from the instance to port localhost:5901. The VNC Viewer client by RealVNC is free to use.
function awsvnc() {
	instance_id="$1"
	aws ec2 start-instances --instance-ids ${instance_id} &&
	aws ec2 wait instance-status-ok --instance-ids ${instance_id} &&
	address="$(aws ec2 describe-instances --filters Name=instance-id,Values=${instance_id} | awk '$1 == "INSTANCES" {print $15}')" &&
	echo "Launched ${address}"
	ssh -o StrictHostKeyChecking=no -i "~/.ssh/AWS-RSA-key1.pem" ubuntu@${address} "vncserver -depth 24 -geometry 1440x900 -localhost :1"
	ssh -i "~/.ssh/AWS-RSA-key1.pem" -L 5901:localhost:5901 -C -N ubuntu@${address}
}
