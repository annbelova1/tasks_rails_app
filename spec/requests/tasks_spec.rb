# frozen_string_literal: true

require 'rails_helper'

describe 'Tasks' do
  let(:task) { create(:task, user: user) }
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /api/tasks' do
    subject { get '/api/tasks' }

    before { create_list(:task, 3) }

    it 'возвращает список всех задач' do
      subject

      expect(response).to be_successful
      expect(JSON.parse(response.body).pluck('id').count).to eq 3
      expect(JSON.parse(response.body).pluck('id')).to match_array(Task.all.pluck(:id))
    end
  end

  describe 'POST /api/tasks' do
    subject { post '/api/tasks', params: params }

    context 'валидные данные' do
        let(:params) { { name: 'Task'} }

        it 'создает задачу' do
            expect { subject }.to(change { Task.count }.by(1))
            expect(response).to be_successful
          end
     
    end

    context 'невалидные данные' do
        let(:params) { { } }

        it 'создает задачу' do
            expect { subject }.not_to(change { Task.count })
            expect(response).not_to be_successful
          end
    end
  end

  describe 'PATCH /api/tasks/:id/start' do
    subject { patch "/api/tasks/#{task.id}/start" }

    context 'если данные валидные' do
      it 'запускает задачу' do
        task
        subject

        expect(JSON.parse(response.body)['success']).to eq true
        expect(JSON.parse(response.body)['data']['status']).to eq 'in_progress'
      end
    end

    context 'если данные не валидные' do
        let(:creator) { create(:user)}
        let(:task) { create(:task, user: creator)}

      it 'не изменяет имя сервиса' do
        task
        subject

        expect(JSON.parse(response.body)['success']).to eq false
        expect(JSON.parse(response.body)['data']['errors'][0]['title']).to eq "Task can be started only by creator"
      end
    end
  end


  describe 'PATCH /api/tasks/:id/approve' do
    subject { patch "/api/tasks/#{task.id}/approve" }


    let(:task) do
        record = create(:task, user: user)
        record.update(status: 'in_progress')
        record
   end

    context 'если данные валидные' do
      let(:another_user) { create(:user)}
      it 'подтверждает таску' do
        sign_in another_user
        subject

        expect(JSON.parse(response.body)['success']).to eq true
        task.reload
        expect(task.approved_user_ids.count).to eq 1
        expect(task.approved_user_ids.first).to eq another_user.id.to_s
      end
    end

    context 'если данные не валидные' do
      it 'не подтверждает таску так как создатель' do
        expect { subject }.not_to change(task, :approved_user_ids)
      end
    end
  end


  describe 'PATCH /api/tasks/:id/cancel' do
    subject { patch "/api/tasks/#{task.id}/cancel" }

    let(:task) do
        record = create(:task, user: user)
        record.update(status: 'in_progress')
        record
   end

    context 'если данные валидные' do
      it 'закрывает таску' do
        subject

        expect(JSON.parse(response.body)['success']).to eq true
        expect(JSON.parse(response.body)['data']['status']).to eq 'canceled'

        task.reload
        expect(task).to be_canceled
        expect(task.canceled_at).to be_present
      end
    end

    context 'если данные не валидные' do
        let(:another_user) { create(:user)}

      it 'не закрывает таску так как не создатель' do
        sign_in another_user
        subject

        expect(JSON.parse(response.body)['success']).to eq false
        expect(JSON.parse(response.body)['data']['errors'][0]['title']).to eq "Task can be canceled only by creator"
        expect(task.reload).not_to be_canceled
      end
    end
  end

  describe 'PATCH /api/tasks/:id/complete' do
    subject { patch "/api/tasks/#{task.id}/complete" }

    let(:task) do
         record = create(:task, user: user)
         record.update(status: 'in_progress')
         record
    end
    context 'если данные валидные' do
      it 'завершает таску' do
        task.update(approved_user_ids: [1,2])

        subject

        expect(JSON.parse(response.body)['success']).to eq true
        expect(JSON.parse(response.body)['data']['status']).to eq 'completed'
        task.reload
        expect(task).to be_completed
        expect(task.completed_at).to be_present
      end
    end

    context 'если данные не валидные' do
        context 'если не создаетель завершает' do
            let(:another_user) { create(:user)}

            it 'не закрывает таску так как не создатель' do
                sign_in another_user
                task.update(approved_user_ids: [1,2])
                subject

                expect(JSON.parse(response.body)['success']).to eq false
                expect(JSON.parse(response.body)['data']['errors'][0]['title']).to eq "Task can be completed only by creator"

                task.reload
                expect(task.reload).not_to be_completed
            end
        end

        context 'если нет как минимум двух подтверждений' do
            it 'не закрывает таску так как не создатель' do
                subject

                expect(JSON.parse(response.body)['success']).to eq false
                expect(JSON.parse(response.body)['data']['errors'][0]['title']).to eq "Task should be approved at least two users for being completed"

                expect(task.reload).not_to be_completed
            end
        end

    end
  end
end
