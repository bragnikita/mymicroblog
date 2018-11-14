import React, {Component} from 'react';
import classes from 'classnames';
import _ from 'lodash';
import styles from './folders-styles.scss';

class AddRenameFolderForm extends Component {

    constructor(props) {
        super(props);
        this.state = {
            name: props.name || '',
        };
    }

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
                <input className="form-control form-control-narrow filler mr-2" type="text" value={this.state.name}
                       onChange={this.onChange}/>
                <button
                    className="btn btn-success btn-circle mr-1"
                    onClick={this.onApply}
                    disabled={!this.isValidName()}
                >
                    <i className="fa fa-chevron-circle-down"/>
                </button>
                <button
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
    constructor(props) {
        super(props);
        this.state = {
            mode: 'none',
        }
    }

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
                        className="btn btn-outline-secondary btn-circle mr-1"
                        onClick={() => this.setState({mode: 'rename'})}
                        disabled={!this.props.name}
                    >
                        <i className="fa fa-i-cursor"/>
                    </button>
                    <button
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

    constructor(props) {
        super(props);
        this.state = {
            folders: [],
            mode: null,
            current_id: null,
        }
    }

    handleSelect = _.memoize((folder) => () => {
        this.setState({current_id: folder.id});
        this.props.handleSelect(folder)
    }, (folder) => folder.id);

    createItems = () => {
        return this.state.folders.map((f) => {
            const classNames = classes(
                "item btn-outline-secondary col-auto",
                {[styles.selected]: f.id === this.state.current_id }
            );
            return (
                <button key={f.id} className={classNames} onClick={this.handleSelect(f)}>
                    <i className="fa fa-folder-o"/> {f.name}
                </button>
            )
        });
    };

    currentFolderName = () => {
        const currentFolder = _.find(this.state.folders, {id: this.props.currentFolderId});
        return currentFolder ? currentFolder.name : null;
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
                        <div className="col-xs-12 col-lg-6 no-padding border-bottom p-1">
                            <AddRenameFolderLine name={this.currentFolderName()}/>
                        </div>
                    </div>
                </div>
            </div>
        )
    }

    updateList = () => {
        this.props.requestFolders().then((folders) => {
            this.setState({
                folders: folders,
            })
        });
    };

    componentDidUpdate = (prevProps, prevState) => {

    };

    componentDidMount = () => {
        this.updateList();
    }
}