defmodule CabbotWeb.QuotaController do
  use CabbotWeb, :controller

  alias Cabbot.Cabbot.Creditos
  alias Cabbot.Cabbot.Creditos.Quota
  alias Cabbot.Cabbot.Creditos.ClientsQuota

  action_fallback CabbotWeb.FallbackController

  @config Application.compile_env(:cabbot, :creditos)

  def index(conn, _params) do
    quota = Creditos.list_quota()
    render(conn, "index.json", quota: quota)
  end

  def create(conn, %{"Creditos" => credits_params}) do
    qm = credits_params
    |> hd
    |> parse_params()
    |> IO.inspect()


    qmap = qm
    |> Enum.filter(fn x -> Map.keys(x) == [:Quota] end)
    |> Enum.map(fn x -> x[:Quota] |> Map.new(fn {k,v} -> {k |> String.to_atom(),v}  end) end)
    |> IO.inspect()
    Cabbot.Repo.insert_all(Quota,qmap)


       qcmap = qm
    |> Enum.filter(fn x -> Map.keys(x) == [:ClientsQuota] end)
    |> Enum.map(fn x -> x[:ClientsQuota] |> Map.new(fn {k,v} -> {k |> String.to_atom(),v}  end) end)
    |> IO.inspect()
    Cabbot.Repo.insert_all(ClientsQuota,qcmap)
 
    
   # Creditos.create_many_quotas(qmap)
    
 #   qm    
 #   |> Enum.map(fn quota_map ->
 #     with [:Quota] <- quota_map |> Map.keys(),
 #          {:ok, %Quota{} = quota} <-
 #            Creditos.create_quota(
 #              quota_map
 #              |> Map.values()
 #              |> hd
 #            ) do
 #       conn
 #       |> put_status(:created)
 #       |> put_resp_header("location", Routes.quota_path(conn, :show, quota))
 #       |> put_view(CabbotWeb.QuotaView)
