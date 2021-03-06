# Simple Command Line Parser

Easy library to validate and parse command line parameters. 

This gem has been designed as a part of the **BlackStack** framework.

I ran tests in Windows environments only.

Email to me if you want to collaborate, by testing this library in any Linux platform.

### Installing

```
gem install simple_command_line_parser
```

## Running the tests

Here are some tests about how to use this gem properly, and how to avoid some common mistakes.

### Specify the list of parameters

The command line parser & validation will be done in the same moment when you create the parser object.

```ruby
require 'simple_command_line_parser'

parser = nil

print "Parse command line... "
begin
  parser = BlackStack::SimpleCommandLineParser.new(
    :description => 'This example command would downolad and install a software.', 
    :configuration => [{
        :name=>'url', 
        :mandatory=>true, 
        :description=>'URL from where download the installer.', 
        :type=>BlackStack::SimpleCommandLineParser::STRING,
      },
      {
        :name=>'max_retries', 
        :mandatory=>true, 
        :description=>'Max number of download retries if the download keep failing.', 
        :type=>BlackStack::SimpleCommandLineParser::INT,
      },
      {
        :name=>'check_for_virus', 
        :mandatory=>true, 
        :description=>'Run verifications when login.', 
        :type=>BlackStack::SimpleCommandLineParser::BOOL,
      },
    ]
  )
  puts "done"
  puts ""
  puts "Param url == #{parser.value('url').to_s}"
  puts "Param max_retries == #{parser.value('max_retries').to_s}"
  puts "Param check_for_virus == #{parser.value('check_for_virus').to_s}"
  puts ""
  puts "Bye!"
rescue => e
  puts "error"
  puts e.to_s
end
```

```
C:\source>ruby example.rb url=foo.com max_retries=2 check_for_virus=yes
Parse command line... done

Param url == foo.com
Param max_retries == 2
Param check_for_virus == true

Bye!
```

### Avoid missed parameters in the command line

Using the same code than the previous sections, will raise an exception if one of the parameters is missed in the command line.

```
C:\source>ruby example.rb url=foo.com max_retries=2
Parse command line... error
Command line parameter check_for_virus expected.
```

### Optional parameters & default values

You can make some parameters not mandatory (optional), but you have to setup a default value for them.

```ruby
require 'simple_command_line_parser'

parser = nil

print "Parse command line... "
begin
  parser = BlackStack::SimpleCommandLineParser.new(
    :description => 'This example command would downolad and install a software.', 
    :configuration => [{
        :name=>'url', 
        :mandatory=>true, 
        :description=>'URL from where download the installer.', 
        :type=>BlackStack::SimpleCommandLineParser::STRING,
      },
      {
        :name=>'max_retries', 
        :mandatory=>true, 
        :description=>'Max number of download retries if the download keep failing.', 
        :type=>BlackStack::SimpleCommandLineParser::INT,
      },
      {
        :name=>'check_for_virus', 
        :mandatory=>false, 
        :description=>'Run verifications when login.', 
        :type=>BlackStack::SimpleCommandLineParser::BOOL,
        :default=>false
      },
    ]
  )
  puts "done"
  puts ""
  puts "Param url == #{parser.value('url').to_s}"
  puts "Param max_retries == #{parser.value('max_retries').to_s}"
  puts "Param check_for_virus == #{parser.value('check_for_virus').to_s}"
  puts ""
  puts "Bye!"
rescue => e
  puts "error"
  puts e.to_s
end 
```

```
C:\source>ruby example.rb url=foo.com max_retries=2
Parse command line... done

Param url == foo.com
Param max_retries == 2
Param check_for_virus == false

Bye!
```

### Avoid mismatch types in the command line

If you declare a parameters as an integer, you can't send other value than an integer in the command line.

```
C:\source>ruby example.rb url=foo.com max_retries=not-an-integer
Parse command line... error
Type mismatch for the command line parameter max_retries.
```

If you declare a parameter as a boolean, you can'tsend other value than 'yes' or 'no' in the command line

```
C:\source>ruby example.rb url=foo.com max_retries=2 check_for_virus=maybe
Parse command line... error
Type mismatch for the command line parameter check_for_virus.
```

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the last [ruby gem](https://rubygems.org/gems/simple_command_line_parser). 

## Authors

* **Leandro Daniel Sardi** - *Initial work* - [LeandroSardi](https://github.com/leandrosardi)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
