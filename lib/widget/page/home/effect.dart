import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_wan/bean/common/article_detail_bean.dart';
import 'package:flutter_wan/bean/home/banner_bean.dart';
import 'package:flutter_wan/bean/home/home_article_bean.dart';
import 'package:flutter_wan/http/api.dart';

import 'action.dart';
import 'home_article_item/state.dart';
import 'state.dart';

Effect<HomeState> buildEffect() {
  return combineEffects(<Object, Effect<HomeState>>{
    Lifecycle.initState: _init,
    HomeAction.loadMoreArticle: _loadMoreArticleData,
    HomeAction.openBannerContent: _openBannnerContent,
  });
}

void _init(Action action, Context<HomeState> ctx) {
  _getBannerData(action, ctx);
  _getArticleData(action, ctx);
}

//获取Banner数据
void _getBannerData(Action action, Context<HomeState> ctx) async {
  println("请求banner数据");
  try {
    Response response = await Dio().get(ApiUrl.GET_BANNER_URL); //获取banner数据
    BannerBean bannerBean =
        BannerBean().fromJson(json.decode(response.toString()));
    ctx.state.banners = bannerBean.data;
    ctx.state.bannerImages = _getImageList(ctx);

    ctx.dispatch(HomeActionCreator.updateBannerData(ctx.state.banners));
    ctx.dispatch(HomeActionCreator.updateBannerImage(ctx.state.bannerImages));
  } catch (e) {
    println("获取首页banner数据失败: " + e.toString());
  }
}

//获取Banner图片数据
List<Widget> _getImageList(Context<HomeState> ctx) {
  List<Widget> imageList = List();
  for (int i = 0; i < ctx.state.banners.length; i++) {
    imageList
      ..add(Image.network(
        ctx.state.banners[i].imagePath,
        fit: BoxFit.fill,
      ));
  }
  return imageList;
}

//获取首页文章数据
void _getArticleData(Action action, Context<HomeState> ctx) async {
  try {
    Response response =
        await Dio().get(ApiUrl.GET_HOME_ARTICLE + "0/json"); //获取首页文章
    HomeArticleBean homeArticleBean =
        HomeArticleBean().fromJson(json.decode(response.toString()));

    List<HomeArticleDataData> items = homeArticleBean.data.datas;
    ctx.state.articleList = List.generate(items.length, (index) {
      return HomeArticleItemState(itemDtail: items[index]);
    });

    ctx.dispatch(
        HomeActionCreator.updateArticleItem(ctx.state.articleList)); //更新列表
  } catch (e) {
    println("获取首页文章数据失败: " + e.toString());
  }
}

//加载更多首页文章数据
void _loadMoreArticleData(Action action, Context<HomeState> ctx) async {
  try {
    int index = action.payload;
    Response response = await Dio()
        .get(ApiUrl.GET_HOME_ARTICLE + index.toString() + "/json"); //获取首页文章
    HomeArticleBean homeArticleBean =
        HomeArticleBean().fromJson(json.decode(response.toString()));

    List<HomeArticleDataData> items = homeArticleBean.data.datas;
    List<HomeArticleItemState> tempList = List.generate(items.length, (index) {
      return HomeArticleItemState(itemDtail: items[index]);
    });
    if (index == 0) {
      ctx.state.articleList = tempList;
    } else {
      ctx.state.articleList.addAll(tempList);
    }
    ctx.dispatch(
        HomeActionCreator.updateArticleItem(ctx.state.articleList)); //更新列表
  } catch (e) {
    println("获取首页文章数据失败: " + e.toString());
  }
}

//打开banner文章内容
void _openBannnerContent(Action action, Context<HomeState> ctx) {
  int index = action.payload;
  ArticleDetailBean articleDetailBean = ArticleDetailBean();
  articleDetailBean.title = ctx.state.banners[index].title;
  articleDetailBean.url = ctx.state.banners[index].url;

  Navigator.of(ctx.context)
      .pushNamed("webview", arguments: {"articleDetail": articleDetailBean});
}
