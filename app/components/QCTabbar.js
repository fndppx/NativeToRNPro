/**
 * Created by SXJH on 17/4/18.
 */
import React, {Component} from 'react';
import {Text, StyleSheet, Image,Platform,Navigator} from 'react-native';

import FirstPage from '../page/SecondPageComponent'
import TabNavigator from 'react-native-tab-navigator';
export default class TabBar extends Component{
    static defaultProps = {
        selectedColor: 'rgb(22,131,251)',
        normalColor: '#a9a9a9',
        tabBarHeight:49,
    };

    constructor(props) {
        super(props);
        this.state = {
            selectedTab: 'home',
            tabBarHeight: 49

        };
    }
    handleTabBar(state){
        this.setState({
            tabBarHeight: state ? 49 : 0
        });
    }
    render(){
        return (
            <TabNavigator tabBarStyle={{ height:this.state.tabBarHeight,backgroundColor:'white' }} sceneStyle={{paddingBottom: this.state.tabBarHeight}}>
                <TabNavigator.Item
                    title="直播"
                    selected={this.state.selectedTab === 'home'}
                    renderIcon={() => <Image source={ {uri:'homepagelight_icon'} } style={styles.iconStyle}/>}
                    renderSelectedIcon={() =><Image source={{uri: 'homepagelight_icon'}} style={styles.iconStyle}/>}   // 选中的图标
                    onPress={() => this.setState({ selectedTab: 'home' })}
                    badgeText = ''>

                    <Navigator
                        initialRoute={{name:"直播", component:FirstPage, passProps: {
                            tabBar: {
                                hide: () => this.handleTabBar(false),
                                show: () => this.handleTabBar(true)
                            }
                        }}}
                        configureScene={()=>{
                            return Navigator.SceneConfigs.PushFromRight;
                        }}
                        renderScene={(route,navigator)=>{
                            let Component = route.component;
                            return <Component {...route.passProps} navigator={navigator}/>;
                        }}
                    />
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
        width: 22,
        height:22,
    },

    selectedTitleStyle:{
        color:'orange'
    }
});