#ifndef _WINDOW_TYPE
#define _WINDOW_TYPE

////////////////////////////////////////////////////////////
/// Includes
////////////////////////////////////////////////////////////
#include "../Platform/Platform.h"

#if defined(__OBJC__)
#   import <Carbon/Carbon.h>
#   import <Cocoa/Cocoa.h>
#else
#   include <Carbon/Carbon.h>
#   include <ApplicationServices/ApplicationServices.h>
typedef void* id;
#endif

#if (PLATFORM_TYPE == PLATFORM_WINDOWS)

////////////////////////////////////////////////////////////
/// Base window MacOS
////////////////////////////////////////////////////////////
struct sWindowBase
{
    id cWindow;
    id wDelegate;
    id appDelegate
};

#elif (PLATFORM_TYPE == PLATFORM_LINUX)

////////////////////////////////////////////////////////////
/// Base window MacOS
////////////////////////////////////////////////////////////
struct sWindowBase
{
    id cWindow;
    id wDelegate;
    id appDelegate
};

#elif (PLATFORM_TYPE == PLATFORM_MACOS)

////////////////////////////////////////////////////////////
/// Base window MacOS
////////////////////////////////////////////////////////////
struct sWindowBase
{
	id cWindow;
	id wDelegate;
    id appDelegate;
    id objMain;
    int Close;
};

#endif

#endif // > _WINDOW_DATA
