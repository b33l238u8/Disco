require 'dm-core'
require  'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost:5432/disco')

class Email
  include DataMapper::Resource
  
  property :id, Serial
  property :subject, Text
  property :body, Text
  property :from, Text
  property :sent_time, Float
  property :uuid, String

  has 1, :label
  has 1, :prediction

  def assign_label relevant
    if self.label
      self.label.relevant = relevant
      puts self.label.save
    else
      Label.create :email => self, :relevant => relevant
    end
  end

  def labeled_irrelevant?
    if !self.label
      false
    else
      self.label.relevant == 0
    end
  end
end

class Feature
  include DataMapper::Resource

  property :id, Serial
  property :feature, Text
  property :feature_type, String
  property :weight, Float

end

class Label
    include DataMapper::Resource

    property :id, Serial
    property :relevant, Integer

    belongs_to :email
end

class Prediction
  include DataMapper::Resource

  property :id, Serial
  property :relevant, Integer

  belongs_to :email
end

DataMapper.finalize