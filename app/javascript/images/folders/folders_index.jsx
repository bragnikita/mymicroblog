import React, {Component} from 'react';
import classes from 'classnames';
import _ from 'lodash';
import styles from './styles.scss';

export default class FoldersIndex extends Component {

    constructor(props) {
        super(props);
        this.state = {
            folders: [],
        }
    }

    handleSelect = _.memoize((folder) => () => this.props.handleSelect(folder),
        (folder) => folder.id);

    createItems = () => {
        return this.state.folders.map((f) => {
            const classNames = classes(
                "item btn-outline-secondary col-auto",
                {[styles.selected]: f.id === this.props.currentFolderId}
            );
            return (
                <button key={f.id} className={classNames} onClick={this.handleSelect(f)}>
                    <i className="fa fa-folder-o"/> {f.name}
                </button>
            )
        });
    };

    render() {

        const items = this.createItems();

        return (
            <div className={classes("folders-index w-100")}>
                <div className="container-fluid">
                    <div className="row">
                        {items}
                    </div>
                </div>
            </div>
        )
    }

    componentDidMount = () => {
        this.props.requestFolders().then((folders) => {
            this.setState({
                folders: folders,
            })
        });
    }
}