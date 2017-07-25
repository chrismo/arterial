require 'active_record'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

class Parent < ActiveRecord::Base
  has_many :children

  connection.create_table table_name, :force => true do |t|
    t.string :name
  end
end

class Child < ActiveRecord::Base
  belongs_to :parent

  connection.create_table table_name, :force => true do |t|
    t.integer :parent_id
    t.string :name
  end
end

class Supplier < ActiveRecord::Base
  has_one :account
  has_one :account_history, :through => :account

  accepts_nested_attributes_for :account, :account_history

  before_validation :ensure_default_account

  def ensure_default_account
    if account.blank?
      self.account = Account.new(name: 'Default')
    end
  end

  connection.create_table table_name, :force => true do |t|
    t.integer :account_id
    t.integer :account_history_id
    t.string :name
  end
end

class Account < ActiveRecord::Base
  belongs_to :supplier
  has_one :account_history

  accepts_nested_attributes_for :account_history

  connection.create_table table_name, :force => true do |t|
    t.integer :supplier_id
    t.string :name
  end
end

class AccountHistory < ActiveRecord::Base
  belongs_to :account

  after_save :initialize_default_account

  connection.create_table table_name, :force => true do |t|
    t.integer :account_id
    t.integer :credit_rating
  end
end

class BlogPost < ActiveRecord::Base
  belongs_to :blog_author
  has_many :blog_comments

  connection.create_table table_name, :force => true do |t|
    t.integer :blog_author_id
    t.string :title
    t.text :body
  end
end

class BlogComment < ActiveRecord::Base
  belongs_to :blog_post
  belongs_to :blog_reader

  connection.create_table table_name, :force => true do |t|
    t.integer :blog_post_id
    t.integer :blog_reader_id
    t.text :body
  end
end

class BlogReader < ActiveRecord::Base
  has_many :blog_comments

  connection.create_table table_name, :force => true do |t|
    t.string :name
  end
end

class BlogAuthor < ActiveRecord::Base
  has_many :blog_posts

  connection.create_table table_name, :force => true do |t|
    t.string :name
  end
end

def setup_faux_blog
  author = BlogAuthor.create!(:name => 'chrismo')

  post = BlogPost.create!(:blog_author => author, :title => 'Your Language Sucks', :body => 'lorem ipsum ' * 1000)
  reader = BlogReader.create!(:name => 'John Galt')
  comment = BlogComment.create!(:blog_post => post, :blog_reader => reader, :body => 'yer blog post sux')

  post = BlogPost.create!(:blog_author => author, :title => 'Your Editor Sucks', :body => 'ipsum lorem ' * 1000)
  reader = BlogReader.create!(:name => 'Claude Rains')
  comment = BlogComment.create!(:blog_post => post, :blog_reader => reader, :body => 'you suck')
end
