module SQLite3
  class ResultSet
    def initialize(statement, handle)
      @statement = statement
      @handle = handle
    end

    def each(&block)
      until @statement.done?
        yield current_row

        @statement.step
      end
    end

    private

    def current_row
      row = {}

      column_count = sqlite3_column_count(@handle)
      0.upto(column_count - 1) do |i|
        name = sqlite3_column_name(@handle, i).to_sym
        type = sqlite3_column_type(@handle, i)

        case type
        when SQLITE_NULL
          row[name] = nil
        when SQLITE_TEXT
          row[name] = sqlite3_column_text(@handle, i)
        when SQLITE_BLOB
          row[name] = NSData.dataWithBytes(sqlite3_column_blob(@handle, i), length: sqlite3_column_bytes(@handle, i))
        when SQLITE_INTEGER
          row[name] = sqlite3_column_int64(@handle, i)
        when SQLITE_FLOAT
          row[name] = sqlite3_column_double(@handle, i)
        end
      end

      row
    end
  end
end
