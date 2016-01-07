class IndexController < ApplicationController
  def index
    @today = Date.today.to_s
    @beginning_of_month = Date.today.beginning_of_month.to_s
    @commit = CommitCollection.order("count DESC").where("date = ?", @today)
  end
end
