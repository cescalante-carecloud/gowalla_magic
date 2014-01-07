#pathtobatch = '../batch-import/gowalla/'
pathtobatch = '../../batch-import/sample2/'
pathtoinput = ""

#make sure to make the nodes first, followed by the relationships

locs = Hash.new(0)
users = Hash.new(0)
users_loc_rels = Hash.new(0)
user_user_rels = Hash.new(0)

count = 0
File.open(pathtoinput+"checkins.txt", "r").each do |record|
  data = []
  record.split(" ").each do |field|
    field.chomp!
    data.push(field)
  end
    users[data[0]] = true
    locs[data[4]] = {:lat => data[2], :long => data[3]}
    users_loc_rels[count] = {:user_id => data[0], :location_id => data[4], :date => [data[1]]}
    #split the date into year - data[1][0..4], month - data[1][5..6], day - data[1][8..9]: 
    puts users_loc_rels[count]
    count+=1
end

count = 0
File.open(pathtoinput+"edges.txt", "r").each do |record|
  data = []
  record.split(" ").each do |field|
    field.chomp!
    data.push(field)
  end
    #just in case they weren't in the previous file
    users[data[0]] = true
    users[data[1]] = true
    #the social network
    user_user_rels[count] = {:user_1 => data[0], :user_2 => data[1]}
    count+=1
end
  
  
File.new(pathtobatch+'user_nodes.csv',File::CREAT)
user_nodes_csv= File.open(pathtobatch+'user_nodes.csv', 'w+')
user_nodes_csv.puts"user_id:int:user_id|l:label"  #header

    users.each do |key, value|
      if key != nil
        user_nodes_csv.puts"#{key}|user" #puts "#{key}: #{value}"
      end
    end

File.new(pathtobatch+'location_nodes.csv',File::CREAT)
loc_nodes_csv= File.open(pathtobatch+'location_nodes.csv', 'w+')
loc_nodes_csv.puts"location_id:int:location_id|lat:float|long:float|l:label"  #header

    locs.each do |key, value|
      if key != nil
        loc_nodes_csv.puts"#{key}|#{value[:lat]}|#{value[:long]}|location" #puts "#{key}: #{value}"
      end
    end

File.new(pathtobatch+'user_loc_rels.csv',File::CREAT)
user_loc_rels_csv= File.open(pathtobatch+'user_loc_rels.csv', 'w+')
user_loc_rels_csv.puts"user_id:int:user_id|location_id:int:location_id|checked_in|time"  #header

    users_loc_rels.each do |key, value|
      if key != nil
        #loc_nodes_csv.puts"#{key}#{value[:lat]}|#{value[:long]}|location" #puts "#{key}: #{value}"
        user_loc_rels_csv.puts"#{value[:user_id]}|#{value[:location_id]}|checked_in|#{value[:date]}" #puts "#{key}: #{value}"
      end
    end
    
#this is wrong, oops
File.new(pathtobatch+'user_user_rels.csv',File::CREAT)
user_user_rels_csv= File.open(pathtobatch+'user_user_rels.csv', 'w+')
user_user_rels_csv.puts"user_id:int:user_id|user_id:int:user_id|friend"  #header

    user_user_rels.each do |key, value|
      if key != nil
        user_user_rels_csv.puts"#{value[:user_1]}|#{value[:user_2]}|friend" #puts "#{key}: #{value}"
      end
    end

