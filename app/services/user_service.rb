class UserService
  include AfterCommitEverywhere

  def successful
    ActiveRecord::Base.transaction do
      User.create! name: 'abc', age: 123
      User.create! name: 'def', age: 456
      after_commit { puts 'Created 2 new users!' }
      ActiveRecord::Base.transaction do
        User.create! name: 'ghi', age: 789
      end
      after_commit { puts 'All is well.' }
    end
  end

  def failing
    ActiveRecord::Base.transaction do
      User.create! name: 'abc', age: 123
      User.create! name: 'def', age: 456
      after_commit { puts 'Created 2 new users!' }
      ActiveRecord::Base.transaction do
        User.create!
      end
      after_commit { puts 'All is well.' }
    end
  end

  def without_transaction(*args)
    User.create! name: 'abc', age: 123
    User.create! name: 'def', age: 456
    after_commit { puts 'Created 2 new users!' }
    User.create! *args
    after_commit { puts 'Created 2 new users!' }
  end
end