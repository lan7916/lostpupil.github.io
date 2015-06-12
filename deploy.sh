#!/bin/bash
jekyll build
rsync -vzr --delete _site/* deploy@eurus.cn:/var/www/lostpupil
rsync -vzr --delete _site/* deploy@banana:/home/deploy/lostpupil
qrsync conf.json
