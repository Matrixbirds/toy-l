module Parser
  module InstanceMethods
    def cur_tok
      @cur_tok
    end

    def binop_precedence
      @binop_precedence ||= {}
    end

    def tok_precedence
      return -1 unless isascii(cur_tok)

      tok_prec = binop_precedence[cur_tok]
      if tok_prec <= 0
        return -1
      end
      tok_prec
    end

    def logger_error str
      raise "Error: #{str}"
    end

    def parse_number_expr
      result = num_val
      next_token
      result
    end

    def parse_parent_expr
      next_token
      expr = parse_expression
      if cur_tok != ')'
        logger_error("expected ')'")
      end
      next_token
      expr
    end

    def parse_identifier_expr
      id_name = id_str
      next_token
      args = []
      if cur_tok != ')'
        loop do
          if arg = parse_expression
            args << arg
          else
            return nil
          end

          break if cur_tok == ')'

          if cur_tok != ','
            logger_error("Expected ')' or ',' in argument list")
          end
          next_token
        end
      end

      next_token
      [id_name, args]
    end

    def parse_primary
      case cur_tok
      when TOK_IDENTIFIER then parse_identifier_expr
      when TOK_NUMBER then parse_number_expr
      when '(' then parse_parent_expr
      else
        logger_error "unknown token when expecting an expression"
      end
    end

    def parse_bin_op_rhs(expr, lhs)
      loop do
        tok_prec = tok_precedence
        if tok_prec < expr_prec
          return lhs
        end
        bin_op = cur_tok
        next_token

        rhs = parse_primary
        return nil unless rhs
      end
    end

    def parse_expression
      lhs = parse_primary
      return unless lhs
      parse_bin_op_rhs(0, lhs)
    end

    def parse_prototype
      logger_error "Expected function name in prototype" if  cur_tok != TOK_IDENTIFIER
      fn_name = id_str
      next_token

      logger_error "Expected '(' in prototype" if cur_tok != '('
      arg_names = []
      while next_token == TOK_IDENTIFIER
        arg_names << id_str
      end

      if cur_tok != ')'
        logger_error "Expected ')' in prototype"
      end
      next_token
      [fn_name, arg_names]
    end

    def parse_definition
      next_token
      proto = parse_prototype
      return unless proto
      if e = parse_expression
        return [proto, e]
      end
    end

    def parse_top_level_expr
      if e = parse_expression
        return [proto, e]
      end
    end

    def parse_extern
      next_token
      parse_prototype
    end

    def handle_definition
      if parse_definition
        logger_error "Parsed a function definition"
      else
        next_token
      end
    end

    def handle_extern
      if parse_extern
        logger_error "Parsed an extern"
      else
        next_token
      end
    end

    def handle_top_level_expression
      if parse_top_level_expr
        logger_error "Parsed a top-level expr"
      else
        next_token
      end
    end
  end
end