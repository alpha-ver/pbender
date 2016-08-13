class Field < ActiveRecord::Base
	belongs_to :project

	has_many :results

	validates :name,  
        		:presence => true,
            :length => {:minimum => 2, :maximum => 254}
end
