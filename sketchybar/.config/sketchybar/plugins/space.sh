#!/bin/bash

ACCENT_COLOR=0xff7dd3fc
MUTED_COLOR=0xff9ca3af

if [ "$SELECTED" = "true" ]; then
  sketchybar --set $NAME icon.color=$ACCENT_COLOR
else
  sketchybar --set $NAME icon.color=$MUTED_COLOR
fi