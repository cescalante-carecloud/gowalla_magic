Real data source: http://snap.stanford.edu/data/loc-gowalla.html

In the same folder, put batch-import, these scripts, and neo4j (whose folder I renamed NEO4J_HOME).

Navigate to the gowalla_magic folder and run the following to populate your batch-import csvs:

ruby batch_instructions.rb

ruby load_nodes.rb

Check if batch-import/sample2 has your new csvs. 
Make sure your java is appropriate: export JAVA_HOME=$(/usr/libexec/java_home)

run batch-import: sh sample2/import.sh

Navigate to your NEO4J folder (which I called NEO4J_HOME) and run it!

./bin/neo4j start
