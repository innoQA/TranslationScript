#!/bin/bash

#SEARCH FOR HTML FILES IN THE PROJECT(CURRENT DIR)
find ../src/main/webapp/pages -name '*.html'> files.txt
cat files.txt
cat attributes.txt
#ITERATE OVER HTML FILES
while read currentFile; do
	echo $currentFile >> logs
	#ITERATE OVER EACH ATTRIBUTE TO BE TRANSLATED SPECIFIED IN ATTRIBUTES.TXT FILE
	while IFS=$'\r\n' read -r currentAttribute; do

		echo "currentAttribute: -------------- ${currentAttribute}" >> logs
		grep ${currentAttribute} $currentFile | awk -F "${currentAttribute}=\"" '{print $2}' | cut -d '"' -f1 >> "${currentAttribute}s.txt"

		while read line; do
  			bind=$(echo $line | cut -d ':' -f1)
  			if [ "$line" != "" ]
  			then
			  		#CHECK IF THE TAG HAS ALREADY BEEN TRANSLATED(IF THEN IGNORE)
    				if [ "$bind" != "bind" ]
    				then
					echo $line >> logs
					original_label_name="${line}"
					#THE VALUE OF THE FIELD IS OBTAINED AND TRANSFORMED TO LBL FORMAT.
					modified_label_name=$(echo $original_label_name | sed "s/[- \/\\]/_/g")					#REPLACE " ",\,/,-  =>  _
					modified_label_name=$(echo $modified_label_name | iconv -f UTF-8 -t ASCII//TRANSLIT)	#TRASNFORM UTF-8 => ASCII
					modified_label_name=$(echo $modified_label_name | sed "s/[!@#$%^&*.()~'-]//g")			#REMOVE ALL SPECIAL CHARS
					modified_label_name="LBL_${modified_label_name^^}"										#SET LABEL UPPERCASE
					
					#IS ADDED TO THE JSON FILE THAT STORES ALL TRANSLATIONS
					echo \"${modified_label_name}\": \"${line}\" >> logs
					echo -e \\t\"${modified_label_name}\": \"${line}\", >> json.txt

					#THE ORIGINAL VALUE IS REPLACED BY THE LBL TRANSLATION IN THE HTML FILE
					OLD_VALUE="$currentAttribute=\"$original_label_name\""
					OLD_VALUE="${OLD_VALUE//\//\\\/}"
					NEW_VALUE="$currentAttribute=\"bind:appLocale.$modified_label_name\""
					
					sed -i -e "s/$OLD_VALUE/$NEW_VALUE/g" $currentFile
					
    				fi
  			fi
		done < "${currentAttribute}s.txt"
		rm "${currentAttribute}s.txt"
	done < attributes.txt
	
done < files.txt
rm files.txt
#REMOVE DUPLICATE LINES AND SORT ALPHABETICALLY
cat json.txt | sort | uniq > json.json
sed -i '1s/^/{/' json.json
truncate -s-2 json.json
echo "}" >> json.json
rm json.txt
