import React, {Component} from 'react';
import PropTypes from 'prop-types';
import classes from 'classnames';
import _ from 'lodash';
import styles from './folders-styles.scss';

class AddRenameFolderForm extends Component {

    state = {
        name: this.props.name || '',
    };

    onChange = (e) => {
        this.setState({
            name: e.target.value,
        });
    };

    onApply = () => {
        this.props.onApply && this.props.onApply(this.state.name);
    };

    onCancel = () => {
        this.props.onCancel && this.props.onCancel();
    };

    isValidName = () => {
        return !!this.state.name;
    };

    render() {
        return (
            <div className={classes("w-100 d-flex align-items-center", this.props.className)}>
                <input name="input_folder_name"
                    className="form-control form-control-narrow filler mr-2" type="text" value={this.state.name}
                       onChange={this.onChange}/>
                <button
                    name="apply"
                    className="btn btn-success btn-circle mr-1"
                    onClick={this.onApply}
                    disabled={!this.isValidName()}
                >
                    <i className="fa fa-chevron-circle-down"/>
                </button>
                <button
                    name="cancel"
                    className="btn btn-warning btn-circle"
                    onClick={this.onCancel}
                >
                    <i className="fa fa-times"/>
                </button>
            </div>
        )
    }
}

class AddRenameFolderLine extends Component {

    static propTypes = {
      createNew: PropTypes.func,
      rename: PropTypes.func,
      name: PropTypes.string,
    };

    state = {
        mode: 'none',
    };

    reset = () => {
        this.setState({mode: 'none'});
    };

    createNew = (name) => {
        if (this.props.createNew) {
            this.props.createNew(name).then(() => this.reset())
        } else {
            this.reset();
        }
    };

    rename = (name) => {
        if (this.props.rename) {
            this.props.rename(name).then(() => this.reset())
        } else {
            this.reset();
        }
    };

    render() {
        if (this.state.mode === 'none') {
            return (
                <div className="w-100 d-flex justify-content-end">
                    <button
                        name="rename"
                        className="btn btn-outline-secondary btn-circle mr-1"
                        onClick={() => this.setState({mode: 'rename'})}
                        disabled={!this.props.name}
                    >
                        <i className="fa fa-i-cursor"/>
                    </button>
                    <button
                        name="add"
                        className="btn btn-success btn-circle"
                        onClick={() => this.setState({mode: 'add'})}
                    >
                        <i className="fa fa-plus"/>
                    </button>
                </div>
            );
        } else if (this.state.mode === 'add') {
            const props = {
                onApply: this.createNew,
                onCancel: this.reset,
            };

            return (<AddRenameFolderForm  {...props} />)
        } else {
            const props = {
                onApply: this.rename,
                onCancel: this.reset,
                name: this.props.name,
            };

            return (<AddRenameFolderForm  {...props} />)
        }

    }
}

export default class FoldersIndex extends Component {

    static propTypes = {
        handleSelect: PropTypes.func,
        requestFolders: PropTypes.func.isRequired,
        rename: PropTypes.func,
        createNew: PropTypes.func,
        initFolderId: PropTypes.string,
    };

    state = {
        folders: [],
        mode: null,
        current_id: this.props.initFolderId,
    };

    static defaultProps = {
        handleSelect: (newFolder) => {}
    };

    handleSelect = _.memoize((folder) => () => {
        this.setState({current_id: folder.id});
        this.props.handleSelect(folder)
    }, (folder) => folder.id);

    createItems = () => {
        return this.state.folders.map((f) => {
            const classNames = classes(
                "item btn-outline-secondary col-auto",
                {[styles.selected]: f.id === this.state.current_id}
            );
            return (
                <button key={f.id} className={classNames} onClick={this.handleSelect(f)} name="folder">
                    <i className="fa fa-folder-o"/> {f.name}
                </button>
            )
        });
    };

    currentFolderName = () => {
        const currentFolder = _.find(this.state.folders, {id: this.state.current_id});
        return currentFolder ? currentFolder.name : null;
    };

    createNew = (name) => {
        if (this.props.createNew) {
            return this.props.createNew(name).then(this.updateList)
        } else {
            return Promise.resolve()
        }
    };

    rename = (name) => {
        if (this.props.rename) {
            return this.props.rename(this.state.current_id, name).then(this.updateList)
        } else {
            return Promise.resolve()
        }
    };

    render() {

        const items = this.createItems();

        return (
            <div className={classes("folders-index w-100")}>
                <div className="container-fluid">
                    <div className="row">
                        {items}
                    </div>
                    <div className="row mt-2">
                        <div className="col-xs-12 col-lg-6 no-h-padding border-bottom p-1">
                            <AddRenameFolderLine
                                name={this.currentFolderName()}
                                createNew={this.createNew}
                                rename={this.rename}
                            />
                        </div>
                    </div>
                </div>
            </div>
        )
    }

    updateList = () => {
        this.props.requestFolders().then((folders) => {
            let currentFolder = _.find(folders, {id: this.state.current_id});
            if (!currentFolder) {
                currentFolder = _.first(folders);
                currentFolder && this.props.handleSelect(currentFolder);
            }
            this.setState({
                folders: folders,
                current_id: currentFolder ? currentFolder.id : null,
            })
        });
    };

    componentDidUpdate = (prevProps, prevState) => {

    };

    componentDidMount = () => {
        this.updateList();
    }
}

export {
    AddRenameFolderForm,
    AddRenameFolderLine
}