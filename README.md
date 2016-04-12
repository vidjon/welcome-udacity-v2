# welcome-udacity-v2

Welcome Udacity To Europe With a Tweet from a country in Europe!
Tweet with a "Hello" in the country language and a picture of the capital geotagged.

# About

Version 2 of the program that was Created for participating in Udacity promo in Europe https://github.com/vidjon/welcome-udacity

# How to use

The parameters to initiate the Class WelcomeUdacity are:
Twitter: (consumer_key, consumer_secret, access_token, access_token_secret)
Google: (google_api_key, google_search_engine_id)

When the Class has been initiated, countries from Europe are printed out.

Then the user can use method tweet_from_country, with the country name as a parameter, "all" for tweeting from all countries and "random" for a random country.

The program gets information about countries in Europe from REST Countries and uses that information
to search in google custom search engine for the country and the capital and chooses randomly a picture from the top 10 results.

"Hello" is translated to the country language using mymemory.translated.net

The picture is then geotagged and Tweeted with the text from Udacity promo with greetings in the country language.

# References

Twitter Gem : https://github.com/sferik/twitter
Twitter DEV: https://dev.twitter.com/
REST Countries : https://restcountries.eu/
Translate Gem (source code used for accessing mymemory): https://rubygems.org/gems/language-converter/versions/1.0.0
MyMemory: http://mymemory.translated.net/
Google Custom Search : https://cse.google.com/
