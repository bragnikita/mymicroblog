import React from 'react'
import ReactDOM from 'react-dom'
import $ from 'jquery'
import './styles.scss'
import Form from './editor_form';


$(() => {
    const editorElement = document.getElementById('post-editor');
    if (editorElement) {
        let editor;
        const page_pathname = window.location.pathname;
        const m = page_pathname.match(/^\/post\/(.+)\/edit$/i);
        if (m) {
            const id = m[1];
            editor = <Form postId={id}/>;
        } else {
            editor = <Form/>;
        }
        ReactDOM.render(editor, editorElement);
    }
});