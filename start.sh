#!/bin/sh

if [ $PNIPFS_BOOTSTRAP_NODE_HOSTNAME = "" || $PNIPFS_BOOTSTRAP_NODE_PORT = "" ]; then
  echo "Must provide PNIPFS_BOOTSTRAP_NODE_IP and PNIPFS_BOOTSTRAP_NODE_PORT env variables! Exiting..."
  exit 1
fi

# Makes sure IPFS doesn't connect to the public cloud
export LIBP2P_FORCE_PNET=1

# Install IPFS from distro
wget $GOIPFS_DISTRO_URL
tar xvfz $(basename $GOIPFS_DISTRO_URL)
mv go-ipfs/ipfs /bin/ipfs
ipfs version

# Clean up
rm $(basename $GOIPFS_DISTRO_URL)
rm -R ./go-ipfs

# Initialize IPFS
ipfs init

# Populate and echo swarm.key
if [ "$PNIPFS_SWARM_KEY" = "" ]; then
  echo "/key/swarm/psk/1.0.0/\n/base16/\n$(tr -dc 'a-f0-9' < /dev/urandom | head -c64)" > ~/.ipfs/swarm.key
fi
if [ "$PNIPFS_SWARM_KEY" != "" ]; then
  echo "/key/swarm/psk/1.0.0/\n/base16/\n$PNIPFS_SWARM_KEY" > ~/.ipfs/swarm.key
fi

echo "swarm.key:"
cat ~/.ipfs/swarm.key

# Remove public bootstrap nodes
ipfs bootstrap rm --all

# Extract and display PeerID
export PNIPFS_PEERID=$(ipfs config show | sed -n 's|.*"PeerID": "\([^"]*\)".*|\1|p')
echo "PNIPFS_PEERID:" && echo $PNIPFS_PEERID

# Add bootstrap node. Not need for first IPFS node in the network.
if [ "$PNIPFS_IS_FIRST_NODE" = "false" ]; then 
  ipfs bootstrap add /ip4/$PNIPFS_BOOTSTRAP_NODE_HOSTNAME/tcp/4001/ipfs/$PNIPFS_BOOTSTRAP_NODE_PORT
fi

# Runs private IPFS network daemon
ipfs daemon