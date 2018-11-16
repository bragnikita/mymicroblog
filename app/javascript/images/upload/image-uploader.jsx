import React from 'react';
import Dropzone from 'react-dropzone';
import styles from './image-upload-styles.scss';
import classnames from 'classnames';
import {withHandlers} from 'recompose';
import update from 'immutability-helper';

class UploadZone extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            files: []
        }
    }

    handleDrop = (files) => {
        this.setState({
            files: files.map((f) => {
                return {
                    data: f,
                    name: f.name,
                    status: 0,
                    preview: URL.createObjectURL(f)
                };
            }),
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
                    })
                })
            });
        });

    };

    render() {
        return (
            <React.Fragment>
                <div className={classnames(styles.wrapper, this.props.className, 'w-100')}>
                    <Dropzone accept="image/*" onDrop={this.handleDrop} className={styles.dropzone}>
                        <div className={styles.innerWrapper}>
                            {this.state.files.map((file) => {
                                return (<div key={file.name}>{file.name} ({file.status})</div>)
                            })}
                            {this.state.files.length > 0 &&
                            <div className="w-100 text-center">
                                <button className="btn btn-success" onClick={this.handleUploadAll}>Upload</button>
                            </div>
                            }
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

export default withHandlers({
    // uploadSingle: (props) => (file) => {
    //     return new Promise((resolve) => {
    //         setTimeout(() => resolve(), 2000)
    //     });
    // }
})(UploadZone);