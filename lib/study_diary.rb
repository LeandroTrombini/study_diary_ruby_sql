require_relative 'category'
require_relative 'study_item'



class StudyDiary
    attr_accessor :items
    def initialize(items: [])
        @items = items
    end


    def menu
        opcao_selecionada = 0
        while opcao_selecionada != 6
            opcoes_menu = <<~MENU           
            ========= Menu ==========\n
        [1] Cadastrar um item para estudo
        [2] Remover um item 
        [3] Ver todos os itens cadastrados
        [4] Buscar um item         
        [5] Concluído        
        [6] Sair        
        Escolha uma opção:
        MENU

        puts opcoes_menu
        opcao_selecionada = gets().chomp().to_i

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
            concluido
        when 6
          puts "Você saiu do Diário de Estudos"
        else
          puts "Opção não encontrada. Tente novamente."
        end
      end
    end

    def cadastrar_item
        puts "Digite o título do item: "
        nome = gets().chomp().to_s       

        puts "Digite a categoria do item: "
        categoria = gets().chomp().to_s    
         
        puts "Digite uma descrição:"
        descricao = gets().chomp().to_s
          
        id_item = items.length + 1
        puts
        items = StudyItem.new(id: id_item, title: nome, category: categoria, descr: descricao, done: done)
        StudyItem.save_to_db(id_item, nome, categoria, descricao, 'Em andamento')
        puts "Item cadastrado!"     
        
        
    end

    def imprimir_itens(buscar_categoria = '')
      items = StudyItem.all
        puts "========= Títulos cadastrados =========="
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
        puts "Digite o código do item a ser deletado:"
            item_para_deletar = gets().chomp().to_i
            if item_para_deletar <= items.length
              items.delete_at(item_para_deletar - 1)
              puts "#{item_para_deletar} removido!"
            else
              puts "Código não localizado. Tente novamente."
            end

      end

      def procurar_item
        puts "Digite o nome do item que deseja buscar:"
    
        item = gets().chomp().to_s
    
        puts "Items encontrados"
    
        item_buscado = items.select {|i| i.title.downcase.include? item.downcase}
        if item_buscado.length != 0
            item_buscado.each do |item|
            puts "[#{item.id}] - #{item.title} / Categoria: #{item.category.name} / Descrição: #{item.descr} / Status: #{item.done}"
          end
          puts "\n\n"
        else
          puts "Nenhum item encontrado com o termo de busca"
        end
    
      end


      def concluido 
        puts "Código a ser concluído: "
        item_para_concluir = gets().chomp().to_i
        if item_para_concluir <= items.length
          items[item_para_concluir - 1].done = 'Concluído'
        else
          puts "Código não localizado. Tente novamente."
        end

      end
    
end
StudyDiary.new.menu()