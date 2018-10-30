import React from 'react';
// import {} from 'formik';
import TextField from "@material-ui/core/es/TextField/TextField";

export class Component extends React.Component {

    handleChange = (e) => {
        this.props.field.onChange(e);
    };

    render() {
        const { field, form, ...rest } = this.props;
        const {name, value, onBlur} = field;
        return (
            <TextField
                label={"Post text"}
                variant={"outlined"}
                margin="normal"
                fullWidth
                multiline
                placeholder={"Post body"}
                {...rest }
                name={name}
                value={value}
                onBlur={onBlur}
                onChange={this.handleChange}
            />
        )
    }
}

export default Component;