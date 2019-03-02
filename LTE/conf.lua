function love.conf(t)
    --No need for a default start up window size
    t.window.title = "Example"
    t.window.icon = nil
    t.window.width = 400
    t.window.height = 400
    t.window.resizable = true --flexibility
    t.window.minwidth = 400
    t.window.minheight = 400

    t.console = true -- debugging purposes

    --we need these modules:
    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.keyboard = true --do we need keyboard, if we already have events?
    t.modules.mouse = true --do we need mouse, if we already have events?
    t.modules.window = true

    --we don't need these modules:
    t.modules.audio = false --Do we need audio?
    t.modules.sound = false --Do we need sound? What's the difference
    t.modules.image = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.system = false
    t.modules.thread = false
    t.modules.timer = false
    t.modules.touch = false
    t.modules.video = false
    
end