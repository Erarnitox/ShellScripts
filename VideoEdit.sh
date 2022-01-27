# This script edits a video:
# 1) It adds a watermark picture
# 2) it boosts the audio of the original clip
# 3) it adds background music
# 4) adds an intro and outro clip
# 5) generate a thumbnail for the video

# Programs required: ffmpeg, convert

#!/bin/sh

TITLE=$2
INTRO="/home/me/Projects/Erarnitox/Video/intro.mkv"
OUTRO="/home/me/Projects/Erarnitox/Video/outro.mkv"
WATERMARK="/home/me/Projects/Erarnitox/Video/watermark.png"
BG_MUSIC="/home/me/Projects/Erarnitox/Video/background.wav"
THUMB_TEXT="${TITLE}"
THUMB_TEMPLATE="/home/me/Projects/Erarnitox/Video/rain_thumb.png"
THUMB="_tmb.png"
TMP=$1

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 VIDEO TITLE"
    exit 1;
fi

# add watermark
ffmpeg -y -i "${TMP}" -i "${WATERMARK}" -filter_complex "overlay='if(lt(t,9), -w+(t)*200, 1600)':50" watermarked.mp4 

# boost audio
ffmpeg -y -i ./watermarked.mp4 -filter:a "volume=2.0" boosted.mp4 

# add background music
ffmpeg -y -stream_loop -1 -i "${BG_MUSIC}" -i ./boosted.mp4 -filter_complex "[0:a]volume=0.05,amix" -map 1:v -map 0:a -map 1:a -shortest with_bg.mp4 

# add intro and outro
ffmpeg -i "${INTRO}" -i with_bg.mp4 -i "${OUTRO}" -filter_complex "[0:v][0:a][1:v][1:a] concat=n=3:v=1:a=1 [outv][outa]" -map "[outv]" -map "[outa]" -vsync vfr "${TITLE}"".mp4"

# generate thumbnail
convert -gravity Center -pointsize 150 -fill cyan -annotate +0+0 "${THUMB_TEXT}" "${THUMB_TEMPLATE}" "${TITLE}""${THUMB}"

# clean up
rm watermarked.mp4
rm boosted.mp4
rm with_bg.mp4
