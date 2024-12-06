#!/bin/bash

ARCH=$(uname -p)

# Download and install Miniconda
cd /tmp/
if [[ "${ARCH}" =~ ^aarch64$ ]]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O Miniconda3-latest.sh
else
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda3-latest.sh
fi

bash Miniconda3-latest.sh -b -p /opt/miniconda3
rm -f Miniconda3-latest.sh

# Configure conda
/opt/miniconda3/bin/conda init bash
/opt/miniconda3/bin/conda config --set ssl_verify /etc/ssl/certs/ca-certificates.crt
/opt/miniconda3/bin/conda config --set auto_activate_base false
/opt/miniconda3/bin/conda update -n base -c defaults conda -y
/opt/miniconda3/bin/conda clean --all -y

# Install pip in the base environment
/opt/miniconda3/bin/conda install pip -y

# Set permissions for shared volume and user
mkdir -p /home/kasm-user/.conda
chown -R 1000:1000 /opt/miniconda3 /home/kasm-user/.conda

# Add Miniconda to PATH for the shared volume
echo 'export PATH=/opt/miniconda3/bin:$PATH' >> /etc/bash.bashrc
echo 'source /opt/miniconda3/bin/activate' >> /etc/bash.bashrc
