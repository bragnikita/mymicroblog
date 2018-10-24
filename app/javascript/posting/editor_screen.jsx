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
        this.state = {
            dataLoaded: false,
            initialValues : {
                title: '', slug: '', content: '', excerpt: '',
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
        $.ajax({
            url: `/post/${this.props.postId}`,
            method: 'get',
        }).then((result) => {
            this.setState({
                dataLoaded: true,
                initialValues: {
                    ...result.object,
                },
            });

        })
    };

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
        if (this.props.postId) {
            $.ajax({
                url: `/post/${this.props.postId}/update`,
                method: 'post',
                data: values,
            }).then((result) => {
                actions.setSubmitting(false);
                window.location.href = window.location.origin + result.redirect_to
            })
        } else {
            $.ajax({
                url: '/posts/create',
                method: 'post',
                data: values,
            }).then((result) => {
                actions.setSubmitting(false);
                window.location.href = window.location.origin + result.redirect_to
            })
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
            >{({values, errors, isSubmitting, submitCount, touched, isValid, handleChange, handleSubmit, handleBlur}) => (
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
                                onBlur={handleBlur}
                                value={values['title']}
                                error={touched['title'] && !!errors['title']}
                                helperText={touched['title'] ? errors['title'] : ''}
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
                                onBlur={handleBlur}
                                value={values['slug']}
                                error={touched['slug'] && !!errors['slug']}
                                helperText={touched['slug'] ? errors['slug'] : ''}
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

        const editorElement = document.getElementById('post-editor');
        if (editorElement) {
            let editor;
            const page_pathname = window.location.pathname;
            const m = page_pathname.match(/^\/post\/(.+)\/edit$/i);
            if (m) {
                const id = m[1];
                editor = <Editor postId={id}/>
            } else {
                editor = <Editor/>
            }
            ReactDOM.render(editor, editorElement);
        }
    })
;