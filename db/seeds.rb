# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)
#
#
#用户
AppUser.destroy_all
AppUser.create(username: "黄培栋", password: "e10adc3949ba59abbe56e057f20f883e", mobile: "123456789", zone: "86")
AppUser.create(username: "xay", password: "e10adc3949ba59abbe56e057f20f883e", mobile: "18511374876", zone: "86")

rows = []
100.times {|index|
  rows.insert(index, "('user#{index+3}', '#{index%2+1}', 'e10adc3949ba59abbe56e057f20f883e',
                      '123456789#{index+3}', '86', #{index%4+1}, #{index%9+1}, #{index%66+1},'#{Time.now}','#{Time.now}')")
}
# 构造SQL语句用于执行
sql = "INSERT INTO app_users (username,sex,password,mobile,zone,app_destination_id,app_exam_date_id,app_exam_location_id,created_at,updated_at) VALUES #{rows.join(",")}"
# 执行SQL语句
ActiveRecord::Base.connection.execute sql

## 额外增加
# rows = []
# 2000000.times {|index|
#   rows.insert(index, "(#{index+8000005}, 'user#{index+3}', '#{index%2+1}', 'e10adc3949ba59abbe56e057f20f883e',
#                       '123456789#{index+3}', '86', #{index%4+1}, #{index%9+1}, #{index%66+1},'#{Time.now}','#{Time.now}')")
# }
# # 构造SQL语句用于执行
# sql = "INSERT INTO app_users (id,username,sex,password,mobile,zone,app_destination_id,app_exam_date_id,app_exam_location_id,created_at,updated_at) VALUES #{rows.join(",")}"
# # 执行SQL语句
# ActiveRecord::Base.connection.execute sql

# 评星
# rows = []
# mid = AppOralPracticeStar.last.id
# 1.times {|index|
#   AppOralPracticeComment.all.each {|item|
#     mid += 1
#     rows.insert(rows.count, "(#{mid},6,6,6,6,2,#{item.id},#{item.app_user_id},'#{Time.now}','#{Time.now}')")
#   }
# }
# # 构造SQL语句用于执行
# sql = "INSERT INTO app_oral_practice_stars (id,fluent,vocab,grammar,pronuce,app_user_id,app_oral_practice_comment_id,to_user_id,created_at,updated_at) VALUES #{rows.join(",")}"
# # 执行SQL语句
# ActiveRecord::Base.connection.execute sql


#考试时间
AppExamDate.destroy_all
i = 1
while i<10
  item = AppExamDate.new
  str = "2018-#{i}-20"
  item.date = Date.parse(str).to_datetime
  item.id =i
  item.save
  i += 1
end


AppOralPracticePart1Category.destroy_all
AppOralPracticePart1Category.create!([
                                         {name: "person"},
                                         {name: "thing"},
                                         {name: "event"},
                                         {name: "location"}
                                     ])

AppOralPracticePart23Category.destroy_all
AppOralPracticePart23Category.create!([
                                          {name: "person"},
                                          {name: "thing"},
                                          {name: "event"},
                                          {name: "location"}
                                      ])
AppPart1Topic.destroy_all
AppPart1Topic.create!([
                          {topic: "Part1测试标题1", content: "Part1测试内容1", is_show: true, app_oral_practice_part1_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 1, oral_practice_description: ""},
                          {topic: "Part1测试标题2", content: "Part1测试内容2", is_show: true, app_oral_practice_part1_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题3", content: "Part1测试内容3", is_show: true, app_oral_practice_part1_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题4", content: "Part1测试内容4", is_show: true, app_oral_practice_part1_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题5", content: "Part1测试内容5", is_show: true, app_oral_practice_part1_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题6", content: "Part1测试内容6", is_show: true, app_oral_practice_part1_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题7", content: "Part1测试内容7", is_show: true, app_oral_practice_part1_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题8", content: "Part1测试内容8", is_show: true, app_oral_practice_part1_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题9", content: "Part1测试内容9", is_show: true, app_oral_practice_part1_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题10", content: "Part1测试内容10", is_show: true, app_oral_practice_part1_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题11", content: "Part1测试内容11", is_show: true, app_oral_practice_part1_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题12", content: "Part1测试内容12", is_show: true, app_oral_practice_part1_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题13", content: "Part1测试内容13", is_show: true, app_oral_practice_part1_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题14", content: "Part1测试内容14", is_show: true, app_oral_practice_part1_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题15", content: "Part1测试内容15", is_show: true, app_oral_practice_part1_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题16", content: "Part1测试内容16", is_show: true, app_oral_practice_part1_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题17", content: "Part1测试内容17", is_show: true, app_oral_practice_part1_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题18", content: "Part1测试内容18", is_show: true, app_oral_practice_part1_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题19", content: "Part1测试内容19", is_show: true, app_oral_practice_part1_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题20", content: "Part1测试内容20", is_show: true, app_oral_practice_part1_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题21", content: "Part1测试内容21", is_show: true, app_oral_practice_part1_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题22", content: "Part1测试内容22", is_show: true, app_oral_practice_part1_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题23", content: "Part1测试内容23", is_show: true, app_oral_practice_part1_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题24", content: "Part1测试内容24", is_show: true, app_oral_practice_part1_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题25", content: "Part1测试内容25", is_show: true, app_oral_practice_part1_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题26", content: "Part1测试内容26", is_show: true, app_oral_practice_part1_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题27", content: "Part1测试内容27", is_show: true, app_oral_practice_part1_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题28", content: "Part1测试内容28", is_show: true, app_oral_practice_part1_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题29", content: "Part1测试内容29", is_show: true, app_oral_practice_part1_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题30", content: "Part1测试内容30", is_show: true, app_oral_practice_part1_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                          {topic: "Part1测试标题31", content: "Part1测试内容31", is_show: true, app_oral_practice_part1_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""}
                      ])

AppPart23Topic.destroy_all
AppPart23Topic.create!([
                           {topic: "Part23测试标题1", content: "Part23测试内容1", is_show: true, app_oral_practice_part23_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题2", content: "Part23测试内容2", is_show: true, app_oral_practice_part23_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题3", content: "Part23测试内容3", is_show: true, app_oral_practice_part23_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题4", content: "Part23测试内容4", is_show: true, app_oral_practice_part23_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题5", content: "Part23测试内容5", is_show: true, app_oral_practice_part23_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题6", content: "Part23测试内容6", is_show: true, app_oral_practice_part23_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题7", content: "Part23测试内容7", is_show: true, app_oral_practice_part23_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题8", content: "Part23测试内容8", is_show: true, app_oral_practice_part23_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题9", content: "Part23测试内容9", is_show: true, app_oral_practice_part23_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题10", content: "Part23测试内容10", is_show: true, app_oral_practice_part23_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题11", content: "Part23测试内容11", is_show: true, app_oral_practice_part23_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题12", content: "Part23测试内容12", is_show: true, app_oral_practice_part23_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题13", content: "Part23测试内容13", is_show: true, app_oral_practice_part23_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题14", content: "Part23测试内容14", is_show: true, app_oral_practice_part23_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题15", content: "Part23测试内容15", is_show: true, app_oral_practice_part23_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题16", content: "Part23测试内容16", is_show: true, app_oral_practice_part23_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题17", content: "Part23测试内容17", is_show: true, app_oral_practice_part23_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题18", content: "Part23测试内容18", is_show: true, app_oral_practice_part23_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题19", content: "Part23测试内容19", is_show: true, app_oral_practice_part23_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题20", content: "Part23测试内容20", is_show: true, app_oral_practice_part23_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题21", content: "Part23测试内容21", is_show: true, app_oral_practice_part23_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题22", content: "Part23测试内容22", is_show: true, app_oral_practice_part23_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题23", content: "Part23测试内容23", is_show: true, app_oral_practice_part23_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题24", content: "Part23测试内容24", is_show: true, app_oral_practice_part23_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题25", content: "Part23测试内容25", is_show: true, app_oral_practice_part23_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题26", content: "Part23测试内容26", is_show: true, app_oral_practice_part23_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题27", content: "Part23测试内容27", is_show: true, app_oral_practice_part23_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题28", content: "Part23测试内容28", is_show: true, app_oral_practice_part23_category_id: 4, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题29", content: "Part23测试内容29", is_show: true, app_oral_practice_part23_category_id: 1, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题30", content: "Part23测试内容30", is_show: true, app_oral_practice_part23_category_id: 2, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""},
                           {topic: "Part23测试标题31", content: "Part23测试内容31", is_show: true, app_oral_practice_part23_category_id: 3, total_count: 0, oral_practice_collections: 0, total_comment_count: 0, oral_practice_description: ""}

                       ])

AppExamCity.destroy_all
AppExamCity.create!([
                        {city: "北京"},
                        {city: "长春"},
                        {city: "长沙"},
                        {city: "成都"},
                        {city: "重庆"},
                        {city: "大连"},
                        {city: "福州"},
                        {city: "广州"},
                        {city: "贵阳"},
                        {city: "合肥"},
                        {city: "杭州"},
                        {city: "呼和浩特"},
                        {city: "哈尔滨"},
                        {city: "海口"},
                        {city: "济南"},
                        {city: "开封"},
                        {city: "昆明"},
                        {city: "兰州"},
                        {city: "南京"},
                        {city: "南宁"},
                        {city: "南昌"},
                        {city: "宁波"},
                        {city: "青岛"},
                        {city: "上海"},
                        {city: "苏州"},
                        {city: "沈阳"},
                        {city: "石家庄"},
                        {city: "深圳"},
                        {city: "天津"},
                        {city: "太原"},
                        {city: "温州"},
                        {city: "乌鲁木齐"},
                        {city: "武汉"},
                        {city: "西安"},
                        {city: "厦门"},
                        {city: "郑州"},
                        {city: "中山"}
                    ])

AppExamLocation.destroy_all
AppExamLocation.create ([
    {location: "上海对外经贸大学 （古北校区）", app_exam_city_id: 24},
    {location: "上海应用技术学院(app_徐汇校区)", app_exam_city_id: 24},
    {location: "上海财经大学（武川路校区）", app_exam_city_id: 24},
    {location: "华东师范大学", app_exam_city_id: 24},
    {location: "新疆财经大学", app_exam_city_id: 32},
    {location: "兰州IELTS考试中心", app_exam_city_id: 18},
    {location: "中国农业大学", app_exam_city_id: 1},
    {location: "北京外国语大学IELTS考试中心", app_exam_city_id: 1},
    {location: "北京市教育考试指导中心", app_exam_city_id: 1},
    {location: "北京语言大学", app_exam_city_id: 1},
    {location: "首都师范大学", app_exam_city_id: 1},
    {location: "首都经济贸易大学IELTS考试中心", app_exam_city_id: 1},
    {location: "东南大学", app_exam_city_id: 19},
    {location: "东南大学 （九龙湖校区）", app_exam_city_id: 19},
    {location: "南京理工大学", app_exam_city_id: 19},
    {location: "广西大学", app_exam_city_id: 20},
    {location: "南昌大学", app_exam_city_id: 21},
    {location: "厦门大学", app_exam_city_id: 35},
    {location: "安徽中澳科技职业学院", app_exam_city_id: 10},
    {location: "内蒙古师范大学", app_exam_city_id: 12},
    {location: "哈尔滨工业大学IELTS考试中心", app_exam_city_id: 13},
    {location: "黑龙江大学", app_exam_city_id: 13},
    {location: "辽宁师范大学", app_exam_city_id: 6},
    {location: "天津外国语大学", app_exam_city_id: 29},
    {location: "太原理工大学", app_exam_city_id: 30},
    {location: "广东外语外贸大学", app_exam_city_id: 8},
    {location: "广州雅思考试中心（广州体育职业技术学院分考场）", app_exam_city_id: 8},
    {location: "河南大学雅思考试中心", app_exam_city_id: 16},
    {location: "四川大学", app_exam_city_id: 4},
    {location: "电子科技大学", app_exam_city_id: 4},
    {location: "云南财经大学", app_exam_city_id: 17},
    {location: "浙江教育考试服务中心（杭州）", app_exam_city_id: 11},
    {location: "湖北大学考场", app_exam_city_id: 33},
    {location: "沈阳师范大学", app_exam_city_id: 26},
    {location: "山东大学", app_exam_city_id: 15},
    {location: "海南大学", app_exam_city_id: 14},
    {location: "深圳赛格人才培训中心", app_exam_city_id: 28},
    {location: "浙江教育考试服务中心（温州）", app_exam_city_id: 31},
    {location: "石家庄信息工程职业学院（北院）", app_exam_city_id: 27},
    {location: "福建师范大学", app_exam_city_id: 7},
    {location: "西交利物浦大学", app_exam_city_id: 25},
    {location: "西安交通大学", app_exam_city_id: 34},
    {location: "西安外国语大学", app_exam_city_id: 34},
    {location: "贵州大学", app_exam_city_id: 9},
    {location: "郑州轻工业大学", app_exam_city_id: 36},
    {location: "四川外国语大学", app_exam_city_id: 5},
    {location: "吉林大学", app_exam_city_id: 2},
    {location: "湖南大众传媒学院（南院）", app_exam_city_id: 3},
    {location: "中国海洋大学", app_exam_city_id: 23},
    {location: "其他海外考场", app_exam_city_id: 2},
    {location: "上海财经大学（分考场）", app_exam_city_id: 24},
    {location: "重庆大学", app_exam_city_id: 5},
    {location: "宁波大学", app_exam_city_id: 22},
    {location: "大连教育学院雅思考试中心", app_exam_city_id: 6},
    {location: "西北工业大学IELTS考试中心", app_exam_city_id: 34},
    {location: "国试考试中心", app_exam_city_id: 1},
    {location: "上海外国语大学", app_exam_city_id: 24},
    {location: "内蒙古师范大学", app_exam_city_id: 12},
    {location: "辽宁大学", app_exam_city_id: 26},
    {location: "吉林大学", app_exam_city_id: 2},
    {location: "东华大学", app_exam_city_id: 24},
    {location: "广州雅思考试中心（仲恺农业工程学院）右边没有", app_exam_city_id: 8},
    {location: "武外英中IELTS考场 右边没有", app_exam_city_id: 33},
    {location: "武昌实验中学IELTS考场", app_exam_city_id: 33},
    {location: "中山职业技术学院", app_exam_city_id: 37},
    {location: "上海对外经贸大学 ", app_exam_city_id: 24}
])

AppOralMemory.destroy_all
AppOralMemory.create ([
    {app_user_id: 1, app_part23_topic_id: 2, app_exam_location_id: 1, app_exam_date_id: 1, room_number: "007室", is_old: false, part1: "part1", part2: "part2", part3: "part3", part_all: "", impression: "印象好", comment_count: 0, is_show: true, collections: 0, part1_is_new_state: false, part23_is_new_state: false, is_meaningless: false},
    {app_user_id: 1, app_part23_topic_id: 2, app_exam_location_id: 1, app_exam_date_id: 1, room_number: "007室", is_old: false, part1: "part1", part2: "part2", part3: "part3", part_all: "", impression: "印象好", comment_count: 0, is_show: true, collections: 0, part1_is_new_state: false, part23_is_new_state: false, is_meaningless: false},
    {app_user_id: 1, app_part23_topic_id: 2, app_exam_location_id: 1, app_exam_date_id: 1, room_number: "007室", is_old: false, part1: "part1", part2: "part2", part3: "part3", part_all: "", impression: "印象好", comment_count: 0, is_show: true, collections: 0, part1_is_new_state: false, part23_is_new_state: false, is_meaningless: false},
    {app_user_id: 1, app_part23_topic_id: 2, app_exam_location_id: 1, app_exam_date_id: 1, room_number: "007室", is_old: false, part1: "part1", part2: "part2", part3: "part3", part_all: "", impression: "印象好", comment_count: 0, is_show: true, collections: 0, part1_is_new_state: false, part23_is_new_state: false, is_meaningless: false},
    {app_user_id: 1, app_part23_topic_id: 2, app_exam_location_id: 1, app_exam_date_id: 1, room_number: "007室", is_old: false, part1: "part1", part2: "part2", part3: "part3", part_all: "", impression: "印象好", comment_count: 0, is_show: true, collections: 0, part1_is_new_state: false, part23_is_new_state: false, is_meaningless: false},
    {app_user_id: 1, app_part23_topic_id: 2, app_exam_location_id: 1, app_exam_date_id: 1, room_number: "007室", is_old: false, part1: "part1", part2: "part2", part3: "part3", part_all: "", impression: "印象好", comment_count: 0, is_show: true, collections: 0, part1_is_new_state: false, part23_is_new_state: false, is_meaningless: false},
    {app_user_id: 1, app_part23_topic_id: 2, app_exam_location_id: 1, app_exam_date_id: 1, room_number: "007室", is_old: false, part1: "part1", part2: "part2", part3: "part3", part_all: "", impression: "印象好", comment_count: 0, is_show: true, collections: 0, part1_is_new_state: false, part23_is_new_state: false, is_meaningless: false}
])


i = 1
while i<=7
  a = AppOralMemory.find(i)
  a.app_part1_topics << AppPart1Topic.find(i)
  a.save
  i += 1
end

AppWrittenMemory.destroy_all
AppWrittenMemory.create([
                            {app_user_id: 1, listening: "hh", reading: "xi", writing: "fasf", extras: "好好学习", comment_counts: 0, location: "深圳", exam_date: "2020年2月2日", collections: 0},
                            {app_user_id: 1, listening: "hh", reading: "xi", writing: "fasf", extras: "好好学习", comment_counts: 0, location: "深圳", exam_date: "2020年2月2日", collections: 0},
                            {app_user_id: 1, listening: "hh", reading: "xi", writing: "fasf", extras: "好好学习", comment_counts: 0, location: "深圳", exam_date: "2020年2月2日", collections: 0},
                            {app_user_id: 1, listening: "hh", reading: "xi", writing: "fasf", extras: "好好学习", comment_counts: 0, location: "深圳", exam_date: "2020年2月2日", collections: 0},
                            {app_user_id: 1, listening: "hh", reading: "xi", writing: "fasf", extras: "好好学习", comment_counts: 0, location: "深圳", exam_date: "2020年2月2日", collections: 0},
                            {app_user_id: 1, listening: "hh", reading: "xi", writing: "fasf", extras: "好好学习", comment_counts: 0, location: "深圳", exam_date: "2020年2月2日", collections: 0},
                            {app_user_id: 1, listening: "hh", reading: "xi", writing: "fasf", extras: "好好学习", comment_counts: 0, location: "深圳", exam_date: "2020年2月2日", collections: 0}
                        ])

AppWrittenImage.destroy_all
AppWrittenImage.create([
                           {app_written_memory_id: 1, memory_type: "reading", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 1, memory_type: "reading", image: "written_defalut.jpg", image_order: 2},
                           {app_written_memory_id: 1, memory_type: "listening", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 1, memory_type: "writing", image: "written_defalut.jpg", image_order: 1},

                           {app_written_memory_id: 2, memory_type: "reading", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 2, memory_type: "reading", image: "written_defalut.jpg", image_order: 2},
                           {app_written_memory_id: 2, memory_type: "listening", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 2, memory_type: "listening", image: "written_defalut.jpg", image_order: 2},
                           {app_written_memory_id: 2, memory_type: "writing", image: "written_defalut.jpg", image_order: 1},

                           {app_written_memory_id: 3, memory_type: "reading", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 3, memory_type: "reading", image: "written_defalut.jpg", image_order: 2},
                           {app_written_memory_id: 3, memory_type: "listening", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 3, memory_type: "listening", image: "written_defalut.jpg", image_order: 2},
                           {app_written_memory_id: 3, memory_type: "writing", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 3, memory_type: "writing", image: "written_defalut.jpg", image_order: 2},

                           {app_written_memory_id: 4, memory_type: "reading", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 4, memory_type: "listening", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 4, memory_type: "listening", image: "written_defalut.jpg", image_order: 2},
                           {app_written_memory_id: 4, memory_type: "writing", image: "written_defalut.jpg", image_order: 1},

                           {app_written_memory_id: 5, memory_type: "reading", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 5, memory_type: "listening", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 5, memory_type: "listening", image: "written_defalut.jpg", image_order: 2},
                           {app_written_memory_id: 5, memory_type: "writing", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 5, memory_type: "writing", image: "written_defalut.jpg", image_order: 2},

                           {app_written_memory_id: 6, memory_type: "reading", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 6, memory_type: "reading", image: "written_defalut.jpg", image_order: 2},
                           {app_written_memory_id: 6, memory_type: "listening", image: "written_defalut.jpg", image_order: 1},
                           {app_written_memory_id: 6, memory_type: "listening", image: "written_defalut.jpg", image_order: 2},
                           {app_written_memory_id: 6, memory_type: "writing", image: "written_defalut.jpg", image_order: 1}
                       ])

AppPart1Topic.all.each {|item|
  a = AppOralPracticeQuestion.create(topic: "part1 #{item.id} Work or studies", description: "part1 #{item.id} What work do you do?", vu: "6fc8491449", uu: "gh5muin4j0", question_order: 1, part_num: 1)
  item.app_oral_practice_questions << a
  b = AppOralPracticeQuestion.create(topic: "part1 #{item.id} Work or studies", description: "part1 #{item.id} What work do you do?", vu: "", uu: "", question_order: 2, part_num: 1)
  item.app_oral_practice_questions << b
}

# AppPart1Topic.all.each {|topic_item|
#   topic_item.app_oral_practice_questions.each {|question_item|
#     AppUser.all.each {|user_item|
#       2.times {
#         user_item.app_oral_practice_comments.create(app_oral_practice_question_id: question_item.id, seconds: 30, audio_record: "https://cdn.offerdoll.com/uploads/app_oral_practice_comment/audio_record/1377260/record.mp3", play_times: 20)
#       }
#     }
#   }
# }

rows = []
AppPart1Topic.all.each {|topic_item|
  topic_item.app_oral_practice_questions.each {|question_item|
    ((AppUser.count)).times {|index|
      rows.insert(index, "(#{index+1},#{question_item.id}, 30, 'record.mp3', 20,'2017-11-15 09:37:57.27744','2017-11-15 09:37:57.27745')")
    }
  }
}
# 构造SQL语句用于执行
sql = "INSERT INTO app_oral_practice_comments (app_user_id,app_oral_practice_question_id,seconds,audio_record,play_times,created_at,updated_at) VALUES #{rows.join(",")}"
# 执行SQL语句
ActiveRecord::Base.connection.execute sql


# a = AppOralPracticeComment.
#     firstQuestion.app_oral_practice_comments << a
# b = AppOralPracticeSampleAnswer
# firstQuestion.app_oral_practice_sample_answers.create({id: 1, app_user_id: 1, content: "content1"})


AppPart23Topic.all.each {|item|

  a = AppOralPracticeQuestion.create(topic: "part23 #{item.id} Work or studies", description: "part23 #{item.id} What work do you do?", vu: "6fc8491449", uu: "gh5muin4j0", question_order: 1, part_num: 23)
  item.app_oral_practice_questions << a
  b = AppOralPracticeQuestion.create(topic: "part23 #{item.id} Work or studies", description: "part23 #{item.id} What work do you do?", vu: "", uu: "", question_order: 2, part_num: 23)
  item.app_oral_practice_questions << b

}
#
# AppPart23Topic.all.each {|topic_item|
#   topic_item.app_oral_practice_questions.each {|question_item|
#     AppUser.all.each {|user_item|
#       2.times {
#         user_item.app_oral_practice_comments.create(app_oral_practice_question_id: question_item.id, seconds: 30, audio_record: "https://cdn.offerdoll.com/uploads/app_oral_practice_comment/audio_record/1377260/record.mp3", play_times: 20)
#       }
#     }
#   }
# }

rows = []
AppPart23Topic.all.each {|topic_item|
  topic_item.app_oral_practice_questions.each {|question_item|
    ((AppUser.count)).times {|index|
      rows.insert(index, "(#{index+1},#{question_item.id}, 30, 'record.mp3', 20,'2017-11-15 09:37:57.27744','2017-11-15 09:37:57.27745')")
    }
  }
}
# 构造SQL语句用于执行
sql = "INSERT INTO app_oral_practice_comments (app_user_id,app_oral_practice_question_id,seconds,audio_record,play_times,created_at,updated_at) VALUES #{rows.join(",")}"
# 执行SQL语句
ActiveRecord::Base.connection.execute sql

#
# firstQuestion = AppPart23Topic.first.app_oral_practice_questions.first
# a = AppOralPracticeComment.create(id: 2, app_user_id: 2, seconds: 30, audio_record: "https://cdn.offerdoll.com/uploads/app_oral_practice_comment/audio_record/1377260/record.mp3", play_times: 20)
# firstQuestion.app_oral_practice_comments << a
#
# firstQuestion.app_oral_practice_sample_answers.create({id: 2, app_user_id: 1, content: "content2"})


AppVideoCategory.destroy_all
AppVideoCategory.create!([
                             {name: "一条"},
                             {name: "学好"},
                             {name: "活好"},
                             {name: "玩好"}
                         ])


AppVideo.destroy_all
4.times {|index|
  10.times {|item|
    AppVideoCategory.find(index+1).app_videos.create([{name: "测试#{index}_#{item},", view_count: 10, vu: "6fc8491449", uu: "gh5muin4j0", snapshot_url: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510632042&di=d5f3eb91f9901e45aa3c003767471220&imgtype=jpg&er=1&src=http%3A%2F%2Fwww.cs.com.cn%2Fssgs%2Fgszt%2F20131014_37955%2F04%2F201403%2FW020140317322275824059.jpg"}])
  }
}

a = AppVideoCategory.find(1).app_videos.last.app_video_comments.new
a.app_user = AppUser.find(2)
a.content = "我的评论，哈哈"
a.save

a = AppVideoCategory.find(1).app_videos.last.app_video_likes.new
a.app_user = AppUser.find(2)
a.save

AppCollection.destroy_all
item_id = AppVideoCategory.find(1).app_videos.last.id
AppUser.find(1).app_collections.create(collection_type: "video", item_id: item_id)


AppUserReport.destroy_all

AppDestinationCountry.destroy_all
AppDestinationCountry.create([{name: "中国"}, {name: "英国"}, {name: "美国"}, {name: "法国"}])

# AppVersion.create!([
#   {url: "182.92.179.182:9999/apk/ieltsbro_v1.4.apk", version: "1.4", force_update: true}
# ])


# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

# UrlPostfixMap.create([
#   {pos: "3", type_method: "method", option: {"3":"put", "6":"post", "7":"get", "9":"patch", a:"delete", c: "head", d:"connect", e:"option"}},
#   {pos: "5", type_method: "api_token", option: {"8":true, a:false}},
#   {pos: "8", type_method: "token", option: {a:true, e:false}},
#   {pos: "9", type_method: "app_version", option: {f:true,c:false}},
#   {pos: "c", type_method: "device_system", option: {"0":true, "8":false}}
# ])
AdminUser.create!(email: 'hpd@hpd.com', password: '123456', password_confirmation: '123456')