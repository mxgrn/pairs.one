defmodule PairsOneWeb.ControllerHelpers do
  @moduledoc """
  Helpers available across all controllers. Imported in web/web.ex.
  """
  def locale do
    Gettext.get_locale(PairsOneWeb.Gettext)
  end
end
