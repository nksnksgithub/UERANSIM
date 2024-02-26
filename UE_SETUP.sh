#!/bin/bash

while true; do
    # Prompt the user for the destination IP address and subnet mask
    read -p "Enter the IP address and subnet mask of gNodeB network (e.g., 192.168.28.0/24): " gNodeB_ip

    # Validate the IP address
    if [[ $gNodeB_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+$ ]]; then
        echo "Valid IP address entered: $gNodeB_ip"
        break
    else
        echo "Invalid IP address format. Please enter a valid IP address and subnet mask."
    fi
done

# Step 1: Create the Bash script
cat <<EOF > /usr/local/bin/custom_routes.sh
#!/bin/bash

# Remove the default route
#ip route del default via 10.0.2.2 dev enp0s3

# Add the custom route
ip route add $gNodeB_ip via 10.0.2.2 dev enp0s3
EOF

# Make the script executable
chmod +x /usr/local/bin/custom_routes.sh

# Step 2: Create the systemd service unit file
cat <<EOF > /etc/systemd/system/custom-routes.service
[Unit]
Description=Custom Routes Setup
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/custom_routes.sh

[Install]
WantedBy=multi-user.target
EOF

# Step 3: Reload systemd and enable/start the service
systemctl daemon-reload
systemctl enable custom-routes.service
systemctl start custom-routes.service

echo "Custom route service created succesfully"
