// Generated code. Do not modify.

import Foundation
import Serialization
import VGSL

public final class UrlVariableTemplate: TemplateValue, Sendable {
  public static let type: String = "url"
  public let parent: String?
  public let name: Field<String>?
  public let value: Field<URL>?

  public convenience init(dictionary: [String: Any], templateToType: [TemplateName: String]) throws {
    self.init(
      parent: dictionary["type"] as? String,
      name: dictionary.getOptionalField("name"),
      value: dictionary.getOptionalField("value", transform: URL.init(string:))
    )
  }

  init(
    parent: String?,
    name: Field<String>? = nil,
    value: Field<URL>? = nil
  ) {
    self.parent = parent
    self.name = name
    self.value = value
  }

  private static func resolveOnlyLinks(context: TemplatesContext, parent: UrlVariableTemplate?) -> DeserializationResult<UrlVariable> {
    let nameValue = { parent?.name?.resolveValue(context: context) ?? .noValue }()
    let valueValue = { parent?.value?.resolveValue(context: context, transform: URL.init(string:)) ?? .noValue }()
    var errors = mergeErrors(
      nameValue.errorsOrWarnings?.map { .nestedObjectError(field: "name", error: $0) },
      valueValue.errorsOrWarnings?.map { .nestedObjectError(field: "value", error: $0) }
    )
    if case .noValue = nameValue {
      errors.append(.requiredFieldIsMissing(field: "name"))
    }
    if case .noValue = valueValue {
      errors.append(.requiredFieldIsMissing(field: "value"))
    }
    guard
      let nameNonNil = nameValue.value,
      let valueNonNil = valueValue.value
    else {
      return .failure(NonEmptyArray(errors)!)
    }
    let result = UrlVariable(
      name: { nameNonNil }(),
      value: { valueNonNil }()
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  public static func resolveValue(context: TemplatesContext, parent: UrlVariableTemplate?, useOnlyLinks: Bool) -> DeserializationResult<UrlVariable> {
    if useOnlyLinks {
      return resolveOnlyLinks(context: context, parent: parent)
    }
    var nameValue: DeserializationResult<String> = { parent?.name?.value() ?? .noValue }()
    var valueValue: DeserializationResult<URL> = { parent?.value?.value() ?? .noValue }()
    _ = {
      // Each field is parsed in its own lambda to keep the stack size managable
      // Otherwise the compiler will allocate stack for each intermediate variable
      // upfront even when we don't actually visit a relevant branch
      for (key, __dictValue) in context.templateData {
        _ = {
          if key == "name" {
           nameValue = deserialize(__dictValue).merged(with: nameValue)
          }
        }()
        _ = {
          if key == "value" {
           valueValue = deserialize(__dictValue, transform: URL.init(string:)).merged(with: valueValue)
          }
        }()
        _ = {
         if key == parent?.name?.link {
           nameValue = nameValue.merged(with: { deserialize(__dictValue) })
          }
        }()
        _ = {
         if key == parent?.value?.link {
           valueValue = valueValue.merged(with: { deserialize(__dictValue, transform: URL.init(string:)) })
          }
        }()
      }
    }()
    var errors = mergeErrors(
      nameValue.errorsOrWarnings?.map { .nestedObjectError(field: "name", error: $0) },
      valueValue.errorsOrWarnings?.map { .nestedObjectError(field: "value", error: $0) }
    )
    if case .noValue = nameValue {
      errors.append(.requiredFieldIsMissing(field: "name"))
    }
    if case .noValue = valueValue {
      errors.append(.requiredFieldIsMissing(field: "value"))
    }
    guard
      let nameNonNil = nameValue.value,
      let valueNonNil = valueValue.value
    else {
      return .failure(NonEmptyArray(errors)!)
    }
    let result = UrlVariable(
      name: { nameNonNil }(),
      value: { valueNonNil }()
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  private func mergedWithParent(templates: [TemplateName: Any]) throws -> UrlVariableTemplate {
    guard let parent = parent, parent != Self.type else { return self }
    guard let parentTemplate = templates[parent] as? UrlVariableTemplate else {
      throw DeserializationError.unknownType(type: parent)
    }
    let mergedParent = try parentTemplate.mergedWithParent(templates: templates)

    return UrlVariableTemplate(
      parent: nil,
      name: name ?? mergedParent.name,
      value: value ?? mergedParent.value
    )
  }

  public func resolveParent(templates: [TemplateName: Any]) throws -> UrlVariableTemplate {
    return try mergedWithParent(templates: templates)
  }
}
