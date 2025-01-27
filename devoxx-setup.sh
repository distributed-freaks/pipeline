#!/bin/bash
# Run first time through to set up all the components and start services for
# ByTheBay Pipeline training

cd ~/pipeline
git reset --hard && git pull

# Source the .profile for exports
# Note:  This shouldn't be needed as it's already symlinked through the Docker image
. ~/.profile

# Make the scripts executable
chmod a+rx *.sh

# IP address eth0
export IP_eth0=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

# Setup tools
./devoxx-config.sh

# Start the pipeline services
./devoxx-start.sh

# Initialize Kafka, Cassandra, Hive
./devoxx-create.sh

echo ...Exported Variables...
export

echo ...Running Java Processes...
jps -l
