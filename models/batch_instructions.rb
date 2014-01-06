#batch_instructions.rb
#updates batch-import/sample/import.sh and batch-import/sample/batch.import files
require 'csv'

pathtobatch = '../batch-import/sample/'

File.new(pathtobatch+'import.sh',File::CREAT)
import_instructions= File.open(pathtobatch+'import.sh', 'w+')

import_instructions.puts"echo \"Importing stuff\"
mvn test-compile exec:java -Dexec.mainClass=\"org.neo4j.batchimport.Importer\" \
 -Dexec.args=\"sample/batch.properties ../NEO4J_HOME/data/graph.db 
 sample/user_nodes.csv,sample/specialty_nodes.csv,sample/specialty_type_nodes.csv,sample/physician_nodes.csv
 sample/referral_rels.csv,sample/user_connection_rels.csv,sample/s_s_t_rels.csv,sample/user_specialty_rels.csv,sample/physician_specialty_rels.csv,sample/physician_user_rels.csv\"
"

File.new(pathtobatch+'batch.properties',File::CREAT)
batch_properties_instructions= File.open(pathtobatch+'batch.properties', 'w+')

batch_properties_instructions.puts"dump_configuration=false
cache_type=weak
use_memory_mapped_buffers=true
neostore.propertystore.db.index.keys.mapped_memory=50M
neostore.propertystore.db.index.mapped_memory=50M
neostore.nodestore.db.mapped_memory=200M
neostore.relationshipstore.db.mapped_memory=2G
neostore.propertystore.db.mapped_memory=205M
neostore.propertystore.db.strings.mapped_memory=205M
batch_import.csv.delim=|
#batch_import.node_index.users=exact
#danger
batch_import.keep_db=false  

batch_import.node_index.user_id=exact
batch_import.node_index.location_id=exact
batch_import.node_index.specialty_id=exact
batch_import.node_index.specialty_type_id=exact
"