import React from 'react'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button';
import './styles.scss'
import Icon from "@material-ui/core/Icon";
import Grid from "@material-ui/core/Grid";
import {withStyles} from '@material-ui/core/styles';
import {Field, Formik} from 'formik';
import {posting} from '../services/apis';
import SourceEditor from './source_editor';
import Select from "@material-ui/core/Select";
import MenuItem from "@material-ui/core/MenuItem";
import FormControl from "@material-ui/core/FormControl";
import OutlinedInput from "@material-ui/core/OutlinedInput";
import InputLabel from "@material-ui/core/InputLabel/InputLabel";
import classNames from 'classnames';

const validators = [
    {name: 'title', validator: (val, values) => val ? undefined : 'Required field'},
    {name: 'slug', validator: (val, values) => val ? undefined : 'Required field'}
];

const styles = (theme) => {
    return {
        gridCell: {
            marginTop: theme.spacing.unit * 2,
            marginBottom: theme.spacing.unit,
        },
        gridCellRight: {
            marginTop: theme.spacing.unit * 2,
            marginBottom: theme.spacing.unit,
            marginLeft: theme.spacing.unit,
        },
        button: {
            margin: theme.spacing.unit,
        },
        formControl: {
            margin: theme.spacing.unit,
            minWidth: 120,
        },
        smallSizeCell: {
            flexGrow: 0,
        },
        outlined_input: {
            minWidth: 150,
            textAlign: 'left',
        },
        cell: {
            // marginLeft: theme.spacing.unit,
            textAlign: 'right',
        },
    }
};


class FormComponents extends React.Component {

    save = (e) => {
        this.props.setValues({post_state: 'draft', ...this.props.values});
        this.props.handleSubmit(e);
    };

    submit = (e) => {
        this.props.setValues({post_state: 'publish', ...this.props.values});
        this.props.handleSubmit(e);
    };

    render() {
        const {values, errors, isEdit, isSubmitting, touched, isValid, handleChange, handleBlur, classes, status} = this.props;
        return (
            <div data-name="editor-component">
                <form>
                    <Grid container>
                        <Grid item xs={12}>
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
                        </Grid>
                        <Grid item xs={12}>
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
                        </Grid>
                    </Grid>
                    <Grid container spacing={8} >
                        <Grid item xs={12} sm >
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
                                // InputProps={{
                                //     startAdornment: <InputAdornment position="start">/</InputAdornment>,
                                // }}
                            />
                        </Grid>
                        <Grid item xs={12} sm classes={{item: classes.smallSizeCell}}>
                            <FormControl className={classNames(classes.cell, classes.gridCell)} variant="outlined">
                                <InputLabel
                                    htmlFor="form-source-filter"
                                >
                                    Source filter
                                </InputLabel>
                                <Select value={values['source_filter']} onChange={handleChange}
                                        input={
                                            <OutlinedInput
                                                className={classes.outlined_input}
                                                labelWidth={100}
                                                name={'source_filter'}
                                                id="form-source-filter"
                                            />
                                        }
                                >
                                    <MenuItem value="markdown">Markdown</MenuItem>
                                    <MenuItem value="html">4234 </MenuItem>
                                    <MenuItem value="plain_text">Plain text</MenuItem>
                                </Select>
                            </FormControl>
                        </Grid>
                    </Grid>
                    <Field name="content" component={SourceEditor}/>
                </form>
                <div style={{width: "100%"}}>
                    <Button type="submit" id="send" variant="contained" color="primary" onClick={this.submit}
                            name="send"
                            disabled={!isValid || isSubmitting}>
                        Publish
                        <Icon className={"right_icon"}>publish</Icon>
                    </Button>
                    {isEdit ? null :
                        <Button id="send" variant="outlined" color="secondary" onClick={this.save}
                                name="save" className={classes.button}>
                            Save
                            <Icon className={"right_icon"}>save</Icon>
                        </Button>
                    }
                    <div className={`${classes.gridCell}`}>

                    </div>
                </div>
            </div>
        )
    }
}

const StyledFormComponents = withStyles(styles)(FormComponents);

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
                title: '', slug: '', content: '', excerpt: '', source_filter: 'markdown'
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
        posting.get(this.props.postId)
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
        if (this.props.postId) {
            posting.update(this.props.postId, values)
                .then((result) => {
                    actions.setSubmitting(false);
                    window.location.href = window.location.origin + result.redirect_to
                });
        } else {
            const action = values.post_state;
            posting.create(values)
                .then((result) => {
                    if (action == 'publish') {
                        window.location.href = window.location.origin + result.redirect_to
                    }
                    actions.setSubmitting(false);
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
                    return (<StyledFormComponents isEdit={this.isEdit()} {...props}/>);
                }}
            </Formik>
        );
    }

}

