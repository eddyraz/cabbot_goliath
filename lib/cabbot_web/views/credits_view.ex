defmodule CabbotWeb.CreditsView do
  use CabbotWeb, :view
  alias CabbotWeb.CreditsView

  def render("index.json", %{quota: quota}) do
    %{data: render_many(quota, QuotaView, "credits_quota.json")}
  end

  def render("show.json", %{quota: quota}) do
    %{data: render_one(quota, QuotaView, "quota.json")}
  end

  def render("credits_quota.json", %{quota: quota}) do
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



      def render("credits_clients_quota.json", %{clients_quota: clients_quota}) do


    %{
      loan_code: clients_quota.loan_code,
      plan_number: clients_quota.plan_number,
      quota_sec: clients_quota.quota_sec,
      concept_code: clients_quota.concept_code,
      user_code: clients_quota.user_code,
      calc_number_days: clients_quota.calc_number_days,
      quota_amount: clients_quota.quota_amount,
      earned_amount: clients_quota.earned_amount,
      paid_amount: clients_quota.paid_amount,
      condoned_amount: clients_quota.condoned_amount,
      payment_sec: clients_quota.payment_sec,
      payment_date: clients_quota.payment_date,
      concept_state: clients_quota.concept_state,
      previous_paid_amount: clients_quota.previous_paid_amount,
      previous_concept_state: clients_quota.previous_concept_state,
      previous_payment_date: clients_quota.previous_payment_date,
      previous_sec_payment: clients_quota.previous_sec_payment,
      last_payment_penalty: clients_quota.last_payment_penalty,
      previous_earned_amount: clients_quota.previous_earned_amount,
      debt_balance: clients_quota.debt_balance,
      office_code: clients_quota.office_code
    }
  end

  
  
end
