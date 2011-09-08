# WarGame 
### the return

### setup:

- install rvm: 
    execute this and follow the istructions:
      bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)

- rvm install 1.9.2
- gem i bundler
- bundle
- rake db:create
- rake db:seed (per un db vuoto asd)
- ruby db/refine.rb  (per il db con le locazioni importate da db/european_cities.txt)
- rails server


- TO RUN backgrounDRB server:
 bundle exec script/backgroundrb start
- TO STOP backgrounDRB server:
 bundle exec script/backgroundrb stop
 
- TO START Workers of backgrounDRB in the rails console type:
  MiddleMan.all_worker_info
  
- Workers for now, just log informations in the log/backgroundrb_11006.log file

gg!
### BUGFIX:

- su iOs e Android quando scrolli la mappa non carica le location (ne la mappa?) se non lasci il dito (gestire eventi multitouch)

- ingrandire il tasto close dei dialog

- Firebug shows that the location are loaded multiple times when moving map... wtf? :D

- Examplain to daniel coffee, otherwise he will NEVER be able to add something... ;)

### TODO:

- signup
- choose city
- production
- movement
- attack

milestone:

- alpha version funzionante

locations:

- manca la serbia!!

db:

- test mongodb vs mysql geocoder
- check acqua
- csv citta
  - population da wolfram
- resque queues?
- citta' alla ogame non alla travian


### feature ideas:

qua possiamo buttare giu tutto quello che ci viene in mente, quando avremmo finito il TODO faremo queste:


UX:

- implementare lo scrolling della mappa via freccette


### setup coffeescript:

execute this line to install homebrew:

    /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"

    brew install node
    curl http://npmjs.org/install.sh | sh
    npm install -g coffee-script

done!

try coffee -e "console.log 1+1"

- homebrew page: http://mxcl.github.com/homebrew/


### notes

Destination point given distance and bearing from start point:
http://www.movable-type.co.uk/scripts/latlong.html 


csvs:
- http://askbahar.com/2010/07/02/world-city-locations-database/
- http://www.maxmind.com/app/worldcities
- http://earth-info.nga.mil/gns/html/cntry_files.html

locations:

florence - firenze
43.7687324, 11.2569013


- http://code.google.com/apis/ajax/playground/#tile_detector
- code at the end of this file is (http://code.google.com/apis/ajax/playground/#geocoding_extraction) modified

### testing stack:

Ruby - Rspec:
  
- model (factories instead of fixtures)
- requests (capybara)

ref: http://railscasts.com/episodes/275-how-i-test?autoplay=true

JavaScript - Jasmine:

ref: http://railscasts.com/episodes/261-testing-javascript-with-jasmine

### running the test suite

prepare the db:

     ruby db/refine.rb test

run:

     guard 

(this also runs livereload)

ref: https://github.com/mockko/livereload


### running the test suite (javascript)

    rake jasmine

open http://localhost:8888/



-----

fiko: https://github.com/carllerche/astaire

--- 

imagemagick favicon notes:
   
    convert some_image.bmp -resize 256x256 -transparent white favicon-256.png
    convert favicon-256.png -resize 16x16 favicon-16.png
    convert favicon-256.png -resize 32x32 favicon-32.png
    convert favicon-256.png -resize 64x64 favicon-64.png
    convert favicon-256.png -resize 128x128 favicon-128.png
    
    convert favicon-16.png favicon-32.png favicon-64.png favicon-128.png favicon-256.png -colors 256 favicon.ico