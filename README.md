# Scdownloader

Scdownloader is a tool used to download songs from SoundCloud to your computer as MP3.

## Installation

    $ gem install scdownloader

## Usage

Stand alone:

    $ scdownloader URL

In your own Ruby applications:

    require 'scdownloader'

    song = Song.new("https://soundcloud.com/example/example-song-name")
    song.id # => 123456
    song.stream_url # => https://soundcloud.hs.llnwd.net/Example.128.mp3?AWSAccessKeyId=Example&Expires=Example&Signature=Example%3D&e=Example&h=Example
    song.name # => example-song-name
    song.url # => https://soundcloud.com/example/example-song-name
    song.download # This will download the song as mp3

## Contributing

1. Fork it ( https://github.com/[my-github-username]/scdownloader/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
