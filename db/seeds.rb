user=User.new(id: 1, email: "hav0k@me.com", password: "12345678",  admin: true)
user.save
user.confirm

Field.create!([
  {id: 1, name: "name", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='productname']", "attr"=>nil}, project_id: 1, created_at: "2016-08-12 12:21:45", updated_at: "2016-08-12 12:30:37"},
  {id: 2, name: "content", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='desc']/div[@class='text']", "attr"=>nil}, project_id: 1, created_at: "2016-08-12 12:32:13", updated_at: "2016-08-12 12:43:13"},
  {id: 4, name: "images", otype: "array_attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='image']", "attr"=>"style"}, project_id: 1, created_at: "2016-08-12 14:23:15", updated_at: "2016-08-13 12:32:20"},
  {id: 3, name: "complect", otype: "array", enabled: false, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@id='complect']/div/ul/li", "attr"=>nil}, project_id: 1, created_at: "2016-08-12 12:48:46", updated_at: "2016-08-13 15:10:18"}
])
Project.create!([
  {id: 1, name: "лосайт", url: "http://intellectico.ru", status: "new", setting: {"option_url"=>"recursion", "include_str"=>"/catalog/", "exclude_str"=>"", "range_str"=>"", "only_path"=>"true", "only_path_field"=>""}, result: {}, progress: 0, tasking: false, interval: 1800, user_id: 1, start_at: "2016-08-17 10:33:49", created_at: "2016-08-12 12:21:36", updated_at: "2016-08-17 10:33:54"},
  {id: 2, name: "лосай", url: "http://intellectico.ru", status: "new", setting: {"include_str"=>"/catalog/", "option_url"=>"recursion"}, result: {}, progress: 0, tasking: false, interval: 1800, user_id: 1, start_at: nil, created_at: "2016-08-13 09:14:12", updated_at: "2016-08-13 14:12:51"}
])