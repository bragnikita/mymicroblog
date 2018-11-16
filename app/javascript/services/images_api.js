import request from './agent';

export default class Service {

    listFolders() {
        return request.get('/folders')
    }

    createFolder(name) {
        return request.put('/folders').send({folder: {name: name}})
    }

    renameFolder(id, name) {
        return request.post(`/folder/${id}`).send({folder: {id: id, name: name}})
    }

    deleteFolder(id) {
        return request.delete(`/folder/${id}`)
    }

    listFolderImages(folder_id) {
        return request.get('/images/list').query({folder: folder_id})
    }

    uploadImage(file, folder_id, title) {
        return request.put('/images')
            .attach('image[link]', file)
            .field('image[folder_id]', folder_id)
            .field('image[title]', title)
    }
}

const instance = new Service();

export {
    instance,
}
