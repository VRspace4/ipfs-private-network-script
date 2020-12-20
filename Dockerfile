# Based on this article:
#   https://medium.com/@s_van_laar/deploy-a-private-ipfs-network-on-ubuntu-in-5-steps-5aad95f7261b

FROM golang:1.15.6-buster

ENV PNIPFS_IS_FIRST_NODE='true'

# Leave empty if creating the first IPFS node in the network.
ENV PNIPFS_BOOTSTRAP_NODE_IP=''
ENV PNIPFS_BOOTSTRAP_NODE_PORT=''
ENV PNIPFS_PEERID=''
# You may, however, pre-define the swarm key. If not, it will be generated for you.
ENV PNIPFS_SWARM_KEY=''

ENV GOIPFS_DISTRO_URL='https://dist.ipfs.io/go-ipfs/v0.7.0/go-ipfs_v0.7.0_linux-amd64.tar.gz'

