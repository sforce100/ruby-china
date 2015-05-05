# coding: utf-8
require 'rails_helper'
require "oauth2"

describe 'OAuth2' do
  let(:password) { '123123' }
  let(:user) { FactoryGirl.create(:user, password: password, password_confirmation: password) }
  let(:app) { FactoryGirl.create(:application) }
  let(:client) {
    OAuth2::Client.new(app.uid,app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
  }
  
  describe 'password get_token' do
    it 'should work' do
      expect {
        @access_token = client.password.get_token(user.email, password)
      }.to change(Doorkeeper::AccessToken, :count).by(1)
      
      expect(@access_token.token).not_to be_nil
      
      # Refresh Token
      expect {
        @new_token = @access_token.refresh!
      }.to change(Doorkeeper::AccessToken, :count).by(1)
      expect(@new_token.token).not_to be_nil
      expect(@new_token.token).not_to eq @access_token.token
    end
  end
end