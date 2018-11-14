import $ from 'jquery';
import ReactDOM from "react-dom";

const mountComponent = (mountPointSelector, componentInstance) => {
  const elements = $(mountPointSelector);
  if (elements.length === 0) {
      return;
  }
  ReactDOM.render(componentInstance, elements[0]);
};

export {
    mountComponent,
}