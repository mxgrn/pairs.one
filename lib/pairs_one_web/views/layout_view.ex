defmodule PairsOneWeb.LayoutView do
  use PairsOneWeb.Web, :view

  def lang_select_options do
    locales = %{
      "en" => "English",
      "de" => "Deutsch",
      "pl" => "Polski",
      "es" => "Castellano",
      "pt" => "Português",
      "fr" => "Français",
      "ru" => "Русский",
      "uk" => "Українська"
    }

    Enum.map(PairsOneWeb.Gettext.supported_locales(), fn locale ->
      {locale, Map.get(locales, locale, String.upcase(locale))}
    end)
  end
end
