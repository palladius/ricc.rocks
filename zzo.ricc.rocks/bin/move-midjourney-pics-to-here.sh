#!/bin/bash


echodo mv ~/Downloads/PalladiusFigata_*png static/gallery/midjourney/
echodo mv ~/Desktop/PalladiusFigata_*png static/gallery/midjourney/

echodo mv ~/Downloads/PalladiusPacans_*png static/gallery/midjourney/
echodo mv ~/Desktop/PalladiusPacans_*png static/gallery/midjourney/

cd static/gallery/midjourney/ && doppioni .
