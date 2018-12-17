import React from 'react';
import sinon from 'sinon';
import {expect} from 'chai';

import {mountComponent} from "../../util/react_utils";
import Thumbnail from "./thumbnail";


const mountIt = (component) => {
    mountComponent('.mount-point', component, true);
};

class StateWrapper extends React.Component {
    state = {selected: false};
    onSelect = (val) => {this.setState({selected: !this.state.selected}); this.props.onSelect(val)};
    render() {
        return (<Thumbnail {...this.props} onSelect={this.onSelect} selected={this.state.selected}/>)
    }
}

const preview_and_capture_mode = () => {
    mountIt(<StateWrapper
        ref_id={"100"}
        onSelect={() => {}}
        selected={false}
        orig_url={"https://via.placeholder.com/550/0000FF/808080?Text=Digital.com"}
        thumb_url={"https://via.placeholder.com/250/0000FF/808080?Text=Digital.com"}
    />);
};

export default {
    preview_and_capture_mode,
};