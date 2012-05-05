# daggregator-rails

Model bindings to aggregate Rails Models to a daggregator server

## Installation

Just add it to your `Gemfile` and `bundle`

    gem "daggregator-rails"

    bundle install

## Use

daggregator-rails maps attributes on your models to keys on daggregator
nodes and `has_many` relationships between your models to daggregator flows.
We'll take care of keeping your attibutes and relationships in sync with
the server, all you need to do is specify which attributes and relationships
you want to track.

``` ruby
# app/models/user.rb
class User
  include Daggregate                                      # Include the DSL

  has_many :postings
  has_many :conversations, :through => :postings

  aggregate_to do |node|
    node.key :popularity                                  # Maps user.popularity to nod[:popularity]
    node.key :user_age, :from => :age                     # Maps user.age to node[:user_age]
    node.key :friend_count do                             # Block syntax.  Assigns the result of executing the block in
      friends.count                                       # instance's scope to the key specified (friend_count)
    end
    
    node.flow_to :conversations, :as => :thread           # Map conversations relationship to flows
                                                          # Since converstions map to two nodes (see below), we must
                                                          # specify which node type we want to flow to
  end
end
```

``` ruby
# app/models/conversation.rb
class Conversation
  include Daggregate

  has_many :postings
  has_many :users, :through => :postings

  aggregate_to(:contrib) do |node|                        # Passing an argument adds a key {:type => :contrib} to the node. Defaults to class name
    node.identifier do |conversation|                     # Constructe node identifier a block. The model instance will be passed
      "contribution_to_#{conversation.id}"                # to the block.
    end                                                   # Defaults to the node type and instance id (ie Conversation_3984)

    node.key(:thread_count) { postings.count }
    node.key :likes

    node.flow_to :users                                   # Simplified flow syntax, since users only map to a single node per instance
  end

  aggregate_to('Thread') do |node|                        # Multiple nodes can be created, but they must have different types (:contribution != 'Thread')
    node.identifier lambda {|c| "thread_#{c.id}"}         # Construct node identifier using the passed lambda
  end
end
```
  
This setup will will allow you to execute the following queries on your models:

``` ruby
@user.aggregate(:count, :type => :contrib)                # Counts the number of conversations a user has contributed to
@user.aggregate(:average, 'likes')                        # The average number of 'likes' for conversations the user has contributed to
@user.aggregate(:sum, 'posting_count')                    # The total number of posts in conversations the user has contributed to

@conversation(:count, :type => 'User')                    # Counts the users who have contributed to the conversation
@conversation(:count, :type => 'Thread')                  # The sum of the number of conversations contributed to by all the conversation's contributors
@conversation(:average, 'user_age')
@conversation(:average, 'friend_count')                                    
@conversation(:average, 'thread_count')                   # The average number of postings for conversations which share a user with this one
```


## Contributing to daggregator-rails
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Ryan Michael. See LICENSE.txt for
further details.

