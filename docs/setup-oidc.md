# Setup oidc-agent for DODAS IAM

Oidc-agent will help up to manage our IAM tokens automaticcally.

## Requirement

- Install oidc-agent as described [here](https://indigo-dc.gitbook.io/oidc-agent/installation)
- Let's kick the agent:
```bash
eval `oidc-agent`
```

## Configurare l'account IAM-demo

Iniziamo creando il nostro account con il nome `dodas`:
```bash
$ oidc-gen dodas
```

You will be prompted with a request for the name of the issuer. Let's insert `https://iam-dodas.cloud.cnaf.infn.it/` and press enter 
```text
[1] https://iam-escape.cloud.cnaf.infn.it/
[2] https://iam-demo.cloud.cnaf.infn.it/
[3] https://accounts.google.com/
[4] https://iam-test.indigo-datacloud.eu/
[5] https://iam.deep-hybrid-datacloud.eu/
[6] https://iam.extreme-datacloud.eu/
[7] https://b2access.eudat.eu/oauth2/
[8] https://b2access-integration.fz-juelich.de/oauth2
[9] https://unity.eudat-aai.fz-juelich.de/oauth2/
[10] https://unity.helmholtz-data-federation.de/oauth2/
[11] https://login.helmholtz-data-federation.de/oauth2/
[12] https://services.humanbrainproject.eu/oidc/
[13] https://aai.egi.eu/oidc/
[14] https://aai-dev.egi.eu/oidc
[15] https://login.elixir-czech.org/oidc/
[16] https://oidc.scc.kit.edu/auth/realms/kit/
[17] https://wlcg.cloud.cnaf.infn.it/
Issuer [https://iam-escape.cloud.cnaf.infn.it/]:  https://dodas-iam.cloud.cnaf.infn.it
```

Then, set `max` for the requested scope and press enter:

```text
This issuer supports the following scopes: openid profile email address phone offline_access
Space delimited list of scopes or 'max' [openid profile offline_access]: max
```

Now you should see something like this:
```text
Registering Client ...
Generating account configuration ...
accepted
To continue and approve the registered client visit the following URL in a Browser of your choice:
https://iam-demo.cloud.cnaf.infn.it/authorize?response_type=code&client_id=c70edf20-51e6-3ae753c&redirect_uri=http://localhost:8080&scope=address phone openid email profile offline_access&access_type=offline&prompt=consent&state=0:BNF-HR38LjQ4MA&code_challenge_method=S256&code_challenge=brx7x6RuQI5rkzlkGwh2u2z7vCVctSlQ
```

If by now a browser window has not been shown let's copy and paste the provided url manually on your browser.

Complete IAM login and if it took more time then expected the session on the terminal could show a timeout like:

```text
Polling oidc-agent to get the generated account configuration .......................
Polling is boring. Already tried 20 times. I stop now.
Please press Enter to try it again.
```

So, once the registration on the browser is completed, just go to the terminal and do what is written there. 

If everything went well you should see the following message. Simply type a password of your choice that will be used for the password encryption:

```text
success
The generated account config was successfully added to oidc-agent. You don't have to run oidc-add.
Enter encryption password for account configuration 'dodas':
```

That's it. Now you can retrieve you valid access token by:

```bash
$ oidc-token dodas
```
```text
eyJraWQiOiJyc2ExIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJlZjVmMTgzZC00ZDllLTRmMmEtOWRjNi0zZjEzNTlmMTliMzUiLCJpc3MiOiJodHRwczpcL1wvaWFtLWRlbW8uY2xvdWQuY25hZi5pbmZuLml0XC8iLCJuYW1lIjoiRGllZ28gQ2lhbmdvdHRpbmk....
```

To get the tool available on all you sessions just include in your bash profile:

```bash
eval `oidc-keychain`
```

On system reboot you can re-authenticate simply with:

```bash
oidc-gen --reauthenticate dodas
```
