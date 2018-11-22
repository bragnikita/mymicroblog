import React from 'react';
import Dropzone from 'react-dropzone';
import styles from './image-upload-styles.scss';
import classnames from 'classnames';
import update from 'immutability-helper';

class UploadZone extends React.Component {

    static defaultProps = {
        onUploadedSingle: () => {
        },
        browserApi: {
            createPreview: (f) => URL.createObjectURL(f),
            clearPreview: (url) => URL.revokeObjectURL(url)
        }
    };

    state = {
        files: []
    };

    handleDrop = (files) => {
        const newFiles = files.map((f) => {
            return {
                data: f,
                name: f.name,
                status: 0,
                preview: URL.createObjectURL(f)
            }
        });
        this.setState({
            files: this.state.files.concat(newFiles),
        });
    };

    handleUploadAll = (e) => {
        e.preventDefault();
        if (!this.props.uploadSingle) return;

        const stateUpdate = {};
        this.state.files.forEach((f, i) => {
            if (f.status === 0) {
                stateUpdate[i] = {status: {$set: 1}}
            }
        });
        const updatedCollection = update(this.state.files, stateUpdate);
        this.setState({
            files: updatedCollection,
        }, () => {
            this.state.files.forEach((f, i) => {
                if (f.status !== 1) return;
                this.props.uploadSingle(f).then((result) => {
                    f.status = 2;
                    this.setState({
                        files: update(this.state.files, {[i]: {status: {$set: 2}}})
                    }, () => {
                        this.props.onUploadedSingle(f)
                    })
                })
            });
        });

    };

    render() {
        const files_to_display = this.state.files.filter((file) => file.status !== 2);
        return (
            <React.Fragment>
                <div className={classnames(styles.wrapper, this.props.className, 'w-100')}>
                    <Dropzone accept="image/*" onDrop={this.handleDrop}
                              className={classnames(styles.dropzone, "d-flex flex-column")}>
                        <div
                            className={classnames(styles.innerWrapper, "d-flex filler flex-column py-2 container-fluid")}>
                            <div className={classnames(styles.previewContainer, "filler mb-3 align-items-center row")}>
                                {files_to_display.map((file, i) => {
                                    return (
                                        <div key={file.name + '_' + i} className="col-6 col-sm-4 col-md-3">
                                            <div className="position-relative">
                                                {file.status === 1 && <div className="curtain"><i
                                                    className="fa fa-circle-o-notch fa-spin fa-3x fa-fw"/></div>}
                                                <img alt="preview" src={file.preview} className="preview img-thumbnail">
                                                </img>
                                            </div>
                                        </div>)
                                })}
                            </div>
                            <div className="w-100 text-center bottom-button">
                                <button className="btn btn-success" onClick={this.handleUploadAll}
                                        disabled={files_to_display.length === 0}>Upload
                                </button>
                            </div>
                        </div>
                    </Dropzone>
                </div>
            </React.Fragment>
        );
    }

    componentWillUnmount() {
        const {files} = this.state;
        for (let i = files.length; i >= 0; i--) {
            const file = files[i];
            URL.revokeObjectURL(file.preview);
        }
    }
}

export default UploadZone;