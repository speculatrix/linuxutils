#!/bin/bash

mytext=$( echo $* | sed -e 's/ /+/g' )

vlc --play-and-exit -I dummy "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&q=$mytext"

