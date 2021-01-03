#! /bin/bash

# Exit this installation script if any error occurs.
set -e

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

if [ $# -ne 2 ]; then
    echo "Usage: $0 PATH_TO_LC_SENSOR INSTALLATION_KEY"
    exit 1
fi

if [ ! -r $1 ]; then
    echo "Cannot read LC sensor: $1"
    exit 1
fi

# Outside parameters.
ORIGINAL_SENSOR=$1
INSTALLATION_KEY=$2

# Deployment constants.
SENSOR_DIR="/bin/"
SENSOR_NAME_ON_DISK="rphcp"
UNIT_FILE_NAME="limacharlie.service"

echo "Installing LimaCharlie sensor to: ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}"

# Copy the sensor to the /bin directory.
cp -f ${ORIGINAL_SENSOR} ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}

# Make sure the sensor is executable but only accessible to root.
chown root:root ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}
chmod 500 ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}

# Write a simple systemd unit file /etc/systemd/system/.
cat >/etc/systemd/system/${UNIT_FILE_NAME} <<EOL
[Unit]
Description=LimaCharlie Agent

[Service]
Type=simple
User=root
Restart=always
RestartSec=10
ExecStart=/bin/bash '${SENSOR_DIR}${SENSOR_NAME_ON_DISK} -d ${INSTALLATION_KEY}'

[Install]
WantedBy=multi-user.target
EOL


# Reload the service files to include the new service
systemctl daemon-reload

# Start the service
systemctl start ${UNIT_FILE_NAME}

# Start the service on every reboot
systemctl enable ${UNIT_FILE_NAME}

# Display the status of the service: $ systemctl status 
# Debug: $ journalctl -u limacharlie.service -b


