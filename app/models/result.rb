class Result < ActiveRecord::Base

	belons_to :url
	belons_to :field
end
