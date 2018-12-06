import React from 'react';
import {Field, Formik} from 'formik';
import {mountComponent} from '../util/react_utils';
import {FormComponent} from "../posting/form_components";
import {users as api} from '../services/apis';
import {redirectTo} from '../util/browser_utils';

const FormIndex = ({handleSubmit, isValid, status}) => {


    return (
        <div className="signin-form">
            <form onSubmit={handleSubmit}>
                <div className="form-group">
                    <Field name="login" render={(props) => (
                        <FormComponent {...props} input="input" type="text" className="form-control"
                                       placeholder="e-mail"/>
                    )}/>
                </div>
                <div className="form-group">
                    <Field name="password" render={(props) => (
                        <FormComponent {...props} input="input" type="password" className="form-control"
                                       placeholder="password"/>
                    )}/>
                </div>
                {status &&
                <div className="form-group">
                    <div className="x-error-status d-block small">{status}</div>
                </div>
                }
                <div className="form-group">
                    <input type="submit" className="btn btn-primary" disabled={!isValid} value="Sign in"/>
                </div>
            </form>
        </div>
    )
};

const Form = () => {
    return (
        <Formik
            initialValues={{login: '', password: ''}}
            validate={values => {
                let errors = {};
                if (!values.login) {
                    errors.login = 'required'
                }
                if (!values.password) {
                    errors.password = 'required'
                }
                return errors;
            }}
            onSubmit={(values, {setSubmitting, setStatus}) => {
                api.signIn(values.login, values.password).then(({body}) => {
                    const redirect_to = body && body.redirect_to;
                    if (redirect_to) {
                        redirectTo(redirect_to);
                    } else {
                        redirectTo('/');
                    }
                    setStatus();
                    setSubmitting(false);
                }).catch(() => {
                    setStatus('e-mail and password pair is wrong');
                    setSubmitting(false);
                });
            }}
        >
            {(props) => {
                return <FormIndex {...props}/>
            }}
        </Formik>
    )
};

mountComponent('#mount-sign-in-form', <Form/>);
