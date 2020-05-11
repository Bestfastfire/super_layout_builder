# Super Layout Builder
Check it out at [Pub.Dev](https://pub.dev/packages/super_layout_builder)

The best way to create responsive layouts for dynamic screen sizes.

*Note: This library was designed for the web version of the flutter, since web pages, unlike cell phone applications, can be resized several times in a row by the user.

### SuperLayoutBuilder
![ezgif com-video-to-gif](https://user-images.githubusercontent.com/22732544/81522137-dd0b5c80-931f-11ea-9a5e-5f2d4067fb10.gif)

### LayoutBuilder
![ezgif com-video-to-gif (1)](https://user-images.githubusercontent.com/22732544/81522150-ec8aa580-931f-11ea-80b1-8210793f514f.gif)

## Getting Started
The implementation is very simple, just call the widget passing your other widget as a child.

    SuperLayoutBuilder(
      triggerWidth: [ // Pass list of sizes to compare
        850
      ],
      triggerHeight: [
        500
      ],
      builder: (c, MediaQueryData m) => MyWidget(),
    )

### Triggers
When passing values ​​to the list of triggers, when the screen is resized, it will be checked if the new screen size is smaller or larger than one of the list sizes, thus only redoing the screen when it hits a specific point, preventing the screen be redone for each modified px.
From the return of MediaQueryData, you can for example compare if the current screen size is already feasible to use a drawer as in the example at the beginning.

## Help Maintenance

I've been maintaining quite many repos these days and burning out slowly. If you could help me cheer up, buying me a cup of coffee will make my life really happy and get much energy out of it.

<a href="https://www.buymeacoffee.com/RtrHv1C" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>
