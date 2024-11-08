import 'package:flutter/material.dart';
import '../style.dart';
import '../DataBase/UserDB.dart';

Container navBar(BuildContext context){




  Icon star = const Icon(Icons.star);
  Icon camera = const Icon(Icons.video_camera_front);
  Icon bookmark =  const Icon(Icons.bookmark);



  ButtonStyle bsc = navButtonStyle;
  ButtonStyle bss = navButtonStyle;
  ButtonStyle bsb = navButtonStyle;

  switch(ModalRoute.of(context)?.settings.name){
    case "/":
      camera = const Icon(Icons.video_camera_front_outlined);
      bsc = navButtonStyleHighLight;
      break;
    case "/avaliacoes":
      star = const Icon(Icons.star_outline);
      bss = navButtonStyleHighLight;
      break;
    case "/recomendacoes":
      bookmark = const Icon(Icons.bookmark_outline);
      bsb = navButtonStyleHighLight;
      break;
    default:
  }



  return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration( color: backColor,),
      height: 108,
      child:

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Column(
                children:[
              ElevatedButton(onPressed: () async {
                  int userId = (await UserDB.getLogged());
                  if(context.mounted && userId > -2) {
                    if (userId == -1) {
                      if (ModalRoute
                          .of(context)
                          ?.settings
                          .name
                          ?.compareTo("/cadastro") != 0) {
                        Navigator.popAndPushNamed(context, "/cadastro");
                      }
                    }
                    else{
                      if (ModalRoute
                          .of(context)
                          ?.settings
                          .name
                          ?.compareTo("/avaliacoes") != 0) {
                        Navigator.popAndPushNamed(
                          context,
                          '/avaliacoes',
                        );
                      }
                    }
                  }
              },
                style: bss,
                child: star,
              ),
              const Text("Avaliações", style: TextStyle(color: iconColor, fontWeight: FontWeight.bold)),
            ])
        ),
        Flexible(
            child: Column(
                children:[
                  ElevatedButton(onPressed: () {
                    if(ModalRoute.of(context)?.settings.name?.compareTo("/") != 0) {
                      Navigator.popAndPushNamed(
                        context,
                        '/',
                      );
                    }
                  },
                    style: bsc,
                    child: camera,
                  ),
                  const Text("Escanear", style: TextStyle(color: iconColor, fontWeight: FontWeight.bold)),
                ])
        ),
        Flexible(
            child: Column(
                children:[
                  ElevatedButton(onPressed: () async {
                    int userId = (await UserDB.getLogged());
                    if(context.mounted && userId > -2){
                      if( userId == -1){
                        if (ModalRoute.of(context)?.settings.name?.compareTo("/cadastro") != 0){
                          Navigator.popAndPushNamed(context, "/cadastro");
                        }
                      }
                      else{
                        if(ModalRoute.of(context)?.settings.name?.compareTo("/recomendacoes") != 0) {
                          Navigator.popAndPushNamed(
                            context,
                            '/recomendacoes',
                          );
                        }
                      }
                    }
                  },
                    style: bsb,
                    child: bookmark,
                  ),
                  const Text("Recomendações", style: TextStyle(color: iconColor, fontWeight: FontWeight.bold)),
                ])
        ),
      ],
    )
  );
}