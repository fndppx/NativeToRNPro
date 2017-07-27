/**
 * Created by SXJH on 2017/7/27.
 */
import {
    Dimensions,
    Platform
} from 'react-native';
import ExtraDimensions from 'react-native-extra-dimensions-android';


const screenSize = {
    width:0,
    height:0
};
const menuBarH = 0;
const statusBarH = 0;
const windowSize = Dimensions.get('window');

if (Platform.OS === 'android') {
    screenSize = Dimensions.get('screen');
    menuBarH = ExtraDimensions.get('SOFT_MENU_BAR_HEIGHT');
    statusBarH = ExtraDimensions.get('STATUS_BAR_HEIGHT');
}



const videoHeight = 9*windowSize.width / 16;
const phoneSize = {
    width:Platform.select({
        ios:windowSize.width,
        android:ExtraDimensions.get('REAL_WINDOW_WIDTH')
    }), //ios
    height:Platform.select({
        ios:windowSize.height,
        android:ExtraDimensions.get('REAL_WINDOW_HEIGHT')
    }), //ios
    noStatusBarW:windowSize.width - statusBarH, //屏幕宽度 - 状态栏高度
    noMenuBarH:screenSize.height - menuBarH, //android下的windowSize的尺寸是不包含menuBar的
    noMenuAndStatusBarH:windowSize.height - statusBarH, //没有
    menuBarH:menuBarH,
    statusBarH:statusBarH
};


/**
 * 将秒数转化为时间字符串
 * @param time
 * @returns {string}
 * @private
 */
export function getTimeString(time) {
    let minutes = Math.floor(time / 60), //总分钟
        h = Math.floor(minutes / 60), //小时
        m = Math.floor(minutes % 60), //分钟
        s = Math.floor(time % 60), //秒数
        hstring;
    hstring = h < 10 ? '0' + h : h;
    m = m < 10 ? '0' + m : m;
    s = s < 10 ? '0' + s : s;
    return h > 0 ? hstring + ':' + m + ':' + s : m + ':' + s;
}

export function getVideoHeight() {
    return videoHeight;
}

export function getPhoneSize(){
    return phoneSize;
}