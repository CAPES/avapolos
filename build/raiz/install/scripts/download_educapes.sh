#!/bin/bash

echo "baixando educapes"

rm -rf "wget-log"

sudo mkdir -p /opt/dspace/downloads
cd /opt/dspace/downloads

rm -rf *

file="http://uploads.capes.gov.br/files/volumesEducapes.part01.rar http://uploads.capes.gov.br/files/volumesEducapes.part02.rar http://uploads.capes.gov.br/files/volumesEducapes.part03.rar http://uploads.capes.gov.br/files/volumesEducapes.part04.rar http://uploads.capes.gov.br/files/volumesEducapes.part05.rar http://uploads.capes.gov.br/files/volumesEducapes.part06.rar http://uploads.capes.gov.br/files/volumesEducapes.part07.rar http://uploads.capes.gov.br/files/volumesEducapes.part08.rar http://uploads.capes.gov.br/files/volumesEducapes.part09.rar"

for FILE in $file; do
	echo "$FILE"			
	wget --limit-rate=100K --progress=dot:giga -c -t 0 -o ../wget-log "$FILE"
	name=$(echo $FILE | rev | cut -d "/" -f1 | rev)
	echo "$name" > status.log			
done

unrar x "volumesEducapes.part01.rar"

mv -f assetstore ..
mv -f data-solr ..
mv -f database ..

chmod root:root -R /opt/dspace

touch ../done