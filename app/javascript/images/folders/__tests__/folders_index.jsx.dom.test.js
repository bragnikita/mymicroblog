import React from 'react';
import {mount} from 'enzyme';
import {AddRenameFolderForm, AddRenameFolderLine} from '../folders_index';
import FoldersIndex from "../folders_index";

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
                props = {name: 'new_folder'};
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

describe('FoldersIndex (Full DOM)', () => {

    describe('callbacks', () => {

        const subject = (props = {}) => {
            const basicProps = {
                requestFolders: jest.fn().mockReturnValue(Promise.resolve([
                    {id: 1, name: 'folder1'}, {id: 2, name: 'folder2'}
                ])),
            };
            return (<FoldersIndex {...basicProps} {...props} />);
        };

        const mountComponent = (component) => {
            return mount(component);
        };

        it('loads items when mounted', () => {
            const component = mountComponent(subject());
            console.log(component.debug());
            expect(component.prop('requestFolders').mock.calls.length).toBe(1);
        });
        it('calls handleSelect callback when clicked on the folder element', () => {
           const props = {
               handleSelect: jest.fn(),
           };
           const component = mountComponent(subject(props));
           setTimeout(() => {
               component.find('[name="folder"]').filter('[key=1]').first().simulate('click');
               expect(props.handleSelect.mock.calls[0][0]).toHaveProperty('id', '1')
           }, 100);
        });
    });
});
