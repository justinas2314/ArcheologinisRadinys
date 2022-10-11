require "./utils.cr"

def lietuvybe_ijungta(data : MainFile) : Bool
    get_basic_lines(data).each do |i|
        if /Console.OutputEncoding.*=.*Encoding.UTF8/
            return true
        end
    end
    false
end

def itartinas_dictionary(data : BasicStatement) : Bool
    /Dictionary.*<.*,.*>/.matches? data.@raw
end

def itartinas_hashset(data : BasicStatement) : Bool
    /HashSet.*<.*>/.matches? data.@raw
end

def nesutiktinas_public(data : ClassStatement) : Bool
    data.@inner_lines.each do |i|
        if i.class == BasicStatement
            if i.@raw.includes? "public"
                return true
            end
        end
    end
    return false
end

def ar_negalima_sito_sudeti_i_funkcija(data : NBStatement, root : MainFile, cache : Hash(String, String)) : Bool
    count = 0
    nonbasic_lines(root).each do |i|
        if inner_statement_count(i) > 3 && compare_similarity data, i, cache
            count += 1
        end
    end
    return count > 1
end


def inputas_nepaprintinus(data : MainFile) : Bool
    wrote_something = false
    main_function = get_main_function data
    if main_function.nil?
        return false
    end
    main_function.@inner_lines.each do |i|
        if i.@raw.includes? ".Write"
            wrote_something = true
        elsif i.@raw.includes? ".Read"
            return wrote_something
        end
    end
    wrote_something
end

def inputas_funkcijoje_kuri_skaiciuoja(data : FunctionStatement) : Bool
    skaiciavimas = false
    inputinimas = false
    data.@inner_lines.each do |i|
        unless i.class == BasicStatement
            if i.@raw.includes? ".Read"
                inputinimas = true
            else
                case i
                when ForLoopStatement, ForEachLoopStatement, WhileLoopStatement, DoWhileLoopStatement
                    skaiciavimas = true
                end
            end
        end
    end
    skaiciavimas && inputinimas
end

def outputas_funkcijoje_kuri_skaiciuoja(data : FunctionStatement) : Bool
    skaiciavimas = false
    outputinimas = false
    data.@inner_lines.each do |i|
        if i.class == BasicStatement
            if i.@raw.includes? ".Write"
                outputinimas = true
            end
            next
        end
        if i.@raw.includes? ".Write"
            outputinimas = true
        else
            skaiciavimas = true
        end
    end
    skaiciavimas && outputinimas
end

def ciklu_count(data : Nil) : Int32
    0
end

def ciklu_count(data : FunctionStatement) : Int32
    count = 0
    data.@inner_lines.each do |i|
        case i
        when ForLoopStatement, ForEachLoopStatement, WhileLoopStatement, DoWhileLoopStatement
            count += 1
        end
    end
    count
end

def negalima_sios_funkcijos_isskaidyti(data : FunctionStatement) : Bool
    count = 0
    data.@inner_lines.each do |i|
        if i.class != BasicStatement && inner_statement_count(i) > 5
            count += 1
        end
    end
    count > 3
end