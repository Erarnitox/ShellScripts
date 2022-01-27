#!/bin/sh
youtube-dl -cit FORMAT --extract-audio --audio-format mp3 "$1"
