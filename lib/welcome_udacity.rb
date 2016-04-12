require 'twitter'
require 'language_converter'

class WelcomeUdacity

    @@rest_countries_europe_url = 'https://restcountries.eu/rest/v1/region/europe'
    @@tweet_to_udacity = "%s @Udacity ! Welcome to Europe. Check out: http://premium.easypromosapp.com/p/217374 #UdacityEurope https://goo.gl/fh990i"

    def initialize(options={})
        @consumer_key = options[:consumer_key]
        @consumer_secret = options[:consumer_secret]
        @access_token = options[:access_token]
        @access_token_secret = options[:access_token_secret]
        @google_api_key = options[:google_api_key]
        @google_search_engine_id = options[:google_search_engine_id]

        initialize_twitter
        initialize_countries_in_europe
    end

    def initialize_twitter
        @twitter_client  = Twitter::REST::Client.new do |config|
          config.consumer_key        = @consumer_key
          config.consumer_secret     = @consumer_secret
          config.access_token        = @access_token
          config.access_token_secret = @access_token_secret
        end
    end

    def initialize_countries_in_europe
        uri = URI(@@rest_countries_europe_url)
        response = Net::HTTP.get_response(uri)
        @countries = JSON.parse(response.body)
        print_list_of_countries_and_languages
    end

    public

    def print_list_of_countries_and_languages
        puts "Countries, Capital and language"
        @countries.each do |country|
            puts "Country: #{country["name"]}, Capital: #{country["capital"]}, Language:#{country["languages"][0]}"
        end
    end

    def tweet_from_country(country_name)
        countries = Array.new
        if country_name.downcase == "all"
            countries = @countries
        elsif country_name.downcase == "random"
            upper_random = @countries.length
            countries << @countries[rand(0..upper_random)]
        else
            countries = @countries.select { |c| c["name"].downcase == country_name.downcase  }
        end

        unless countries == nil || countries.length == 0
            countries.each do |country|
                tweet_with_picture(
                country: country["name"],
                capital: country["capital"],
                language: country["languages"],
                lat: country["latlng"][0].to_f,
                long: country["latlng"][1].to_f)
            end
        else
            puts "No country with name #{country_name}. Get countries with method: print_list_of_countries_and_languages"
        end
    end

    private

    def get_url_of_image_from_google(text)
        uri = URI('https://www.googleapis.com/customsearch/v1')
        params = { :q => text, cx: @google_search_engine_id,
                    searchType: 'image', key: @google_api_key}
        uri.query = URI.encode_www_form(params)
        response = Net::HTTP.get_response(uri)
        result = JSON.parse(response.body)
        urls = result["items"].map { |item| item["link"] }
        return urls[rand(0...10)]
    end

    def get_twitter_text(language_code)
        translated_text = translate('Hello', language_code)
        tweet_text = @@tweet_to_udacity % translated_text.capitalize
    end

    def tweet_with_picture(options={})
        url = get_url_of_image_from_google("#{options[:country]} #{options[:capital]}")
        uri = URI.parse(url)
        puts url
        media = uri.open
        media.instance_eval("def original_filename; '#{File.basename(uri.path)}'; end")
        text_to_tweet = get_twitter_text(options[:language])

        @twitter_client.update_with_media(text_to_tweet, media, lat:options[:lat], long:options[:long])
        puts "Tweeted for country #{options[:country]}: \" #{text_to_tweet}\". With picture: #{url}"
    end

    def translate(text, to, from='en')

        if to[0] == from
            return text
        end

        uri = URI.parse("http://mymemory.translated.net/api/get")
        response = Net::HTTP.post_form(uri, {"q" => text,"langpair"=>"#{from.to_s.downcase}|#{to[0].to_s.downcase}", "per_page" => "50"})
        json_response_body = JSON.parse(response.body)

        if json_response_body['responseStatus'] == 200
          json_response_body['responseData']['translatedText']
        else
            if to.length == 1
                puts "Error translating"
            else
                translate(text, to.select { |e| to.index(e) > 0  } )
            end
        end
    end
end
