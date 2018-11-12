import $ from 'jquery';
import ReactDOM from "react-dom";

const mountComponent = (mountPointSelector, componentInstance) => {
  const element = $(mountPointSelector);
  if (!element) {
      return;
  }
  ReactDOM.render(componentInstance, element[0]);
};

export {
    mountComponent,
}