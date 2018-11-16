import React from 'react';
import classNames from 'classnames';
import styles from './images_index_styles.scss';

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
                <div key={item.id} className={classNames(styles.item, "col-lg-auto col-md-3 col-sm-4 col-xs-6")}>
                    <a href={item.orig_url} target="_blank">
                        <div className={styles.image_wrapper}>
                            <div className={styles.overlay} />
                            <img className="img-thumbnail" src={item.thumb_url}/>
                        </div>
                    </a>
                </div>
            )
        })
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