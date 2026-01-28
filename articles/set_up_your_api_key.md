# Set up your API key

You should use an API key to identify yourself when you access
data.census.gov. Like many public APIs, the US Census Bureau’s data
portal allows anonymous users. However, it limits the number of requests
that an anonymous user can send, both per second and per day. If you
[register](http://api.census.gov/data/key_signup.md) with the site, it
will send you a key. You can use the key to identify yourself when
making future calls. Chances are that you will never come up against any
kind of throttling.

To make it easy for new users, `hercacstables` includes a function,
[`api_key_setup()`](https://higherx4racine.github.io/hercacstables/reference/api_key_setup.md),
that will take you to the sign-up page and then help you permanently
save your key as a local environment variable. That variable is called
“CENSUS_API_KEY” to be compatible with another popular package for
accessing the Census API,
[tidycensus](https://walker-data.com/tidycensus/index.html).

``` r
hercacstables::api_key_setup()
```
