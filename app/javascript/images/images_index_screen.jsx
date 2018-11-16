import React from 'react';
import Index from './index/images_index';
import * as utils from '../util/react_utils';
import FoldersIndex from './folders/folders_index';
import {images} from './../services/apis';
import {withHandlers} from 'recompose';
import Uploader from './upload/image-uploader';

const Folders = withHandlers({
    createNew: () => images.createFolder,
    rename: () => images.renameFolder,
    requestFolders: () => () => images.listFolders().then((r) => r.body.list),
})(FoldersIndex);

const folder1 = {
    id: 1,
    name: 'common',
    items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => {
        return {
            id: i,
            filename: `image_${i}.jpg`,
            thumb_url: `https://via.placeholder.com/300x200.jpg?text=image_${i}`,
            orig_url: `https://via.placeholder.com/1024x786.jpg?text=image_${i}`,
        }
    }),
};
const folder2 = {
    id: 2,
    name: "trash",
    items: [],
};

const folders = { 1: folder1, 2: folder2 };

class ImageIndexScreen extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            items: null,
            folder: null
        }
    }

    requestFolders = () => {
        return images.listFolders().then((response) => response.body.list);
    };
    handleSelect = (folder) => {
        this.setState({
            folder: folder,
            // items: folders[folder.id].items,
        })
    };

    upload = (file) => {
        return images.uploadImage(file.data, this.state.folder.id, file.name).then((response) => response.body.object)
    };

    render() {
        const {items, folder} = this.state;
        return (
            <div className="image_index_screen">
                <div className="container-fluid">
                    <Folders
                        requestFolders={this.requestFolders}
                        handleSelect={this.handleSelect}
                    />
                </div>
                <Uploader uploadSingle={this.upload}/>
                {folder &&
                <React.Fragment>
                    <div className="container-fluid text-left">{folder && folder.name || ''}</div>
                    <Index items={items || []}/>
                </React.Fragment>
                }
            </div>
        );
    }

    componentDidMount = () => {
        const folder = folders[this.props.currentId];
        this.setState({
            folder: folder,
            items: folder.items,
        })
    }
}


utils.mountComponent('#image-index-screen', <ImageIndexScreen currentId={1}/>);