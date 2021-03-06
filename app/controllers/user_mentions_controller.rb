class UserMentionsController < ApplicationController
  before_action :set_user_mention, only: [:show, :edit, :update, :destroy]

  # GET /user_mentions
  # GET /user_mentions.json
  def index
    @user_mentions = UserMention.all
  end

  # GET /user_mentions/1
  # GET /user_mentions/1.json
  def show
  end

  # GET /user_mentions/new
  def new
    @user_mention = UserMention.new
  end

  # GET /user_mentions/1/edit
  def edit
  end

  def search
    @username = params[:q]
    @mentions = Array.new
    @count = 0
    (1..5).each do |i|
      begin
        @tweets = $client.user_timeline(@username, options={:count => 200, :page => i})
      rescue Twitter::Error::NotFound
        @error = "User not found."
      rescue Twitter::Error::TooManyRequests
        @error = "You've made too many requests, but we have a cached version of your results."
        begin
          @cached_um = UserMention.find_by(username: @username)
        rescue Mongoid::Errors::DocumentNotFound
          @error = "You've made too many requests. Unfortunately, we have no cached data for the username entered."
        else 
          @sorted_mc = @cached_um.mentions
        end
      else 
        @tweets.each do |tweet|
          @count += 1
          tweet.user_mentions.each do |mention|
            if mention.attrs[:screen_name].downcase != @username.downcase
              @mentions.push('@' + mention.attrs[:screen_name])
            end
          end
        end
      end
    end
    if @mentions.length != 0
      @mentions_count = Hash.new(0)
      @mentions.each { |mention| @mentions_count[mention] += 1 }
      @sorted_mc = Hash[@mentions_count.sort_by{ |_, v| -v }]
    else
      if !@error 
        @error = "No mentions found."
      end
    end
    begin
      @params = { :username => @username, :mentions => @sorted_mc }
      @um = UserMention.new(@params)
      @um.save
    rescue Mongo::Error::OperationFailure => e
      @cached_um = UserMention.find_by(username: @username)
      @cached_um.mentions = @sorted_mc
      @cached_um.save
    end
  end

  # POST /user_mentions
  # POST /user_mentions.json
  def create
    @user_mention = UserMention.new(user_mention_params)

    respond_to do |format|
      if @user_mention.save
        format.html { redirect_to @user_mention, notice: 'User mention was successfully created.' }
        format.json { render :show, status: :created, location: @user_mention }
      else
        format.html { render :new }
        format.json { render json: @user_mention.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_mentions/1
  # PATCH/PUT /user_mentions/1.json
  def update
    respond_to do |format|
      if @user_mention.update(user_mention_params)
        format.html { redirect_to @user_mention, notice: 'User mention was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_mention }
      else
        format.html { render :edit }
        format.json { render json: @user_mention.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_mentions/1
  # DELETE /user_mentions/1.json
  def destroy
    @user_mention.destroy
    respond_to do |format|
      format.html { redirect_to user_mentions_url, notice: 'User mention was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_mention
      @user_mention = UserMention.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_mention_params
      params.require(:user_mention).permit(:username, :mentions)
    end
end
