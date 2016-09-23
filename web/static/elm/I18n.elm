module I18n exposing (..)

import I18n.Translation exposing (..)
import I18n.En
import I18n.Ru
import I18n.Uk


translate : String -> Translation -> String
translate language translation =
    case language of
        "en" ->
            I18n.En.translate translation

        "ru" ->
            I18n.Ru.translate translation

        "uk" ->
            I18n.Uk.translate translation

        _ ->
            I18n.En.translate translation
