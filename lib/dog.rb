class Dog

    attr_accessor :name, :breed, :id

    def initialize(name:, breed:, id: nil)
        @name = name
        @breed = breed
        @id = id
    end

    def self.create_table
        sql = <<-SQL
            CREATE TABLE dogs (
                id INTEGER PRIMARY KEY,
                name TEXT,
                breed TEXT
            );
        SQL

        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = <<-SQL
            DROP TABLE dogs;
        SQL

        DB[:conn].execute(sql)
    end

    def save
        sql = <<-SQL
            INSERT INTO dogs (name, breed)
            VALUES (?, ?);
        SQL

        DB[:conn].execute(sql, self.name, self.breed)
        self.id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]

        self
    end

    def self.create(name:, breed:, id:nil)
        song = self.new(name:name, breed:breed, id:id)
        song.save
    end

    def self.new_from_db(row)
        self.new(id:row[0], name:row[1], breed:row[2])
    end

    def self.all
        sql = <<-SQL
            SELECT * FROM dogs;
        SQL

        DB[:conn].execute(sql).map do |row|
            new_from_db(row)
        end
    end

    def self.find_by_name(name)
        all.find do |song|
            song.name == name
        end
    end

    def self.find(id)
        all.find do |song|
            song.id == id
        end
    end
end
