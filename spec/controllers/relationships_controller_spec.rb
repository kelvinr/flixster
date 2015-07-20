require 'spec_helper'

describe RelationshipsController do
  let(:alice) { Fabricate(:user) }
  let(:bob) { Fabricate(:user) }

  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    it "creates a relationship where current user follows the leader" do
      set_current_user(alice)
      post :create, leader_id: bob.id
      expect(alice.following_relationships.first.leader).to eq(bob)
    end

    it "redirects to the people page" do
      set_current_user(alice)
      post :create, leader_id: bob.id
      expect(response).to redirect_to :people
    end

    it "does not create a relationship if the current user already follows the leader" do
      set_current_user(alice)
      Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end

    it "does not allow user to follow themselves" do
      set_current_user(alice)
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end
  end

  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      set_current_user(alice)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    before { set_current_user(alice) }

    it_behaves_like "require sign in" do
      let(:action) { delete :destroy, id: 2 }
    end

    it "deletes the relationship if the current user is the follower" do
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "redirects to the people page" do
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship
      expect(response).to redirect_to :people
    end

    it "does not delete the relationship if the current user is not the follower" do
      jake = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: jake, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end
end
