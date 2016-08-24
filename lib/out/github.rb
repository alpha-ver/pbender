class OutGithub
  def initialize(:project => project, :user => user)
    @current_project = project
    if user.nil?
      @current_user = user
    else
      @current_user = project.user
    end
  end


  def info
    {
      :name  => {
        :en => "Github Api plugin out",
        :ru => "Github Api plugin out"
      },
      :description => {
        :en => "Github desc",
        :ru => "Github desc"        
      },
      :email  => "hav0k@me.com",
      :author => "Alexey Vildyaev",
      :site   => "hav0k@me.com",
      :fields => {
        :request => {

        },
        :advanced => {

        },
      :setting => {
        
      }
    }
  end 
  
  
end