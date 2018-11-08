import React from 'react';
import TextArea from 'react-textarea-autosize';
import Select from 'react-select';

import {FormComponent, FormComponentWrapper, FormSelector} from './form_components'
import {FastField, Field} from "formik";
import Editor from './source_editor';

export default class Form extends React.Component {


    render() {
        const { handleSubmit, setFieldValue, status, isEdit } = this.props;
        return (
            <form className="form container">
                <div className="form-group row">
                    <div className="col">
                        <FastField name="title" render={(props) => (
                            <FormComponent
                                {...props}
                                input="input"
                                type="text"
                                className="form-control"
                                placeholder="Title"
                            />
                        )}/>
                        {/*<input className="form-control" name="title" placeholder="Title"/>*/}
                    </div>
                </div>
                <div className="form-group row">
                    <div className="col">
                        <FastField name="excerpt" render={(props) => (
                            <FormComponent
                                {...props}
                                input={TextArea}
                                className="form-control"
                                name="excerpt"
                                minRows={3}
                                placeholder="Excerpt"
                            />
                        )}/>
                    </div>
                </div>
                <div className="row">
                    <div className="col-xs-12 col-sm form-group">
                        <FastField name="slug" render={(props) => (
                            <FormComponent {...props} input="input" type="text" placeholder="Slug" className="form-control" />
                        )}/>
                    </div>
                    <div className="col-xs-6 col-sm-auto form-group" style={{width: 170}}>
                        <FastField name="contents.main.content_format" render={(props) => (
                            <FormSelector
                                {...props}
                                options={[
                                    {value: 'html', label: 'HTML'},
                                    {value: 'markdown', label: 'Markdown'},
                                    {value: 'plain', label: 'Plain text'},
                                ]}
                            />
                        )}/>
                    </div>
                </div>
                <div className="row form-group">
                    <div className="col">
                        <FastField name="contents.main.content" render={(props) => (
                            <FormComponentWrapper>
                                <Editor {...props} />
                            </FormComponentWrapper>
                        )}/>
                    </div>
                </div>
                <div className="row d-flex justify-content-start">
                    <div className="col-auto">
                        <button type="submit" title="publish"
                            className="btn btn-lg btn-success"
                            onClick={(e) => { setFieldValue('action', 'publish', false); handleSubmit(e)} }
                        >{isEdit ? 'Update' : 'Publish'}</button>
                        <button type="submit" title="save"
                                className="btn btn-lg btn-secondary ml-2"
                                onClick={(e) => { setFieldValue('action', 'save', false); handleSubmit(e)} }
                        >{'Save'}</button>
                    </div>
                    <div className="col d-flex align-items-center">
                        <span className="text-secondary">{ status || '' }</span>
                    </div>
                </div>
            </form>
        );
    }

}