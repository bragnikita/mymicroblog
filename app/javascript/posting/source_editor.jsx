import React from 'react';
// import {} from 'formik';
import _ from 'lodash';
import TextArea from 'react-textarea-autosize';


export default class Editor extends React.Component {

    constructor(props) {
        super(props);
        this.inputRef = null;
    };

    render() {
        const {field, form, ...rest} = this.props;
        return (
            <TextArea
                {...field}
                minRows={10}
                className="form-control"
                name="content"
                placeholder="Text"
                ref={(ref) => this.inputRef = ref}/>
        )
    }
}