import $ from 'jquery';
import Posting from './posting_api';
import Images from './images_api';
import Users from './users_api';

const posting = new Posting();
const images = new Images();
const users = new Users();

$(document).bind("ajaxStart", function(){
    $('html').addClass('ajax-active');
}).bind("ajaxStop", function(){
    $('html').removeClass('ajax-active');
});

export  {
    posting,
    images,
    users,
}