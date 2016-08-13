class Project < ActiveRecord::Base
	belongs_to :user

	has_many :urls
	has_many :fields

	validates :name,  
            :presence => true,
            :uniqueness => true,
            :length => {:minimum => 1, :maximum => 254}

  validates :url,
            :url => {:allow_nil => false, :allow_blank => false, :no_local => true}
end
