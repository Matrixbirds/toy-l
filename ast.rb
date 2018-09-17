module ExprAST
  def initialize; raise NotImplementedError ;end
end

class NumberExprAST
  include ExprAST
  attr_reader :val

  def initialize val
    @val = val
  end
end

class VariableExprAST
  include ExprAST
  attr_reader :name

  def initialize name
    @name = name
  end
end

class BinaryExprAST
  include ExprAST
  attr_reader :op, :lhs, :rhs
  def initialize op, lhs, rhs
    @op = op
    @lhs = lhs
    @rhs = rhs
  end
end

class CallExprAST
  include ExprAST
  attr_reader :callee, :args

  def initialize callee, args
    @callee = callee
    @args = args
  end
end

class PrototypeAST
  attr_reader :name

  def initialize name, args
    @name = name
    @args = args
  end
end

class FunctionAST
  attr_reader :proto, :body

  def initialize proto, body
    @proto = proto
    @body = body
  end
end