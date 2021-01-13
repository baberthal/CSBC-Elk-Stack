# Interview Questions - Network Security

### Unsecured Web Server

#### Problem

Compliance guidelines require web servers implement encryption in motion.
Despite these guidelines, we have discovered a web server running HTTP over port
80, indicating that the traffic is not encrypted.

#### Example Scenario

In Project 1, we had three web servers accepting traffic on port 80. These
machines were the Web-1 VM, the Web-2 VM, and the Web-3 VM. These machines were
all behind a single load-balancer and accepted traffic from a single public IP
address. The load-balancer also accepted HTTP traffic over port 80.

This was permissible due to the configuration of the associated network security
group ("NSG"). The NSG was configured to only allow HTTP traffic on port 80 from
a single IP address (the IP address of my home network), ensuring no
unauthorized traffic was allowed to the machines.

In a real deployment, both the load-balancer and three web VMs would be
configured differently. The load-balancer would be configured to allow HTTP
traffic over port 80 and port 443 (HTTP over TLS). The three web VMs would be
configured to allow HTTP traffic over port 80 and 443. Additionally, the web VMs
would be configured to redirect any traffic from port 80 to port 443. This would
ensure no unencrypted HTTP traffic is sent to and from the web servers, with the
exception of the initial request, if it is over port 80.

#### Solution Requirements

Running HTTP on port 80 presents a potential problem due to the fact none of the
HTTP traffic is encrypted. A malicious actor could potentially intercept this
traffic, and harvest sensitive data, including usernames, passwords and database
configuration, as well as any other user data.

To configure a server to server HTTP traffic safely, the following configuration
changes are needed:

* Allow load-balancer to receive traffic over both port 80 and port 443.
* Allow web VMs to receive traffic over both port 80 and port 443.
* Configure web VMs to redirect traffic from port 80 to port 443.
* Install required modules to enable SSL/TLS.
* Configure SSL certificates on the web VMs.

This fixes the problem by ensuring any traffic over port 80 is redirected to
port 443. Any unencrypted traffic is not allowed (besides the initial request),
and all valuable data is secured.

#### Solution Details

To implement this solution, the following tools and technologies are required
(assuming the web VMs are using the Apache HTTP server):

* Apache HTTP Server
* Apache `mod_ssl`
* Signed SSL certificate

If the web VMs are running the Apache HTTP server, the module `mod_ssl` should
be installed. Apache should also be configured with a virtual host on port 80,
which includes a permanent redirect to the HTTPS version of the site.

Assuming the site we wish to configure has the URL `example.com`, the following
Apache configuration should be used to redirect HTTP traffic from port 80 to
port 443. This configuration also includes aliases for `www.example.com`.

```apache
<VirtualHost *:80>
  ServerName example.com
  ServerAlias www.example.com

  # The following will return HTTP 301 for any requests to http://example.com
  # and http://www.example.com and redirect to https://example.com
  Redirect permanent / https://example.com
</VirtualHost>

<VirtualHost *:443>
  ServerName example.com
  ServerAlias www.example.com

  # Enable http2 and http1.1
  Protocols h2 http/1.1

  # SSL configuration

  # Other Apache configuration
</VirtualHost>
```

Additionally, an SSL certificate would need to be purchased from a trusted root
certificate authority ("CA"), and Apache would need to be configured to use this
new certificate. The specific configuration changes to Apache are out of this
document's scope.

#### Advantages and Disadvantages

###### Advantages

This solution would be backwards-compatible and not break any clients that use
port 80 to communicate with the server. Any and all traffic from port 80 would
simply be redirected to port 443.

Very little work would be required to keep this solution running outside of the
initial configuration. The purchased SSL certificate would need to be updated
periodically when it expires, but would only need to be changed every five to 10
years, depending on the lifetime of the purchased SSL certificate.

###### Disadvantages

Potential disadvantages of this solution are the cost of the SSL certificate, as
well as the technical debt that comes with configuring Apache to use SSL. An SSL
certificate from GoDaddy costs approximately $80 per year for one website, and
$200 per year for multiple websites.

Additionally, security engineers would need to spend time configuring the
various web servers to use HTTPS. While this process could only take a few
hours, engineering time is both precious and expensive. Engineers would have to
take time to configure the server that could otherwise be spent working on
revenue-generating projects. This means the company would be incurring costs not
only for the configuration, but in lost time that could be spent working on
other things.

Overall, the required costs in both monetary value and time would be well worth
it in order to ensure all HTTP traffic is encrypted.
