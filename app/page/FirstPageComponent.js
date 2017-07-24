/**
 * Created by SXJH on 17/4/17.
 */
import React from 'react';
import {
    View,
    Navigator,
    TouchableOpacity,
    Text,
    ListView,
    StyleSheet,
} from 'react-native';

import SecondPageComponent from './SecondPageComponent';

export default class FirstPageComponent extends React.Component {
    constructor(props) {
        super(props);
        this.state = {};
    }


    render() {
        return (
            <View style={styles.container}>
                {/*<TouchableOpacity onPress={this._pressButton.bind(this)}>*/}
                    {/*<Text>点我跳转</Text>*/}
                {/*</TouchableOpacity>*/}
            </View>

        );
    }
}


const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#e8e8e8'
    },

});