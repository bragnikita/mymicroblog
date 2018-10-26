import $ from 'jquery';
import Posting from './posting_api';

const posting = new Posting();


$.ajaxSetup({
    beforeSend: function (xhr) {
        const token = $('meta[name="csrf-token"]').attr('content');
        xhr.setRequestHeader('X-CSRF-Token', token);
    }
});

$(document).bind("ajaxStart", function(){
    $('html').addClass('ajax-active');
}).bind("ajaxStop", function(){
    $('html').removeClass('ajax-active');
});

export  {
    posting,
}