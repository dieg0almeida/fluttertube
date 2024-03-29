import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorite_screen.dart';
import 'package:fluttertube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/yt_logo_rgb_dark.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.of<FavoriteBloc>(context).outFav,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Text(snapshot.data.length.toString());
                }else{
                  return Container();
                }
              },
            )
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favorite()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async{
              String result = await showSearch(context: context, delegate: DataSearch());
              if(result != null){
                BlocProvider.of<VideosBloc>(context).inSearch.add(result);
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
          stream: BlocProvider.of<VideosBloc>(context).outVideos,
          initialData: [],
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (context, index){
                    if(index < snapshot.data.length){
                      return VideoTile(snapshot.data[index]);
                    }else if(index > 1 ){
                      BlocProvider.of<VideosBloc>(context).inSearch.add(null);
                      return Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red),),
                      );
                    }else{
                      return Container();
                    }
                  }
              );
            }else{
              return Container();
            }
          }
      ),
    );
  }
}
