import request from 'superagent';
import $ from "jquery";

const agent = request.agent().use((request) => {
    request.set('Accept', 'application/json');
    const token = $('meta[name="csrf-token"]').attr('content');
    request.set('X-CSRF-Token', token);
    request.set('X-Requested-With', 'XMLHttpRequest')
});

export default agent;