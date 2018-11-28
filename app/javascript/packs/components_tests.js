import React from 'react';
import _ from 'lodash';
import $ from 'jquery';
import URI from 'urijs';
import '../util/common_imports';
import folders_index from '../images/folders/testcases_folders_index';

console.log('Components test --- START');
const setMessage = (...msgs) => {
    const message = msgs.join(' ')
    console.log(message);
    $('.__message').text(message);
};
const ok = () => (true);
const checkWrapper = (func) => {
    if (!func) {
        return () => {
            setMessage('No checks...');
            return true;
        };
    }
    return () => {
        try {
            func();
            setMessage('SUCCESS!!!');
            return true;
        } catch (e) {
            setMessage('FAILURE!!! ', e.message);
            return false;
        }
    }
};
const prepareCases = (cases) => {
    return _.mapValues(cases, (func) => {
        return (...args) => {
            const check = func(...args);
            window.check = checkWrapper(check) || ok;
        }
    });
};
const tests = {
    folders_index: prepareCases(folders_index),
};
window.tests = tests;

const urlParams = new URI().search(true);
const testName = urlParams['test'];
if (testName) {
    const func = _.get(window.tests, testName);
    if (func) {
        window.currentTest = func;
        func();
    } else {
        setMessage('Test not found!');
    }
}

$('[name="__run_checks"]').click(() => {
    window.check && window.check();
});
$('[name="__reload"]').click(() => {
    window.currentTest && window.currentTest();
    setMessage('');
});

const template = `
<% _.forEach(suites,function(s) { %>
    <ul>
    <li><%= s.name %>
    <ul>
        <% _.forEach(s.tests, function(t) { %>
            <li>
                <a href="<%= t.url %>"><%= t.name %></a>
            </li>
        <% }); %>
    </ul>
    </li>
    </ul>
<% }); %>

`;
const list = _.template(template)({
    suites: _.entries(window.tests).map((suite) => {
        return {
            name: suite[0],
            tests: _.keys(suite[1]).map((test) => {
                return {
                    name: test,
                    url: `/components_test/open?test=${suite[0]}.${test}`
                }
            }),
        }
    }),
    suites1: [
        { name: 'suite', tests: [ { name: 'test1', url: '/test/1' }]}
    ]
});
$('.available_tests').html(list);

console.log('Components test --- END');