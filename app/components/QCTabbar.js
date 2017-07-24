/**
 * Created by SXJH on 17/4/18.
 */
import React, {Component} from 'react';
import {Text, StyleSheet, Image,Platform} from 'react-native';

import px2dp from '../../../../GitHubDemo/NativeToRNPro/app/utils/px2dp';
import FirstPage from '../page/SecondPageComponent'
import TabNavigator from 'react-native-tab-navigator';
export default class TabBar extends Component{
    static defaultProps = {
        selectedColor: 'rgb(22,131,251)',
        normalColor: '#a9a9a9'
    };

    constructor(props) {
        super(props);
        this.state = {
            selectedTab: 'home'
        };
    }
    render(){
        return (

            <TabNavigator tabBarStyle={{ backgroundColor:'white' }} style={{backgroundColor: 'white'}}>
                <TabNavigator.Item
                    title="直播"
                    selected={this.state.selectedTab === 'home'}
                    renderIcon={() => <Image source={ {uri:'homepagelight_icon'} } style={styles.iconStyle}/>}
                    renderSelectedIcon={() =><Image source={{uri: 'homepagelight_icon'}} style={styles.iconStyle}/>}   // 选中的图标
                    onPress={() => this.setState({ selectedTab: 'home' })}
                    badgeText = ''>

                    <FirstPage {...this.props} />
                </TabNavigator.Item>
                <TabNavigator.Item
                    title="回看"
                    selected={this.state.selectedTab === 'playground'}
                    renderIcon={() => <Image source={ {uri:'me_icon'} } style={styles.iconStyle}/>}
                    renderSelectedIcon={() => <Image source={ {uri:'me_icon'} } style={styles.iconStyle}/>}
                    onPress={() => this.setState({ selectedTab: 'playground' })}
                    badgeText = ''
                >
                    <FirstPage {...this.props} />
                </TabNavigator.Item>
                <TabNavigator.Item
                    title="我的"
                    selected={this.state.selectedTab === 'other'}
                    renderIcon={() => <Image source={ {uri:'seeagainlight_icon'} } style={styles.iconStyle}/>}
                    renderSelectedIcon={() => <Image source={ {uri:'seeagainlight_icon'} } style={styles.iconStyle}/>}
                    onPress={() => this.setState({ selectedTab: 'other' })}
                    badgeText = ''
                >

                    <FirstPage {...this.props}/>
                </TabNavigator.Item>
            </TabNavigator>
        );
    }
}

const styles = StyleSheet.create({
    iconStyle: {
        width: Platform.OS === 'ios' ? 22 : 22,
        height: Platform.OS === 'ios' ? 22 : 22
    },

    selectedTitleStyle:{
        color:'orange'
    }
});