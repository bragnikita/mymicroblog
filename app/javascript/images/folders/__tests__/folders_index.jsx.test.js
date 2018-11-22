import React from 'react';
import {shallow} from 'enzyme';
import {shallowToJson} from 'enzyme-to-json';
import {AddRenameFolderForm} from '../folders_index';



describe('AddRenameFolderForm', () => {
    describe('Snapshots', () => {
        let props = {};
        const baseProps = {};

        const subject = () => shallow(
            <AddRenameFolderForm {...props} />
        );

        beforeEach(() => {
            props = Object.assign({}, baseProps)
        });

        test('{name: "common"}', () => {
            props.name = 'common';
            expect(shallowToJson(subject())).toMatchSnapshot();
        });
        test('{name: undefined}', () => {
            expect(shallowToJson(subject())).toMatchSnapshot();
        });
        test('after some text inputted', () => {
           const component = subject();
           component.instance().onChange({target: {value:'some'}});
           expect(shallowToJson(component)).toMatchSnapshot();
        });
    });
});