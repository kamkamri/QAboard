
[1mFrom:[0m /home/ec2-user/environment/QAboard/app/controllers/admin/trees_controller.rb:22 Admin::TreesController#index:

     [1;34m4[0m: [32mdef[0m [1;34mindex[0m
     [1;34m5[0m:   @trees = [1;34;4mTree[0m.all
     [1;34m6[0m: 
     [1;34m7[0m:   [1;34m# 検索[0m
     [1;34m8[0m:   [32mcase[0m params[[33m:genre[0m]
     [1;34m9[0m:     [1;34m# admin受信した質問[0m
    [1;34m10[0m:     [32mwhen[0m [31m[1;31m"[0m[31m受信[1;31m"[0m[31m[0m [32mthen[0m
    [1;34m11[0m:       @admin_user = current_admin_user
    [1;34m12[0m:       [1;34m# ツリーの送信者が自分の担当拠点[0m
    [1;34m13[0m:       @myarea = @admin_user.areas.where([35myour_areas[0m:{[35madmin_user_id[0m: @admin_user.id})
    [1;34m14[0m:       [1;34m# ツリーの業務がじぶんの担当業務[0m
    [1;34m15[0m:       @myjob = @admin_user.jobs.where([35myour_jobs[0m:{[35madmin_user_id[0m: @admin_user.id})
    [1;34m16[0m:       @trees = [1;34;4mTree[0m.where([35marea_id[0m: @myarea, [35mjob_id[0m: @myjob).or( [1;34;4mTree[0m.where([35mpost_id[0m: @myarea, [35mjob_id[0m: @myjob)).distinct
    [1;34m17[0m:       binding.pry
    [1;34m18[0m:     [32melse[0m
    [1;34m19[0m: 
    [1;34m20[0m:   [32mend[0m
    [1;34m21[0m: 
 => [1;34m22[0m: [32mend[0m

