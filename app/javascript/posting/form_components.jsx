import React from 'react';
import classNames from 'classnames';
import './form_components.scss';
import Select from "react-select";

const ERROR_CLASSES = {
    input_text: 'border-danger',
    input_select: '',
};

export const FormComponentWrapper = ({children, label = ''}) => {
    return (
        <div className={`x-form-component`}>
            <span className="x-form-component__label small">{label}</span>
            {children}
        </div>
    )
};

export const FormComponent = ({ field, form, input, className, ...rest}) => {
    const error = form.errors[field.name];
    const touched = form.touched[field.name];
    const showError = error && touched;

    const newClassName = classNames(className, {[ERROR_CLASSES.input_text] : showError});

    const showLabel = !!field.value;
    const label = rest.label || rest.placeholder;

    let Component = React.createElement(input, {...field, ...rest, className: newClassName}, null)
    return (
        <div className={classNames(`x-form-component`, { 'error': showError })}>
            <span className="x-form-component__label small">{showLabel ? label : null}</span>
            {Component}
            {showError ?
                <span className="x-form-component__error text-danger small">{error}</span>
            : null}
        </div>
    );
};

export const FormSelector = ({ field, form, input, className, ...rest}) => {
    const error = form.errors[field.name];
    const touched = form.touched[field.name];
    const showError = error && touched;

    const newClassName = classNames(className, {[ERROR_CLASSES.input_select] : showError});

    const showLabel = true;
    const label = rest.label || rest.placeholder;

    return (
        <div className={classNames(`x-form-component`, { 'error': showError })}>
            <span className="x-form-component__label">{showLabel ? label : null}</span>
            <Select
                {...rest}
                onChange={(option) => {
                    form.setFieldValue(field.name, option)
                }}
                className={newClassName}
            />
            {showError ?
                <span className="x-form-component__error text-danger">{error}</span>
                : null}
        </div>
    );
};