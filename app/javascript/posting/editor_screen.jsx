import React from 'react'
import ReactDOM from 'react-dom'
import $ from 'jquery'
import _ from 'lodash'
import TextField from '@material-ui/core/TextField'
import InputAdornment from '@material-ui/core/InputAdornment'
import Button from '@material-ui/core/Button';
import './styles.scss'
import Icon from "@material-ui/core/es/Icon/Icon";
import {Formik} from 'formik';

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

class Editor extends React.Component {
    constructor(props) {
        super(props);
    }

    onTextInput = (e) => {
        const fieldName = e.target.name;
        const value = e.target.value;

        let error = undefined;
        const validator = _.find(validators, {name: fieldName});
        if (validator) {
            error = validator.validator(value, this.state.values);
        }

        this.setState({
            values: {
                ...this.state.values,
                [fieldName]: value
            },
            errors: {
                ...this.state.errors,
                [fieldName]: error,
            }
        })
    };

    isValid = () => {
        return _.every(Object.values(this.state.errors), (v) => v === undefined);
    };

    submit = (values, actions) => {
        $.ajax({
            url: '/posts/create',
            method: 'post',
            data: values,
        }).then((result) => {
            actions.setSubmitting(false);
            window.location.href = window.location.origin + result.redirect_to
        })
    };

    render() {

        const initialValues = {
            title: '', slug: '', content: '', excerpt: '',
        };
        return (
            <Formik
                initialValues={initialValues}
                validate={validateAll}
                onSubmit={this.submit}
            >{({values, errors, isSubmitting, submitCount, touched, isValid, handleChange, handleSubmit}) => (
                <div data-name="editor-component">
                    <form>
                        <div className="c_row">
                            <TextField
                                name="title"
                                label={"Title"}
                                variant={"outlined"}
                                margin="normal"
                                fullWidth
                                placeholder={"Title"}
                                onChange={handleChange}
                                value={values['title']}
                                error={!!errors['title']}
                                helperText={errors['title']}
                            />
                        </div>

                        <div className="c_row">
                            <TextField
                                name="slug"
                                label={"Slug"}
                                variant={"outlined"}
                                margin="normal"
                                fullWidth
                                onChange={handleChange}
                                value={values['slug']}
                                error={!!errors['slug']}
                                helperText={errors['slug']}
                                InputProps={{
                                    startAdornment: <InputAdornment position="start">/</InputAdornment>,
                                }}
                            />
                        </div>

                        <div className="c_row">
                            <TextField
                                name="excerpt"
                                label={"Excerpt"}
                                variant={"outlined"}
                                margin="normal"
                                fullWidth
                                onChange={handleChange}
                                value={values['excerpt']}
                                multiline
                                placeholder={"Short description"}
                                rows={3}
                                rowsMax={6}
                            />
                        </div>

                        <div className="c_row">
                            <TextField
                                name="content"
                                label={"Post text"}
                                variant={"outlined"}
                                margin="normal"
                                fullWidth
                                onChange={handleChange}
                                value={values['content']}
                                multiline
                                placeholder={"Post body"}
                            />
                        </div>
                    </form>
                    <Button type="submit" id="send" variant="contained" color="primary" onClick={handleSubmit}
                             name="send"
                             disabled={!isValid || isSubmitting}>
                        Publish
                        <Icon className={"right_icon"}>publish</Icon>
                    </Button>
                </div>
            )}
            </Formik>


        )
    }
}

$(
    () => {

        const
            token = $('meta[name="csrf-token"]').attr('content');

        $
            .ajaxSetup({
                beforeSend: function

                    (xhr) {
                    xhr
                        .setRequestHeader(
                            'X-CSRF-Token'
                            ,
                            token
                        )
                    ;
                }
            })
        ;

        const editor = document.getElementById('post-editor');
        if (editor) {
            ReactDOM.render(<Editor/>, editor);
        }
    })
;