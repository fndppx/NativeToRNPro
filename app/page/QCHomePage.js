
import React, {Component} from 'react';
import {Text, View} from 'react-native';

import TabBar from '../components/QCTabbar';


export default  class HomePage extends  Component{
    constructor(props){
        super(props);
    }

    render(){
        return(
            <View style={{flex: 1, justifyContent: 'flex-end'}}>
                {/*<TabBar navigator={this.props.navigator}/>*/}
                <TabBar/>

            </View>
        );
    }
}