import React from 'react';
import {shallow} from 'enzyme';
import {shallowToJson} from 'enzyme-to-json';
import {AddRenameFolderForm, AddRenameFolderLine} from '../folders_index';


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
            component.instance().onChange({target: {value: 'some'}});
            expect(shallowToJson(component)).toMatchSnapshot();
        });
    });
});

describe('AddRenameFolderLine', () => {
    let props = {};

    beforeEach(() => { props = {}});

    const subject = (extraProps = {}) => shallow(
        <AddRenameFolderLine {...props} {...extraProps} />
    );
    describe('Snapshots', () => {

        test('if folder name specified', () => {
            props = {name: 'folder_name'};
            expect(shallowToJson(subject())).toMatchSnapshot();
        });
        test('if folder name is not specified', () => {
            props = {};
            expect(shallowToJson(subject())).toMatchSnapshot();
        });
        test('when new button was clicked', () => {
            const component = subject();
            component.find('[name="add"]').first().simulate('click');
            expect(shallowToJson(component)).toMatchSnapshot();
        });
        test('when rename button was clicked', () => {
            const component = subject({name: 'new folder'});
            component.find('[name="rename"]').first().simulate('click');
            expect(shallowToJson(component)).toMatchSnapshot();
        });
    });
    describe('Callbacks', () => {
        test('it calls rename', () => {
            const rename = jest.fn().mockReturnValue(Promise.resolve());
            const component = subject({rename, name: "old_name"});
            component.find('[name="rename"]').first().simulate('click');
            component.find(AddRenameFolderForm).prop('onApply')('renamed_folder');
            expect(rename.mock.calls.length).toBe(1);
            expect(rename.mock.calls[0][0]).toBe('renamed_folder');
        });
        test('it calls createNew', () => {
            const createNew = jest.fn().mockReturnValue(Promise.resolve());
            const component = subject({createNew});
            component.find('[name="add"]').first().simulate('click');
            component.find(AddRenameFolderForm).prop('onApply')('new_folder');
            expect(createNew.mock.calls.length).toBe(1);
            expect(createNew.mock.calls[0][0]).toBe('new_folder');
        })
    })
});