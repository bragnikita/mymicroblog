import React from 'react'
import ReactDOM from 'react-dom'
import $ from 'jquery'
import _ from 'lodash'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button';
import './styles.scss'
import Icon from "@material-ui/core/es/Icon/Icon";

const validators = [
    {name: 'title', validator: (val, values) => val ? undefined : 'Required field'},
    {name: 'slug', validator: (val, values) => val ? undefined : 'Required field'}
];


const validateAll = (values) => {
    const errors = {};
    validators.forEach((v) => {
        errors[v.name] = v.validator(values[v.name], values);
    });
    return errors;
};

class Editor extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            values: {
                title: '',
                slug: '',
                excerpt: '',
                content: ''
            },
            displayErrors: false,
        };
        this.state.errors = validateAll(this.state.values);
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


    setErrorState = (state, field, validator) => {
        state[field] = validator(this.state[field], this.state);
    };

    submit = (e) => {
        e.preventDefault();
        const isValid = this.isValid();

        if (!isValid && !this.state.displayErrors) {
            this.setState({
                displayErrors: true,
            });
        }

        if (!isValid) {
            return;
        }

        $.ajax({
            url: '/posts/create',
            method: 'post',
            data: this.state.values,
        }).then((result) => {
            window.location.href = window.location.origin + result.redirect_to
        })
    };

    render() {
        const valid = this.isValid();
        const values = this.state.values;
        const errors = this.state.displayErrors ? this.state.errors : {};
        return (

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
                            onChange={this.onTextInput}
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
                            onChange={this.onTextInput}
                            value={values['slug']}
                            error={!!errors['slug']}
                            helperText={errors['slug']}
                        />
                    </div>

                    <div className="c_row">
                        <TextField
                            name="excerpt"
                            label={"Excerpt"}
                            variant={"outlined"}
                            margin="normal"
                            fullWidth
                            onChange={this.onTextInput}
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
                            onChange={this.onTextInput}
                            value={values['content']}
                            multiline
                            placeholder={"Post body"}
                        />
                    </div>
                </form>
                <Button variant="contained" color="primary" onClick={this.submit} name="send"
                        disabled={!valid && this.state.displayErrors}>
                    Publish
                    <Icon className={"right_icon"}>publish</Icon>
                </Button>
            </div>

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