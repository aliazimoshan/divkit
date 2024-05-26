import { applyTemplate } from '../../src/utils/applyTemplate';

describe('optional_string_enum_property', () => {
    test('test_optional_string_enum_property_not_templated', () => {
        const json = require('../../../../../test_data/template_test_data/optional_string_enum_property/test_optional_string_enum_property_not_templated.json');
        const logError = jest.fn();

        expect(applyTemplate(json.entity, {}, json.templates, logError)).toMatchSnapshot();
        expect(logError.mock.calls).toMatchSnapshot();
    });

    test('test_optional_string_enum_property_with_link', () => {
        const json = require('../../../../../test_data/template_test_data/optional_string_enum_property/test_optional_string_enum_property_with_link.json');
        const logError = jest.fn();

        expect(applyTemplate(json.entity, {}, json.templates, logError)).toMatchSnapshot();
        expect(logError).not.toBeCalled();
    });

    test('test_optional_string_enum_property_with_link_missing_data', () => {
        const json = require('../../../../../test_data/template_test_data/optional_string_enum_property/test_optional_string_enum_property_with_link_missing_data.json');
        const logError = jest.fn();

        expect(applyTemplate(json.entity, {}, json.templates, logError)).toMatchSnapshot();
        expect(logError.mock.calls).toMatchSnapshot();
    });

    test('test_optional_string_enum_property_with_override', () => {
        const json = require('../../../../../test_data/template_test_data/optional_string_enum_property/test_optional_string_enum_property_with_override.json');
        const logError = jest.fn();

        expect(applyTemplate(json.entity, {}, json.templates, logError)).toMatchSnapshot();
        expect(logError.mock.calls).toMatchSnapshot();
    });

    test('test_optional_string_enum_property_without_link', () => {
        const json = require('../../../../../test_data/template_test_data/optional_string_enum_property/test_optional_string_enum_property_without_link.json');
        const logError = jest.fn();

        expect(applyTemplate(json.entity, {}, json.templates, logError)).toMatchSnapshot();
        expect(logError).not.toBeCalled();
    });

    test('test_optional_string_enum_property_without_link_missing_data', () => {
        const json = require('../../../../../test_data/template_test_data/optional_string_enum_property/test_optional_string_enum_property_without_link_missing_data.json');
        const logError = jest.fn();

        expect(applyTemplate(json.entity, {}, json.templates, logError)).toMatchSnapshot();
        expect(logError).not.toBeCalled();
    });
});
