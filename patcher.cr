require "./utils.cr"

def lietuvybes_ijungimas(data : MainFile)
    unless lietuvybe_importuota data
        data.@inner_lines.insert 1, BasicStatement.new("\nusing System.Text;")
    end
    main_function = get_main_function data
    main_function.@inner_lines.insert 0, BasicStatment.new("\n" + get_indentation main_function + "Console.Encoding = Encoding.UTF8;")
end
