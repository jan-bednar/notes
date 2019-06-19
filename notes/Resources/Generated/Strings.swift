// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Creating note has failed
  internal static let detailCreateNoteError = L10n.tr("Localizable", "detail_create_note_error")
  /// Deleting note has failed
  internal static let detailRemoveNoteError = L10n.tr("Localizable", "detail_remove_note_error")
  /// Updating note has failed
  internal static let detailUpdateNoteError = L10n.tr("Localizable", "detail_update_note_error")
  /// Oops, tha's not good!
  internal static let generalAlertTitle = L10n.tr("Localizable", "general_alert_title")
  /// OK
  internal static let generalOk = L10n.tr("Localizable", "general_ok")
  /// Deleting note has failed
  internal static let listDeleteNoteError = L10n.tr("Localizable", "list_delete_note_error")
  /// Could not download notes
  internal static let listGetNotesError = L10n.tr("Localizable", "list_get_notes_error")
  /// List
  internal static let listTitle = L10n.tr("Localizable", "list_title")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    if format != key {
        return String(format: format, locale: Locale.current, arguments: args)
    }
    guard
        let path = Bundle.main.path(forResource: "Base", ofType: "lproj"),
        let bundle = Bundle(path: path)
        else { return String(format: format, locale: Locale.current, arguments: args) }
    let fallbackFormat = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
    return String(format: fallbackFormat, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
