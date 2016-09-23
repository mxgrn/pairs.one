defmodule PairsOne.ViewHelpers do
  @moduledoc """
  Helpers available across all views. Imported in web/web.ex.
  """
  def locale do
    PairsOne.ControllerHelpers.locale
  end
end
