import React from 'react';
// import {} from 'formik';
import TextField from "@material-ui/core/es/TextField/TextField";
import List from "@material-ui/core/List/List";
import ListItem from "@material-ui/core/ListItem/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon/ListItemIcon";
import Icon from "@material-ui/core/Icon/Icon";


export class Editor extends React.Component {

    constructor(props) {
        super(props);
        this.inputRef = null;
    }

    handleChange = (e) => {
        this.props.field.onChange(e);
    };

    render() {
        const {field, form, ...rest} = this.props;
        const {name, value, onBlur} = field;
        return (
            <TextField
                label={"Post text"}
                variant={"outlined"}
                margin="normal"
                fullWidth
                multiline
                placeholder={"Post body"}
                {...rest}
                name={name}
                value={value}
                onBlur={onBlur}
                onChange={this.handleChange}
                inputRef={(ref) => this.inputRef = ref}
            />
        )
    }
}


const SideMenuButton = ({
                            children, onClick = () => {
    }, ...rest
                        }) => (<Icon
    onClick={onClick}
    fontSize={'large'}
    classes={{
        root: 'menu-icon',
        fontSizeLarge: 'menu-icon-size-large'
    }}
    {...rest}>
    {children}
</Icon>);

const editorPanelStyles = {
    root: {display: 'flex', width: '100%'},
    editor_cell: {flexGrow: 1},
    menu_cell: {width: '50px'}
};

export class EditorPanel extends React.Component {

    render() {
        return (
            <div style={editorPanelStyles.root}>
                <div style={editorPanelStyles.editor_cell}>
                    <Editor {...this.props} />
                </div>
                <div style={editorPanelStyles.menu_cell}>
                    <List component="div">
                        <ListItem button disableGutters>
                            <ListItemIcon>
                                <SideMenuButton>add_photo_alternate</SideMenuButton>
                            </ListItemIcon>
                        </ListItem>
                        <ListItem button disableGutters>
                            <ListItemIcon>
                                <SideMenuButton>code</SideMenuButton>
                            </ListItemIcon>
                        </ListItem>
                    </List>
                </div>
            </div>);
    }
}

export default EditorPanel;