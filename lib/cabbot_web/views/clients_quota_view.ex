defmodule CabbotWeb.ClientsQuotaView do
  use CabbotWeb, :view
  alias CabbotWeb.ClientsQuotaView

  def render("show_many.json", %{clients_quota: clients_quota}) do
    %{data: render_many(clients_quota, ClientsQuotaView, "clients_quota.json")}
  end

    def render("clients_quota.json", %{clients_quota: clients_quota}) do
    %{
      id: clients_quota.id,
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







