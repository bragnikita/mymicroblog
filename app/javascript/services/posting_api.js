import $ from 'jquery';

const flattenForm = (raw_form) => {
    const res = _flattenForm(raw_form);
    delete res.action;
    return res;
};
const _flattenForm = (raw_form) => {
    const res = {};
    Object.entries(raw_form).forEach(entry => {
        let key = entry[0];
        let value = entry[1];
        let newValue = value;
        if (typeof value === "object") {
            if (Object.keys(value).length === 2 && 'label' in value && 'value' in value) {
                newValue = value.value;
            } else {
                newValue = flattenForm(value)
            }
        }
        res[key] = newValue;
    });
    return res;
}

export default class Service {

    get(search_arg, content_roles = []) {
        if (!search_arg) {
            throw 'Post id is not specified';
        }
        if (typeof search_arg === 'string') {
            return this.__get(`/post/${search_arg}`)
        } else {
            throw 'Not implemented'
        }
    }

    update(id, raw_values) {
        const values = flattenForm(raw_values);
        if (!id) {
            throw 'Id is not specified'
        }
        return this.__post(`/post/${id}/update`, values);
    }

    create(raw_values) {
        const values = flattenForm(raw_values);
        return this.__post(`/posts/create`, values);
    }

    __get(url, query = {}) {
        return $.ajax({
            url: url,
            method: 'get',
            params: query,
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
