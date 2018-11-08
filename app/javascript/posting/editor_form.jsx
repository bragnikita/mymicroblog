import React from 'react'
import './styles.scss'
import {Formik} from 'formik';
import {posting} from '../services/apis';
import BsForm from './editor_form_bootstrap';

const validators = [
    {name: 'title', validator: (val, values) => val ? undefined : 'Required field'},
    {name: 'slug', validator: (val, values) => val ? undefined : 'Required field'}
];


const validateAll = (values) => {
    const errors = {};
    validators.forEach((v) => {
        const res = v.validator(values[v.name], values);
        if (res) {
            errors[v.name] = res;
        }
    });
    return errors;
};

export default class Form extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            dataLoaded: false,
            initialValues: {
                title: '', slug: '', excerpt: '', post_type: '', contents: {
                    main: {
                        content: '',
                        content_format: 'markdown',
                    }
                }
            }
        }
    }

    isEdit() {
        return !!this.props.postId;
    };

    isNew() {
        return !this.isEdit();
    }

    componentDidMount() {
        if (this.isNew()) {
            return;
        }
        posting.get(this.props.postId, {roles: 'main'})
            .then((result) => {
                this.setState({
                    dataLoaded: true,
                    initialValues: {
                        ...result.object,
                    },
                });

            })
    };

    submit = (values, actions) => {
        const action = values.action;
        if (this.props.postId) {
            posting.update(this.props.postId, values)
                .then((result) => {
                    if (action === 'publish') {
                        window.location.href = window.location.origin + result.redirect_to
                    } else {
                        actions.setStatus('Saved');
                        actions.setSubmitting(false);
                    }
                });
        } else {
            posting.create(values)
                .then((result) => {
                    if (action === 'publish') {
                        window.location.href = window.location.origin + result.redirect_to
                    } else {
                        actions.setStatus('Saved')
                        actions.setSubmitting(false);
                    }
                });
        }
    };


    render() {
        if (this.isEdit() && !this.state.dataLoaded) {
            return null;
        }
        return (
            <Formik
                initialValues={this.state.initialValues}
                validate={validateAll}
                onSubmit={this.submit}
                enableReinitialize={!!this.props.postId}
                isEdit={this.isEdit()}
            >
                {(props) => {
                    // return (<StyledFormComponents isEdit={this.isEdit()} {...props}/>);
                    return (<BsForm isEdit={this.isEdit()} {...props}/>);
                }}
            </Formik>
        );
    }

}

