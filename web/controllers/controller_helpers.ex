defmodule PairsOne.ControllerHelpers do
  @moduledoc """
  Helpers available across all controllers. Imported in web/web.ex.
  """
  def locale do
    Gettext.get_locale(PairsOne.Gettext)
  end
end
