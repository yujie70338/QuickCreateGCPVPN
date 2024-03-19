# Delete tunnels
gcloud compute vpn-tunnels delete vpc-demo-tunnel0  --region europe-west1 --quiet
gcloud compute vpn-tunnels delete on-prem-tunnel0  --region europe-west1 --quiet 
gcloud compute vpn-tunnels delete vpc-demo-tunnel1  --region europe-west1 --quiet
gcloud compute vpn-tunnels delete on-prem-tunnel1  --region europe-west1 --quiet
sleep 10

# Remove Peering
gcloud compute routers remove-bgp-peer vpc-demo-router1 --peer-name bgp-on-prem-tunnel0 --region europe-west1 --quiet
gcloud compute routers remove-bgp-peer vpc-demo-router1 --peer-name bgp-on-prem-tunnel1 --region europe-west1 --quiet
gcloud compute routers remove-bgp-peer on-prem-router1 --peer-name bgp-vpc-demo-tunnel0 --region europe-west1 --quiet
gcloud compute routers remove-bgp-peer on-prem-router1 --peer-name bgp-vpc-demo-tunnel1 --region europe-west1 --quiet
sleep 10

# Delete routers
gcloud compute  routers delete on-prem-router1 --region europe-west1 --quiet
gcloud compute  routers delete vpc-demo-router1 --region europe-west1 --quiet
sleep 10

# Delete gateways
gcloud compute vpn-gateways delete vpc-demo-vpn-gw1 --region europe-west1 --quiet
gcloud compute vpn-gateways delete vpc-demo-vpn-gw1 --region europe-west1 --quiet
gcloud compute vpn-gateways delete vpc-demo-vpn-gw1 --region europe-west1 --quiet
gcloud compute vpn-gateways delete on-prem-vpn-gw1 --region europe-west1 --quiet
sleep 10

# Delete instances
#gcloud compute instances delete vpc-demo-instance1 --zone europe-west1-c --quiet
#gcloud compute instances delete vpc-demo-instance2 --zone europe-west4-b --quiet
#gcloud compute instances delete on-prem-instance1 --zone europe-west1-b --quiet
#sleep 10

# Delete firewall-rules
gcloud compute firewall-rules delete vpc-demo-allow-custom --quiet
gcloud compute firewall-rules delete on-prem-allow-subnets-from-vpc-demo --quiet
gcloud compute firewall-rules delete on-prem-allow-ssh-icmp --quiet
gcloud compute firewall-rules delete on-prem-allow-custom --quiet
gcloud compute firewall-rules delete vpc-demo-allow-subnets-from-on-prem --quiet
gcloud compute firewall-rules delete vpc-demo-allow-ssh-icmp --quiet
sleep 10

# Delete subnets
gcloud compute networks subnets delete vpc-demo-subnet1 --region europe-west1 --quiet
gcloud compute networks subnets delete vpc-demo-subnet2 --region europe-west4 --quiet
gcloud compute networks subnets delete on-prem-subnet1 --region europe-west1 --quiet
sleep 10

# Delete VPC
gcloud compute networks delete vpc-demo --quiet
gcloud compute networks delete on-prem --quiet
sleep 10 