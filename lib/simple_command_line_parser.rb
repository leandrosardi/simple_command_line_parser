
module BlackStack

  class SimpleCommandLineParser
    STRING = 0
    INT = 1
    BOOL = 2
    BOOL_VALUES = ['yes', 'no']
    
    attr_accessor :args, :conf, :desc

    # list tha possible values for the :type param in the h configuration.
    # Example: h = [{:name=>'w', :mandatory=>true, :description=>"Worker Name", :type=>BlackStack::CommandLineParser::STRING}] 
    def self.types()
      [
        BlackStack::SimpleCommandLineParser::STRING, 
        BlackStack::SimpleCommandLineParser::INT, 
        BlackStack::SimpleCommandLineParser::BOOL
      ]
    end
 
    # possible values for the bool parameters in the command line
    def self.bool_values()
      BlackStack::SimpleCommandLineParser::BOOL_VALUES
    end
    
    # will raise an exception if argv parameters does not meet with the configuration specification.
    def self.validate_arguments(argv)
      # validate configuration format
      raise "Array of strings expected in the argv parameter." if !argv.kind_of?(Array)
      argv.each { |x| raise "Array of strings expected in the argv parameter." if !x.kind_of?(String) }
    end

    # will raise an exception if the h configuration does not meet with the configuration specification.
    def self.validate_configuration(h)
      raise "Array of strings expected in the h parameter." if !h.kind_of?(Array)
      h.each { |x| raise "Array of hashes expected in the h parameter." if !x.kind_of?(Hash) }
      h.each { |x| 
        raise "A :name key expected in all the params specification." if !x.key?(:name)
        raise "A :mandatory key expected in all the params specification." if !x.key?(:mandatory)
        raise "A :description key expected in all the params specification." if !x.key?(:description)
        raise "A :type key expected in all the params specification." if !x.key?(:type)
        raise "String expected in the value of the :name parameter." if !x[:name].kind_of?(String)
        raise "String expected in the value of the :mandatory parameter." if (x[:mandatory]!=true && x[:mandatory]!=false)
        raise "String expected in the value of the :description parameter." if !x[:description].kind_of?(String)
        raise "Invalid code in the :type parameter." if !self.types.include?(x[:type]) 
      }      
    end # validate_configuration

    # return an array of hashes (args) frm the array of string (argv).
    # Example of the argv array: ['w=worker01', 'd=euler']
    # Example of the args array: [{'w'=>'worker01'}, {'d'=>'euler'}]
    def self.parse_argumnts(argv)
      Hash[ argv.flat_map{|s| s.scan(/([^=\s]+)(?:=(\S+))?/) } ]
    end
 
    # will raise an exception if the argv array does not match with the h configuration
    def self.validate_values(argv, h)
      argc = SimpleCommandLineParser.parse_argumnts(argv)
      h.each { |x|
        # if the parameter is mandatory, it must exist in the argc array
        raise "Command line parameter #{x[:name]} expected." if ( x[:mandatory]==true && !argc.key?(x[:name]) )

        # if the parmaeter exists, it must match with the type
        raise "Type mismatch for the command line parameter #{x[:name]}." if x[:type]==SimpleCommandLineParser::STRING && argc[x[:name]].to_s.size==0
        raise "Type mismatch for the command line parameter #{x[:name]}." if x[:type]==SimpleCommandLineParser::INT && argc[x[:name]].to_s!=argc[x.name].to_i.to_s
        raise "Type mismatch for the command line parameter #{x[:name]}." if x[:type]==SimpleCommandLineParser::BOOL && !SimpleCommandLineParser::bool_values.include?(argc[x[:name]].to_s)
      }
    end

    # argv: Array of strings. It is usually the command line parameters. 
    # h: Array of hashes. Parser configuration.  
    # Example: h = [{:name=>'w', :mandatory=>true, :description=>"Worker Name", :type=>BlackStack::CommandLineParser::STRING}] 
    def set_conf(argv, x)
      # validations
      raise ":configuration key expected" if !x.key?(:configuration)
      raise ":description key expected" if !x.key?(:description)
      
      # will raise an exception if the argv parameters does not meet with the configuration specification.
      SimpleCommandLineParser.validate_arguments(argv)

      # will raise an exception if the h configuration does not meet with the configuration specification.
      SimpleCommandLineParser.validate_configuration(x[:configuration])

      # will raise an exception if the argv array does not match with the h configuration
      SimpleCommandLineParser.validate_values(argv, x[:configuration])
      
      # map the parameterss to the object attributes
      self.args = SimpleCommandLineParser.parse_argumnts(argv)
      self.conf = x[:configuration]
      self.desc = x[:description]

    end # def set_conf
        
    # Unlike the set_conf method, this constructor will use the ARGV constant as the array of command line arguments.
    # This constructor will simply call the set_conf method. 
    # h: Array of hashes. Parser configuration.  
    # Example: h = [{:name=>'w', :mandatory=>true, :description=>"Worker Name", :type=>BlackStack::CommandLineParser::STRING}] 
    def initialize(x)
      self.set_conf(ARGV, x)
    end # initialize

    def key?(k)
      self.args.key?(k)
    end
    
    def value(k)
      self.args[k][:value]
    end
  
    def askHelp?()
      ( key?('h')==true || key?('help')==true || key?('?')==true )
    end
      
    def validate()
      # valido que los argumentos existan en la list de comandos conocidos
      self.args.each do |key, value|
        if (self.allowedParams().include?(key) == false)
          raise "Unhandled command option or parameter (#{key}). Run this command with the option 'help' to get informaton about expected parameters."
        end
      end
      
      # TODO: si se pasa el comando w, entonces no se debepasar el comando d
  
      # TODO: si se pasa el comando w, entonces r debe ser "parent"
  
      # TODO: si se pasa el comando d, entonces no se debepasar el comando w
  
      # TODO: si se pasa el comando d, entonces r debe ser "child"
  
    end
  
    def appUrl()   
      division_name = self.value("d")
      
      # validar que el formato no sea nulo
      if (division_name.to_s.length == 0)
        raise "Division name expected."
      end
    
      if (division_name != "local")
        dname = division_name
      else
        dname = Socket.gethostname # nombre del host local
      end
    
      uri = URI("#{WORKER_API_SERVER_URL}/api1.2/division/get.json")
      res = CallPOST(uri, {'api_key' => WORKER_API_KEY, 'dname' => "#{dname}"})
      parsed = JSON.parse(res.body)
      if (parsed["status"] == WORKER_API_SUCCESS)
        wid = parsed["value"]
         
        ret = "#{parsed["app_url"]}:#{parsed["app_port"]}"
      else
        raise "Error getting connection string: #{parsed["status"]}"
      end
      
      return ret
    end
  
  end # SimpleCommandLineParser

end # module BlackStack