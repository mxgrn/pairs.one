module I18n exposing (..)

import I18n.De
import I18n.En
import I18n.Es
import I18n.Fr
import I18n.Pt
import I18n.Ru
import I18n.Translation exposing (..)
import I18n.Uk


translate : String -> Translation -> String
translate language translation =
    case language of
        "en" ->
            I18n.En.translate translation

        "de" ->
            I18n.De.translate translation

        "es" ->
            I18n.Es.translate translation

        "ru" ->
            I18n.Ru.translate translation

        "uk" ->
            I18n.Uk.translate translation

        "pt" ->
            I18n.Pt.translate translation

        "fr" ->
            I18n.Fr.translate translation

        _ ->
            I18n.En.translate translation
