require 'Date'

#pathtobatch = '../batch-import/gowalla/'
pathtobatch = '../batch-import/sample2/'
pathtoinput = "./real_data/"

#make sure to make the nodes first, followed by the relationships
EPOCH = Date.parse('2010-04-27')
#EPOCH = Date.parse('2010-05-27')
locs = Hash.new(0)
users = Hash.new(0)
days = Hash.new(0)
events = Hash.new(0)
user_user_rels = Hash.new(0)
user_event_rels = Hash.new(0)
event_loc_rels = Hash.new(0)
event_day_rels = Hash.new(0)
#users_loc_rels = Hash.new(0) #getting rid of this

event_nodes_csv=File.open(pathtobatch+'event_nodes.csv', 'w+')
day_nodes_csv=File.open(pathtobatch+'day_nodes.csv', 'w+')
event_day_rels_csv=File.open(pathtobatch+'event_day_rels.csv', 'w+')
event_loc_rels_csv=File.open(pathtobatch+'event_loc_rels.csv', 'w+')
user_event_rels_csv=File.open(pathtobatch+'user_event_rels.csv', 'w+')
day_day_rels_csv=File.open(pathtobatch+'day_day_rels.csv', 'w+')
user_user_rels_csv= File.open(pathtobatch+'user_user_rels.csv', 'w+')


event_nodes_csv.puts"event_id:int:event_id|l:label"
day_nodes_csv.puts"day_id:int:day_id|l:label"
event_day_rels_csv.puts"event_id:int:event_id|day_id:int:day_id|when"
event_loc_rels_csv.puts"event_id:int:event_id|location_id:int:location_id|where"
user_event_rels_csv.puts"user_id:int:user_id|event_id:int:event_id|who"
day_day_rels_csv.puts"day_id:int:day_id|day_id:int:day_id|time_hop"
user_user_rels_csv.puts"user_id:int:user_id|user_id:int:user_id|friend"  #header


event_id = 0
@last_day
File.open(pathtoinput+"checkins.txt", "r").each do |record|
  data = []
  record.split(" ").each do |field|
    field.chomp!
    data.push(field)
  end
    day_id = Date.parse(data[1]) - EPOCH
    location_id = data[4]
    event_nodes_csv.puts"#{event_id}|event"
    user_id = data[0]
    users[data[0]] = true
    locs[data[4]] = {:lat => data[2], :long => data[3]}
    event_day_rels_csv.puts"#{event_id}|#{day_id}|when"
    event_loc_rels_csv.puts"#{event_id}|#{location_id}|where"
    user_event_rels_csv.puts"#{user_id}|#{event_id}|who"
    event_id+=1
    @last_day = day_id
end

all_days = *(-1..@last_day-1)
all_days.each do |item|
  day_nodes_csv.puts"#{item+1}|day"
  day_day_rels_csv.puts"#{item}|#{item+1}|time_hop"
end


user_edge_count = 0
File.open(pathtoinput+"edges.txt", "r").each do |record|
  data = []
  record.split(" ").each do |field|
    field.chomp!
    data.push(field)
  end
    user_user_rels_csv.puts"#{data[0]}|#{data[1]}|friend"
    #just in case they weren't in the checkins file
    users[data[0]] = true
    users[data[1]] = true
    #the social network
    user_user_rels[user_edge_count] = {:user_1 => data[0], :user_2 => data[1]}
    user_edge_count+=1
end

#have to use this method because users are repeated in both input files
File.new(pathtobatch+'user_nodes.csv',File::CREAT)
user_nodes_csv= File.open(pathtobatch+'user_nodes.csv', 'w+')
user_nodes_csv.puts"user_id:int:user_id|l:label"  #header

    users.each do |key, value|
      if key != nil
        user_nodes_csv.puts"#{key}|user" #puts "#{key}: #{value}"
      end
    end

#have to use this method because locations are repeated in input file
File.new(pathtobatch+'location_nodes.csv',File::CREAT)
loc_nodes_csv= File.open(pathtobatch+'location_nodes.csv', 'w+')
loc_nodes_csv.puts"location_id:int:location_id|lat:float|long:float|l:label"  #header

    locs.each do |key, value|
      if key != nil
        loc_nodes_csv.puts"#{key}|#{value[:lat]}|#{value[:long]}|location" #puts "#{key}: #{value}"
      end
    end
=begin
#this is wrong, oops
File.new(pathtobatch+'user_user_rels.csv',File::CREAT)
user_user_rels_csv= File.open(pathtobatch+'user_user_rels.csv', 'w+')
user_user_rels_csv.puts"user_id:int:user_id|user_id:int:user_id|friend"  #header

    user_user_rels.each do |key, value|
      if key != nil
        user_user_rels_csv.puts"#{value[:user_1]}|#{value[:user_2]}|friend" #puts "#{key}: #{value}"
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
=end   
    


