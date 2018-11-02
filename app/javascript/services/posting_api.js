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

    update(id, raw_values) {
        const values = flattenForm(raw_values);
        const post_values = {
            ...values,
            contents: {
                main: values.content,
                ...(values.contents ? values.contents : {}),
            },
            content: undefined,
        };
        if (!id) {
            throw 'Id is not specified'
        }
        return this.__post(`/post/${id}/update`, post_values);
    }

    create(raw_values) {
        const values = flattenForm(raw_values);
        const post_values = {
            ...values,
            contents: {
                main: values.content,
                ...(values.contents ? values.contents : {}),
            },
            content: undefined,
        };
        return this.__post(`/posts/create`, post_values);
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
