Rails.application.routes.draw do
  #start activeadmin自动创建
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #end

  get 'app_users/test'

  #common/common_controller
  post 'list/part1s', to: 'tab1_oral_memory/oral_memory#part1s'
  post 'list/part23s', to: 'tab1_oral_memory/oral_memory#part23s'
  post 'list/exam_dates', to: 'common/common#exam_dates'
  post 'list/cities', to: 'common/common#cities'
  post 'list/locations', to: 'common/common#locations'
  post 'list/destination_countries', to: 'common/common#destination_countries'
  post 'app_user/report', to: 'common/common#report'
  get 'app_user/avatar/:id/:avatar', to: 'common/common#user_avatar'
  get 'app_user/oral_practice_question_comments/:id', to: 'common/common#get_user_oral_practice_question_comments'

  #common/count_controller
  post 'count/audio', to: 'common/count#audio'
  post 'count/video', to: 'common/count#video'

  #common/app_collection
  post 'app_collection/is_collected', to: 'common/app_collection#is_collected'
  post 'app_collection/add_to_collection', to: 'common/app_collection#add_to_collection'

  #AppUtilitiesController
  post 'app_utility/send_verify_code', to: 'app_utilities#send_verify_code'

  #AppUsersController
  post 'app_user/register', to: 'app_users#register'
  post 'app_user/validate_user_name', to: 'app_users#validate_user_name'
  post 'app_user/logout', to: 'app_users#logout'
  post 'app_user/login', to: 'app_users#login'
  post 'app_user/upload_avatar', to: 'app_users#upload_avatar'
  post 'app_user/validate_user_name', to: 'app_users#validate_user_name'
  post 'app_user/update_avatar_and_username', to: 'app_users#update_avatar_and_username'
  post 'app_user/add_me_as_fan_to', to: 'app_users#add_me_as_fan_to'
  post 'app_user/target_user_details', to: 'app_users#target_user_details'
  post 'app_user/target_user_details_oral_practices', to: 'app_users#target_user_details_oral_practices'
  post 'app_user/target_user_details_followed', to: 'app_users#target_user_details_followed'
  post 'app_user/target_user_details_fans', to: 'app_users#target_user_details_fans'
  post 'app_user/relationship_to_user', to: 'app_users#relationship_to_user'
  post 'app_user/remove_me_from_fan_list_of', to: 'app_users#remove_me_from_fan_list_of'
  post 'app_user/update_profile', to: 'app_users#update_profile'
  post 'app_user/my_profile_basic_info', to: 'app_users#my_profile_basic_info'


  #tab1_oral_memory/oral_memory_controller
  post 'memory/oral_memory_list', to: 'tab1_oral_memory/oral_memory#oral_memory_list'
  post 'memory/oral_memory_detail', to: 'tab1_oral_memory/oral_memory#oral_memory_detail'
  post 'memory/publish_oral_memory', to: 'tab1_oral_memory/oral_memory#publish_oral_memory'
  post 'memory/publish_oral_memory_comment', to: 'tab1_oral_memory/oral_memory#publish_oral_memory_comment'
  post 'memory/more_oral_memory_comments', to: 'tab1_oral_memory/oral_memory#more_oral_memory_comments'
  post 'memory/recommended_oral_practice_comments', to: 'tab1_oral_memory/oral_memory#recommended_oral_practice_comments'

  #tab1_written_memory/written_memory_controller
  post 'memory/written_memory_list', to: 'tab1_oral_memory/written_memory#written_memory_list'
  post 'memory/written_memory_detail', to: 'tab1_oral_memory/written_memory#written_memory_detail'
  post 'memory/publish_written_memory_comment', to: 'tab1_oral_memory/written_memory#publish_written_memory_comment'
  post 'memory/more_written_memory_comments', to: 'tab1_oral_memory/written_memory#more_written_memory_comments'


  #tab2/speak/oral_practice_controller
  post 'oral_practice/oral_list', to: 'tab2/speak/oral_practice#oral_list'
  post 'oral_practice/question_list', to: 'tab2/speak/oral_practice#question_list'
  post 'oral_practice/oral_detail_comments', to: 'tab2/speak/oral_practice#oral_detail_comments'
  post 'oral_practice/oral_detail_answers', to: 'tab2/speak/oral_practice#oral_detail_answers'
  post 'oral_practice/publish_oral_practice_comment', to: 'tab2/speak/oral_practice#publish_oral_practice_comment'
  post 'oral_practice/publish_oral_detail_answer', to: 'tab2/speak/oral_practice#publish_oral_detail_answer'
  post 'oral_practice/search_oral_practice', to: 'tab2/speak/oral_practice#search_oral_practice'
  post 'oral_practice/give_stars_to_oral_practice_comment', to: 'tab2/speak/oral_practice#give_stars_to_oral_practice_comment'


  #tab3/app_video_controller
  post 'app_video/get_category_list', to: 'tab3/app_video#get_category_list'
  post 'app_video/get_video_list', to: 'tab3/app_video#get_video_list'
  post 'app_video/get_video_detail', to: 'tab3/app_video#get_video_detail'
  post 'app_video/get_video_comment', to: 'tab3/app_video#get_video_comment'
  post 'app_video/publish_video_comment', to: 'tab3/app_video#publish_video_comment'
  post 'app_video/is_liked', to: 'tab3/app_video#is_liked'
  post 'app_video/like_video', to: 'tab3/app_video#like_video'

  #tab4/app_exam_group_controller
  post 'app_exam_group/oral_practice_list', to: 'tab4/app_exam_group#oral_practice_list'
  post 'app_exam_group/top_practices', to: 'tab4/app_exam_group#top_practices'
  post 'app_exam_group/top_stars', to: 'tab4/app_exam_group#top_stars'
  post 'app_exam_group/oral_practice_detail', to: 'tab4/app_exam_group#oral_practice_detail'
  post 'app_exam_group/get_more_comments', to: 'tab4/app_exam_group#get_more_comments'
  post 'app_exam_group/publish_comment', to: 'tab4/app_exam_group#publish_comment'
  post 'app_exam_group/is_stared_by_user', to: 'tab4/app_exam_group#is_stared_by_user'
  post 'app_user/search_user', to: 'tab4/app_exam_group#search_user'

  #tab5/personal_controller
  post 'app_user/my_basic_memories', to: 'tab5/personal#my_basic_memories'
  post 'app_user/my_oral_practice', to: 'tab5/personal#my_oral_practice'
  post 'app_user/my_exam_group', to: 'tab5/personal#my_exam_group'
  post 'app_user/change_mobile', to: 'tab5/personal#change_mobile'
  post 'app_collection/get_collection', to: 'tab5/personal#get_collection'


  ####for ActiveAdmin
  get 'application/generate_user_avatar_url'
  ####end ActiveAdmin

end
