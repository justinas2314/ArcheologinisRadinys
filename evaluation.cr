require "./utils.cr"
require "./filters.cr"

class Evaluation
    @lietuvybe_ijungta = false
    @main_funkcijoje_per_daug_ciklu = false
    @inputas_nepaprintinus = false
    @itartini_dictionary = Array(Statement).new
    @itartini_hashset = Array(Statement).new
    @nesutiktini_public = Array(Statement).new
    @sudejimai_i_funkcija = Array(Statement).new
    @galimai_galimos_isskaidyti_funkcijos = Array(Statement).new
    @inputai_funkcijose_kurios_skaiciuoja = Array(Statement).new
    @outputai_funkcijose_kurios_skaiciuoja = Array(Statement).new
    def initialize(data : MainFile)
        cache = Hash(String, String).new
        @lietuvybe_ijungta = lietuvybe_ijungta(data)
        # guess that i found the main function
        @main_funkcijoje_per_daug_ciklu = ciklu_count(get_main_function(data)) > 1
        @inputas_nepaprintinus = inputas_nepaprintinus data
        get_basic_lines(data).each do |i|
            if itartinas_dictionary i
                @itartini_dictionary << i
            elsif itartinas_hashset i
                @itartini_hashset << i
            end
        end
        get_all_class_statements(data).each do |i|
            if nesutiktinas_public i
                @nesutiktini_public << i
            end
        end
        nonbasic_lines(data).each do |i|
            if ar_negalima_sito_sudeti_i_funkcija i, data, cache
                @sudejimai_i_funkcija << i
            end
        end
        get_all_function_statements(data).each do |i|
            if negalima_sios_funkcijos_isskaidyti i
                @galimai_galimos_isskaidyti_funkcijos << i
            end
            if inputas_funkcijoje_kuri_skaiciuoja i
                @inputai_funkcijose_kurios_skaiciuoja << i
            end
            if outputas_funkcijoje_kuri_skaiciuoja i
                @outputai_funkcijose_kurios_skaiciuoja << i
            end
        end
    end
    def display()
        if !@lietuvybe_ijungta
            puts "Lietuvybė neįjungta"
        end
        if @main_funkcijoje_per_daug_ciklu
            puts "Main funkcijoje per daug ciklų."
        end
        if @inputas_nepaprintinus
            puts "Nespausdinama prieš imant duomenis iš konsolės."
        end
        if @itartini_dictionary.size > 0
            puts "Ar čia tikrai reikėjo naudoti dictionary?"
        end
        if @itartini_hashset.size > 0
            puts "Ar čia tikrai reikėjo naudoti hashset?"
        end
        if @nesutiktini_public.size > 0
            puts "Nu, kolega, su public aš nesutinku, pakeiskite, kad šiuos kintamuosius apsaugotumėte."
        end
        if @sudejimai_i_funkcija.size > 0
            puts "Kolega, čia aš sutinku, tačiau jūs šimtuko iš egzamino negautumėte, nes čia yra pasikartojančio kodo, kurį reiktų įdėti į atskirą funkciją."
        end
        @galimai_galimos_isskaidyti_funkcijos.each do |i|
            puts "Ar tikrai negalima '" + i.as(FunctionStatement).@name + "' išskaidyti į kelias mažesnes funkcijas?"
        end
        if @inputai_funkcijose_kurios_skaiciuoja.size > 0 || @outputai_funkcijose_kurios_skaiciuoja.size > 0
            puts "Čia šį kartą tiek to, bet kitam kartui žinokite, kad reiktų geriau atskirti funkcijas, kurios apdoroja konsolės duomenis ar spausdina į konsole ir funkcijas, kurios skaičiuoja."
        end
    end
end
