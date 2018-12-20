import React from 'react';
import sinon from 'sinon';
import {expect} from 'chai';

import {mountComponent, mountWithEnzyme} from "../../util/react_utils";
import Thumbnail from "./thumbnail";


const mountIt = (component) => {
    // mountComponent('.mount-point', component, true);
    return mountWithEnzyme('.mount-point', component)
};

class StateWrapper extends React.Component {
    state = {selected: false};
    onSelect = (val) => {this.setState({selected: !this.state.selected}); this.props.onSelect(val)};
    render() {
        return (<Thumbnail {...this.props} onSelect={this.onSelect} selected={this.state.selected}/>)
    }
}

const preview_and_capture_mode = () => {
    const callback = sinon.spy();
    const wrapper = mountIt(<StateWrapper
        ref_id={"100"}
        onSelect={callback}
        selected={false}
        orig_url={"https://via.placeholder.com/550/0000FF/808080?Text=Digital.com"}
        thumb_url={"https://via.placeholder.com/250/0000FF/808080?Text=Digital.com"}
    />);
    return () => {
        expect(callback.called, 'callback was not called').to.be.true
        expect(callback.lastCall.lastArg, 'callback parameter is wrong' ).to.equal("100")
    }
};

export default {
    preview_and_capture_mode,
};