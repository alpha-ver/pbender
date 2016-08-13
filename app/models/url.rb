class Url < ActiveRecord::Base
	belongs_to :project

	has_many :results
end
