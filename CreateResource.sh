# Create cloud's VPC and subnet
gcloud compute networks create vpc-demo --subnet-mode custom
sleep 10 
gcloud compute networks subnets create vpc-demo-subnet1 --network vpc-demo --range 10.1.1.0/24 --region "europe-west1"
gcloud compute networks subnets create vpc-demo-subnet2 --network vpc-demo --range 10.2.1.0/24 --region europe-west4 
sleep 10 
gcloud compute firewall-rules create vpc-demo-allow-custom   --network vpc-demo   --allow tcp:0-65535,udp:0-65535,icmp   --source-ranges 10.0.0.0/8
gcloud compute firewall-rules create vpc-demo-allow-ssh-icmp     --network vpc-demo     --allow tcp:22,icmp
#gcloud compute instances create vpc-demo-instance1 --machine-type=e2-medium --zone europe-west1-c --subnet vpc-demo-subnet1
#gcloud compute instances create vpc-demo-instance2 --machine-type=e2-medium --zone europe-west4-b --subnet vpc-demo-subnet2

# Create on-prem's VPC and subnet
gcloud compute networks create on-prem --subnet-mode custom
sleep 10
gcloud compute networks subnets create on-prem-subnet1 --network on-prem --range 192.168.1.0/24 --region europe-west1
sleep 5
gcloud compute firewall-rules create on-prem-allow-custom   --network on-prem   --allow tcp:0-65535,udp:0-65535,icmp   --source-ranges 192.168.0.0/16
gcloud compute firewall-rules create on-prem-allow-ssh-icmp     --network on-prem     --allow tcp:22,icmp
#gcloud compute instances create on-prem-instance1 --machine-type=e2-medium --zone europe-west1-b --subnet on-prem-subnet1

# Create cloud's gateways
gcloud compute vpn-gateways create vpc-demo-vpn-gw1 --network vpc-demo --region europe-west1
sleep 10
# Create on-prem's gateways
gcloud compute vpn-gateways create on-prem-vpn-gw1 --network on-prem --region europe-west1
sleep 10
#gcloud compute vpn-gateways describe vpc-demo-vpn-gw1 --region europe-west1
#gcloud compute vpn-gateways describe on-prem-vpn-gw1 --region europe-west1

# Create cloud's routers
gcloud compute routers create vpc-demo-router1     --region europe-west1     --network vpc-demo     --asn 65001
sleep 5
# Create on-prem's routers
gcloud compute routers create on-prem-router1     --region europe-west1     --network on-prem     --asn 65002
sleep 5

# Create cloud's tunnels
gcloud compute vpn-tunnels create vpc-demo-tunnel0     --peer-gcp-gateway on-prem-vpn-gw1     --region europe-west1     --ike-version 2     --shared-secret [SHARED_SECRET]     --router vpc-demo-router1     --vpn-gateway vpc-demo-vpn-gw1     --interface 0
gcloud compute vpn-tunnels create vpc-demo-tunnel1     --peer-gcp-gateway on-prem-vpn-gw1     --region europe-west1     --ike-version 2     --shared-secret [SHARED_SECRET]     --router vpc-demo-router1     --vpn-gateway vpc-demo-vpn-gw1     --interface 1
sleep 10
# Create on-prem's tunnels
gcloud compute vpn-tunnels create on-prem-tunnel0     --peer-gcp-gateway vpc-demo-vpn-gw1     --region europe-west1     --ike-version 2     --shared-secret [SHARED_SECRET]     --router on-prem-router1     --vpn-gateway on-prem-vpn-gw1     --interface 0
gcloud compute vpn-tunnels create on-prem-tunnel1     --peer-gcp-gateway vpc-demo-vpn-gw1     --region europe-west1     --ike-version 2     --shared-secret [SHARED_SECRET]     --router on-prem-router1     --vpn-gateway on-prem-vpn-gw1     --interface 1
sleep 10

# Create router interface & Border Gateway Protocol (BGP) peering for each tunnel
gcloud compute routers add-interface vpc-demo-router1     --interface-name if-tunnel0-to-on-prem     --ip-address 169.254.0.1     --mask-length 30     --vpn-tunnel vpc-demo-tunnel0     --region europe-west1
sleep 5
gcloud compute routers add-bgp-peer vpc-demo-router1     --peer-name bgp-on-prem-tunnel0     --interface if-tunnel0-to-on-prem     --peer-ip-address 169.254.0.2     --peer-asn 65002     --region europe-west1
sleep 5
gcloud compute routers add-interface vpc-demo-router1     --interface-name if-tunnel1-to-on-prem     --ip-address 169.254.1.1     --mask-length 30     --vpn-tunnel vpc-demo-tunnel1     --region europe-west1
sleep 5
gcloud compute routers add-bgp-peer vpc-demo-router1     --peer-name bgp-on-prem-tunnel1     --interface if-tunnel1-to-on-prem     --peer-ip-address 169.254.1.2     --peer-asn 65002     --region europe-west1
sleep 5

gcloud compute routers add-interface on-prem-router1     --interface-name if-tunnel0-to-vpc-demo     --ip-address 169.254.0.2     --mask-length 30     --vpn-tunnel on-prem-tunnel0     --region europe-west1
sleep 5
gcloud compute routers add-bgp-peer on-prem-router1     --peer-name bgp-vpc-demo-tunnel0     --interface if-tunnel0-to-vpc-demo     --peer-ip-address 169.254.0.1     --peer-asn 65001     --region europe-west1
sleep 5
gcloud compute routers add-interface  on-prem-router1     --interface-name if-tunnel1-to-vpc-demo     --ip-address 169.254.1.2     --mask-length 30     --vpn-tunnel on-prem-tunnel1     --region europe-west1
sleep 5
gcloud compute routers add-bgp-peer  on-prem-router1     --peer-name bgp-vpc-demo-tunnel1     --interface if-tunnel1-to-vpc-demo     --peer-ip-address 169.254.1.1     --peer-asn 65001     --region europe-west1

# Configure firewall rules to allow traffic from the remote VPC
gcloud compute firewall-rules create vpc-demo-allow-subnets-from-on-prem     --network vpc-demo     --allow tcp,udp,icmp     --source-ranges 192.168.1.0/24
gcloud compute firewall-rules create on-prem-allow-subnets-from-vpc-demo     --network on-prem     --allow tcp,udp,icmp     --source-ranges 10.1.1.0/24,10.2.1.0/24