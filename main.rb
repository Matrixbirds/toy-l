require "./lexer"
require "./ast"

class Program
  def run
    loop do
      logger next_token
    end
  end

  def next_token
    @curtok = Token.gettok
  end

  def logger *args
    @logger ||=  File.new("./#{self.class.name}.log", 'w+')
    @logger.puts *args
  end
end

Program.new.run