import $ from 'jquery';
import ReactDOM from "react-dom";

const mountComponent = (mountPointSelector = '#mount_to', componentInstance, clean = false) => {
  const elements = $(mountPointSelector);
  if (elements.length === 0) {
      return;
  }
  const element = elements[0];
  if (clean) {
      ReactDOM.unmountComponentAtNode(element);
  }
  ReactDOM.render(componentInstance, element);
};

export {
    mountComponent,
}