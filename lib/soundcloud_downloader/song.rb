require "excon"
require "json"
require "uri"

class Song
  attr_reader :id, :stream_url, :name, :url
  def initialize(url)
    raise ArgumentError, "Invalid url" if url !~ URI::regexp
    @url = url
    @name = url.split("/").last
    @id ||= get_id
    @stream_url ||= get_stream_url
  end

  def download (file = "#{@name}.mp3", folder = "./")
    raise ArgumentError, "Invalid folder" if not File.directory?(folder)
    raise ArgumentError, "Cannot write to this folder" if not File.writable?(folder)
    raise ArgumentError, "File must have .mp3 extension" if File.extname(file) != ".mp3"
    streamer = lambda do |chunk, remaining_bytes, total_bytes|
      file.write(chunk)
      remaining = ((remaining_bytes.to_f / total_bytes) * 100).to_i
      STDOUT.flush
      print "\rRemaining: #{remaining}%"
    end
    path = File.join(folder,File.basename(file))
    file = open(path, 'wb')
    Excon.get(@stream_url, :response_block => streamer)
    puts "\r\nSaved to #{File.realpath(path)}!"
    file.close
  end

  private

  def get_stream_url
    response = Excon.get("https://api.sndcdn.com/i1/tracks/#{@id}/streams", :query => { :client_id => $client_id })
    JSON.parse(response.body)["http_mp3_128_url"]
  end

  def get_id
    response = Excon.get("https://api.sndcdn.com/resolve?_status_code_map%5B302%5D=200", 
    :headers => { "Accept" => "application/json" }, 
    :query => {
      :url => @url,
      :_status_format => 'json',
      :client_id => $client_id
    })
    location = JSON.parse(response.body)["location"]
    uri = URI.parse(location).path.to_s
    uri.split('/').last
  end
end