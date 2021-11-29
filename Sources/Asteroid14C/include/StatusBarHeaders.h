#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface _UIStatusBarItem : NSObject {

    BOOL _needsUpdate;
    NSMutableDictionary *_displayItems;
}
@property (nonatomic, retain) NSMutableDictionary *displayItems; //@synthesize displayItems=_displayItems - In the implementation block
@property (nonatomic, readonly) NSSet *dependentEntryKeys;
@property (nonatomic, readonly) BOOL needsUpdate; //@synthesize needsUpdate=_needsUpdate - In the implementation block
+ (id)displayItemIdentifierFromString:(id)arg1;
+ (id)defaultDisplayIdentifier;
+ (id)identifier;
+ (Class)itemClassForIdentifier:(id)arg1;
+ (id)displayItemIdentifierFromIdentifier:(id)arg1 string:(id)arg2;
+ (id)itemIdentifierFromString:(id)arg1;
+ (id)itemIdentifierForDisplayItemIdentifier:(id)arg1;
+ (id)createItemForIdentifier:(id)arg1 statusBar:(id)arg2;
- (BOOL)needsUpdate;
- (void)applyStyleAttributes:(id)arg1 toDisplayItem:(id)arg2;
- (void)prepareAnimation:(id)arg1 forDisplayItem:(id)arg2;
- (id)overriddenStyleAttributesForData:(id)arg1 identifier:(id)arg2;
- (BOOL)canEnableDisplayItem:(id)arg1 fromData:(id)arg2;
- (NSSet *)dependentEntryKeys;
- (id)viewForIdentifier:(id)arg1;
- (void)updatedDisplayItemsWithData:(id)arg1;
- (id)displayItemForIdentifier:(id)arg1;
- (id)additionAnimationForDisplayItemWithIdentifier:(id)arg1;
- (void)setDisplayItems:(NSMutableDictionary *)arg1;
- (id)_applyUpdate:(id)arg1 toDisplayItem:(id)arg2;
- (id)description;
- (id)initWithIdentifier:(id)arg1 statusBar:(id)arg2;
- (id)removalAnimationForDisplayItemWithIdentifier:(id)arg1;
- (id)createDisplayItemForIdentifier:(id)arg1;
- (void)setNeedsUpdate;
- (NSMutableDictionary *)displayItems;
- (id)applyUpdate:(id)arg1 toDisplayItem:(id)arg2;
@end

@interface _UIStatusBarStringView : UILabel {

    BOOL _showsAlternateText;
    long long _fontStyle;
    NSString *_alternateText;
    NSString *_originalText;
    NSTimer *_alternateTextTimer;
    UIEdgeInsets _alignmentRectInsets;
}
@property (nonatomic, assign) BOOL isTime;
@property (nonatomic, assign) BOOL isCarrier;
@property (nonatomic) CGRect origFrame;
@property (assign, nonatomic) BOOL showsAlternateText; //@synthesize showsAlternateText=_showsAlternateText - In the implementation block
@property (nonatomic, copy) NSString *originalText; //@synthesize originalText=_originalText - In the implementation block
@property (nonatomic, readonly) NSTimer *alternateTextTimer; //@synthesize alternateTextTimer=_alternateTextTimer - In the implementation block
@property (assign, nonatomic) long long fontStyle; //@synthesize fontStyle=_fontStyle - In the implementation block
@property (assign, nonatomic) UIEdgeInsets alignmentRectInsets; //@synthesize alignmentRectInsets=_alignmentRectInsets - In the implementation block
@property (nonatomic, copy) NSString *alternateText; //@synthesize alternateText=_alternateText - In the implementation block
@property (nonatomic, readonly) BOOL wantsCrossfade;
@property (nonatomic, readonly) BOOL prefersBaselineAlignment;
@property (nonatomic, readonly) long long overriddenVerticalAlignment;
@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;
@property (copy, readonly) NSString *description;
@property (copy, readonly) NSString *debugDescription;
- (void)setFontStyle:(long long)arg1;
- (BOOL)prefersBaselineAlignment;
- (void)applyStyleAttributes:(id)arg1;
- (UIEdgeInsets)alignmentRectInsets;
- (long long)fontStyle;
- (void)didMoveToWindow;
- (NSString *)originalText;
- (void)setText:(id)arg1;
- (void)setAlternateText:(NSString *)arg1;
- (BOOL)wantsCrossfade;
- (NSTimer *)alternateTextTimer;
- (void)setAlignmentRectInsets:(UIEdgeInsets)arg1;
- (BOOL)showsAlternateText;
- (NSString *)alternateText;
- (void)setShowsAlternateText:(BOOL)arg1;
- (void)setOriginalText:(NSString *)arg1;
- (id)initWithFrame:(CGRect)arg1;
- (void)_updateAlternateTextTimer;
@end

@interface _UIStatusBarTimeItem : _UIStatusBarItem {

