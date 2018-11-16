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

class ImageIndexScreen extends React.Component {

    state = {
        folder: null,
    };

    handleSelect = (folder) => {
        this.setState({
            folder: folder,
        }, () => {
            this.images_list.reload();
        })
    };

    upload = (file) => {
        return images.uploadImage(file.data, this.state.folder.id, file.name).then((response) => {
            return response.body.object
        })
    };

    fetchImages = () => {
        if (this.state.folder) {
            return images.listFolderImages(this.state.folder.id).then((response) => {
                return response.body.list
            })
        }
        return Promise.resolve([]);
    };

    render() {
        const {folder} = this.state;
        return (
            <div className="image_index_screen">
                <div className="container-fluid">
                    <Folders
                        handleSelect={this.handleSelect}
                    />
                </div>
                <Uploader uploadSingle={this.upload} onUploadedSingle={() => this.images_list.reload()}/>
                {folder &&
                <React.Fragment>
                    <div className="container-fluid text-left">{folder && folder.name || ''}</div>
                    <Index ref={(ref) => this.images_list = ref} fetch={this.fetchImages}/>
                </React.Fragment>
                }
            </div>
        );
    }
}


utils.mountComponent('#image-index-screen', <ImageIndexScreen/>);