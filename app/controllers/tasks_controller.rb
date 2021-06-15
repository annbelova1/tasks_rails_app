class TasksController < ApplicationController
    before_action :authenticate_user!

    before_action :set_task, only: [:edit, :update, :destroy, :start, :approve, :cancel, :complete]

    def index
        @tasks = Task.all
    end

    def show
        @task
    end

    def create
        @task = Task.create(task_params.merge(user_id: current_user.id))
        respond_to do |format|
            if  @task.save
                format.html { redirect_to tasks_path, notice: "Task #{@task.name} was successfully created." }
                format.js
            else
                format.html { render action: "index" }
                format.js
            end
        end
    end

    def start
        @result = Tasks::Start.call(@task, current_user)

        respond_to do |format|
            if @result.success?
                format.html { redirect_to tasks_path, notice: "Task #{@task.name} was successfully started." }
                format.js
            else
                format.html { redirect_to tasks_path, alert: @result.data[:errors][0][:title] }
                format.js
            end
        end
    end

    def cancel
        @result = Tasks::Cancel.call(@task, current_user)

        respond_to do |format|
            if @result.success?
                format.html { redirect_to tasks_path, notice: "Task #{@task.name} was successfully canceled."}
                format.js
            else
                format.html { redirect_to tasks_path, alert: @result.data[:errors][0][:title] }
                format.js
            end
        end
    end

    def complete
        @result = Tasks::Complete.call(@task, current_user)

        respond_to do |format|
            if @result.success?
                format.html { redirect_to tasks_path, notice: "Task #{@task.name} was successfully completed." }
                format.js
            else
                format.html { redirect_to tasks_path, alert: @result.data[:errors][0][:title] }
                format.js
            end
        end
    end

    def approve
        @result = Tasks::Approve.call(@task, current_user)

        respond_to do |format|
            if @result.success?
                format.html { redirect_to tasks_path, notice: "Task #{@task.name} was successfully approved." }
                format.js
            else
                format.html { redirect_to tasks_path, alert: @result.data[:errors][0][:title] }
                format.js
            end
        end
    end

    # def update
    #     if @task.update(task_params)
    #         redirect_to @task.post, notice: "task updated."
    #     else
    #         render 'edit'
    #     end
    # end

    # def destroy
    #     @task.destroy
    #     redirect_to @task, notice: "task successfully deleted."
    # end

    private
        def set_task
            @task = Task.find(params[:id])
        end

        def task_params
            params.permit(:name)
        end
end