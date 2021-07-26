class User < ApplicationRecord
  after_commit { puts "Committed change to User #{id}" }
end
