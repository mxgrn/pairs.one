defmodule PairsOneWeb.Plug.Locale do
  @moduledoc """
  Setting and verifying locales in the URL. Mostly taken from http://code.parent.co/practical-i18n-with-phoenix-and-elixir/.
  """

  import Plug.Conn

  def init(default), do: default

  def call(conn, default) do
    locale = conn.params["locale"]
    is_ietf_tag = BCP47.valid?(locale, ietf_only: true)

    if is_ietf_tag && locale in PairsOneWeb.Gettext.supported_locales() do
      # Check if path contains a valid Locale
      conn |> assign_locale!(locale)
    else
      # Get locale based on user agent and redirect
      locale = List.first(extract_locale(conn)) || default
      # Invalid or missing locales redirect with user agent locale
      path =
        if is_ietf_tag do
          localized_path(conn.request_path, locale, conn.params["locale"])
        else
          localized_path(conn.request_path, locale)
        end

      conn |> redirect_to(path)
    end
  end

  defp assign_locale!(conn, value) do
    # Apply the locale as a process var and continue
    Gettext.put_locale(PairsOneWeb.Gettext, value)

    conn
    |> assign(:locale, value)
  end

  defp extract_locale(conn) do
    locales =
      if Blank.present?(conn.params["locale"]) do
        [conn.params["locale"] | extract_accept_language(conn)]
      else
        extract_accept_language(conn)
      end

    # Filter for only known locales
    locales
    |> Enum.filter(fn locale -> Enum.member?(PairsOneWeb.Gettext.supported_locales(), locale) end)
  end

  defp extract_accept_language(conn) do
    case conn |> get_req_header("accept-language") do
      [value | _] ->
        value
        |> String.split(",")
        |> Enum.map(&parse_language_option/1)
        |> Enum.sort(&(&1.quality > &2.quality))
        |> Enum.map(& &1.tag)

      _ ->
        []
    end
  end

  defp parse_language_option(string) do
    captures =
      ~r/^(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i
      |> Regex.named_captures(string)

    quality =
      case Float.parse(captures["quality"] || "1.0") do
        {val, _} -> val
        _ -> 1.0
      end

    %{tag: captures["tag"], quality: quality}
  end

  defp localized_path(request_path, locale, original) do
    # If locale is an ietf tag, we don't support it. In this case,
    # replace the tag with the new locale.
    ~r/(\/)#{original}(\/(?:.+)?|\?(?:.+)?|$)/
    |> Regex.replace(request_path, "\\1#{locale}\\2")
  end

  defp localized_path(request_path, locale) do
    # If locale is not an ietf tag, it is a page request.
    "/#{locale}#{request_path}"
  end

  defp redirect_to(conn, path) do
    # Apply query if present
    path =
      if Blank.blank?(conn.query_string) do
        path
      else
        path <> "?#{conn.query_string}"
      end

    # Redirect
    conn |> Phoenix.Controller.redirect(to: path) |> halt
  end
end
