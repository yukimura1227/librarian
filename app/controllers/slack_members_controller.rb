class SlackMembersController < ApplicationController
  before_action :set_slack_member, only: [:show, :edit, :update, :destroy]

  # GET /slack_members
  # GET /slack_members.json
  def index
    @slack_members = SlackMember.all
  end

  # GET /slack_members/1/edit
  def edit
  end

  # PATCH/PUT /slack_members/1
  # PATCH/PUT /slack_members/1.json
  def update
    respond_to do |format|
      if @slack_member.update(slack_member_params)
        format.html { redirect_to slack_members_path, notice: 'Slack member was successfully updated.' }
        format.json { render :show, status: :ok, location: @slack_member }
      else
        format.html { render :edit }
        format.json { render json: @slack_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slack_members/1
  # DELETE /slack_members/1.json
  def destroy
    @slack_member.destroy
    respond_to do |format|
      format.html { redirect_to slack_members_url, notice: 'Slack member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_slack_member
    @slack_member = SlackMember.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def slack_member_params
    params.require(:slack_member).permit(:slack_id, :slack_user_name, :user_id)
  end
end
