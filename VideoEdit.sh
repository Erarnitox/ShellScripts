#!/bin/sh

# This script edits a video:
# 1) It adds a watermark picture
# 2) it boosts the audio of the original clip
# 3) it adds background music
# 4) adds an intro and outro clip
# 5) generate a thumbnail for the video

# Programs required: ffmpeg, convert


# Note that this script is still WIP. It is working but will need some adjustments in the future.

TITLE=$2
INTRO="/home/me/Projects/Erarnitox/Video/glitch_intro.mp4"
OUTRO="/home/me/Projects/Erarnitox/Video/glitch2_outro.mp4"
WATERMARK="/home/me/Projects/Erarnitox/Video/watermark.png"
BG_MUSIC="/home/me/Projects/Erarnitox/Video/bg_loop_rev.wav"
THUMB_TEXT="${TITLE}"
THUMB_TEMPLATE="/home/me/Projects/Erarnitox/Video/rain_thumb.png"
THUMB="_tmb.png"
TMP=$1
OUT_DIR="./out/"

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <VIDEO> <TITLE>"
    exit 1;
fi

mkdir -p "${OUT_DIR}"

# improve voice quality
ffmpeg -y -i "${TMP}" -af "highpass=f=200, lowpass=f=3000, \
     equalizer=f=100:t=h:width_type=h:width=200:g=-5" \
     -c:v copy -c:a aac -b:a 192k "${OUT_DIR}""audio_filters.mp4"

# speed up silence
# speed_silence.py --silent-threshold 10 --silent-speed 2 --input-file "${OUT_DIR}""audio_filters.mp4" --output-file "${OUT_DIR}""sped_up.mp4"

# add watermark
ffmpeg -y -i "${OUT_DIR}""audio_filters.mp4" -i "${WATERMARK}" -filter_complex "overlay='if(lt(t,9), -w+(t)*200, 1600)':50" "${OUT_DIR}""watermarked.mp4"

# add background music
#ffmpeg -y -stream_loop -1 -i "${BG_MUSIC}" -i ./boosted.mp4 -filter_complex "[0:a]volume=0.07,amix" -map 1:v -map 0:a -map 1:a -shortest with_bg.mp4 
#ffmpeg -y -stream_loop -1 -i "${BG_MUSIC}" -i "${OUT_DIR}""watermarked.mp4" -filter_complex "[0:a]volume=0.07,amix,[1:a]amerge,pan=stereo|c0<c0+c2|c1<c1+c3[out]" -map 1:v -map "[out]" -c:v copy -shortest "${OUT_DIR}""with_bg.mp4"

# boost audio
# ffmpeg -y -i ./watermarked.mp4 -filter:a "volume=60" boosted.mp4 
ffmpeg -y -i "${OUT_DIR}""watermarked.mp4" -af "volume=10dB, dynaudnorm=f=150" -c:v copy -c:a aac -b:a 192k "${OUT_DIR}""boosted.mp4"

# add intro and outro
ffmpeg -y -i "${INTRO}" -i "${OUT_DIR}""boosted.mp4" -i "${OUTRO}" -filter_complex "[0:v][0:a][1:v][1:a] concat=n=3:v=1:a=1 [outv][outa]" -map "[outv]" -map "[outa]" -fps_mode vfr "${OUT_DIR}""final.mp4"

# normalize audio
ffmpeg -y -i "${OUT_DIR}""final.mp4" -af "dynaudnorm=f=150" -c:v copy -c:a aac -b:a 192k "${TITLE}"".mp4"

# make a screenshot of the video at 30s
ffmpeg -y -ss 30 -i "${TMP}" -vframes 1 "${OUT_DIR}""screenshot.png"

# overlay the screenshot with the thumbnail template:
convert "${OUT_DIR}""screenshot.png" "${THUMB_TEMPLATE}" -compose screen -composite "${OUT_DIR}""thumbnail.png" 

# generate thumbnail
convert -gravity Center -pointsize 100 -fill cyan -annotate +0+0 "${THUMB_TEXT}" "${OUT_DIR}""thumbnail.png" "${TITLE}""${THUMB}"

# clean up
# rm ${TMP}
# rm sped_up.mp4
# rm watermarked.mp4
# rm boosted.mp4
# rm with_bg.mp4
