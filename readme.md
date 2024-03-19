# initial configuration
## Setting roject ID

```
gcloud config set project <RROJECT_ID>
gcloud auth list
```
## Setting Environment variables
```
export = 
export = 
export = 
export = 
export = 
export = 
export = 
export = 
export = 
export = 

```
# Global routing with VPN
HA VPN is a regional resource and cloud router that by default only sees the routes in the region in which it is deployed. To reach instances in a different region than the cloud router, you need to enable global routing mode for the VPC. ***This allows the cloud router to see and advertise routes from other regions.***
## update the bgp-routing mode from Regional to GLOBAL:
```
gcloud compute networks update vpc-demo --bgp-routing-mode GLOBAL
gcloud compute networks describe vpc-demo
```
