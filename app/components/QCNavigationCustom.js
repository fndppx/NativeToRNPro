/**
 * Created by SXJH on 17/4/18.
 */
import React, {Component} from 'react';
import {Navigator} from 'react-native';
import HomePage from '../page/QCHomePage';

export default class QCNavigationCustom extends Component{

    render(){
        return(
            <Navigator
                initialRoute={{component: HomePage}}
                renderScene={(route, navigator) => {
                    return <route.component navigator={navigator} {...route.args}/>
                }
                }/>
        );
    }

    // componentDidMount(){
    //     SplashScreen.hide();
    // }
}