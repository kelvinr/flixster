shared_examples "require sign in" do
  it "redirects to the sign in page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to :login
  end
end

shared_examples "require admin" do
  it "redirects regular user to home path" do
    set_current_user
    action
    expect(response).to redirect_to :home
  end
end

shared_examples "already logged in" do
  it "redirects to home if there's a current user" do
    set_current_user
    action
    expect(response).to redirect_to :home
  end
end

shared_examples "tokenable" do |prefix=nil|
  it "generates a random token" do
    object.create_reset_digest unless prefix.nil?
    expect(object.send("#{prefix}token")).to be_present
  end
end
