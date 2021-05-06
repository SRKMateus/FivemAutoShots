RegisterServerEvent('TakeScreenShotSRK')
AddEventHandler('TakeScreenShotSRK',function(name)
    exports['screenshot-basic']:requestClientScreenshot(source, {
        fileName = 'cache/'..name..'.jpg'
    }, function(err, data)
    end)
end)