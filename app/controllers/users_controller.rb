class UsersController < ApplicationController
    
    def index
        @users = User.all.order(created_at: "desc") 

        @q = @users.ransack(params[:q])
        @users = @q.result(distinct: true)
    end
  end
  