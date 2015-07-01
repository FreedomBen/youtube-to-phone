#!/usr/bin/env bash

die()
{
  echo "[Error]: $1"
  exit 1
}

if [ -z "$1" ]; then
  die "Oh no!  I need a URL of a video to download!"
fi

if ! $(which youtube-dl >/dev/null 2>&1); then
  die "Uh oh, you need to install youtube-dl"
fi

read -p "Do you want the audio only? [Y/n]: " audio_only
read -p "Enter your phone's IP address or leave blank to not xfer: " phone_ip

audio_flag=""
if [[ $audio_only =~ [Yy] ]]; then
  audio_flag="--extract-audio"
fi

cd "$(mktemp -d)"
youtube-dl $audio_flag "$1"

if [ -n "$phone_ip" ]; then
  scp -P 54321 * "${phone_ip}:/sdcard/Music"
  depart_msg=''
else
  depart_msg='(did not transfer to phone cause you did not enter an IP address)'
fi

echo "All done! $depart_msg"
