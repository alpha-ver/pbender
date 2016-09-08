user=User.new(id: 1, email: "hav0k@me.com", password: "kjkjirf8887",  admin: true)
user.save
user.confirm

pl1=Plugin.new(name: "Git hav0k", setting: {"login"=>"123", "password"=>"123", "repo"=>"123"}, class_name: "OutGithub", user_id: user.id, test: false, created_at: "2016-09-01 06:20:19", updated_at: "2016-09-01 12:12:59")
pl2=Plugin.new(name: "Git hav0k-ok", setting: {"login"=>"groverz", "password"=>"kjkjirf8887", "repo"=>"r35_post"}, class_name: "OutGithub", user_id: user.id, test: true, created_at: "2016-09-01 12:19:03", updated_at: "2016-09-05 14:11:50")
pl1.save
pl2.save

pr1=Project.new(name: "лосайт", url: "http://intellectico.ru", status: "new", group: nil, setting: {"option_url"=>"recursion", "include_str"=>"/product/", "exclude_str"=>"", "range_str"=>"", "only_path"=>"false", "only_path_field"=>""}, result: {}, progress: 0, tasking: false, interval: 1800, pid: nil, user_id: user.id, start_at: "2016-08-17 10:33:49")
pr2=Project.new(name: "Вологда портал", url: "http://vologda-portal.ru", status: "finish", group: "Новости вологды", setting: {"option_url"=>"recursion", "include_str"=>"/novosti/index.php\\?ID=", "exclude_str"=>"", "range_str"=>"", "only_path"=>"true", "only_path_field"=>"/novosti/", "plugin"=>{"id"=>pl2.id}}, result: {}, progress: 0, tasking: true, interval: 1800, pid: nil, user_id: user.id, start_at: "2016-09-06 06:24:16")
pr3=Project.new(name: "Комсомольская правда", url: "http://www.vologda.kp.ru", status: "finish", group: "Новости вологды", setting: {"option_url"=>"recursion", "include_str"=>"^/online/news/", "exclude_str"=>"", "range_str"=>"", "only_path"=>"true", "only_path_field"=>"", "plugin"=>{"id"=>"0"}}, result: {}, progress: 0, tasking: true, interval: 1800, pid: nil, user_id: user.id, start_at: "2016-09-06 06:24:19")
pr4=Project.new(name: "Newsvo", url: "http://newsvo.ru", status: "finish", group: "Новости вологды", setting: {"option_url"=>"recursion", "include_str"=>"^/news/", "exclude_str"=>"", "range_str"=>"", "only_path"=>"true", "only_path_field"=>"", "plugin"=>{"id"=>pl2.id}}, result: {}, progress: 0, tasking: true, interval: 1800, pid: nil, user_id: user.id, start_at: "2016-09-06 06:24:13")
pr1.save
pr2.save
pr3.save
pr4.save


f=Field.new(name: "name", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='productname']", "attr"=>nil}, project_id: pr1.id, created_at: "2016-08-12 12:21:45", updated_at: "2016-08-12 12:30:37")
f.save
f=Field.new(name: "content", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='desc']/div[@class='text']", "attr"=>nil}, project_id: pr1.id, created_at: "2016-08-12 12:32:13", updated_at: "2016-08-12 12:43:13")
f.save
f=Field.new(name: "title", otype: "attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//meta[@property='og:title']", "attr"=>"content"}, project_id: pr3.id, created_at: "2016-08-18 13:40:56", updated_at: "2016-08-18 13:42:01")
f.save
f=Field.new(name: "content", otype: "html", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='text']/p", "attr"=>nil}, project_id: pr3.id, created_at: "2016-08-18 13:42:07", updated_at: "2016-08-18 13:44:36")
f.save
f=Field.new(name: "image", otype: "attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//meta[@property='og:image']", "attr"=>"content"}, project_id: pr3.id, created_at: "2016-08-18 13:45:45", updated_at: "2016-08-18 13:46:47")
f.save
f=Field.new(name: "tags", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class=\"tags\"]", "attr"=>nil}, project_id: pr3.id, created_at: "2016-08-18 13:49:59", updated_at: "2016-08-18 13:50:25")
f.save
f=Field.new(name: "complect", otype: "array", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@id='complect']/div/ul/li", "attr"=>nil, "regex"=>""}, project_id: pr1.id, created_at: "2016-08-12 12:48:46", updated_at: "2016-08-28 08:18:51")
f.save
f=Field.new(name: "tags", otype: "array", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='tags']/a", "attr"=>nil}, project_id: pr4.id, created_at: "2016-08-18 08:54:53", updated_at: "2016-08-18 08:55:48")
f.save
f=Field.new(name: "images", otype: "array_attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='image']", "attr"=>"style", "regex"=>"^background-image:url\\((\\S{1,})\\)$", "download"=>"true"}, project_id: pr1.id, created_at: "2016-08-12 14:23:15", updated_at: "2016-08-28 09:53:25")
f.save
f=Field.new(name: "category", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[contains(@class, 'news_content')]/div[@class='date_tag']/a", "attr"=>nil}, project_id: pr4.id, created_at: "2016-08-18 08:56:28", updated_at: "2016-08-18 09:00:14")
f.save
f=Field.new(name: "content", otype: "html", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='news_main_text']//p", "attr"=>nil}, project_id: pr4.id, created_at: "2016-08-18 08:41:02", updated_at: "2016-08-18 09:02:30")
f.save
f=Field.new(name: "image", otype: "attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//meta[@property='og:image']", "attr"=>"content", "regex"=>"", "download"=>"true"}, project_id: pr4.id, created_at: "2016-08-18 08:43:46", updated_at: "2016-08-28 11:52:56")
f.save
f=Field.new(name: "category", otype: "array", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//span[@class='news-rub'][last()]//a", "attr"=>nil, "regex"=>"", "download"=>"false"}, project_id: pr2.id, created_at: "2016-08-18 12:18:26", updated_at: "2016-08-28 14:31:37")
f.save
f=Field.new(name: "content", otype: "html", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[contains(@class, 'content')]//p", "attr"=>nil, "regex"=>"", "download"=>"false"}, project_id: pr2.id, created_at: "2016-08-18 09:16:14", updated_at: "2016-08-28 14:32:12")
f.save
f=Field.new(name: "title", otype: "attr", enabled: true, ok: true, unique: false, required: true, setting: {"xpath"=>"//meta[@name='og:title']", "attr"=>"content", "regex"=>"", "download"=>"false"}, project_id: pr2.id, created_at: "2016-08-18 09:11:42", updated_at: "2016-08-28 14:32:18")
f.save
f=Field.new(name: "title", otype: "attr", enabled: true, ok: true, unique: false, required: true, setting: {"xpath"=>"//meta[@property='og:title']", "attr"=>"content", "regex"=>"", "download"=>"false"}, project_id: pr4.id, created_at: "2016-08-18 08:11:02", updated_at: "2016-09-02 13:33:15")
f.save
f=Field.new(name: "category", otype: "text", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//div[@class='tags']", "attr"=>nil, "regex"=>"", "download"=>"false"}, project_id: pr3.id, created_at: "2016-09-05 14:22:57", updated_at: "2016-09-05 14:43:44")
f.save
f=Field.new(name: "image", otype: "attr", enabled: true, ok: true, unique: false, required: false, setting: {"xpath"=>"//meta[@name='og:image']", "attr"=>"content", "regex"=>"", "download"=>"true"}, project_id: pr2.id, created_at: "2016-09-05 17:49:35", updated_at: "2016-09-0 17:50:45")
f.save
