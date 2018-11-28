import React from 'react';
import sinon from 'sinon';
import {expect} from 'chai';

import {mountComponent} from "../../util/react_utils";
import FoldersIndex from "./folders_index";


const mountIt = (component) => {
    mountComponent('.mount-point', component, true);
};

const no_folders = () => {
    mountIt(<FoldersIndex requestFolders={() => Promise.resolve([])}/>);
};
const with_folders = () => {
    const rename = sinon.fake.returns(Promise.resolve());
    mountIt(<FoldersIndex
        requestFolders={() => Promise.resolve([{id: 1, name: 'folder1'}, {id: 2, name: 'folder2'}])}
        rename={rename}
    />);
    return () => {
        expect(rename.called, 'rename was not called').to.be.true;
        expect(rename.lastArg).to.equal('folder3', `rename: unexpected argument "${rename.lastArg}"`);
    };
};

export default {
    no_folders,
    with_folders,
};