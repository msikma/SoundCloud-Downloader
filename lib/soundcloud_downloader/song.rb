require "excon"
require "json"
require "uri"
require "mp3info"

class Song
  attr_reader :metadata, :name, :url, :resolved_url

  def initialize(url)
    raise ArgumentError, "Invalid url" if url !~ URI::regexp
    @url = url
    @name = url.split("/").last
    @resolved_url ||= resolve_url
    @metadata ||= get_metadata
    @stream_url ||= get_stream_url
  end

  def download (filename = "#{@metadata['title']}.mp3")
    file = File.open(filename, 'wb')
    
    streamer = lambda do |chunk, remaining_bytes, total_bytes|
      file.write(chunk)
      remaining = ((remaining_bytes.to_f / total_bytes) * 100).to_i
      STDOUT.flush
      print "\rRemaining: #{remaining}%"
    end

    Excon.get(@stream_url, :response_block => streamer)
    file.close
    puts "\r\nSaved to #{File.realpath(filename)}!"
    Mp3Info.open(File.realpath(filename)) do |mp3|
      mp3.tag.title = @metadata["title"]
    end

  end

  private

  def get_stream_url
    response = Excon.get("https://api.sndcdn.com/i1/tracks/#{@metadata['id']}/streams", :query => { :client_id => $client_id })
    JSON.parse(response.body)["http_mp3_128_url"]
  end

  def resolve_url
    response = Excon.get("http://api.soundcloud.com/resolve.json", 
    :query => {
      :url => @url,
      :client_id => $client_id
    })
    JSON.parse(response.body)["location"]
  end

  def get_metadata
    response = Excon.get(@resolved_url,
    :query => {
      :client_id => $client_id
    })
    JSON.parse(response.body)
  end

end