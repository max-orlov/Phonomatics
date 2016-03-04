# Phonomatics
This project provides several easy modules for working with praat and 
a sql based DB. The projects uses the Praat app to analyze wave files, 
any feature extracted from the wave file, is later parsed and inserted into the db.
Labels are also inserted into the db. Those labels and the feature tagging are both used by the machine learning tools (this project provides some Matlab script for machine learning).

### Working with Praat
The project contains a module named PraatPlugin which mainly holds the VoiceAnalyzer interface. The VoiceAnalyzer holds 3 main function

- praat_file_process - runs the praat app on the file (or files) and output a praat output files.
- process_output - which parses the praat output into an easy to use dictionary format.
- full_file_process -  runs both of the functions above.

please note that running the praat file process could require some time (dependent on the number of files you have to process), thus you may want to use process_output if the output files were created by previous VoiceAnalyzer runs (or direct Praat runs).
### Working with the db
The DBInterface module holds 3 main files to work with the db:

- featuresdb - enables adding features into the db. This process is streamlines using the insert_episode which receives data in dictionary (or in file) format and adds the entire content into the db.
- labeldb - enables adding label into the db, while using the easy to create csv files. the labelsdb uses the csv file to add and create the labels db.

### Machine learning
The projects comes with several Matlab scripts which provide machine learning capabilities from the db.
