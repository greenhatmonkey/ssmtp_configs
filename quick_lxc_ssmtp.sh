#!/bin/bash

# CC0 Licence
# This script is for getting a working ssmtp account setup 
#   For email providers like gmail, yandex, yahoo, outlook, icloud.
# So your server can email you details, like updates for alerts from fail2ban, etc.
# It is designed with a fresh ubuntu 20.04 lxc container in mind.


# Depends ssmtp conf template. which will modify/changed placeholders with sed in script.

# Check user root/sudo
# Check software ssmtp is installed
# Download ssmtp email config template
# Select an eMail account to send mail from
# Usermod - select name of sending
# send test email - in vesbose 
# print finished msg


# Check user root function
#-----------------------------------------------------------------
function user_sudo_root()
{
if [[ $EUID -ne 0 ]]; then
	printf "This script is designed to be run by root\n"
	printf "Use: sudo\n"
	exit 1
fi
}
#----------------------------------------------------------------

# Check software installed
#---------------------------------------------------------------
function check_warez()
{
apt install ssmtp -y
}

function download_ssmtp_conf()
{
	ssmtp_conf_sum="21048b74b58486bfd123d848701cddd7"	
	wget https://raw.githubusercontent.com/greenhatmonkey/ssmtp_configs/master/ssmtp.conf?raw=true
	downloaded_ssmtp_sum="$(md5sum ssmtp.conf\?raw\=true | awk '{print $1}')"
	if [ $downloaded_ssmtp_sum == $ssmtp_conf_sum ] ;
	then
		echo "checksum checks out"
		mv ssmtp.conf\?raw\=true /etc/ssmtp/ssmtp.conf
	else
		echo "CheckSum not checking out!"
		printf "looking for $ssmtp_conf_sum but found $downloaded_ssmtp_sum\n"
		read -r -p $"Press anykey to end script!"
		exit 1
	fi

}
#-------------------------------------------------------------

# List email providers
#-------------------------------------------------------------
function select_mail_provider()
{

printf "Please select an email service:\n
\t1.hotmail/outlook
\n\t2.yandex
\n\t3.yahoo
\n\t4.icloud
\n\t5.gmail
\n\tq.quit
\nPlease Select (select number 1, 2, 3, 4, 5, q): "
read email_provider_selected

if [ -z "$email_provider_selected" ]; then
       select_mail_provider
elif [ "$email_provider_selected" == "q" ]; then
 	echo "quitting email setup"
elif [ "$email_provider_selected" == "1" ]; then
	microsoft_email_conf
elif [ "$email_provider_selected" == "2" ]; then
	yandex_email_conf
elif [ "$email_provider_selected" == "3" ]; then
	yahoo_email_conf
elif [ "$email_provider_selected" == "4" ]; then
	icloud_email_conf
elif [ "$email_provider_selected" == "5" ]; then
	gmail_email_conf
else
	echo "Please only enter 1, 2, 3, 4, 5 or q"
	select_mail_provider
fi

}
#------------------------------------------------------

# setup functions for each email provider
#-------------------------------------------------------
function microsoft_email_conf()
{
    printf "Outlook email account\n"
    printf "Please enter your email address: Example:name@gmail.com >"
    read user_email_address
    printf "Please Enter You Email Passwd >"
    read user_email_passwd
    # smtp address and port
    smtp_add_port="smtp-mail.outlook.com:587"
    # edit /etc/ssmtp/ssmtp.conf file
    sed -i "s/MAILH/$smtp_add_port/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/HOSTN/localhost/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILADD/$user_email_address/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILPASSWD/$user_email_passwd/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/UTLS/no/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/STLS/yes/g" /etc/ssmtp/ssmtp.conf
    # /etc/ssmtp/revaliases
    # /etc/ssmtp/revaliases
    echo "root:$user_email_address:$smtp_add_port" > /etc/ssmtp/revaliases
    localusers=$(ls -l /home/ | awk '{print $9}')
    for i in $localusers
    do
            echo $i:$user_email_address:$smtp_add_port >> /etc/ssmtp/revaliases
    done

}

