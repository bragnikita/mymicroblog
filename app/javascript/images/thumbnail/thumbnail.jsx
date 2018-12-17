import React from 'react';
import PropTypes from 'prop-types';
import styles from "./thumbnail.scss";
import classNames from 'classnames';
import {isDomEnv, copyToClipboard, urlAbsolutize, isAbsolute} from '../../util/browser_utils';

const copyToClipboardHandler = (link, e) => {
    if (e) e.preventDefault();
    if (isDomEnv()) {
        copyToClipboard(link)
    }
};

const ButtonsOverlay = ({public_link, ref_id, onDelete, selected, onSelect}) => {

    const copyPublicLinkBtn = (<div
        className={classNames(styles.overlay_btn, "fa fa-circle-thin ")}
        onClick={(e) => copyToClipboardHandler(urlAbsolutize(public_link), e)}
    ><span className="fa fa-external-link"/></div>);

    const copyRelativeLinkBtn = (<div
        className={classNames(styles.overlay_btn, "fa fa-circle-thin ")}
        onClick={(e) => copyToClipboardHandler(public_link, e)}
    ><span className="fa fa-link"/></div>);

    const copyRefIdBtn = (<div
        className={classNames(styles.overlay_btn, "fa  fa-circle-thin ")}
        onClick={(e) => copyToClipboardHandler(ref_id, e)}
    >
        <span className="fa fa-thumb-tack"/>
    </div>);

    const selectButton = (
        <div className={classNames(styles.select_btn)} onClick={onSelect}>
            {selected || <span className="fa fa-square-o"/>}
            {selected && <span className="fa fa-check-square-o"/>}
        </div>
    );

    return (
        <div className={selected ? styles.selected : styles.overlay}>
            {onSelect && selectButton}
            {selected || copyPublicLinkBtn}
            {selected || isAbsolute(public_link) || copyRelativeLinkBtn}
            {selected || copyRefIdBtn}
        </div>
    )
};

const ThumbnailPresent = (props) => {
    const {thumb_url, orig_url, ref_id, selected = false, onSelect} = props;

    return (
        <div className={classNames(styles.item, "col-xl-2 col-lg-2 col-md-3 col-sm-4 col-xs-6")}>
            <a href={orig_url} target="_blank">
                <div className={styles.image_wrapper}>
                    <ButtonsOverlay public_link={orig_url} ref_id={ref_id} selected={selected} onSelect={onSelect}/>
                    <img className="img-thumbnail" src={thumb_url}/>
                </div>
            </a>
        </div>
    );
};

class Thumbnail extends React.Component {

    onSelect = (e) => {
        e.preventDefault();
        this.props.onSelect && this.props.onSelect(this.props.ref_id)
    };

    render() {
        return (
            <ThumbnailPresent
                {...this.props}
                onSelect={this.onSelect}
            />
        )
    }

}

Thumbnail.propTypes = {
    thumb_url: PropTypes.string,
    orig_url: PropTypes.string,
    ref_id: PropTypes.string,
    selected: PropTypes.bool,
    onSelect: PropTypes.func
};

export default Thumbnail;