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
LAUNCHER_SCRIPT_NAME="limacharlie"
IDENTIFY_FILE_DIRECTORY="/etc/"

echo "Installing LimaCharlie sensor to: ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}"

# Copy the sensor to the /bin directory.
cp -f ${ORIGINAL_SENSOR} ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}

# Make sure the sensor is executable but only accessible to root.
chown root:root ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}
chmod 500 ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}

# Write a simple launcher script to /etc/init.d/.
cat >/etc/init.d/${LAUNCHER_SCRIPT_NAME} <<EOL
#! /bin/sh
### BEGIN INIT INFO
# Provides:          limacharlie
# Required-Start:    $local_fs $network $named
# Required-Stop:     $local_fs $network $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts limacharlie
# Description:       starts limacharlie using start-stop-daemon
### END INIT INFO
start() {
  cd ${IDENTIFY_FILE_DIRECTORY}
  ${SENSOR_DIR}${SENSOR_NAME_ON_DISK} -d ${INSTALLATION_KEY} >/dev/null 2>&1 &
}
stop() {
  pkill -2 -f ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}
}
case "\$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        status FOO
        ;;
  restart|reload|condrestart)
        stop
        start
        ;;
  *)
        echo $"Usage: \$0 {start|stop|restart|reload|status}"
        exit 1
esac

exit 0
EOL

# Make the launcher script executable and only accessible to root.
chown root:root /etc/init.d/${LAUNCHER_SCRIPT_NAME}
chmod 500 /etc/init.d/${LAUNCHER_SCRIPT_NAME}

# Setup the launcher script.
if command -v update-rc.d; then
  update-rc.d ${LAUNCHER_SCRIPT_NAME} defaults
else
  chkconfig ${LAUNCHER_SCRIPT_NAME} on
fi

# Start the service.
/etc/init.d/${LAUNCHER_SCRIPT_NAME} start

echo "LimaCharlie installed and started successfully."
echo "To uninstall the LimaCharlie service: "
echo "sudo service limacharlie stop"
echo "sudo rm -rf ${SENSOR_DIR}${SENSOR_NAME_ON_DISK}"
echo "sudo update-rc.d ${LAUNCHER_SCRIPT_NAME} remove -f"
echo "sudo rm -rf /etc/init.d/${LAUNCHER_SCRIPT_NAME}"
echo ""
echo "This does not delete the identity files from disk."
echo "This means you can re-install in the future and keep the same sensor ID."
echo "If you wish to delete the identity: "
echo "sudo rm /etc/hcp"
echo "sudo rm /etc/hcp_conf"
echo "sudo rm /etc/hcp_hbs"
