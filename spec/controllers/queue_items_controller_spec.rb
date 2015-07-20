require 'spec_helper'

describe QueueItemsController do
  let(:jake) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  let(:queue_item1) { Fabricate(:queue_item, user: jake, position: 1, video: video) }
  let(:queue_item2) { Fabricate(:queue_item, user: jake, position: 2, video: video) }

  describe "GET index" do
    it "sets @queue_items" do
      set_current_user(jake)
      get :index
      expect(assigns(:queue_items)).to eq([queue_item1, queue_item2])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it "redirects to my queue page" do
      set_current_user
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      set_current_user
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "queue item is associated with the video" do
      set_current_user
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates a queue item associated with the signed in user" do
      set_current_user(jake)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(jake)
    end

    it "puts the video as the last one in the queue" do
      set_current_user(jake)
      monk = Fabricate(:video)
      Fabricate.create(:queue_item, video: monk, user: jake)
      futurama = Fabricate(:video)
      post :create, video_id: futurama.id
      futurama_queue_item = QueueItem.find_by(video_id: futurama.id, user_id: jake.id)
      expect(futurama_queue_item.position).to eq(2)
    end

    it "does not add the video to the queue if the video is already present" do
      set_current_user(jake)
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: jake)
      post :create, video_id: monk.id
      expect(jake.queue_items.count).to eq(1)
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create, video_id: 3}
    end
  end

  describe "PUT update_queue" do
    before { set_current_user(jake) }

    context "with valid input" do
      it "redirects to my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to :my_queue
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(jake.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(jake.queue_items.pluck(:position)).to eq([1, 2])
      end
    end

    context "with invalid input" do
      it "redirects to my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to :my_queue
      end

      it "sets the flash message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.2}, {id: queue_item2.id, position: 1}]
        expect(flash[:danger]).not_to be_nil
      end

      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end

      it "does not change the queue items with invalid user" do
        bob = Fabricate(:user)
        queue_item3 = Fabricate(:queue_item, user: bob, position: 1, video: video)
        queue_item4 = Fabricate(:queue_item, user: bob, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item3.id, position: 3}, {id: queue_item4.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) {post :update_queue}
    end
  end

  describe "DELETE destroy" do
    before { set_current_user(jake) }

    it "redirects to queue page" do
      delete :destroy, id: Fabricate(:queue_item, user: jake).id
      expect(response).to redirect_to :my_queue
    end

    it "deletes the queue item" do
      delete :destroy, id: Fabricate(:queue_item, user: jake).id
      expect(QueueItem.count).to eq(0)
    end

    it "removes queue item from users queue" do
      delete :destroy, id: Fabricate(:queue_item, user: jake).id
      expect(jake.queue_items).to eq([])
    end

    it "adjusts the position of the queue items" do
      queue_item1; queue_item2
      delete :destroy, id: queue_item1.id
      expect(queue_item2.reload.position).to eq(1)
    end

    it "sets flash when incorrect user" do
      delete :destroy, id: Fabricate(:queue_item, user: Fabricate(:user)).id
      expect(flash[:danger]).not_to be_nil
    end

    it_behaves_like "require sign in" do
      let(:action) { delete :destroy, id: Fabricate(:queue_item, user: Fabricate(:user)).id }
    end
  end
end
