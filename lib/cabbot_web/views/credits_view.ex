defmodule CabbotWeb.CreditsView do
  use CabbotWeb, :view
  alias CabbotWeb.CreditsView

  def render("render_many.json",data ) do
    
    results = data[:credits]
    |> Enum.split_with(fn x -> x.__struct__  ==  Cabbot.Cabbot.Creditos.Quota end )

    for n <- 0..1 do
      case n do
	0 -> 
          Map.new([{:QuotasPlan, results |> elem(n)}])
	  |> IO.inspect()
         _ ->
          Map.new([{:QuotasConcept, results |> elem(n)}])
	  |> IO.inspect
      end
     end 

  end
end
