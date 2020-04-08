class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = UIViewController.alloc.init
    rootViewController.title = 'sqlite3-leak'
    rootViewController.view.backgroundColor = UIColor.whiteColor

    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    library_path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, true)[0]
    db_path = File.join(library_path, 'test.db')
    @db = SQLite3::Database.new(db_path)

    @db.execute(<<-SQL)
      CREATE TABLE IF NOT EXISTS test (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          str1 VARCHAR(255),
          str2 VARCHAR(255)
      );

      delete from test;
    SQL

    @q = Dispatch::Queue.new("db stuff")

    Dispatch::Queue.concurrent.async do
      5_000.times do |i|
        @q.async do
          autorelease_pool do
            if i % 2 == 0
              @db.execute "INSERT INTO test (str1, str2) VALUES (?, ?);", ["this is a test string", "this is also a test string"]
            else
              @db.execute "SELECT * FROM test limit 15;" { |row| }
            end
          end
        end
      end
    end

    true
  end
end
