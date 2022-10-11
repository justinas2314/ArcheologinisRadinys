require "./utils.cr"

def get_length_inside_braces(raw_data : String)
    count = 1
    raw_data.each_char_with_index do |i, j|
        case i
        when '{'
            count += 1
        when '}'
            count -= 1
        end
        if count == 0
            return j
        end
    end
end


def iterate_with_groupings(raw_file_contents : String)
    last_index = 0
    open = 0
    i = 0
    while i < raw_file_contents.size
        case raw_file_contents[i]
        when '('
            open += 1
            i += 1
        when ')'
            open -= 1
            i += 1
        when '{'
            # p! raw_file_contents[i + 1..]
            # puts raw_file_contents[i + 1..]
            # p! get_length_inside_braces raw_file_contents[i + 1..]
            brace_part_length = (get_length_inside_braces raw_file_contents[i + 1..]).as(Int32)
            # puts raw_file_contents[i + 1..i + brace_part_length]
            # tell do while and while apart with the semicolon
            if raw_file_contents[last_index...i].strip() == "do"
                raw_file_contents[i + brace_part_length + 2..].each_char_with_index do |j, k|
                    if j == ';'
                        last_index = i + brace_part_length + 2
                        i = i + k + brace_part_length + 3
                        break
                    end
                end
            end
            yield raw_file_contents[last_index...i], raw_file_contents[i + 1..i + brace_part_length]
            last_index = i = i + brace_part_length + 2
        when ';'
            i += 1
            if open == 0
                yield raw_file_contents[last_index...i], nil
                last_index = i = i + 1
            end
        else
            i += 1
        end
    end
    begin
        yield raw_file_contents[last_index..], nil
    rescue
    end
end

def from_grouping(root : String)
    kids = Array(Statement).new
    iterate_with_groupings(root) do |i, j|
        kids << from_grouping i, j
    end
    MainFile.new kids, root
end


# switch case statements (prob impossible to fuck that up so no need to check)

def from_grouping(root : String, extra : String?)
    if extra.nil?
        return BasicStatement.new root, root
    end
    kids = Array(Statement).new
    iterate_with_groupings(extra) do |i, j|
        kids << from_grouping i, j
    end
    if root.includes? "if"
        if root.includes? "else"
            return ElseIfStatement.new root, kids, extra
        else
            return IfStatement.new root, kids, extra
        end
    end
    if root.includes? "else"
        return ElseStatement.new kids, extra
    end
    if root.includes? "foreach"
        return ForEachLoopStatement.new root, kids, extra
    end
    if root.includes? "for"
        return ForLoopStatement.new root, kids, extra
    end
    if root.includes? "while"
        if root.includes? ";"
            return DoWhileLoopStatement.new root, kids, extra
        else
            return WhileLoopStatement.new root, kids, extra
        end
    end
    if root.includes? "try"
        return TryStatement.new kids, extra
    end
    if root.includes? "catch"
        return CatchStatement.new root, kids, extra
    end
    if root.includes? "finally"
        return FinallyStatement.new kids, extra
    end
    if root.includes? "switch"
        return SwitchStatement.new root, kids, extra
    end
    if root.includes? "class"
        return ClassStatement.new root, kids, extra
    end
    if root.includes? "namespace"
        return NamespaceStatement.new root, kids, extra
    end
    # need to make sure this is a function not an array or something
    if root.includes?("(") && root.includes?(")")
        return FunctionStatement.new root, kids, extra
    end
    return BasicStatement.new root + "{" + extra + "}", root + "{" + extra + "}"
end
