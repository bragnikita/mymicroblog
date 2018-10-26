import $ from 'jquery';

export default class Service {

    get(search_arg) {
        if (!search_arg) {
            throw 'Post id is not specified';
        }
        if (typeof search_arg === 'string') {
            return this.__get(`/post/${search_arg}`)
        } else {
            throw 'Not implemented'
        }
    }

    update(id, values) {
        if (!id) {
            throw 'Id is not specified'
        }
        return this.__post(`/post/${id}/update`, values);
    }

    create(values) {
        return this.__post(`/posts/create`, values);
    }

    __get(url) {
        return $.ajax({
            url: url,
            method: 'get'
        });
    }

    __post(url, data) {
        return $.ajax({
            url: url,
            method: 'post',
            data: data,
        });
    }

}

const instance = new Service();

export {
    instance,
}
