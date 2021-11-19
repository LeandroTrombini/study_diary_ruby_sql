require 'sqlite3'
require_relative 'category'

class StudyItem 
    attr_accessor :id, :title, :category, :descr, :done
    def initialize(id:, title:, category:, descr: 'Sem descrição', done: 'Em Andamento')
        @id = id
        @title = title
        @category = Category.new(name: category)
        @descr = descr
        @done = done
    end

    def self.all
        db = SQLite3::Database.open 'db/database.db'
        db.results_as_hash = true
        tasks = db.execute 'SELECT * FROM tasks '
        db.close
    
        tasks.map do |task|
          new(id: task['id'], title: task['title'], category: task['category'], descr: task['descr'], done: task['done'])
        end
      end

      def self.save_to_db(id, title, category, descr, done)
        db = SQLite3::Database.open 'db/database.db'
        db.execute "INSERT INTO tasks VALUES('#{ id }', '#{ title }', '#{ category }', '#{ descr }', '#{ done }')"
        db.close
    
        self
      end

      def self.delete_by_id(id)
        db = SQLite3::Database.open "db/database.db"
        db.results_as_hash = true
        tasks = db.execute "DELETE FROM tasks WHERE id=#{id}"
        db.close
      end

      def self.find_by_title(title)
        db = SQLite3::Database.open "db/database.db"
        db.results_as_hash = true
        tasks = db.execute "SELECT id, title, category, descr, done FROM tasks where (title LIKE'%#{title}%' OR descr LIKE'%#{title}%')"
        db.close
        tasks.map {|task| new(id: task['id'], title: task['title'], category: task['category'], descr: task['descr'], done: task['done']) }
        if tasks.length == 0
          return print "Não foi encontrado nenhum item."
        else
          print "Resultado da busca:"
          puts
          tasks.each { |task| print "\n#{task['id']} - #{task['title']} - #{task['category']} - #{task['descr']} - #{task['done']}\n"}
          puts
        end
      end

      def self.all_done
        db = SQLite3::Database.open 'db/database.db'
        db.results_as_hash = true
        tasks = db.execute  "SELECT id, title, category, descr, done FROM tasks where done LIKE 'Concluído'"
        db.close    
        tasks.map do |task|
          new(id: task['id'], title: task['title'], category: task['category'], descr: task['descr'], done: task['done'])
        print "Os itens concluídos são: "
        puts
        tasks.each { |task| print "\n#{task['id']} - #{task['title']} - #{task['category']} - #{task['descript']} - #{task['done']}\n"}
        puts
        end
      end
     
      def self.done(id)
        db = SQLite3::Database.open "db/database.db"
        db.results_as_hash = true
        tasks = db.execute "UPDATE tasks SET done = 'Concluído' WHERE id=#{id}"
        db.close
        
      end
end