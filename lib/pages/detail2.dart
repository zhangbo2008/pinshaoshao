import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:learn_flutter/views/shopCar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import '../app.dart';

import 'dart:ui';

import 'package:add_cart_parabola/add_cart_parabola.dart';
import 'package:flutter/material.dart';

// 好像应该用stateless
class CatDetailPage extends StatefulWidget {
  var item;

  CatDetailPage({Key key, this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CatDetailPageState(item: item);
  }
}

class CatDetailPageState extends State<CatDetailPage> {
  CatDetailPageState({Key key, this.item});

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var item;

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    print(111111111111111);
    _refreshController.refreshToIdle(); //刷新上面.
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    var a = 1;
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  //引入动画的记忆状态.
  GlobalKey floatKey = GlobalKey();
  GlobalKey rootKey = GlobalKey();
  GlobalKey rootKey2 = GlobalKey();
  Offset floatOffset;

  Offset temp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox renderBox = floatKey.currentContext.findRenderObject();
      floatOffset = renderBox
          .localToGlobal(Offset.zero); //floatingActionButton 的坐标. 对应floatkey 的
      print('dayindongzuo');
      print(floatOffset);
    });
  }



  @override
  Widget build(BuildContext context) {
    return // 这个地方应该用Notification报一下.

//        ChangeNotifierProvider<MyModel>( create: (context) => MyModel(),
//    child:

        Scaffold(
      key: rootKey2,
      appBar: AppBar(
        title: Text("详情页"),
      ),
      body:
//      Row(
//        children: <Widget>[

          Column(
        children: <Widget>[


//            Container(
//              height: 40.0,
//              child: Text('sssssssssssssss'),
//            ),

          Flexible(
              // 在ListView上在包裹一层Flexible
              child: SmartRefresher(
            // 上下拉动都加载.包上一层上下刷新的组件.
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),

            footer:
                CustomFooter(builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
              } else if (mode == LoadStatus.loading) {
                body = CircularProgressIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("加载失败");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("加载更多");
              } else {
                body = Text("没有更多");
              }
              return Container(
                height: 50.0,
                child: Center(child: body),
              );
            }),
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            controller: _refreshController,
            // 控制器
            child:
                //下面是刷新的内容.组件是一个listview
                ListView(
//          physics: new NeverScrollableScrollPhysics(),

                    children: <Widget>[
                  Container(
                    height: 500, //让滑动

                    child: Image.network(item['info']['imgurl']),
                    decoration: BoxDecoration(color: Colors.yellow[50]),
                    padding: EdgeInsets.all(24),
                  ),
                  Container(
                    child: Text(item['title'],
                        style: TextStyle(
                            fontSize: 32,
                            color: Theme.of(context).accentColor)),
                    margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
                  ),
                  Text(item['info']['yanyuan'])
                ]
                    //添加按钮.
                    ),
          )),

          Container(
              padding: EdgeInsets.fromLTRB(
                50,
                10,
                10,
                10,
              ), //设置空间的位置.
              child: Row(children: <Widget>[
                Consumer<MyModel>(
                  builder: (context, model, child) {
                    return FlatButton(
                        key: floatKey,
                        color: Colors.tealAccent,
                        onPressed: () {
                          Navigator.of(context).push(
                              //路由跳转到.  CatDetailPage(item: item) 这个. //并且用的是page内部跳转.
                              MaterialPageRoute(builder: (ctx) {
                            return myViews3();
                          })); //要用栈push这个跳转.这个跳转是最应该使用的.符合逻辑,因为推出时候,不按照层次来推出,而是按照浏览记录来退出,符合我们的需求!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                      Navigator.of(context).pushReplacementNamed("cart");
                        },
                        child: Icon(Icons.add_shopping_cart)

                    );
                  },
                ),
                SizedBox(
                  width: 120,
                ), // 这个是padding 组件,用来拉开组件之间的距离

                Consumer<MyModel>(//写一个button

                    builder: (context, model, child) {
                  return FloatingActionButton(
                      //FloatingActionButton 这个东西要少用,貌似一行只能用1个.写多了,页面渲染不了.

// onPressed 里面输入一个void callback, 所以他不能直接写函数.需要把盗用的写{}里面就行了.
                      onPressed: () {
                        print(item['title']);
                        model.addproduct(item['title']);

                        //做动画.
                      },
                      child: Text("购买"));
                }),
              ]))
        ],
      ),
    );
  }
}
