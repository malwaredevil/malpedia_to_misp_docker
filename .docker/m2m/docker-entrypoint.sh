#!/bin/bash
# DO THIS WHEN THE CONTAINER STARTS
set -e

eval `ssh-agent -s`
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
service ssh restart
ssh-add -k /root/.ssh/id_rsa
ssh -o StrictHostKeyChecking=no git@malpedia.caad.fkie.fraunhofer.de
service ssh restart

cd /opt/m2m/dependencies
echo "Cloning/Updating Malpedia To MISP Core"
git clone https://github.com/malwaredevil/malpedia_to_misp.git || (cd /opt/m2m/dependencies/malpedia_to_misp ; git pull)
cd /opt/m2m/dependencies/malpedia_to_misp
chmod +x /opt/m2m/dependencies/malpedia_to_misp/bootstrap.sh

bash /opt/m2m/dependencies/malpedia_to_misp/bootstrap.sh --misp-key $MISP_KEY \
            --misp-url $MISP_URL \
            --malpedia-key $MALPEDIA_KEY \
            --postgres-server $POSTGRES_HOST \
            --postgres-port $POSTGRES_PORT \
            --postgres-user $POSTGRES_USER \
            --postgres-password $POSTGRES_PASSWORD

echo "***********************************************************************************"
echo "**                MALPEDIA TO MISP DOCKER INGEST COPMLETE                        **"
echo "***********************************************************************************"
echo "***********************************************************************************"
echo "**         If you wish to keep your MISP database up-to-date with Malpedia       **"
echo "**        you will need to create a cron job or  scheduled task on your host     **"
echo "**        that executes this container as often as you require and pending       **"
echo "**        your  system and network specifications.                               **"
echo "**        This container will shutdown in 5 minutes                              **"
echo "***********************************************************************************"
echo "***********************************************************************************"


sleep 5m

# exec "$@"
