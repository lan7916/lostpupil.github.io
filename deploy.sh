#!/bin/bash
jekyll build
rsync -vzr --delete _site/* deploy@eurus.cn:/var/www/lostpupil
