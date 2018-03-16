//
//  main.cpp
//  heWaW Window
//
//  Created by Juan Beccaceci on 26/1/18.
//  Copyright © 2018 Juan Beccaceci. All rights reserved.
//

#include <iostream>
#include "MacOS/OSWindow.h"

int main(int argc, const char * argv[])
{
	std::cout << "Inicio la APP \n";

    OSWindow Window;
    if (!Window.createNativeWindow())
    {
        std::cout << "Error en la ventana";
    }
    
    while (!Window.getWindow()->Close)
    {

        Window.parseEvents();

    }

    std::cout << "Fin de la APP \n";
    return 0;
}
