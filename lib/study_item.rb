require 'sqlite3'
require_relative 'category'

class StudyItem 
    attr_accessor :id, :title, :category, :descr, :done
    def initialize(id:, title:, category: Category.new, descr: 'Sem descrição', done: 'Em Andamento')
        @id = id
        @title = title
        @category = category
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

      def self.save_to_db(category, title, descr)
        db = SQLite3::Database.open 'db/database.db'
        db.execute "INSERT INTO task VALUES('#{ id }', '#{ title }', '#{ category }', '#{ descr }', '#{ done }')"
        db.close
    
        self
      end

     

end