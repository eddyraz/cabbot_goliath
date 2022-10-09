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
    credits_params
    |> hd
    |> parse_params()
    |> IO.inspect()
    |> Enum.map(fn quota_map ->
#      with [:ClientsQuota] <- quota_map |> Map.keys(),
#           {:ok, %ClientsQuota{} = clients_quota} <-
#             Creditos.create_clients_quota(
#               quota_map
#               |> Map.values()
#               |> hd
#             ) do

      with [:ClientsQuota] <- quota_map |> Map.keys() do
             Creditos.create_clients_quota(
               quota_map
               |> Map.values()
               |> hd
             ) 
#      conn
#        |> put_status(:created)
#        |> put_resp_header("location", Routes.quota_path(conn, :show, clients_quota))
#               |> put_view(CabbotWeb.ClientsQuotaView)
#               |> render("show.json", clients_quota: clients_quota)
	       
	   end
	     

      with [:Quota] <- quota_map |> Map.keys(),
           {:ok, %Quota{} = quota} <-
             Creditos.create_quota(
               quota_map
               |> Map.values()
               |> hd
             ) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.quota_path(conn, :show, quota))
        |> put_view(CabbotWeb.QuotaView)
        |> render("show.json", quota: quota)
        # |> Phoenix.View.render_many("index_quota.json", Quota: quota)

      end
    end)
  end

  #  def show(conn, %{"id" => id}) do
  #    quota = Creditos.get_quota!(id)
  #    render(conn, "show.json", quota: quota)
  #  end

  #  def update(conn, %{"id" => id, "quota" => quota_params}) do
  #    quota = Creditos.get_quota!(id)
  #    with {:ok, %Quota{} = quota} <- Creditos.update_quota(quota, quota_params) do
  #     render(conn, "show.json", quota: quota)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   quota = Creditos.get_quota!(id)
  #   with {:ok, %Quota{}} <- Creditos.delete_quota(quota) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end

  # ++++++++funcion Alternativa a parse_incomming_data++++
  def parse_params(data) do
    loan_code_field = data["Codprestamo"]
    quota_concept_list = data["CuotasConcepto"]
    quota_plan_list = data["PlanCuotas"]
    process_quota_map(quota_plan_list, loan_code_field) ++ process_concept_quota_map(quota_concept_list, loan_code_field)
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
        |> Map.update!("quota_delayed_days", fn _x -> _x |> String.to_integer() end)
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
	  

        Enum.into([ClientsQuota: proto_concept_quota_map], %{})
    end)
  end

  # **********************************************************
  # fixed functions
  # **********************************************************

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
    |> IO.inspect()
    |> Enum.map(fn {k, v} -> {k, Timex.parse(v, "%d/%m/%Y %H:%M:%S %Z", :strftime) |> elem(1)} end)
    |> IO.inspect()
    |> Enum.into(%{})
  end

  def extract_date_fields(qmap) do
    qmap
    |> IO.inspect()
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "_date"))
    |> Enum.into(%{}, fn x -> {x, qmap[x]} end)
    |> Enum.filter(fn {_x, v} ->
      Regex.match?(~r/^[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9]/, v |> to_string())
    end)
    |> convert_dates()
  end

  def quota_map_fill_up() do
    @config["PlanCuotasFillupValues"]
  end

  def concept_quota_map_fill_up() do
    @config["CuotasConceptoFillupValues"]
  end

  # ************************************************************

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
