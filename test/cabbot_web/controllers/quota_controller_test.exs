defmodule CabbotWeb.QuotaControllerTest do
  use CabbotWeb.ConnCase

  import Cabbot.Cabbot.CreditosFixtures

  alias Cabbot.Cabbot.Creditos.Quota

  @create_attrs %{
    plan_number: 42,
    clients_quota: "some clients_quota",
    quota_delayed_days: 42,
    last_payment_penalty: "some last_payment_penalty",
    quota_state: "some quota_state",
    concept_state: "some concept_state",
    bill_number: "some bill_number",
    delayed_quota_history_days: 42,
    prevision_amount: "120.5",
    start_date: ~U[2022-09-03 15:55:00Z],
    previous_earned_amount: "120.5",
    user_code: "some user_code",
    conpcept_code: "some conpcept_code",
    debt_balance: "120.5",
    calc_number_days: 42,
    office_code: "some office_code",
    earned_amount: "120.5",
    due_date: ~U[2022-09-03 15:55:00Z],
    paid_amount: "120.5",
    balance_sub_code: "some balance_sub_code",
    payment_sec: 42,
    condoned_amount: "120.5",
    previous_sec_payment: 42,
    loan_code: "some loan_code",
    previous_concept_state: "some previous_concept_state",
    ClientsQuota: "some ClientsQuota",
    INTE_adjust: "some INTE_adjust",
    payment_date: ~U[2022-09-03 15:55:00Z],
    previous_state_sub_code: "some previous_state_sub_code",
    quota_amount: "120.5",
    quota_sec: 42,
    previous_quota_state: "some previous_quota_state",
    previous_paid_amount: "120.5",
    Cabbot.Creditos: "some Cabbot.Creditos",
    previous_payment_date: ~U[2022-09-03 15:55:00Z]
  }
  @update_attrs %{
    plan_number: 43,
    clients_quota: "some updated clients_quota",
    quota_delayed_days: 43,
    last_payment_penalty: "some updated last_payment_penalty",
    quota_state: "some updated quota_state",
    concept_state: "some updated concept_state",
    bill_number: "some updated bill_number",
    delayed_quota_history_days: 43,
    prevision_amount: "456.7",
    start_date: ~U[2022-09-04 15:55:00Z],
    previous_earned_amount: "456.7",
    user_code: "some updated user_code",
    conpcept_code: "some updated conpcept_code",
    debt_balance: "456.7",
    calc_number_days: 43,
    office_code: "some updated office_code",
    earned_amount: "456.7",
    due_date: ~U[2022-09-04 15:55:00Z],
    paid_amount: "456.7",
    balance_sub_code: "some updated balance_sub_code",
    payment_sec: 43,
    condoned_amount: "456.7",
    previous_sec_payment: 43,
    loan_code: "some updated loan_code",
    previous_concept_state: "some updated previous_concept_state",
    ClientsQuota: "some updated ClientsQuota",
    INTE_adjust: "some updated INTE_adjust",
    payment_date: ~U[2022-09-04 15:55:00Z],
    previous_state_sub_code: "some updated previous_state_sub_code",
    quota_amount: "456.7",
    quota_sec: 43,
    previous_quota_state: "some updated previous_quota_state",
    previous_paid_amount: "456.7",
    Cabbot.Creditos: "some updated Cabbot.Creditos",
    previous_payment_date: ~U[2022-09-04 15:55:00Z]
  }
  @invalid_attrs %{previous_payment_date: nil, "Cabbot.Creditos": nil, previous_paid_amount: nil, previous_quota_state: nil, quota_sec: nil, quota_amount: nil, previous_state_sub_code: nil, payment_date: nil, INTE_adjust: nil, ClientsQuota: nil, previous_concept_state: nil, loan_code: nil, previous_sec_payment: nil, condoned_amount: nil, payment_sec: nil, balance_sub_code: nil, paid_amount: nil, due_date: nil, earned_amount: nil, office_code: nil, calc_number_days: nil, debt_balance: nil, conpcept_code: nil, user_code: nil, previous_earned_amount: nil, start_date: nil, prevision_amount: nil, delayed_quota_history_days: nil, bill_number: nil, concept_state: nil, quota_state: nil, last_payment_penalty: nil, quota_delayed_days: nil, clients_quota: nil, plan_number: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all quota", %{conn: conn} do
      conn = get(conn, Routes.quota_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create quota" do
    test "renders quota when data is valid", %{conn: conn} do
      conn = post(conn, Routes.quota_path(conn, :create), quota: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.quota_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "payment_date" => "2022-09-03T15:55:00Z",
               "user_code" => "some user_code",
               "delayed_quota_history_days" => 42,
               "condoned_amount" => "120.5",
               "INTE_adjust" => "some INTE_adjust",
               "balance_sub_code" => "some balance_sub_code",
               "previous_earned_amount" => "120.5",
               "debt_balance" => "120.5",
               "previous_sec_payment" => 42,
               "quota_delayed_days" => 42,
               "conpcept_code" => "some conpcept_code",
               "previous_concept_state" => "some previous_concept_state",
               "quota_state" => "some quota_state",
               "last_payment_penalty" => "some last_payment_penalty",
               "plan_number" => 42,
               "office_code" => "some office_code",
               "paid_amount" => "120.5",
               "payment_sec" => 42,
               "loan_code" => "some loan_code",
               "calc_number_days" => 42,
               "previous_paid_amount" => "120.5",
               "clients_quota" => "some clients_quota",
               "concept_state" => "some concept_state",
               "quota_sec" => 42,
               "ClientsQuota" => "some ClientsQuota",
               "previous_quota_state" => "some previous_quota_state",
               "Cabbot.Creditos" => "some Cabbot.Creditos",
               "start_date" => "2022-09-03T15:55:00Z",
               "bill_number" => "some bill_number",
               "due_date" => "2022-09-03T15:55:00Z",
               "prevision_amount" => "120.5",
               "previous_payment_date" => "2022-09-03T15:55:00Z",
               "previous_state_sub_code" => "some previous_state_sub_code",
               "earned_amount" => "120.5",
               "quota_amount" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.quota_path(conn, :create), quota: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update quota" do
    setup [:create_quota]

    test "renders quota when data is valid", %{conn: conn, quota: %Quota{id: id} = quota} do
      conn = put(conn, Routes.quota_path(conn, :update, quota), quota: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.quota_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "payment_date" => "2022-09-04T15:55:00Z",
               "user_code" => "some updated user_code",
               "delayed_quota_history_days" => 43,
               "condoned_amount" => "456.7",
               "INTE_adjust" => "some updated INTE_adjust",
               "balance_sub_code" => "some updated balance_sub_code",
               "previous_earned_amount" => "456.7",
               "debt_balance" => "456.7",
               "previous_sec_payment" => 43,
               "quota_delayed_days" => 43,
               "conpcept_code" => "some updated conpcept_code",
               "previous_concept_state" => "some updated previous_concept_state",
               "quota_state" => "some updated quota_state",
               "last_payment_penalty" => "some updated last_payment_penalty",
               "plan_number" => 43,
               "office_code" => "some updated office_code",
               "paid_amount" => "456.7",
               "payment_sec" => 43,
               "loan_code" => "some updated loan_code",
               "calc_number_days" => 43,
               "previous_paid_amount" => "456.7",
               "clients_quota" => "some updated clients_quota",
               "concept_state" => "some updated concept_state",
               "quota_sec" => 43,
               "ClientsQuota" => "some updated ClientsQuota",
               "previous_quota_state" => "some updated previous_quota_state",
               "Cabbot.Creditos" => "some updated Cabbot.Creditos",
               "start_date" => "2022-09-04T15:55:00Z",
               "bill_number" => "some updated bill_number",
               "due_date" => "2022-09-04T15:55:00Z",
               "prevision_amount" => "456.7",
               "previous_payment_date" => "2022-09-04T15:55:00Z",
               "previous_state_sub_code" => "some updated previous_state_sub_code",
               "earned_amount" => "456.7",
               "quota_amount" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, quota: quota} do
      conn = put(conn, Routes.quota_path(conn, :update, quota), quota: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete quota" do
    setup [:create_quota]

    test "deletes chosen quota", %{conn: conn, quota: quota} do
      conn = delete(conn, Routes.quota_path(conn, :delete, quota))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.quota_path(conn, :show, quota))
      end
    end
  end

  defp create_quota(_) do
    quota = quota_fixture()
    %{quota: quota}
  end
end
