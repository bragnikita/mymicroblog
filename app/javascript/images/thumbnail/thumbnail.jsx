import React from 'react';
import styles from "./thumbnail.scss";
import classNames from 'classnames';
import {isDomEnv, copyToClipboard, urlAbsolutize} from '../../util/browser_utils';

const copyToClipboardHandler = (link, e) => {
    if (e) e.preventDefault();
    if (isDomEnv()) {
        copyToClipboard(link)
    }
};

const ButtonsOverlay = ({public_link, ref_id, onDelete}) => {

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

    return (
        <div className={styles.overlay}>
            {copyPublicLinkBtn}
            {copyRelativeLinkBtn}
            {copyRefIdBtn}
        </div>
    )
};

const Thumbnail = (props) => {
    const {thumb_url, orig_url, ref_id} = props;

    return (
        <div className={classNames(styles.item, "col-xl-2 col-lg-2 col-md-3 col-sm-4 col-xs-6")}>
            <a href={orig_url} target="_blank" >
                <div className={styles.image_wrapper}>
                    <ButtonsOverlay public_link={orig_url} ref_id={ref_id}/>
                    <img className="img-thumbnail" src={thumb_url}/>
                </div>
            </a>
        </div>
    );
};

export default Thumbnail;