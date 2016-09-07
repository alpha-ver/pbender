user=User.new(id: 1, email: "hav0k@me.com", password: "kjkjirf8887",  admin: true)
user.save
user.confirm

Field.create!([
  {id: 1, name: "name", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='productname']", "attr"=>nil}, project_id: 1, created_at: "2016-08-12 12:21:45", updated_at: "2016-08-12 12:30:37"},
  {id: 2, name: "content", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='desc']/div[@class='text']", "attr"=>nil}, project_id: 1, created_at: "2016-08-12 12:32:13", updated_at: "2016-08-12 12:43:13"},
  {id: 16, name: "title", otype: "attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//meta[@property='og:title']", "attr"=>"content"}, project_id: 5, created_at: "2016-08-18 13:40:56", updated_at: "2016-08-18 13:42:01"},
  {id: 17, name: "content", otype: "html", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='text']/p", "attr"=>nil}, project_id: 5, created_at: "2016-08-18 13:42:07", updated_at: "2016-08-18 13:44:36"},
  {id: 18, name: "image", otype: "attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//meta[@property='og:image']", "attr"=>"content"}, project_id: 5, created_at: "2016-08-18 13:45:45", updated_at: "2016-08-18 13:46:47"},
  {id: 19, name: "tags", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class=\"tags\"]", "attr"=>nil}, project_id: 5, created_at: "2016-08-18 13:49:59", updated_at: "2016-08-18 13:50:25"},
  {id: 3, name: "complect", otype: "array", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@id='complect']/div/ul/li", "attr"=>nil, "regex"=>""}, project_id: 1, created_at: "2016-08-12 12:48:46", updated_at: "2016-08-28 08:18:51"},
  {id: 9, name: "tags", otype: "array", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='tags']/a", "attr"=>nil}, project_id: 2, created_at: "2016-08-18 08:54:53", updated_at: "2016-08-18 08:55:48"},
  {id: 4, name: "images", otype: "array_attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='image']", "attr"=>"style", "regex"=>"^background-image:url\\((\\S{1,})\\)$", "download"=>"true"}, project_id: 1, created_at: "2016-08-12 14:23:15", updated_at: "2016-08-28 09:53:25"},
  {id: 10, name: "category", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[contains(@class, 'news_content')]/div[@class='date_tag']/a", "attr"=>nil}, project_id: 2, created_at: "2016-08-18 08:56:28", updated_at: "2016-08-18 09:00:14"},
  {id: 7, name: "content", otype: "html", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='news_main_text']//p", "attr"=>nil}, project_id: 2, created_at: "2016-08-18 08:41:02", updated_at: "2016-08-18 09:02:30"},
  {id: 8, name: "image", otype: "attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//meta[@property='og:image']", "attr"=>"content", "regex"=>"", "download"=>"true"}, project_id: 2, created_at: "2016-08-18 08:43:46", updated_at: "2016-08-28 11:52:56"},
  {id: 15, name: "category", otype: "array", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//span[@class='news-rub'][last()]//a", "attr"=>nil, "regex"=>"", "download"=>"false"}, project_id: 3, created_at: "2016-08-18 12:18:26", updated_at: "2016-08-28 14:31:37"},
  {id: 14, name: "content", otype: "html", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[contains(@class, 'content')]//p", "attr"=>nil, "regex"=>"", "download"=>"false"}, project_id: 3, created_at: "2016-08-18 09:16:14", updated_at: "2016-08-28 14:32:12"},
  {id: 12, name: "title", otype: "attr", enabled: true, ok: true, unique: false, required: true, setting: {"xpath"=>"//meta[@name='og:title']", "attr"=>"content", "regex"=>"", "download"=>"false"}, project_id: 3, created_at: "2016-08-18 09:11:42", updated_at: "2016-08-28 14:32:18"},
  {id: 5, name: "title", otype: "attr", enabled: true, ok: true, unique: false, required: true, setting: {"xpath"=>"//meta[@property='og:title']", "attr"=>"content", "regex"=>"", "download"=>"false"}, project_id: 2, created_at: "2016-08-18 08:11:02", updated_at: "2016-09-02 13:33:15"},
  {id: 20, name: "category", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='tags']", "attr"=>nil, "regex"=>"", "download"=>"false"}, project_id: 5, created_at: "2016-09-05 14:22:57", updated_at: "2016-09-05 14:43:44"},
  {id: 21, name: "image", otype: "attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//meta[@name='og:image']", "attr"=>"content", "regex"=>"", "download"=>"true"}, project_id: 3, created_at: "2016-09-05 17:49:35", updated_at: "2016-09-05 17:50:45"}
])
Plugin.create!([
  {id: 2, name: "Git hav0k", setting: {"login"=>"123", "password"=>"123", "repo"=>"123"}, class_name: "OutGithub", user_id: 1, test: false, created_at: "2016-09-01 06:20:19", updated_at: "2016-09-01 12:12:59"},
  {id: 3, name: "Git hav0k-ok", setting: {"login"=>"groverz", "password"=>"kjkjirf8887", "repo"=>"r35_post"}, class_name: "OutGithub", user_id: 1, test: true, created_at: "2016-09-01 12:19:03", updated_at: "2016-09-05 14:11:50"}
])
Project.create!([
  {id: 1, name: "лосайт", status: "new", group: nil, setting: {"option_url"=>"recursion", "include_str"=>"/product/", "exclude_str"=>"", "range_str"=>"", "only_path"=>"false", "only_path_field"=>""}, progress: 0, tasking: false, interval: 1800, pid: nil, user_id: 1, start_at: "2016-08-17 10:33:49", created_at: "2016-08-12 12:21:36", updated_at: "2016-08-17 10:59:00"},
  {id: 3, name: "Вологда портал", status: "finish", group: "Новости вологды", setting: {"option_url"=>"recursion", "include_str"=>"/novosti/index.php\\?ID=", "exclude_str"=>"", "range_str"=>"", "only_path"=>"true", "only_path_field"=>"/novosti/", "plugin"=>{"id"=>"3"}}, progress: 0, tasking: true, interval: 1800, pid: nil, user_id: 1, start_at: "2016-09-06 06:24:16", created_at: "2016-08-18 09:04:50", updated_at: "2016-09-06 05:54:20"},
  {id: 5, name: "Комсомольская правда", status: "finish", group: "Новости вологды", setting: {"option_url"=>"recursion", "include_str"=>"^/online/news/", "exclude_str"=>"", "range_str"=>"", "only_path"=>"true", "only_path_field"=>"", "plugin"=>{"id"=>"0"}}, progress: 0, tasking: true, interval: 1800, pid: nil, user_id: 1, start_at: "2016-09-06 06:24:19", created_at: "2016-08-18 13:36:57", updated_at: "2016-09-06 05:54:34"},
  {id: 2, name: "Newsvo", status: "finish", group: "Новости вологды", setting: {"option_url"=>"recursion", "include_str"=>"^/news/", "exclude_str"=>"", "range_str"=>"", "only_path"=>"true", "only_path_field"=>"", "plugin"=>{"id"=>"3"}}, progress: 0, tasking: true, interval: 1800, pid: nil, user_id: 1, start_at: "2016-09-06 06:24:13", created_at: "2016-08-18 08:05:38", updated_at: "2016-09-06 05:54:19"}
])