require "simple_command_line_parser"

parser = nil

print "Parse command line... "
begin
  parser = BlackStack::SimpleCommandLineParser.new(
    :description => "", 
    :configuration => [{
        :name=>'w', 
        :mandatory=>true, 
        :description=>"Worker Name", 
        :type=>BlackStack::SimpleCommandLineParser::STRING
      },
      {
        :name=>'verif', 
        :mandatory=>true, 
        :description=>"Run verifications when login", 
        :type=>BlackStack::SimpleCommandLineParser::BOOL
      },
    ]
  )
  puts "done"
rescue => e
  puts "error"
  puts e.to_s
end
