# Copyright 2014 Patrick Dawson <pat@dw.is>
#
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

from sdl2 cimport *

def init():
    SDL_InitSubSystem(SDL_INIT_JOYSTICK)

def quit():
    SDL_QuitSubSystem(SDL_INIT_JOYSTICK)

def get_init():
    return SDL_WasInit(SDL_INIT_JOYSTICK)

def get_count():
    return SDL_NumJoysticks()


cdef class Joystick:
    cdef SDL_Joystick *joystick

    def __cinit__(self):
        self.joystick = NULL

    def __dealloc(self):
        if self.joystick and SDL_JoystickGetAttached(self.joystick):
            SDL_JoystickClose(self.joystick)

    def __init__(self, id):
        self.joystick = SDL_JoystickOpen(id)
        if self.joystick == NULL:
            raise ValueError(SDL_GetError())

    def init(self):
        pass

    def quit(self):
        pass

    def get_init(self):
        return True

    def get_id(self):
        return SDL_JoystickInstanceID(self.joystick)

    def get_name(self):
        return SDL_JoystickName(self.joystick)

    def get_numaxes(self):
        return SDL_JoystickNumAxes(self.joystick)

    def get_numballs(self):
        return SDL_JoystickNumBalls(self.joystick)

    def get_numbuttons(self):
        return SDL_JoystickNumButtons(self.joystick)

    def get_numhats(self):
        return SDL_JoystickNumHats(self.joystick)

    def get_axis(self, axis_number):
        return SDL_JoystickGetAxis(self.joystick, axis_number) / 32768.0

    def get_ball(self, ball_number):
        cdef int dx, dy
        if SDL_JoystickGetBall(self.joystick, ball_number, &dx, &dy) == 0:
            return (dx, dy)
        else:
            raise Exception(SDL_GetError())

    def get_button(self, button):
        return SDL_JoystickGetButton(self.joystick, button) == 1

    def get_hat(self, hat_number):
        state = SDL_JoystickGetHat(self.joystick, hat_number)
        hx = hy = 0
        if state & SDL_HAT_LEFT:
            hx = -1
        elif state & SDL_HAT_RIGHT:
            hx = 1

        if state & SDL_HAT_UP:
            hy = 1
        elif state & SDL_HAT_DOWN:
            hy = -1

        return (hx, hy)
