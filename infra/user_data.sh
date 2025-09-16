#!/bin/bash -xe



echo "Starting user_data script execution..." >> /var/log/user_data.log

# Update system and install packages
yum update -y
amazon-linux-extras install nginx1 -y
yum install -y aws-cli
echo "System packages updated and required software installed." >> /var/log/user_data.log
# --- Sync Web Content from S3 ---
# The --region flag is more reliable for scripts than 'aws configure'.
# This command runs as root, so it has permission to write to /usr/share/nginx/html.
echo "Syncing website files from S3 bucket..."
aws s3 sync s3://devops-assign-web-content/ /usr/share/nginx/html --region ap-southeast-1

echo "Website files synced from S3 bucket." >> /var/log/user_data.log 

# --- Start and Enable Nginx ---
# Now that the content is in place, start the web server.
echo "Starting and enabling Nginx service..."
systemctl start nginx
systemctl enable nginx
echo "Nginx service started and enabled." >> /var/log/user_data.log

echo "User_data script finished successfully."