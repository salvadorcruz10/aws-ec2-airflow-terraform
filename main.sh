#!/bin/bash
shopt -s expand_aliases

step="S_VALIDATING"
#alias fmt_string_start='echo "[$(date +"%Y-%m-%d %H:%M:%S")] "'
alias fmt_string_start='echo " "'

function validate(){
	ret=0
	value=$(eval 'echo $'$1)

	if [ -z "$value" ];then
		echo "$(fmt_string_start)[INFO] Variable [$1] was not set, please check this out"
		ret=1
	fi

	return $ret
}

if [ "$step" == "S_VALIDATING" ];then
	echo "$(fmt_string_start)[INFO] Validating environment variables..."

	validate "AWS_ACCESS_KEY_ID"
	if [ $? == 1 ];then
		echo "$(fmt_string_start)[ERROR] error on validating"
		exit 1
	fi

	validate "AWS_SECRET_ACCESS_KEY"
	if [ $? == 1 ];then
		echo "$(fmt_string_start)[ERROR] error on validating"
		exit 1
	fi

	step="S_CREATE_KEYS_FOLDER"
fi

if [ "$step" == "S_CREATE_KEYS_FOLDER" ];then
	echo "$(fmt_string_start)[INFO] Creating \"keys\" folder for ssh-keygen command..." 

	echo "$(fmt_string_start)[INFO] mkdir -p $(pwd)/keys"
	mkdir -p keys
	if [ $? == 1 ];then
		echo "$(fmt_string_start)[ERROR] error on creating \"key\" folder [mkdir key]"
		exit 1
	fi

	step="S_VALIDATING_SSH_KEYGEN"
fi

if [ "$step" == "S_VALIDATING_SSH_KEYGEN" ];then
	echo "$(fmt_string_start)[INFO] Validating ssh-keygen files..." 

	if [[ -f "keys/aws_terraform" &&  -f "keys/aws_terraform.pub"  ]]; then

		ret=$(diff <(ssh-keygen -y -f keys/aws_terraform | cut -d' ' -f 2) <(cut -d' ' -f 2 keys/aws_terraform.pub))
		if [ $? == 1 ];then
			echo "$(fmt_string_start)[ERROR] Something wrong when comparing both files [] and [keys/aws_terraform.pub]"
			exit 1
		fi

		if [ -z "$ret" ];then
			echo "$(fmt_string_start)[INFO] Everything is ok with the ssh-keygen files, so the ssh-keygen execution step will be skipped"
			step="S_GRANT_PERMISIONS_TO_SSH_KEYGEN_FILES"
		else
			step="S_EXECUTE_SSH_KEYGEN"
		fi
	else
		step="S_EXECUTE_SSH_KEYGEN"
	fi
fi


if [ "$step" == "S_EXECUTE_SSH_KEYGEN" ];then
	echo "$(fmt_string_start)[INFO] Running ssh-keygen..."
	#ssh-keygen -q -f keys/aws_terraform -C aws_terraform_ssh_key -N ''
	echo "Ejecuting ssh-keygen"
	if [ $? == 1 ];then
		echo "$(fmt_string_start)[ERROR] Error on executing ssh-keygen"
		exit 1
	fi

	step="S_GRANT_PERMISIONS_TO_SSH_KEYGEN_FILES"
fi

if [ "$step" == "S_GRANT_PERMISIONS_TO_SSH_KEYGEN_FILES" ];then
	echo "$(fmt_string_start)[INFO] chmod 400 keys/aws_terraform ..."
	chmod 400 keys/aws_terraform
	if [ $? == 1 ];then
		echo "$(fmt_string_start)[ERROR] error on chmod 400 keys/aws_terraform"
		exit 1
	fi

	echo "$(fmt_string_start)[INFO] chmod 400 keys/aws_terraform.pub ..."
	chmod 400 keys/aws_terraform.pub
	if [ $? == 1 ];then
		echo "$(fmt_string_start)[ERROR] error on chmod 400 keys/aws_terraform.pub"
		exit 1
	fi

	step="S_EXPORT_PUB_KEY"
fi

if [ "$step" == "S_EXPORT_PUB_KEY" ];then
	echo "$(fmt_string_start)[INFO] Exporting TF_VAR variables..."

	echo "$(fmt_string_start)[INFO] Exporting TF_VAR_public_key ...."
	export export TF_VAR_public_key=$(cat keys/aws_terraform.pub)
	if [ $? == 1 ];then
		echo "$(fmt_string_start)[ERROR] Error on export TF_VAR_public_key"
		exit 1
	fi
	step="S_EXECUTIONG_TERRAFORM"
fi

if [ "$step" == "S_EXECUTIONG_TERRAFORM" ];then
	echo "$(fmt_string_start)[INFO] Executing \"terraform plan\" ..."
	terraform plan

	echo "Should we perform \"terraform apply\"??? [\"yes\"]"
	read answer
	if [ ! -z $(echo "$answer" | grep -e "^yes$") ];then
		terraform apply
	fi
fi

echo "$(fmt_string_start)[INFO] End.."










   #para conectarse a la instancia
   #ssh -i ./keys/aws_terraform ec2-user@ec2-3-17-73-9.us-east-2.compute.amazonaws.com

