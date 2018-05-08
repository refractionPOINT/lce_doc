#! /bin/sh

echo Update current OS
apt-get update -y
apt-get upgrade -y


echo Download Splunk
wget "https://download.splunk.com/products/splunk/releases/7.1.0/linux/splunk-7.1.0-2e75b3406c5b-linux-2.6-amd64.deb"

echo Install Splunk
dpkg -i ./*splunk*.deb

echo Creating SFTP User
adduser --disabled-password --gecos "" lc

echo Creating the Directory Structure
mkdir -p /var/sftp/uploads
chown root:root /var/sftp
chmod 755 /var/sftp
chown lc:lc /var/sftp/uploads

echo Configure SFTP Access
echo "
Match User lc
ForceCommand internal-sftp
PasswordAuthentication no
ChrootDirectory /var/sftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
" >> /etc/ssh/sshd_config
systemctl restart sshd

echo Creating SSH Keys
sudo -u lc -- ssh-keygen -t rsa -N "" -f /home/lc/.ssh/id_rsa
cp /home/lc/.ssh/id_rsa.pub /home/lc/.ssh/authorized_keys

echo Configuring Splunk
echo "
[limacharlie]
SHOULD_LINEMERGE = false
" >> /opt/splunk/etc/apps/search/local/props.conf

echo "
[batch:///var/sftp/uploads]
disabled = false
sourcetype = limacharlie
move_policy = sinkhole
" >> /opt/splunk/etc/apps/search/local/inputs.conf

echo "
[user_info]
USERNAME = admin
PASSWORD = letmein1
" > /opt/splunk/etc/system/local/user-seed.conf

echo Restarting Splunk
/opt/splunk/bin/splunk restart --accept-license --no-prompt

echo "You can connect to Splunk by creating an SSH tunnel like: \"ssh your-splunk-machine -L 127.0.0.1:8000:0.0.0.0:8000 -N\" and then connecting to local port 8000."

echo "Done, use the following information to configure a limacharlie.io output (all other fields are default):"
echo "======================="
echo "Output Module: SFTP"
echo "dest_host: <IP ADDRESS OF THIS HOST>"
echo "dir: /uploads"
echo "username: lc"
echo "secret_key:"
cat /home/lc/.ssh/id_rsa