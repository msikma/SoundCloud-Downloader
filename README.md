# SoundcloudDownloader

SoundcloudDownloader is a tool used to download songs from SoundCloud to your computer as MP3.

## Installation

    $ gem install soundcloud_downloader

## Usage

Stand alone:

    $ soundcloud_downloader URL

In your own Ruby applications:

    require 'soundcloud_downloader'

    song = Song.new("https://soundcloud.com/example/example-song-name")
    song.id # => 123456
    song.stream_url # => https://soundcloud.hs.llnwd.net/Example.128.mp3?AWSAccessKeyId=Example&Expires=Example&Signature=Example%3D&e=Example&h=Example
    song.name # => example-song-name
    song.url # => https://soundcloud.com/example/example-song-name
    song.download # This will download the song as mp3