function yahoo_email_conf()
{
    printf "Outlook email account\n"
    printf "Please enter your email address: Example:name@gmail.com >"
    read user_email_address
    printf "Please Enter You Email Passwd >"
    read user_email_passwd
    # smtp address and port
    smtp_add_port="smtp-mail.outlook.com:587"
    # edit /etc/ssmtp/ssmtp.conf file
    sed -i "s/MAILH/$smtp_add_port/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/HOSTN/localhost/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILADD/$user_email_address/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILPASSWD/$user_email_passwd/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/UTLS/no/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/STLS/yes/g" /etc/ssmtp/ssmtp.conf
    # /etc/ssmtp/revaliases
    # /etc/ssmtp/revaliases
    echo "root:$user_email_address:$smtp_add_port" > /etc/ssmtp/revaliases
    localusers=$(ls -l /home/ | awk '{print $9}')
    for i in $localusers
    do
            echo $i:$user_email_address:$smtp_add_port >> /etc/ssmtp/revaliases
    done

}

function yandex_email_conf()
{
    printf "Yahoo email account\n"
    printf "Please enter your email address: Example:name@gmail.com >"
    read user_email_address
    printf "Please Enter You Email Passwd >"
    read user_email_passwd
    # smtp address and port
    smtp_add_port="smtp.mail.yahoo.com:465"
    # edit /etc/ssmtp/ssmtp.conf file
    sed -i "s/MAILH/$smtp_add_port/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/HOSTN/localhost/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILADD/$user_email_address/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILPASSWD/$user_email_passwd/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/UTLS/yes/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/STLS/no/g" /etc/ssmtp/ssmtp.conf
    # /etc/ssmtp/revaliases
    # /etc/ssmtp/revaliases
    echo "root:$user_email_address:$smtp_add_port" > /etc/ssmtp/revaliases
    localusers=$(ls -l /home/ | awk '{print $9}')
    for i in $localusers
    do
            echo $i:$user_email_address:$smtp_add_port >> /etc/ssmtp/revaliases
    done

}

function yandex_email_conf()
{
    printf "Yandex email account\n"
    printf "Please enter your email address: Example:name@gmail.com >"
    read user_email_address
    printf "Please Enter You Email Passwd >"
    read user_email_passwd
    # smtp address and port
    smtp_add_port="smtp.yandex.com:465"
    # edit /etc/ssmtp/ssmtp.conf file
    sed -i "s/MAILH/$smtp_add_port/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/HOSTN/localhost/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILADD/$user_email_address/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILPASSWD/$user_email_passwd/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/UTLS/yes/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/STLS/no/g" /etc/ssmtp/ssmtp.conf
    # /etc/ssmtp/revaliases
    # /etc/ssmtp/revaliases
    echo "root:$user_email_address:$smtp_add_port" > /etc/ssmtp/revaliases
    localusers=$(ls -l /home/ | awk '{print $9}')
    for i in $localusers
    do
            echo $i:$user_email_address:$smtp_add_port >> /etc/ssmtp/revaliases
    done

}

function icloud_email_conf()
{
    printf "Icloud email account\n"
    printf "Please enter your email address: Example:name@gmail.com >"
    read user_email_address
    printf "Please Enter You Email Passwd >"
    read user_email_passwd
    # smtp address and port
    smtp_add_port="smtp.mail.me.com:587"
    # edit /etc/ssmtp/ssmtp.conf file
    sed -i "s/MAILH/$smtp_add_port/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/HOSTN/localhost/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILADD/$user_email_address/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILPASSWD/$user_email_passwd/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/UTLS/no/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/STLS/yes/g" /etc/ssmtp/ssmtp.conf
    # /etc/ssmtp/revaliases
    # /etc/ssmtp/revaliases
    echo "root:$user_email_address:$smtp_add_port" > /etc/ssmtp/revaliases
    localusers=$(ls -l /home/ | awk '{print $9}')
    for i in $localusers
    do
            echo $i:$user_email_address:$smtp_add_port >> /etc/ssmtp/revaliases
    done

}