#        |> render("index.json", quotas: quota)
 #     end

 #     with [:ClientsQuota] <- quota_map |> Map.keys(),
 #          {:ok, %ClientsQuota{} = clients_quota} <-
 #            Creditos.create_clients_quota(
 #              quota_map
 #              |> Map.values()
 #              |> hd
 #            ) do
 #       conn
  #      |> put_status(:created)
  #      |> put_resp_header("location", Routes.quota_path(conn, :show, clients_quota))
  #      |> put_view(CabbotWeb.ClientsQuotaView)
  #      |> render("show.json", clients_quota: clients_quota)
  #    end
  #  end)
  end

  def parse_params(data) do
    loan_code_field = data["Codprestamo"]
    quota_concept_list = data["CuotasConcepto"]
    quota_plan_list = data["PlanCuotas"]

    process_quota_map(quota_plan_list, loan_code_field) ++
      process_concept_quota_map(quota_concept_list, loan_code_field)
  end

  # ++++++++++++++++++++Para la tabla Cuota++++++++++++++++++++++++++++++++++

  def process_quota_map(quota_plan_list, loan_code_field) do
    quota_plan_list
    |> Enum.map(fn %{
                     "Diasatrcuota" => delayed_days_value,
                     "Estadocuota" => quota_state_value,
                     "Fechainicio" => start_date_value,
                     "Fechapago" => payment_date_value,
                     "Fechavencimiento" => due_date_value,
                     "Seccuota" => quota_sequence_value
                   } ->
      quota_final_map =
        %{
          "Diasatrcuota" => delayed_days_value,
          "Estadocuota" => quota_state_value,
          "Fechainicio" => start_date_value,
          "Fechapago" => payment_date_value,
          "Fechavencimiento" => due_date_value,
          "Seccuota" => quota_sequence_value
        }
        |> field_translator("PlanCuotas")
        |> request_data_merge(quota_map_fill_up(), loan_code_field)

      parsed_dates =
        quota_final_map
        |> extract_date_fields()

      proto_quota_map =
        Map.merge(quota_final_map, parsed_dates)
        |> Map.update!("payment_date", fn _x -> ~U[1970-01-01 00:00:00Z] end)
        |> Map.update!("quota_delayed_days", fn x -> x |> String.to_integer() end)
        |> Map.update!("quota_sec", fn x -> x |> String.to_integer() end)

      Enum.into([Quota: proto_quota_map], %{})
    end)
  end

  # ++++++++++++++++++++Para la tabla ClientsCuota++++++++++++++++++++++++++++++++++

  def process_concept_quota_map(quota_concept_list, loan_code_field) do
    quota_concept_list
    |> Enum.map(fn
      %{
        "Seccuota" => quota_sec_value,
        "Codconcepto" => concept_code_value,
        "Numdiascalc" => num_calc_days_values,
        "Montocuota" => quota_amount_value,
        "Montodevengado" => earned_amount_value,
        "Montopagado" => paid_amount_value,
        "Fechapago" => payment_date_value,
        "Estadoconcepto" => concept_state_value
      } ->
        concept_quota_final_map =
          %{
            "Seccuota" => quota_sec_value,
            "Codconcepto" => concept_code_value,
            "Numdiascalc" => num_calc_days_values,
            "Montocuota" => quota_amount_value,
            "Montodevengado" => earned_amount_value,
            "Montopagado" => paid_amount_value,
            "Fechapago" => payment_date_value,
            "Estadoconcepto" => concept_state_value
          }
          |> field_translator("CuotasConcepto")
          |> request_data_merge(concept_quota_map_fill_up(), loan_code_field)

        concept_parsed_dates =
          concept_quota_final_map
          |> extract_date_fields()

        proto_concept_quota_map =
          Map.merge(concept_quota_final_map, concept_parsed_dates)
          |> Map.update!("payment_date", fn _x -> ~U[1970-01-01 00:00:00Z] end)
          |> Map.update!("quota_sec", fn x -> x |> String.to_integer() end)
          |> Map.update!("calc_number_days", fn x -> x |> String.to_integer() end)
          |> Map.update!("earned_amount", fn x -> x |> String.to_float() end)
          |> Map.update!("paid_amount", fn x -> x |> String.to_float() end)
          |> Map.update!("quota_amount", fn x -> x |> String.to_float() end)

        Enum.into([ClientsQuota: proto_concept_quota_map], %{})
    end)
  end

  def request_data_merge(
        quota_plan_translated_fields,
        quota_fill_up,
        loan_code
      ) do
    Map.merge(quota_plan_translated_fields, quota_fill_up)
    |> Map.put(@config["Codprestamo"], loan_code)
  end

  def field_translator(quota_list, table_name) do
    Enum.into(quota_list, %{}, fn {k, v} ->
      {@config[table_name][k], v}
    end)
  end

  def convert_dates(dates_list) do
    dates_list
    |> Enum.map(fn {k, v} -> {k, Timex.parse(v, "%d/%m/%Y %H:%M:%S %Z", :strftime) |> elem(1)} end)
    |> Enum.into(%{})
  end

  def extract_date_fields(qmap) do
    qmap
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "_date"))
    |> Enum.into(%{}, fn x -> {x, qmap[x]} end)
    |> Enum.filter(fn {_x, v} ->
      Regex.match?(~r/^[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9]/, v |> to_string())
    end)
    |> Enum.map(fn {k, v} -> {k, v <> " 00:00:00 Z"} end)
    |> convert_dates()
  end

  def quota_map_fill_up() do
    @config["PlanCuotasFillupValues"]
  end

  def concept_quota_map_fill_up() do
    @config["CuotasConceptoFillupValues"]
  end

  # ***********************************************
  # unused functions
  # ***********************************************

  def fix_null_fields({key, value}) do
    if value |> to_string() |> String.length() == 0 do
      new_value = @config["NullFieldFillupValues"]["Quota"][key]
      {key, new_value}
    end
  end

  # ************************************************
end
