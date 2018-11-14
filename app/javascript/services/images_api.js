import request from './agent';

export default class Service {

    listFolders() {
        return request.get('/folders')
    }

    createFolder(name) {
        return request.put('/folder').send({folder: { name: name }})
    }

    renameFolder(id, name) {
        return request.post(`/folder/${id}`).send({ folder: { id: id, name: name }})
    }

    deleteFolder(id) {
        return request.delete(`/folder/${id}`)
    }
}

const instance = new Service();

export {
    instance,
}
