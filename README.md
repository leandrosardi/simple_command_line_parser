# Simple Command Line Parser

Easy library to validate and parse command line parameters. 

This gem has been designed as a part of the **BlackStack** framework.

I ran tests on:

- Ubuntu 18.04,
- Ubuntu 20.04,
and
- Windows 7 only.

Email to me if you want to collaborate.

**Outline**

1. [Installation](#1-installation)
2. [Getting Started](#2-getting-started)
3. [Missing Parameters](#3-missing-parameters)
4. [Optional Parameters](#4-optional-parameters)
5. [Type Mismatching](#5-type-mismatching)

## 1. Installation

```
gem install simple_command_line_parser
```

## 2. Getting Started

The command line parser & validation will be done in the same moment when you create the parser object.

As an example, create the a new file,

```
touch ~/example.rb
```

And write this script there:

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

  # TODO: Code your process here.

  puts "Bye!"
rescue => e
  puts "error"
  puts e.to_s
end
```

Try running the script:

```
ruby ~/example.rb url=foo.com max_retries=2 check_for_virus=yes
```

```
Parse command line... done

Param url == foo.com
Param max_retries == 2
Param check_for_virus == true

Bye!
```

## 3. Missing Parameters

Using the same code than the previous sections, will raise an exception if one of the parameters is missed in the command line.

```
ruby ~/example.rb url=foo.com max_retries=2
```

```
Parse command line... error
Command line parameter check_for_virus expected.
```

## 4. Optional Parameters

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
        :mandatory=>false, # <==== OPTIONAL PARAMETER
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
ruby ~/example.rb url=foo.com max_retries=2
```

```
Parse command line... done

Param url == foo.com
Param max_retries == 2
Param check_for_virus == false

Bye!
```

## 5. Type Mismatching

If you declare a parameters as an integer, you can't send other value than an integer in the command line.

```
ruby ~/example.rb url=foo.com max_retries=not-an-integer
```

```
Parse command line... error
Type mismatch for the command line parameter max_retries.
```

If you declare a parameter as a boolean, you can'tsend other value than 'yes' or 'no' in the command line

```
ruby ~/example.rb url=foo.com max_retries=2 check_for_virus=maybe
```

```
Parse command line... error
Type mismatch for the command line parameter check_for_virus.
```

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the last [ruby gem](https://rubygems.org/gems/simple_command_line_parser). 

## Authors

* **Leandro Daniel Sardi** - *Initial work* - [LeandroSardi](https://github.com/leandrosardi)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
