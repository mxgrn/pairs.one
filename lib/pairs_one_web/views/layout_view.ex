defmodule PairsOneWeb.LayoutView do
  use PairsOneWeb.Web, :view

  def lang_select_options do
    locales = %{
      "en" => "English",
      "ru" => "Русский",
      "uk" => "Українська",
      "pt" => "Português",
      "fr" => "Français"
    }

    Enum.map(PairsOneWeb.Gettext.supported_locales(), fn locale ->
      {locale, Map.get(locales, locale, String.upcase(locale))}
    end)
  end
end
