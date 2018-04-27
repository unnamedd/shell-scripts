#!/bin/bash

# You should install cloc before use this script
# https://github.com/AlDanial/cloc

for i in $(ls -d */); do 
	cd ${i%%/};
	dir=${i%?}

	cloc --exclude-dir=Carthage,.build,.frameworks,rakelib --exclude-lang=Ruby,JSON,XML,YAML,Markdown --md -out="../RESULT-${dir}.md" --by-file-by-lang --quiet ./
			
	cd ..
done
