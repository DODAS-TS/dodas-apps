# Quick start

## Requirements

- IAM credentials for accessing the Enabling Facility resources (you can skip this if you are not going to use the INFN infrastructure, e.g. for development instance described later):
    - Register to the IAM-DODAS service by accessing the service [here](https://dodas-iam.cloud.cnaf.infn.it). You can use your IdP because IAM-DODAS supports eduGAIN identity federation. The first registration will require the approval from the DODAS admins.
- oidc-agent installed and configured ([instructions here](setup-oidc.md)):
    - you can skip this if you are not going to use the INFN infrastructure, e.g. for development instance described later
- dodas client installed  ([instructions here](dodas-client.md))
- access to a cloud provider
- curl
- condor client for testing

## Deployment modes

To proceed with an end-to-end deployment from the infrastructure creation to the application setup we propose two approaches:

- using the **[INFN mantained infrastructure](https://dodas-ts.github.io/dodas-templates/quick-start-community/)** (part of the Enabling facility offer, requires a free registration for evaluation purpose [here](https://dodas-iam.cloud.cnaf.infn.it))
- a **[standalone setup](https://dodas-ts.github.io/dodas-templates/quick-start/)** where the needed componentes will be deployed on a docker container. Suggested for a development/playground usage.