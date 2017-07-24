/**
 * Created by SXJH on 17/4/17.
 */

import {
    Text,
    View,
    ListView
} from 'react-native';

 class QCListView extends Component{
    constructor(props){
        // super(props);
        // const ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        // this.state = {
        //     dataSource: ds.cloneWithRows([
        //         'John', 'Joel', 'James', 'Jimmy', 'Jackson', 'Jillian', 'Julie', 'Devin'
        //     ])
        };
    }
    render(){
        return (
            {/*<View style={{flex: 1, paddingTop: 22}}>*/}
                {/*<ListView*/}
                    {/*dataSource={this.state.dataSource}*/}
                    {/*renderRow={(rowData) => <Text>{rowData}</Text>}*/}
                {/*/>*/}
            {/*</View>*/}
        <View>
            <Text>sss</Text>
        </View>
        );
    }

}
export default QCListView;
