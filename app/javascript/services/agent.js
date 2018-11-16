import request from 'superagent';
import $ from "jquery";

const agent = request.agent().use((request) => {
    request.set('Accept', 'application/json');
    const token = $('meta[name="csrf-token"]').attr('content');
    request.set('X-CSRF-Token', token);
});

export default agent;