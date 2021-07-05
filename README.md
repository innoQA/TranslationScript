# TranslationScript

Script for literal translation of files with html extension. 

Performs a pass through all the html files of the project located in 'src/main/webapp/pages' according to the attributes indicated in the file 'attributes.txt'. When it finds a literal contained by one of the given attributes it creates an entry in the generated file 'json.json', with a tag based on the literal as key and the literal as value.
 
The html file is modified by replacing the literal with the translation tag. This generated json can then be used to input into the i18n files, only changing the values with their respective translations.

Steps to follow

1. Download the project source files.
2. Locate the file 'ScriptFiles' in the root directory of the project.
3. Execute the script inside the file.
4. Obtain the generated json to add to the i18n files and delete the 'ScriptFiles' file from the project.
5. Update the source files of the project in the 'more' tab of the leftnav of the wavemaker project.
