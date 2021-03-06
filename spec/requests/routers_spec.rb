 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/routers", type: :request do
  # Router. As you add validations to Router, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Router.create! valid_attributes
      get routers_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      router = Router.create! valid_attributes
      get router_url(router)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_router_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      router = Router.create! valid_attributes
      get edit_router_url(router)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Router" do
        expect {
          post routers_url, params: { router: valid_attributes }
        }.to change(Router, :count).by(1)
      end

      it "redirects to the created router" do
        post routers_url, params: { router: valid_attributes }
        expect(response).to redirect_to(router_url(Router.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Router" do
        expect {
          post routers_url, params: { router: invalid_attributes }
        }.to change(Router, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post routers_url, params: { router: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested router" do
        router = Router.create! valid_attributes
        patch router_url(router), params: { router: new_attributes }
        router.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the router" do
        router = Router.create! valid_attributes
        patch router_url(router), params: { router: new_attributes }
        router.reload
        expect(response).to redirect_to(router_url(router))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        router = Router.create! valid_attributes
        patch router_url(router), params: { router: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested router" do
      router = Router.create! valid_attributes
      expect {
        delete router_url(router)
      }.to change(Router, :count).by(-1)
    end

    it "redirects to the routers list" do
      router = Router.create! valid_attributes
      delete router_url(router)
      expect(response).to redirect_to(routers_url)
    end
  end
end
