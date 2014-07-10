# SoundcloudDownloader

SoundcloudDownloader is a tool used to download songs from SoundCloud to your computer as MP3.

## Installation

    $ gem install soundcloud_downloader

## Usage

CLI:

    $  soundcloud-downloader <URL> [OPTIONS]
          -o, --out [filename]             Filename for the MP3, optional
          -f, --folder [folder]            Folder to save the MP3 to, optional
          -v, --version                    Show version

In your own Ruby applications:

    require 'soundcloud_downloader'

    song = Song.new("https://soundcloud.com/example/example-song-name")
    song.id # => 123456
    song.stream_url # => https://soundcloud.hs.llnwd.net/Example.128.mp3?AWSAccessKeyId=Example&Expires=Example&Signature=Example%3D&e=Example&h=Example
    song.name # => example-song-name
    song.url # => https://soundcloud.com/example/example-song-name
    song.download # This will download the song as mp3
