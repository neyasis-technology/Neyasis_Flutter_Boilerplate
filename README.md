#Neyasis Flutter Boilerplate

Project files ;

* <strong>assets</strong> - It is the file where the translation and image files part of the project is.
* <strong>components</strong> - This is the folder where the project's Component files are. The components under this must be completely global components. Screen components should be added to the folder under screens.
* <strong>constants</strong> - The constants file is generally the file in which enums, utils, global static variables are kept.
* <strong>helpers</strong> - The Helpers file is the file where the auxiliary classes used in the project are brought together. If an auxiliary function is to be written, it must be defined under functions.dart, in other words AppFunctions under this file.
* <strong>model</strong> - It is the file with our Bloc and Application models.
* <strong>repository</strong> - This is the folder where the Bloc and HttpClient repository files are located. According to the flow of the project, extra repositories should be added to this file.
* <strong>storage</strong> - We should manage databases and local storages functions in this file.
* <strong>bloc</strong> - We should call the API or call the MethodChannels on this file. We must generate all of our bloc classes. We musn't call API on our screen.

<hr/>
<center><b style="color:red" >Libraries</b></center>

| Library  | Information  |
|--|---|
| <a href="https://pub.dev/packages/rxdart">rxdart</a>  |This library help us about using observable pattern.   |
| <a href="https://pub.dev/packages/uuid">uuid</a>   |We created our guid from this package. It's helping us to make unique request on bloc model.   |
| <a href="https://pub.dev/packages/cached_network_image">cached_network_image</a>   |This package help us about cache the images. For example when u show a image in your app. The image is downloading and store a file. When you trigger your second request about image. This library going to read image from your storage.   |
| <a href="https://pub.dev/packages/dio">dio</a>   |This package help us the network processes. |
| <a href="https://pub.dev/packages/flutter_screenutil">flutter_screenutil</a>   |You know that, we have big issue about UX. When we write a Text component from any fontSize, this fontSize hasn't change every screen size. So we should create a logic about screen size to generate fontSize. This package help us about that. Cuz when we use this library we set the value which we create our UX from which screen size. After then, the package will change our fontSize the diffrent screen sizes. |
| <a href="https://pub.dev/packages/shared_preferences">shared_preferences</a>   |If we want to store key value parameter we can use this library. It's not a database but this library can store your key value variables.|
| <a href="https://pub.dev/packages/easy_localization">easy_localization</a>   |This library help us about localization.|
| <a href="https://pub.dev/packages/flutter_spinkit">flutter_spinkit</a>   |If we want to show any spinner(indicator) on our project. We can use this library. This library is very easy for use.|

<hr/>
<center><b style="color:red">Helpers</b></center>

<b>Alerts </b>
If we want to show any alert from our project we can use this helper. You don't need any context to use this helper. So you can show any alert from where u want to show.

<b>Device Info </b>
When we create a component from device size percent we can use this helper functions. 

<b>Functions </b>
We should write our helper single functions on this class. For example, jwtClaims parser, some mathematical functions etc.

<b>Http Client </b>
If u want to make any network request, you should use this helper. Cuz this helper written with authentications, logging etc. You don't need anything for make network requests. There is parser about query param on get requests. You don't need make a query params when u make request. You can do it from your Map<String,dynamic> object.

<center><b style="color:red">About customize bloc pattern</b></center>

We keept a issue about this pattern. We should write PublishSubject every classes and we can't do any single process on our bloc. For example if u create a money input and you calculate something on every money input change event you got a issue. The issue is when u press every number you should create a request. And you need last request from the requests but the server may not give u last request. Because your request join a queue on the server side. The most recent request may be the first to be answered. And it's a big issue for you. If we tell through an example story.

We want to calculate usd to try rate. Suppose 1 by 10.
When we press 1 the result should be -> 10 and request time 1 sec
When we press 2 the result should be -> 120 and request time 0.5
When we press 0 the result should be -> 1.200 and request time 0.75

So we will see "10" on our screen. But we need "1.200" from this example. In this issue, you should override the last 2 request or stop the requests. You can do it in this custom bloc pattern. 


```dart
abstract class BlocRepository<RequestObject, ResponseObject> 
```

When you extend this Repository you should set a RequestObject and ResponseObject model or type.

<h4><b style="color:red">Learn methods and variables</b></h4>
- About <strong>process</strong> method

```dart
  @override
  Future process(String lastRequestUniqueId) async {
    
  }
```

The process method working when u call <strong>block.call(requestObject:YourRequestClassOrType());</strong>. When this process end you should sink your result object for refresh your StreamBuilder. If you don't call <strong>fetcherSink</strong> method your StreamBuilder will not refresh. One thing more if you want to clear store bloc, sink your store on your component  when you call your bloc. Then you should use <strong>sinkNullObject</strong> variable on your call method. For Example <strong>bloc.call(sinkNullObject: true);</strong>.

- About <strong>lastRequestUniqueId</strong> variable

```dart
  @override
  Future process(String lastRequestUniqueId) async {
      this.fetcherSink(null, lastRequestUniqueId: lastRequestUniqueId);
  }
```

if u sink with lastRequestUniqueId your store, the old requests will be override so you can solve this problem like this. It's a generic repository you can set your call bloc model and store model.

- About <strong>isBlocHandling</strong> variable

The isBlocHandling variable give information to you about is process working or process ended. When your bloc process ended this variable value setting false. For example; when you call an API your process working asynchronous so you should show a spiner or etc in your component. Then you should use this variable on your StreamBuilder when your builder rerendered.

- About <strong>setStore</strong> function

If you want to set a store without call method or in your constructor (Maybe if u want set default store). You should use setStore function on your constructor etc.

- About <strong>clearStore</strong> function

If you want to clear store in your application (anywhere) you should use this function.

- About <strong>setListener</strong> callback

If you want to listen the store variable, you should use this function. For example; if you want to listen your store and want show a toast message from store changes, you should write a listener and listen your store.

```dart
  @override
  initState(){
    bloc.setListener((MyStore? store) {
      if(store==null&&store.showToast) {
        Fluttertoast.showToast(
          msg: "Test test test",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: ScreenUtil().setSp(17),
        );
      }
    });
    super.initState();
  }
```

Note: In the Flutter 2 versiyon we cant sink null variable on our PublishSubject so i use the addError method for it. I'll fix this issue when we sink null object on our PublishSubject.



<center><b style="color:red">CI/CD Scripts And .env.json Folder</b></center>

We have big issue about control development modes and CI/CD  bundleId/applicationId name changes. We solve our problem in those scripts.We have four application mode. They are Development, Test, UAT and last one is production. The operations that we can easily perform with this file are as follows.

- We can set our API base url every application mode.
- We can set our versionName and versionCode variables about android and ios operation system on this file.
- We can set our keystore variables and files for every application mode.
- We can set our Google services files every application mode also.

This environment changing when u rebuild your project. We have some scripts. In android we use gradle scripts. In IOS we use Javascript (NodeJS) script. If you want to check scripts you see them on rootFolder which name is project_scripts folder. We created from dart language which we use coding flutter but we got some errors on this script. After then, we changed it from dart to javascript (nodejs). We have a goal change it to swift or dart.