function gmail_email_conf()
{
    #Give warning
    printf "Gmail email account\n"
    printf "Please enter your email address: Example:name@gmail.com >"
    read user_email_address
    printf "Please Enter You Email Passwd >"
    read user_email_passwd
    # smtp address and port
    smtp_add_port="smtp.gmail.com:587"
    # edit /etc/ssmtp/ssmtp.conf file
    sed -i "s/MAILH/$smtp_add_port/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/HOSTN/localhost/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILADD/$user_email_address/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/EMAILPASSWD/$user_email_passwd/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/UTLS/no/g" /etc/ssmtp/ssmtp.conf
    sed -i "s/STLS/yes/g" /etc/ssmtp/ssmtp.conf
    # /etc/ssmtp/revaliases
    echo "root:$user_email_address:$smtp_add_port" > /etc/ssmtp/revaliases
    localusers=$(ls -l /home/ | awk '{print $9}')
    for i in $localusers 
    do 
            echo $i:$user_email_address:$smtp_add_port >> /etc/ssmtp/revaliases
    done

}

#------------------------------------------------------------------------------
# Who to send email as - select display email address of sender

function email_sender_name()
{
	printf "Please select a sender name for emails from this machine.\n"
	printf "Example: 'yourserver@servername.com' or 'mywiki_server'\n"
	printf "Enter Name: "
	read email_send_name
	printf "The sender name you selected is \"$email_send_name\" is this correct? (y/n): "
	read send_name_check
	if [ $send_name_check == "y" ] ; then
		printf "Your emails from this machine will be sent addressed as the sender \"$email_send_name\"\n"
		# This will be the sender name on all accounts on this machine
		usermod -c "\"$email_send_name\"" root
		# find user account on machine
		localusers=$(ls -l /home/ | awk '{print $9}')
		    for i in $localusers
		    do 
            		usermod -c "\"$email_send_name\"" $i
    		    done

	elif [ -z $send_name_check ]; then
		email_sender_name

	elif [ $send_name_check == "n" ] ; then 
		#restart function
		email_sender_name
	else
		echo "Please only enter 'n' or 'y'"
		email_sender_name
	fi
}
#-------------------------------------------------
# test email

send_test_email()
{
	printf "Please enter email address we are going to send email to: "
	read send_to_this_email

	printf "We are going to send a test message;\n Remember to check your spam folder!\n"
	printf "\n\tEnter a Subject header: "
	read sub_head
	echo -e "Subject:$sub_head\n" > /tmp/email.smtp

	printf "\nEnd your email with uppercase SEND on single line to send email when finished\n"
	printf "Please Enter email message: "
	finished=false
	while [ "$finished" == false ]; do 
		read email_content
		echo $email_content >> /tmp/email.smtp
		if [ "$email_content" == "SEND" ]; then
			finished=true
			# Delete last line from file: the SEND part.
			sed -i '$ d' /tmp/email.smtp
		fi
	done
	
	printf "we are about to send an email to $send_to_this_email, do you wish to send (y) or start again (n)?\n"
	printf "Please enter y/n: "
	read send_yn
	if [ "$send_yn" == "y" ]; then
		# use -v to debug - makes sendmail verbose: sendmail -v $send_to_this_email
		sendmail -v $send_to_this_email < /tmp/email.smtp
	elif [ "$send_yn" == "n" ]; then
		send_test_email
	else
		send_test_email
	fi
}


#---------------------------------------------
# Message about setup
function setup_msg()
{
	echo "your ssmtp email as now been setup"
}




## modules to run in order
user_sudo_root
check_warez
download_ssmtp_conf
select_mail_provider
email_sender_name
send_test_email
setup_msg
