/**
 * Created by SXJH on 2017/7/27.
 */
import React,{Component} from 'react';
import {
    Text,
    Platform,
    PixelRatio
} from 'react-native';
var DeviceInfo = require('react-native-device-info');

export default class QcText extends Component{
    render(){

        //PingFangSC-Ultralight
        //PingFangSC-Regular
        //PingFangSC-Semibold'
        //PingFangSC-Thin
        //PingFangSC-Light
        //PingFangSC-Medium

        let below9 = parseFloat(DeviceInfo.getSystemVersion()) < 9.0;
        let fontFamily = '',
            fontWeight = this.props.fontWeight;
        // let fontSize,lineHeight;

        // if (Platform.OS == 'android') {
        //     fontSize = this.props.style && this.props.style.fontSize ?  this.props.style.fontSize : 17;
        //     lineHeight = this.props.style && this.props.style.lineHeight ?  this.props.style.lineHeight : 20;
        //     const fontSizeScaler = PixelRatio.get() / PixelRatio.getFontScale();
        //     fontSize = Math.round(fontSizeScaler * fontSize);
        //     lineHeight =Math.round(fontSizeScaler * lineHeight);
        // }

        if (Platform.OS == 'ios') {
            fontFamily = below9 ? 'HelveticaNeue' : 'PingFangSC-Regular';
            if(fontWeight == 'bold'){
                fontFamily = below9 ? "HelveticaNeue-Bold" : "PingFangSC-SemiBold" ;
            } else if(fontWeight == 'medium'){
                fontFamily = below9 ? "HelveticaNeue-Medium" : "PingFangSC-Medium";
            } else if(fontWeight == 'light'){
                fontFamily = below9 ? "HelveticaNeue-Light" : "PingFangSC-Light";
            }
        }


        return <Text ref={ref=>this.realRef = ref} numberOfLines={(typeof this.props.numberOfLines) == 'undefined' ? 1 : this.props.numberOfLines} onLayout={this.props.onLayout} onPress={this.props.onPress} allowFontScaling={false} style={[{fontFamily:fontFamily,backgroundColor:'transparent'},this.props.style]}>
            {this.props.children}
        </Text>
    }

    ref(){
        return this.realRef;
    }

}