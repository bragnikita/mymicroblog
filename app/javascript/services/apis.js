import $ from 'jquery';
import Posting from './posting_api';
import Images from './images_api';

const posting = new Posting();
const images = new Images();

$(document).bind("ajaxStart", function(){
    $('html').addClass('ajax-active');
}).bind("ajaxStop", function(){
    $('html').removeClass('ajax-active');
});

export  {
    posting,
    images,
}