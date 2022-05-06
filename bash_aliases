# Local aliases
#alias scratch='cd /scratch/twmccart'
#alias DATA='cd /DATA/GROUP/twmccart'
alias diff='diff --color=always'
#alias gremlinfind='find /home/twmccart /scratch/twmccart /usr/local /opt'
#alias geany='geanyer'
#alias gopen='gnome-open'


function awslaunch() {
	instance_id="$1"
	aws ec2 start-instances --instance-ids ${instance_id} &&
	aws ec2 wait instance-status-ok --instance-ids ${instance_id} &&
	ssh -o StrictHostKeyChecking=no -i "~/.ssh/AWS-RSA-key1.pem" ubuntu@$(aws ec2 describe-instances --filters Name=instance-id,Values=${instance_id} | awk '$1 == "INSTANCES" {print $16}')
}
