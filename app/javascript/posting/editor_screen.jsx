import React from 'react'
import ReactDOM from 'react-dom'
import $ from 'jquery'
import _ from 'lodash'

class Editor extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            title: '',
            slug: undefined,
            excerpt: '',
            text: ''
        }
    }

    onFieldInput = (name) => {
        return (e) => {
            this.setState({
                [name]: e.target.value,
            });
        }
    };

    submit = () => {
        $.ajax({
            url: '/posts/create',
            method: 'post',
            data: this.state,
        }).then((result) => {
            window.location.href = window.location.origin + result.redirect_to
        })
    };

    render() {
        return (

            <div data-name="editor-component">
                <form>
                    <label htmlFor="title">Title</label>
                    <input name="title" onChange={this.onFieldInput('title')} value={this.state['title']}/>

                    <label htmlFor="slug">Slug</label>
                    <input name="slug" id="slug" onChange={this.onFieldInput('slug')} value={this.state['slug']}/>

                    <label htmlFor="excerpt">Excerpt</label>
                    <textarea name="excerpt" id="excerpt" onChange={this.onFieldInput('excerpt')}>{this.state['excerpt']}</textarea>

                    <label htmlFor="text">Text</label>
                    <textarea name="text" id="text" cols="20" onChange={this.onFieldInput('text')} >{this.state['text']}</textarea>
                </form>
                <button type="submit" value="submit" name="send" id="send" onClick={this.submit}>Send</button>
            </div>

        )
    }
}

$(() => {

    const token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

    $.ajaxSetup( {
        beforeSend: function ( xhr ) {
            xhr.setRequestHeader( 'X-CSRF-Token', token );
        }
    });

    const editor = document.getElementById('post-editor');
    if (editor) {
        ReactDOM.render(<Editor/>, editor);
    }
});