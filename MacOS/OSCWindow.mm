////////////////////////////////////////////////////////////
/// Includes
////////////////////////////////////////////////////////////
#include "OSWindow.h"
#include "OSCWindow.h"

////////////////////////////////////////////////////////////
/// Main APP
////////////////////////////////////////////////////////////
@implementation MainApplication

////////////////////////////////////////////////////////////
/// Thread method
////////////////////////////////////////////////////////////
- (void)doNothing:(id)object
{
}
@end

////////////////////////////////////////////////////////////
/// APP Delegate
////////////////////////////////////////////////////////////
@implementation APPCDelegate
{
    sWindowBase * Window;
}

////////////////////////////////////////////////////////////
/// Initialize window
////////////////////////////////////////////////////////////
- (instancetype)initWindow:(sWindowBase *)iWindow
{
    self = [super init];
    if (self != nil)
        Window = iWindow;
    
    return self;
}

////////////////////////////////////////////////////////////
/// Finish launching method
////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [NSApp stop:nil];
    
    //  Empty event
    [Window->objMain EmptyEvent];
}

////////////////////////////////////////////////////////////
/// Will terminate method
////////////////////////////////////////////////////////////
- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    
    //    Se usa cuando la APP esta a punto de terminar
    
}

@end

////////////////////////////////////////////////////////////
/// Window Delegate
////////////////////////////////////////////////////////////
@implementation WindowDelegate

////////////////////////////////////////////////////////////
/// Initialize window
////////////////////////////////////////////////////////////
- (instancetype)initWindow:(sWindowBase *)iWindow
{
    self = [super init];
    if (self != nil)
        Window = iWindow;
    
    return self;
}

////////////////////////////////////////////////////////////
/// Window close
////////////////////////////////////////////////////////////
- (BOOL)windowShouldClose:(id)sender
{
    [Window->objMain DestroyWindow];
    
    //    Le avisa al delegado que cierra la ventana
    return NO;
}

////////////////////////////////////////////////////////////
/// Window dimension resize
////////////////////////////////////////////////////////////
- (void)windowDidResize:(NSNotification *)notification
{
    
    //    Le avisa al delegado que redimenciona la ventana
    
}

////////////////////////////////////////////////////////////
/// Window move
////////////////////////////////////////////////////////////
- (void)windowDidMove:(NSNotification *)notification
{
    
    //    Le avisa al delegado que mueve la ventana
    
}

////////////////////////////////////////////////////////////
/// Window minimize
////////////////////////////////////////////////////////////
- (void)windowDidMiniaturize:(NSNotification *)notification
{
    
    //    Le avisa al delegado que minimiza la ventana
    
}

////////////////////////////////////////////////////////////
/// Window maximize
////////////////////////////////////////////////////////////
- (void)windowDidDeminiaturize:(NSNotification *)notification
{
    
    //    Le avisa al delegado que maximiza la ventana
    
}

@end

////////////////////////////////////////////////////////////
/// OBJC Window functions
////////////////////////////////////////////////////////////
@implementation macOSWindow

////////////////////////////////////////////////////////////
/// Initialize window
////////////////////////////////////////////////////////////
- (instancetype)initWindow:(sWindowBase *)iWindow
{
    self = [super init];
    if (self != nil)
        Window = iWindow;
    
    return self;
}

////////////////////////////////////////////////////////////
///    Create OSX Window
////////////////////////////////////////////////////////////
- (BOOL)WindowCreate
{
    //    Window delegate
    Window->wDelegate = [[WindowDelegate alloc] initWindow:Window];
    if (Window->wDelegate == nil)
    {
        std::cout << "Error en WindowDelegate";
        return NO;
    }
    
    //    Make window rect
    NSRect windowRect = NSMakeRect(100, 100, 800, 400);
    
    //  Window style
    NSUInteger windowStyle = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable;
    
    //    Create window
    Window->cWindow = [[NSWindow alloc] initWithContentRect:windowRect
                                                  styleMask:windowStyle
                                                    backing:NSBackingStoreBuffered
                                                      defer:NO];
    if (Window->cWindow == nil)
    {
        std::cout << "Error en Create Window";
        return NO;
    }
    
    //    Window propertys
    [Window->cWindow center];
    [Window->cWindow setDelegate:Window->wDelegate];
    [Window->cWindow setTitle:@"Prueba cocoa WINDOW"];
    
    //  Show window
    [Window->cWindow orderFront:nil];
    
    [NSApp activateIgnoringOtherApps:YES];
    [Window->cWindow makeKeyAndOrderFront:nil];
    
    return YES;
}

