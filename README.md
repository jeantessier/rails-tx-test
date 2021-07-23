# Rails Tx Test

A playground for exploring ActiveRecord transactions.

The sample model `User` has `name` and `age` fields.  The model itself does not
specify any constraints.  But we can make them mandatory in the database with:

```mysql
alter table users modify name varchar(255) not null;
alter table users modify age int(11) not null;
```

When using transactions, and especially nested transactions, database violations
will prevent faulty data from being persisted.

The following example will fail to even make it to the nested transaction.

```ruby
ActiveRecord::Base.transaction do
  User.create! name: 'abc', age: 123
  User.create!
  ActiveRecord::Base.transaction do
    User.create!
  end 
end
```

> The attempt still _uses up_ one User ID.

This next example fails in the nested transaction, which rolls back everything,
including the outer transaction.

The following example will fail to even make it to the nested transaction.

```ruby
ActiveRecord::Base.transaction do
  User.create! name: 'abc', age: 123
  User.create! name: 'def', age: 456
  ActiveRecord::Base.transaction do
    User.create!
  end
end
```

> The attempt still _uses up_ two User IDs.

This last example will succeed and adds three rows to the `users` table.

The following example will fail to even make it to the nested transaction.

```ruby
ActiveRecord::Base.transaction do
  User.create! name: 'abc', age: 123
  User.create! name: 'def', age: 456
  ActiveRecord::Base.transaction do
    User.create! name: 'ghi', age: 789
  end 
end
```

`.create!` raises upon failure, so anything we place after a `.create!` will not
run if that `.create!` fails.  But anything ahead of it will still execute.

In the following example, we will still see the message written to the console,
even though the outer transaction is rolled back and no records are persisted.

```ruby
ActiveRecord::Base.transaction do
  User.create! name: 'abc', age: 123
  User.create! name: 'def', age: 456
  puts 'Created 2 new users!'
  ActiveRecord::Base.transaction do
    User.create!
  end
end
```
