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

gg!


### TODO:

- Signup and Choice of the Capital...
- All via GoogleMap (after signup mail confirmation).

locations:

- manca la serbia!!


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

firenze
43.7687324, 11.2569013


- http://code.google.com/apis/ajax/playground/#tile_detector
- code at the end of this file is (http://code.google.com/apis/ajax/playground/#geocoding_extraction) modified


WarGame

[europe]
- test mongodb vs mysql geocoder
- check acqua
- csv citta con population
- resque queues?
- citta' alla ogame non alla travian



-----

    imagemagick favicon notes:
   
    convert some_image.bmp -resize 256x256 -transparent white favicon-256.png
    convert favicon-256.png -resize 16x16 favicon-16.png
    convert favicon-256.png -resize 32x32 favicon-32.png
    convert favicon-256.png -resize 64x64 favicon-64.png
    convert favicon-256.png -resize 128x128 favicon-128.png
    
    convert favicon-16.png favicon-32.png favicon-64.png favicon-128.png favicon-256.png -colors 256 favicon.ico