////////////////////////////////////////////////////////////
///    Api toolkit initialize
////////////////////////////////////////////////////////////
- (BOOL)initCocoaAPI
{
    //    Create app instance
    [MainApplication sharedApplication];
    
    //    Make Cocoa enter multi-threaded mode
    [NSThread detachNewThreadSelector:@selector(doNothing:)
                             toTarget:NSApp
                           withObject:nil];
    
    //    App delegate
    Window->appDelegate = [[APPCDelegate alloc] initWindow:Window];
    if (Window->appDelegate == nil)
    {
        std::cout << "Error en APPDelegate";
        return false;
    }
    
    //    Asing delegate
    [NSApp setDelegate:Window->appDelegate];
    [NSApp run];
    
    return YES;
}

////////////////////////////////////////////////////////////
/// Pool empty event
////////////////////////////////////////////////////////////
- (void)EmptyEvent
{
    @autoreleasepool
    {
        NSEvent* event = [NSEvent otherEventWithType:NSEventTypeApplicationDefined
                                            location:NSMakePoint(0, 0)
                                       modifierFlags:0
                                           timestamp:0
                                        windowNumber:0
                                             context:nil
                                             subtype:0
                                               data1:0
                                               data2:0];
        [NSApp postEvent:event atStart:YES];
    }
}

////////////////////////////////////////////////////////////
/// Destroy current Window
////////////////////////////////////////////////////////////
- (void)DestroyWindow
{
    [Window->cWindow orderOut:nil];
    
    //  Delete window delegate
    [Window->cWindow setDelegate:nil];
    [Window->appDelegate release];
    Window->appDelegate = nil;
    
    //  Close window
    [Window->cWindow close];
    Window->cWindow = nil;
    
    //  Delete APP
    if (Window->appDelegate)
    {
        [NSApp setDelegate:nil];
        [Window->appDelegate release];
        Window->appDelegate = nil;
    }
    
    //  Event close
    Window->Close = true;
}

@end

///////////////////////////////////////////////////////////////
///    Constructor class
///////////////////////////////////////////////////////////////
OSWindow::OSWindow()
{
    //  Allocate memory
    Window = new sWindowBase;
    if (!Window)
        std::cout << "Error en memoria";
    
    //  Set empty data
    Window->appDelegate = nil;
    Window->cWindow = nil;
    Window->objMain = nil;
    Window->wDelegate = nil;
    Window->Close = false;
}

///////////////////////////////////////////////////////////////
///    Destructor class
///////////////////////////////////////////////////////////////
OSWindow::~OSWindow()
{
    
    if (Window)
        delete Window;
    
}

///////////////////////////////////////////////////////////////
///    Create native window
///////////////////////////////////////////////////////////////
bool OSWindow::createNativeWindow()
{
    if (Window)
    {
        //  Objetive C functions
        if (!Window->objMain)
            Window->objMain = [[macOSWindow alloc] initWindow:Window];
        
        //  Cocoa API
        if (!NSApp)
            [Window->objMain initCocoaAPI];
        
        //  Create window
        [Window->objMain WindowCreate];
        
        return true;
    }
    
    return false;
}

///////////////////////////////////////////////////////////////
///    Window events
///////////////////////////////////////////////////////////////
void OSWindow::parseEvents()
{
    @autoreleasepool
    {
        for (;;)
        {
            NSEvent* event = [NSApp nextEventMatchingMask:NSEventMaskAny
                                                untilDate:[NSDate distantPast]
                                                   inMode:NSDefaultRunLoopMode
                                                  dequeue:YES];
            if (event == nil)
                break;
            
            [NSApp sendEvent:event];
        }
    }
}

///////////////////////////////////////////////////////////////
///    Get window pointer
///////////////////////////////////////////////////////////////
sWindowBase * OSWindow::getWindow()
{
    
    return Window;
    
}

///////////////////////////////////////////////////////////////
///    Window destry
///////////////////////////////////////////////////////////////
void OSWindow::destroyWindow()
{
    if (Window)
        [Window->objMain DestroyWindow];
}
