defmodule PairsOne.LayoutView do
  use PairsOne.Web, :view

  def lang_select_options do
    locales = %{
      "en" => "English",
      "ru" => "Русский",
      "uk" => "Українська",
      "pt" => "Português",
      "zh-hans" => "简体中文"
    }

    Enum.map(PairsOne.Gettext.supported_locales, fn(locale) ->
      {locale, Map.get(locales, locale, String.upcase(locale))}
    end)
  end
end
