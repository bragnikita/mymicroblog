import request from './agent';

export default class Service {

    signIn(login, password) {
        return this.__post('/auth', { user: { login_id: login, password: password }});
    }

    __get(url, query = {}) {
        return request.get(url).query(query)
    }

    __post(url, data) {
        return request.post(url).send(data);
    }
}