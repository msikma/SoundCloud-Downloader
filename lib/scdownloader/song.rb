require "unirest"

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
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      begin
        file = open("#{file}", 'wb')
        http.request_get uri.request_uri do |response|
          downloaded = 0
          total_length = response['Content-Length'].to_f
          response.read_body do |segment|
            downloaded += (segment.length).to_f
            print "\rDownloaded " + (((downloaded/total_length)*100).to_i).to_s + "%"
            STDOUT.flush
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
    response = Unirest.get "https://api.sndcdn.com/i1/tracks/#{@id}/streams", headers: {}, parameters: { :client_id => $client_id }
    response.body["http_mp3_128_url"]
  end

  def get_id
    response = Unirest.get "https://api.sndcdn.com/resolve?_status_code_map%5B302%5D=200", 
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