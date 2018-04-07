#!/bin/bash

NOT_IN_USE=`sudo -u minecraft msm world connected | grep "No players" | wc -l`

if [[ $NOT_IN_USE == '1' ]]
then
  sudo -u minecraft msm world say "No one is watching :) skip map generation"
else
  sudo -u minecraft msm world say "Starting map creation..."
  sudo -u minecraft overviewer.py --config=/data/overviewer.conf
  sudo -u minecraft msm world say "Map creation done."
fi

