# details of the gateway
gcloud compute vpn-gateways describe vpc-demo-vpn-gw1 --region europe-west1
gcloud compute vpn-gateways describe on-prem-vpn-gw1 --region europe-west1

# details of the routers
gcloud compute routers describe vpc-demo-router1     --region europe-west1
gcloud compute routers describe on-prem-router1     --region europe-west1

# details of the vpn-tunnels
gcloud compute vpn-tunnels list
gcloud compute vpn-tunnels describe vpc-demo-tunnel0       --region europe-west1
gcloud compute vpn-tunnels describe vpc-demo-tunnel1       --region europe-west1
gcloud compute vpn-tunnels describe on-prem-tunnel0       --region europe-west1
gcloud compute vpn-tunnels describe on-prem-tunnel1       --region europe-west1
