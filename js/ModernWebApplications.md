sites built on react, node, etc

crawl with katana to gather as many endpoints as possible  
`https://github.com/projectdiscovery/katana`  

can also use the hack in console located here:  
`https://0-a.nl/jsendpoints.txt`  

use `https://github.com/denandz/sourcemapper` after locating the .map file    
example:  
`./sourcemapper -url https://www.apply-test.originations-np.lfscnp.com/static/js/main.72998b08.chunk.js.map -output ./output/ -proxy http://127.0.0.1:8080`  
after this, run trufflehog on the created directories
`/trufflehog filesystem --directory=./output --debug`  
