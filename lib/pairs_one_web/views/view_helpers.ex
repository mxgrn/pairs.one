defmodule PairsOneWeb.ViewHelpers do
  @moduledoc """
  Helpers available across all views. Imported in web/web.ex.
  """
  def locale do
    PairsOneWeb.ControllerHelpers.locale()
  end
end
