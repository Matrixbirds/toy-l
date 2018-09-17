require 'ostruct'
require 'io/console'
require 'byebug'
require 'bigdecimal'
module Token
  TOK_EOF = -1
  TOK_DEF = -2
  TOK_EXTERN = -3
  TOK_IDENTIFIER = -4
  TOK_NUMBER = -5
  TOK_COMMENT = -6

  Presenter = OpenStruct.new(:identifier_str => nil, :num_val => nil, :comment_str => nil)

  LAST_CHAR = ' ';

  def gettok
    # loop do
    @last_char = LAST_CHAR
    while isspace(@last_char)
      @last_char = STDIN.getch
    end
    if isalpha(@last_char)
      @id_str = @last_char
      while (isalnum(@last_char = STDIN.getch))
        @id_str += @last_char
      end
      return TOK_DEF if @id_str == "def"
      return TOK_EXTERN if @id_str == "extern"
      return TOK_IDENTIFIER
    end

    if isdigit(@last_char) || @last_char == '.'
      @num_str = '';
      loop do
        @num_str += @last_char
        @last_char = STDIN.getch
        break if !isdigit(@last_char) && @last_char != '.'
      end
      @num_val = BigDecimal(@num_str)
      return TOK_NUMBER
    end

    if @last_char == '#'
      while line=gets
        @comment_str = line
        return TOK_COMMENT
      end
      # gettok if @last_char != '\n' && @last_char != '\r'
    end

    this_char = @last_char
    @last_char = STDIN.getch
    return this_char
  end

  def isspace val
    val =~ /\s/
  end

  def isalpha val
    val =~ /[a-zA-Z][a-zA-Z0-9]*/
  end

  def isdigit val
    val =~ /[0-9.]+/
  end

  def isalnum val
    val =~ /[a-zA-Z]/
  end

  def isnewline val
    val =~ /\r\n|\n/
  end

  module_function :gettok, :isspace, :isdigit, :isalpha, :isalnum, :isnewline
end