    _UIStatusBarStringView *_timeView;
    _UIStatusBarStringView *_shortTimeView;
    _UIStatusBarStringView *_pillTimeView;
    _UIStatusBarStringView *_dateView;
}
@property (nonatomic, retain) _UIStatusBarStringView *timeView; //@synthesize timeView=_timeView - In the implementation block
@property (nonatomic, retain) _UIStatusBarStringView *shortTimeView; //@synthesize shortTimeView=_shortTimeView - In the implementation block
@property (nonatomic, retain) _UIStatusBarStringView *pillTimeView; //@synthesize pillTimeView=_pillTimeView - In the implementation block
@property (nonatomic, retain) _UIStatusBarStringView *dateView; //@synthesize dateView=_dateView - In the implementation block
+ (id)shortTimeDisplayIdentifier;
+ (id)timeDisplayIdentifier;
+ (id)pillTimeDisplayIdentifier;
+ (id)dateDisplayIdentifier;
- (_UIStatusBarStringView *)timeView;
- (_UIStatusBarStringView *)dateView;
- (void)setDateView:(_UIStatusBarStringView *)arg1;
- (void)setPillTimeView:(_UIStatusBarStringView *)arg1;
- (_UIStatusBarStringView *)pillTimeView;
- (id)dependentEntryKeys;
- (void)setShortTimeView:(_UIStatusBarStringView *)arg1;
- (id)viewForIdentifier:(id)arg1;
- (_UIStatusBarStringView *)shortTimeView;
- (void)_create_dateView;
- (void)_create_shortTimeView;
- (void)_create_timeView;
- (void)_create_pillTimeView;
- (void)setTimeView:(_UIStatusBarStringView *)arg1;
- (id)applyUpdate:(id)arg1 toDisplayItem:(id)arg2;
@end

@interface _UIStatusBarCellularItem : _UIStatusBarItem {

    BOOL _showsDisabledSignalBars;
    BOOL _marqueeServiceName;
    _UIStatusBarStringView *_serviceNameView;
    _UIStatusBarStringView *_networkTypeView;
    _UIStatusBarStringView *_rawStringView;
}
@property (nonatomic, readonly) NSString *cellularDataEntryKey;
@property (nonatomic, retain) _UIStatusBarStringView *serviceNameView; //@synthesize serviceNameView=_serviceNameView - In the implementation block
@property (nonatomic, retain) _UIStatusBarStringView *networkTypeView; //@synthesize networkTypeView=_networkTypeView - In the implementation block
@property (assign, nonatomic) BOOL showsDisabledSignalBars; //@synthesize showsDisabledSignalBars=_showsDisabledSignalBars - In the implementation block
@property (assign, nonatomic) BOOL marqueeServiceName; //@synthesize marqueeServiceName=_marqueeServiceName - In the implementation block
+ (id)rawDisplayIdentifier;
+ (id)signalStrengthDisplayIdentifier;
+ (id)typeDisplayIdentifier;
+ (id)nameDisplayIdentifier;
+ (id)sosDisplayIdentifier;
+ (id)warningDisplayIdentifier;
+ (id)callForwardingDisplayIdentifier;
+ (id)groupWithHighPriority:(long long)arg1 lowPriority:(long long)arg2 typeClass:(Class)arg3 allowDualNetwork:(BOOL)arg4;
- (void)_create_callForwardingView;
- (_UIStatusBarStringView *)networkTypeView;
- (NSString *)cellularDataEntryKey;
- (void)_create_signalView;
- (void)prepareAnimation:(id)arg1 forDisplayItem:(id)arg2;
- (BOOL)showsDisabledSignalBars;
- (void)_create_sosView;
- (id)dependentEntryKeys;
- (id)viewForIdentifier:(id)arg1;
- (void)_create_serviceNameView;
- (void)_create_rawStringView;
- (void)_create_warningView;
- (void)setServiceNameView:(_UIStatusBarStringView *)arg1;
- (void)setNetworkTypeView:(_UIStatusBarStringView *)arg1;
- (void)_create_networkTypeView;
- (void)setRawStringView:(_UIStatusBarStringView *)arg1;
- (void)setShowsDisabledSignalBars:(BOOL)arg1;
- (BOOL)marqueeServiceName;
- (id)initWithIdentifier:(id)arg1 statusBar:(id)arg2;
- (id)_stringForCellularType:(long long)arg1;
- (void)setmarqueeServiceName:(BOOL)arg1;
- (BOOL)_showCallFowardingForEntry:(id)arg1;
- (_UIStatusBarStringView *)rawStringView;
- (void)setMarqueeServiceName:(BOOL)arg1;
- (id)applyUpdate:(id)arg1 toDisplayItem:(id)arg2;
- (id)entryForDisplayItemWithIdentifier:(id)arg1;
- (_UIStatusBarStringView *)serviceNameView;
- (id)_fillColorForUpdate:(id)arg1 entry:(id)arg2;
- (BOOL)_updateSignalView:(id)arg1 withUpdate:(id)arg2 entry:(id)arg3 forceShowingDisabledSignalBars:(BOOL)arg4;
@end