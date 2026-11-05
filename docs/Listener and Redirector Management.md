## Overview 

Once the Team Server is up and running, an important consideration and measure for any engagement is the configuration of a listener and a redirector. In the context of Trinity C2 a listener can both be a configuration for an Agent payload and directive for the Team Server to initiate polling on a specified port for incoming checkin requests. A redirector as the name implies redirects traffic to the appropriate endpoint on the Team Server and forwards the response to the relevant Agent which has initiated the request. 

## Listener Management 

To manage Trinity C2 listeners, select the **Listeners** toolbar icon. This will open a tab listing all of your configured listeners. 

![[Pasted image 20261103124454.png]]

The management options for each configured listener will present a dialogue and are as follows: 
- Add - create an additional listener configuration.
- Edit - modify an existing listener configuration.
- Restart - stop and resume polling on a HTTP listener configuration's bind port. 
- Remove - terminate an existing listener configuration. 

It should be noted that `restart` only applies to listener configurations that issue a polling directive on the Team Server, such as the HTTP listener.  

![[Pasted image 20261103124520.png]]

## HTTP(S) Listener Setup

To create a HTTP or HTTPS Beacon listener select **Listeners** toolbar icon on the main menu and press the **Add** button at the bottom of the Listeners tab display.

The New Listener dialogue displays the following: 

![[Pasted image 20261103124520.png]]

Select **HTTP** or **HTTPS** as the type and give the listener a **Name**. Make sure to give the new listener configuration a memorable name as this name is how you will refer to this listener throughout various Trinity C2 workflows such as payload generation and Agent management. Valid characters are alphabetic (a-z and A-Z), numeric (0-9), dash (-), period (.), and underscore (_).
### Parameters

- **HTTP(S) Hosts** - Press **[+]** to add one or more hosts for the HTTP(S) Agent to checkin to. Press **[-]** to remove one or more hosts.
- **Host Rotation Strategy** - This value configures the beacons behaviour for choosing which host(s) from the list to use for checkin. Select one of the following:
	- **Round-robin** - Loop through the list of host names in the order they are provided. Each host is used for one checkin. 
	- **Random** - Select to randomly select a host name from the list each time a checkin is attempted.
- **Max Retry Stategy** - This configures the Agent behavior for exiting after a number of consecutive failed checkin attempts to the Team Server.
	- **Default** - Agent will not exit because of failed connection attempts.
- **C2 Port** - This field sets the port your HTTP(S) Agent will checkin to.
- **Bind Port** - This field specifies the port which should be listener upon for Agent checkin requests. 
- **HTTP(S) Host Header** - The headers that should be used. If nothing is provided then the listener configuration will use `Content-type: */*` or else the agent wont be able to checkin.
- **User Agent** - The user agent that should be used by the Agent for checkin requests. 

## TOR Listener Setup 

TODO 

## Redirector Setup 

A redirector is a system that sits between your target’s network and your Team Server. Any connections that come to the redirector are forwarded to your Team Server to process. A redirector is a way to provide multiple hosts for your Agent to checkin to. Additionally, a redirector bolsters operational security as it makes it harder to trace the true location of your Team Server.

Trinity C2's listener management features support the use of redirectors. Simply specify your redirector hosts when you configure an HTTP(S)  listener. Trinity C2 does not validate this information, it is therefore your responsibility to ensure the redirector and listener configurations are correct. Furthermore, Trinity C2 does not provide a redirector, therefore it lies at your discretion as to which third-party redirector you wish to choose fit for this purpose.   

### Apache 2 

The Apache 2 HTTP Server is a free and open-source cross-platform web server and has been chosen to demonstrate the use of a redirector within the context of Trinity C2's listener configurations. 

The following modules will be required to set up Apache 2 as a redirector: 
- **mod_rewrite** - Allows rules to be written to forward requests based on HTTP/S content.
- **mod_proxy** - Allows Apache to act as a reverse or forward proxy.
- **proxy_http** - Enables the server to act as proxy for HTTP (mod_proxy needs to be enabled).
- **mod_headers** - Enables the manipulation of HTTP request and response headers.

**Below is the command to enable the modules mentioned above:**

```shell-session
a2enmod rewrite && a2enmod proxy && a2enmod proxy_http && a2enmod headers && systemctl start apache2 && systemctl status apache2
```

**If you encounter a `Module rewrite already enabled` error due to a lack of permissions despite running as the root user, use the following command:**

```shell-session
sudo a2enmod proxy 
sudo systemctl restart apache2
```

**Lastly check if Apache 2 is running with the following command:**

```shell-session
systemctl status apache2
```

*NOTE: Apache 2 listens on port 80 by default, however if there is already a service running on this port you will need to close it.*

### Troubleshooting 

Sometimes  despite all modules appearing to be enabled there is failure to forward the request. In this eventuality use WireShark with the HTTP(S) filter to validate that the request is being received by your endpoint. 

Notice below that there is an Internal server error: 

![[Pasted image 20261103133332.png]]

Inspect the logs under `/var/log/apache2/error.log`, in this case no protocol handler was valid for the URL. This indicates there is an issue with how the server is handling the HTTP(S) request, typically this is the cause of `mod_proxy_http` not being enabled.  To resolve this issue, run the following command below: 

```shell-session
sudo a2enmod proxy_http
sudo systemctl restart apache2
```

