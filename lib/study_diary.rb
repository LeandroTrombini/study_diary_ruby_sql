require_relative 'category'
require_relative 'study_item'


class StudyDiary
    attr_accessor :items
    def initialize(items: [])
        @items = items
    end
    REGISTER = 1
    DELETE = 2
    ALL = 3
    SEARCH_ITEM = 4
    SEARCH_DONE = 5
    DONE = 6
    EXIT = 7

    def menu
        opcao_selecionada = 0
        while opcao_selecionada != EXIT
            opcoes_menu = <<~MENU           
            ========= Menu ==========\n
        [#{REGISTER}] Cadastrar um item para estudo
        [#{DELETE}] Remover um item 
        [#{ALL}] Ver todos os itens cadastrados
        [#{SEARCH_ITEM}] Buscar um item         
        [#{SEARCH_DONE}] Buscar itens concluídos         
        [#{DONE}] Marcar como concluído        
        [#{EXIT}] Sair        
        Escolha uma opção:
        MENU

        puts opcoes_menu
        opcao_selecionada = gets.to_i

        case opcao_selecionada
        when 1
            cadastrar_item
        when 2
            remover_item
        when 3
          puts "Visualizar itens por categoria? (S, N)"
          result = gets().chomp().to_s
          if result.downcase == 's'
            puts "Digite o nome da categoria que deseja:"
            buscar_categoria = gets().chomp().to_s
            imprimir_itens(buscar_categoria)
          else
            imprimir_itens
          end
        when 4
            procurar_item
        when 5
            procurar_item_concluido
        when 6
            concluido
        when 7
          puts "Você saiu do Diário de Estudos"
        else
          puts "Opção não encontrada. Tente novamente."
        end
      end
    end

    def cadastrar_item
      items = StudyItem.all
        puts "Digite o título do item: "
        nome = gets().chomp().to_s       

        puts "Digite a categoria do item: "
        categoria = gets().chomp().to_s    
         
        puts "Digite uma descrição:"
        descricao = gets().chomp().to_s
          
        id_item = items.length + 1
        puts
        StudyItem.save_to_db(id_item, nome, categoria, descricao, 'Em andamento')
        
        puts "Item cadastrado!"          
        
    end

    def imprimir_itens(buscar_categoria = '')
      items = StudyItem.all
        puts "========= Títulos cadastrados =========="
        puts
        if buscar_categoria == ''
            items.each do |item|
            puts "[#{item.id}] - Nome: #{item.title} / Categoria: #{item.category.name} / Descrição: #{item.descr} / Status: #{item.done}"      
            puts
            end
        else
            item_buscado = items.select {|i| i.category.name.downcase.include? buscar_categoria.downcase}
            if item_buscado.length != 0
                item_buscado.each do |item|
                  puts "[#{item.id}] - Nome: #{item.title} / Categoria: #{item.category.name} / Descrição: #{item.descr} / Status: #{item.done}"
                end
                puts 
            else 
                puts "Nenhum item cadastrado"
            end
        end
    end

    def remover_item
      items = StudyItem.all
        puts "Digite o código do item a ser deletado:"         
            item_para_deletar = gets.to_i

            if item_para_deletar != 0  
              StudyItem.delete_by_id(item_para_deletar)              
              puts "#{item_para_deletar} removido!"
            else
              puts "Código não localizado. Tente novamente."
            end            
      end

      def procurar_item
        items = StudyItem.all
        puts "Digite o nome do item que deseja buscar:"       
        item = gets().chomp().to_s    
            
            StudyItem.find_by_title(item)    
      end

      def procurar_item_concluido
                      
            StudyItem.all_done               
      end


      def concluido 
        items = StudyItem.all
        puts
        items.each do |item|
          puts "[#{item.id}] - Nome: #{item.title} / Categoria: #{item.category.name} / Descrição: #{item.descr} / Status: #{item.done}"   
        end    
          puts 
          puts "Escolha um item para ser concluído: "
        
        puts
        item_para_concluir = gets.to_i
        StudyItem.done(item_para_concluir)

      end
    
end
StudyDiary.new.menu()