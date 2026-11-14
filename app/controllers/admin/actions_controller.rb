module Admin
  class ActionsController < BaseController
    def index
      @actions = AdminAction.includes(:admin).order(created_at: :desc).limit(100)
    end
  end
end
