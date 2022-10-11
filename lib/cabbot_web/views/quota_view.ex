defmodule CabbotWeb.QuotaView do
  use CabbotWeb, :view
  alias CabbotWeb.QuotaView

  def render("show_many.json", %{quotas: quotas}) do
    %{data: render_many(quotas, QuotaView, "quota.json")}
   end

  
  def render("show.json", %{quota: quota}) do
    %{data: render_one(quota, QuotaView, "quota.json")}
  end

  def render("quota.json", %{quota: quota}) do
    %{
      id: quota.id,
      loan_code: quota.loan_code,
      plan_number: quota.plan_number,
      quota_sec: quota.quota_sec,
      start_date: quota.start_date,
      payment_date: quota.payment_date,
      due_date: quota.due_date,
      quota_delayed_days: quota.quota_delayed_days,
      quota_state: quota.quota_state,
      balance_sub_code: quota.balance_sub_code,
      delayed_quota_history_days: quota.delayed_quota_history_days,
      previous_quota_state: quota.previous_quota_state,
      previous_payment_date: quota.previous_payment_date,
      previous_state_sub_code: quota.previous_state_sub_code,
      prevision_amount: quota.prevision_amount,
      inte_adjust: quota.inte_adjust,
      bill_number: quota.bill_number,
}
  end
end


