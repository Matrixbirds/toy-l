require "./lexer"
require "./ast"
require './parser'
require './logger'

require 'ap'

class Program
  include Token::InstanceMethods
  include Parser::InstanceMethods

  def set_binop_precedence
    binop_precedence['<'] = 10
    binop_precedence['+'] = 20
    binop_precedence['-'] = 30
    binop_precedence['*'] = 40
  end

  def run
    set_binop_precedence
    puts "ready> "
    next_token
    loop do
      puts "ready> "
      case cur_tok
      when nil
        return
      when ";"
        next_token
        break
      when TOK_DEF
        handle_definition
        break
      when TOK_EXTERN
        handle_extern
      else
        handle_top_level_expression
        break
      end
    end
  rescue => errors
    awesome_print "ERRORS: BEGIN"
    awesome_print errors.backtrace
    awesome_print "ERRORS: END"
  end

  def next_token
    @cur_tok = gettok
  end

  def logger *args
    @logger ||=  File.new("./#{self.class.name}.log", 'w+')
    @logger.puts *args
  end

  include Logger


  log_around 'debug', Token::InstanceMethods.instance_methods + Parser::InstanceMethods.instance_methods

end

Program.new.run