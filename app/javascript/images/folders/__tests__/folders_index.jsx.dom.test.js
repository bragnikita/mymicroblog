import React from 'react';
import {mount} from 'enzyme';
import {AddRenameFolderForm, AddRenameFolderLine} from '../folders_index';

describe('AddRenameFolderLine (full DOM)', () => {

    const subject = (props) => {
        return (<AddRenameFolderLine {...props} />);
    };

    const mountComponent = (component) => {
        return mount(component);
    };

    describe('when creationg new folder', () => {
        let component, props;
        describe('rendering', () => {
            beforeEach(() => {
                props = { name: 'new_folder'};
                component = mountComponent(subject(props))
            });
            test('mode: add', (done) => {
                component.setState({mode: 'add'}, () => {
                    expect(component.find('[name="input_folder_name"]').exists()).toBeTruthy();
                    done();
                });
            });
            test('mode: rename', (done) => {
                component.setState({mode: 'rename'}, () => {
                    expect(component.find('[name="input_folder_name"]').exists()).toBeTruthy();
                    done();
                });
            });
            test('mode: none', (done) => {
                component.setState({mode: 'none'}, () => {
                    expect(component.find('[name="input_folder_name"]').exists()).toBeFalsy();
                    done();
                });
            })
        });
        describe('callbacks', () => {
            beforeEach(() => {
                props = {
                    name: 'old_folder',
                    createNew: jest.fn().mockReturnValue(Promise.resolve()),
                    rename: jest.fn().mockReturnValue(Promise.resolve()),
                };
                component = mountComponent(subject(props));
            });
            test('create new folder', () => {
                component.find('[name="add"]').first().simulate('click');
                const form = component.find(AddRenameFolderForm);
                form.find('input[name="input_folder_name"]').first().simulate('change', {target: {value: 'new_folder'}});
                form.find('[name="apply"]').first().simulate('click');
                expect(props.createNew.mock.calls.length).toBe(1);
                expect(props.createNew.mock.calls[0][0]).toBe('new_folder');
            });
            test('rename folder', () => {
                component.find('[name="rename"]').first().simulate('click');
                const form = component.find(AddRenameFolderForm);
                form.find('input[name="input_folder_name"]').first().simulate('change', {target: {value: 'new_folder'}});
                form.find('[name="apply"]').first().simulate('click');
                expect(props.rename.mock.calls.length).toBe(1);
                expect(props.rename.mock.calls[0][0]).toBe('new_folder');
            });
        });
        afterEach(() => {
            if (component) {
                component.unmount();
            }
        })
    });
});
