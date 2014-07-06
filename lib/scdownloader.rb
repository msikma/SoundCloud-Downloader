require "scdownloader/version"

module Scdownloader
  class Song
      attr_reader :id, :stream_url, :name, :url
      def initialize(url)
          @url = url
          @name = url.split("/").last
          @id ||= get_id
          @stream_url ||= get_stream_url
      end

      def download (file = "#{@name}.mp3")
           uri = URI(@stream_url)
           Net::HTTP.start(uri.host) do |http|
             begin
               file = open("#{file}", 'w')
               http.request_get('#{uri.path}?#{uri.fragment}') do |response|
                 response.read_body do |segment|
                  file.write(segment)
                 end
               end
             ensure
               file.close
             end
           end
      end

      private

      def get_stream_url
          response = Unirest::Unirest.get "https://api.sndcdn.com/i1/tracks/#{@id}/streams", headers: {}, parameters: { :client_id => $client_id }
          response.body["http_mp3_128_url"]
      end

      def get_id
          response = Unirest::Unirest.get "https://api.sndcdn.com/resolve?_status_code_map%5B302%5D=200", 
              headers: { "Accept" => "application/json" }, 
              parameters: {
                  :url => @url,
                  :_status_format => 'json',
                  :client_id => $client_id
              }
          uri = URI.parse(response.body["location"]).path.to_s
          uri.split('/').last
      end
  end
end
    