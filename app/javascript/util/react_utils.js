import $ from 'jquery';
import ReactDOM from "react-dom";
import { mount } from "enzyme";

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
const mountWithEnzyme = (mountPointSelector = '#mount_to', componentInstance) => {
    const elements = $(mountPointSelector);
    if (elements.length === 0) {
        return;
    }
    const element = elements[0];
    return mount(componentInstance, { attachTo: element })
};

export {
    mountComponent,
    mountWithEnzyme,
}