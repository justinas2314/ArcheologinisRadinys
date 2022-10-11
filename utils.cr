alias Statement = BasicStatement | IfStatement | ElseIfStatement | ElseStatement | ForLoopStatement | ForEachLoopStatement | WhileLoopStatement | DoWhileLoopStatement | TryStatement | CatchStatement | FinallyStatement | SwitchStatement | FunctionStatement | ClassStatement | NamespaceStatement
alias NBStatement = IfStatement | ElseIfStatement | ElseStatement | ForLoopStatement | ForEachLoopStatement | WhileLoopStatement | DoWhileLoopStatement | TryStatement | CatchStatement | FinallyStatement | SwitchStatement | FunctionStatement | ClassStatement | NamespaceStatement


struct BasicStatement
    def initialize(@text : String, @id : Int32 = 0)
        @raw = @text
    end
    def initialize(@text : String, @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        BasicStatement.new @text, @raw, @id
    end
end

struct IfStatement
    def initialize(@args : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        IfStatement.new @args, new_lines, @raw, @id
    end
end

struct ElseIfStatement
    def initialize(@args : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        ElseIfStatement.new @args, new_lines, @raw, @id
    end
end

struct ElseStatement
    def initialize(@inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        ElseStatement.new new_lines, @raw, @id
    end
end

struct ForLoopStatement
    def initialize(@args : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        ForLoopStatement.new @args, new_lines, @raw, @id
    end
end

struct ForEachLoopStatement
    def initialize(@args : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        ForEachLoopStatement.new @args, new_lines, @raw, @id
    end
end

struct WhileLoopStatement
    def initialize(@args : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        WhileLoopStatement.new @args, new_lines, @raw, @id
    end
end

struct DoWhileLoopStatement
    def initialize(@args : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        DoWhileLoopStatement.new @args, new_lines, @raw, @id
    end
end

struct TryStatement
    def initialize(@inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        TryStatement.new new_lines, @raw, @id
    end
end

struct CatchStatement
    def initialize(@args : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        CatchStatement.new @args, new_lines, @raw, @id
    end
end

struct FinallyStatement
    def initialize(@inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        Finally.new new_lines, @raw, @id
    end
end

struct SwitchStatement
    def initialize(@args : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        Finally.new @args, new_lines, @raw, @id
    end
end

struct FunctionStatement
    @static : Bool
    def initialize(@static : Bool, @name : String, @arguments : String, @return_type : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def initialize(root : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
        @static = root.includes? "static"
        @name = ""
        @arguments = ""
        @return_type = ""
        open = 0
        temp = ""
        splat = Array(String).new
        root.each_char do |i|
            case i
            when '('
                if open == 0
                    splat << temp
                    temp = ""
                else
                    temp += i
                end
                open += 1
            when '<'
                open += 1
                temp += i
            when ')', '>'
                open -= 1
                if open == 0
                    splat << temp
                    temp = ""
                else
                    temp += i
                end
            when ' '
                if open == 0
                    splat << temp
                    temp = ""
                else
                    temp += i
                end
            else
                temp += i
            end
        end
        splat = splat.select { |x| x.size > 0}
        @arguments = splat[-1]
        @name = splat[-2]
        begin
            case splat[-3]
            when "public", "private", "protected", "internal"
                @return_type = @name
            else
                @return_type = splat[-3]
            end 
        rescue
            @return_type = @name
        end
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        FunctionStatement.new @static, @name, @arguments, @return_type, new_lines, @raw, @id
    end
end

struct ClassStatement
    def initialize(@name : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def initialize(root : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
        @name = ""
        root.split(' ').each_with_index do |i, j|
            if i == "class"
                @name = root.split(' ')[j + 1]
                return
            end
        end
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        ClassStatement.new @name, new_lines, @raw, @id
    end
end

struct NamespaceStatement
    def initialize(@name : String, @inner_lines : Array(Statement), @raw : String, @id : Int32 = 0)
    end
    def initialize(root : String, @inner_lines : Array(Statement), @raw : Strings, @id : Int32 = 0)
        @name = ""
        root.split(' ').each_with_index do |i, j|
            if i == "namespace"
                @name = root.split(' ')[j + 1]
                return
            end
        end
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        NamespaceStatement.new @name, new_lines, @raw, @id
    end
end

struct MainFile
    def initialize(@inner_lines : Array(Statement), @raw : String)
    end
    def deepcopy()
        new_lines = @inner_lines.map {|x| x.deepcopy}
        MainFile.new new_lines, @raw
    end
end

def get_basic_lines(data : MainFile | NBStatement) : Array(BasicStatement)
    output = Array(BasicStatement).new
    data.@inner_lines.each do |i|
        case i
        when BasicStatement
            output << i
        else
            output.concat(get_basic_lines i)
        end
    end
    output
end

def get_main_function(data : MainFile | Statement)
    case data
    when MainFile, NamespaceStatement, ClassStatement
        data.@inner_lines.each do |i|
            t = get_main_function i
            unless t.nil?
                return t
            end
        end
    when FunctionStatement
        if data.@name == "Main" && (data.@return_type == "int" || data.@return_type == "void")
            return data
        end
    end
    nil
end

def lietuvybe_importuota(data : MainFile)
    get_basic_lines(data).each do |i|
        if /using .*System.Text/.match? i.@raw
            return true
        end
    end
    false
end

def nonbasic_lines(data : MainFile | Statement) : Array(NBStatement)
    output = Array(NBStatement).new
    data.@inner_lines.each do |i|
        case i
        when BasicStatement
        else
            output << i
            output.concat(nonbasic_lines i)
        end
    end
    output
end

def nonbasic_line_raws(data : MainFile | Statement)
    if data.class == BasicStatement
        return
    end
    yield data.@raw
    data.@inner_lines.each do |i|
        nonbasic_line_raws(i).each do |j|
            yield j
        end
    end
end

# the code this returns does not compile
# and should only be used for comparison
def without_whitespace(raw_line : String, cache : Hash(String, String))
    if cache.includes? raw_line
        return cache[raw_line]
    end
    output = ""
    seperator = false
    inside_string = false
    inside_line_comment = false
    inside_lines_comment = false
    escaping_a_character = false
    raw_line[...-1].each_char.zip(raw_line[1..].each_char) do |i, j|
        case i
        when '*'
            if !inside_string && inside_lines_comment && j == '/'
                inside_lines_comment = false
            end
        when '/'
            unless inside_string || inside_line_comment || inside_lines_comment
                inside_lines_comment = j == '*'
                inside_line_comment = j == '/'
            end
        when '\n'
            if inside_string
                output += i
            else
                inside_line_comment = false
            end
        when '\t', ' '
            if inside_string
                output += i
            end
        when ';'
            seperator = !(inside_string || inside_line_comment || inside_lines_comment)
        when '\\'
            escaping_a_character = !(inside_string || inside_line_comment || inside_lines_comment)
            unless inside_line_comment || inside_lines_comment
                output += '\\'
            end
        when '"', '\''
            unless escaping_a_character
                inside_string = !inside_string
            end
            output += i
        else
            if inside_line_comment || inside_lines_comment
                next
            end
            if seperator
                output += ';'
                seperator = false
            end
            output += i
        end
    end
    cache[raw_line] = output
    output
end

def compare_similarity(first : BasicStatement, second : BasicStatement, cache : Hash(String, String))
    without_whitespace(first.@raw, cache) == without_whitespace(second.@raw, cache)
end

def compare_similarity(first : NBStatement, second : NBStatement, cache : Hash(String, String))
    first.@inner_lines.each do |i|
        second.@inner_lines.each do |j|
            unless compare_similarity i, j, cache
                return false
            end
        end
    end
    true
end

def compare_similarity(_a, _b, _c)
    false
end

def get_indentation(data : Statement)
    count = 0
    data.@raw.each_char do |i|
        case i
        when '\n'
        when ' '
            count += 1
        else
            break
        end
    end
    " " * count
end

def inner_statement_count(data : BasicStatement)
    return 1
end

def inner_statement_count(data : NBStatement)
    count = 1
    data.@inner_lines.each do |i|
        count += inner_statement_count i
    end
    count
end

def get_all_class_statements(data : MainFile | NBStatement) : Array(ClassStatement)
    output = Array(ClassStatement).new
    data.@inner_lines.each do |i|
        case i
        when ClassStatement
            output << i
        when BasicStatement
        else
            output.concat(get_all_class_statements i)
        end
    end
    output
end

def get_all_function_statements(data : MainFile | NBStatement) : Array(FunctionStatement)
    output = Array(FunctionStatement).new
    data.@inner_lines.each do |i|
        case i
        when FunctionStatement
            output << i
        when BasicStatement
        else
            output.concat(get_all_function_statements i)
        end
    end
    output
end

def remove_comments(raw_text : String)
    output = ""
    inside_string = false
    inside_line_comment = false
    inside_lines_comment = false
    escaping_a_character = false
    raw_text[...-1].each_char.zip(raw_text[1..].each_char) do |i, j|
        case i
        when '*'
            if !inside_string && inside_lines_comment && j == '/'
                inside_lines_comment = false
            end
        when '/'
            unless inside_string || inside_line_comment || inside_lines_comment
                inside_lines_comment = j == '*'
                inside_line_comment = j == '/'
            end
        when '\n'
            output += i
            inside_line_comment = false
        when '\\'
            escaping_a_character = !(inside_string || inside_line_comment || inside_lines_comment)
            unless inside_line_comment || inside_lines_comment
                output += '\\'
            end
        when '"', '\''
            unless escaping_a_character
                inside_string = !inside_string
            end
            output += i
        else
            if inside_line_comment || inside_lines_comment
                next
            end
            output += i
        end
    end
    output
end