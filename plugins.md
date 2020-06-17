### [插件优先级说明](https://docs.konghq.com/2.0.x/plugin-development/custom-logic/)

Your plugin’s priority can be configured via a property accepting a number in the returned handler table:
```
CustomHandler.PRIORITY = 10
```
The current order of execution for the bundled plugins is:
           
|Plugin	 | Priority                   |
| ------ | ------                     |
|pre-function	|+inf                 |
|zipkin	|100000                       |
|ip-restriction|	3000              |
|bot-detection	|2500                 |
|cors	|2000                         |
|session	|1900                     |
|kubernetes-sidecar-injector	|1006 |
|jwt	|1005                         |
|oauth2	|1004                         |
|key-auth	|1003                     |
|ldap-auth	|1002                     |
|basic-auth|	1001                  |
|hmac-auth	|1000                     |
|request-size-limiting	|951          |
|acl	|950                          |
|rate-limiting	|901                  |
|response-ratelimiting	|900          |
|request-transformer	|801          |
|response-transformer	|800          |
|aws-lambda	|750                      |
|azure-functions	|749              |
|prometheus	|13                       |
|http-log	|12                       |
|statsd	|11                           |
|datadog	|10                       |
|file-log	|9                        |
|udp-log	|8                        |
|tcp-log	|7                        |
|loggly|	6                         |
|syslog|	4                         |
|request-termination|	2             |
|correlation-id	|1                    |
|post-function |-1000                 |


### [插件执行顺序说明](https://docs.konghq.com/0.14.x/admin-api/#information-routes/)

Precedence
A plugin will always be run once and only once per request. But the configuration with which it will run depends on the entities it has been configured for.

Plugins can be configured for various entities, combination of entities, or even globally. This is useful, for example, when you wish to configure a plugin a certain way for most requests, but make authenticated requests behave slightly differently.

Therefore, there exists an order of precedence for running a plugin when it has been applied to different entities with different configurations. The rule of thumb is: the more specific a plugin is with regards to how many entities it has been configured on, the higher its priority.

The complete order of precedence when a plugin has been configured multiple times is:

Plugins configured on a combination of: a Route, a Service, and a Consumer. (Consumer means the request must be authenticated).
Plugins configured on a combination of a Route and a Consumer. (Consumer means the request must be authenticated).
Plugins configured on a combination of a Service and a Consumer. (Consumer means the request must be authenticated).
Plugins configured on a combination of a Route and a Service.
Plugins configured on a Consumer. (Consumer means the request must be authenticated).
Plugins configured on a Route.
Plugins configured on a Service.
Plugins configured to run globally.