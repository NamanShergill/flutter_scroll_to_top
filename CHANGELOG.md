## [2.0.0] - 21 November 2021.
- *BREAKING CHANGE* - Replaced `child` parameter with `builder`.
- Added `scrollDirection`, `primary`, `alwaysVisibleAtOffset` parameters.
- Made `scrollController` parameter nullable and added `PrimaryScrollController.of(context)` fallback.
- Better behaviour for horizontal scrollviews.
- Changed default behaviour to show prompt on upwards scroll. Can be disabled by setting `alwaysVisibleAtOffset` to false.
- Made `ScrollWrapper` and `PromptButtonTheme` constructors const.

## [1.2.0] - 21 November 2021.

- Added elevation to `PromptButtonTheme`
- Added `AppBarTheme`'s colors as default to the button, so it matches the AppBar
- Added a `didUpdateWidget` override, so the `PromptButtonTheme` updates on hot reload

## [1.1.0] - 18 April 2021.

* Added `promptAnimationType` to specify the kind of animation the prompt shows up with.

## [1.0.6] - 17 April 2021.

* Added `scrollToTopDuration` and `scrollToTopCurve` parameters.

## [1.0.5] - 17 April 2021.

* Alignment fix.

## [1.0.4] - 17 April 2021.

* Removed promptTheme assert.

## [1.0.3] - 17 April 2021.

* Updated description.

## [1.0.0] - 17 April 2021.

* Initial Release.
