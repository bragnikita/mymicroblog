import React from 'react';
import classNames from 'classnames';
import styles from './images_index_styles.scss';
import Thumbnail from "../thumbnail/thumbnail";

export default class ImagesIndex extends React.Component {

    state = {
        items: [],
    };

    reload = () => {
        if (this.props.fetch) {
            this.props.fetch().then((images) => {
                this.setState({
                    items: images.map((i) => {
                        return {
                            id: i.id,
                            orig_url: i.url,
                            thumb_url: i.url
                        }
                    })
                })
            })
        }
    };

    createItems = () => {
        return this.state.items.map((item) => {
            return (
                <Thumbnail
                    key={item.id}
                    thumb_url={item.thumb_url}
                    orig_url={item.orig_url}
                    ref_id={item.id}
                />
            );
        });
    };

    render() {

        const items = this.createItems();

        return (
            <div className="images_index container-fluid">
                <div className="row">
                    {items}
                </div>
            </div>
        )
    }

}