module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[suspend restore]

    def index
      scope = User.includes(:listings).order(created_at: :desc)
      if params[:q].present?
        like = "%#{User.sanitize_sql_like(params[:q])}%"
        phone = User.normalize_phone(params[:q])
        scope = if phone.present?
                  scope.where("name ILIKE :name OR phone LIKE :phone", name: like, phone: "%#{phone}%")
                else
                  scope.where("name ILIKE ?", like)
                end
      end
      @users = scope.limit(50)
    end

    def suspend
      if @user.admin?
        redirect_to admin_users_path, alert: "Admins can't be suspended. Remove admin access first."
      else
        @user.update!(suspended: true)
        AdminAction.record!(current_user, "suspend_user", @user, @user.name)
        redirect_to admin_users_path(q: params[:q]), notice: "#{@user.name} is suspended."
      end
    end

    def restore
      @user.update!(suspended: false)
      AdminAction.record!(current_user, "restore_user", @user, @user.name)
      redirect_to admin_users_path(q: params[:q]), notice: "#{@user.name} can log in again."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
