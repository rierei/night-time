Events:Subscribe('Partition:Loaded', function(partition)
    for _, instance in pairs(partition.instances) do
        if instance:Is('OutdoorLightComponentData') then
            local outdoor = OutdoorLightComponentData(instance)
            outdoor:MakeWritable()

            outdoor.sunColor = Vec3(0.01, 0.01, 0.01)
            outdoor.skyColor = Vec3(0.01, 0.01, 0.01)
            outdoor.groundColor = Vec3(0, 0, 0)

            outdoor.skyEnvmapShadowScale = 0.5
        end

        if instance:Is('SkyComponentData') then
            local sky = SkyComponentData(instance)
            sky:MakeWritable()

            sky.brightnessScale = 0.01
            sky.sunSize = 0.01
            sky.sunScale = 1

            sky.cloudLayer1SunLightIntensity = 0.01
            sky.cloudLayer1SunLightPower = 0.01
            sky.cloudLayer1AmbientLightIntensity = 0.01

            sky.cloudLayer2SunLightIntensity = 0.01
            sky.cloudLayer2SunLightPower = 0.01
            sky.cloudLayer2AmbientLightIntensity = 0.01

            sky.staticEnvmapScale = 0.1
            sky.skyEnvmap8BitTexScale = 0.8

            if sky.partition.name:match('mp_subway') or sky.partition.name:match('mp_011') then
                sky.staticEnvmapScale = 0.01
            end

            if sky.partition.name:match('mp_subway_subway') then
                sky.staticEnvmapScale = 0.1

                ResourceManager:RegisterInstanceLoadHandlerOnce(Guid('36536A99-7BE3-11E0-8611-A913E18AE9A4'), Guid('64EE680C-405E-2E81-E327-6DF58605AB0B'), function(loadedInstance)
                    sky.staticEnvmapTexture = TextureAsset(loadedInstance)
                end)
            end
        end

        if instance:Is('FogComponentData') then
            local fog = FogComponentData(instance)
            fog:MakeWritable()

            fog.fogColor = Vec3(0.02, 0.02, 0.02)
        end

        if instance:Is('TonemapComponentData') then
            local tonemap = TonemapComponentData(instance)
            tonemap:MakeWritable()

            tonemap.minExposure = 2
            tonemap.maxExposure = 4

            tonemap.exposureAdjustTime = 0.5
            tonemap.middleGray = 0.02

            tonemap.tonemapMethod = TonemapMethod.TonemapMethod_FilmicNeutral
        end

        if instance:Is('ColorCorrectionComponentData') then
            local color = ColorCorrectionComponentData(instance)
            color:MakeWritable()

            if instance.partition.name:match('menuvisualenvironment') then
                color.brightness = Vec3(1, 1, 1)
                color.contrast = Vec3(1, 1, 1)
                color.saturation = Vec3(0.5, 0.5, 0.5)
            end

            if instance.partition.name:match('outofcombat') then
                color.contrast = Vec3(0.9, 0.9, 0.9)
            end
        end

        if instance:Is('EnlightenComponentData') then
            local enlighten = EnlightenComponentData(instance)
            enlighten:MakeWritable()

            enlighten.enable = false
        end

        if instance:Is('SunFlareComponentData') then
            local flare = SunFlareComponentData(instance)
            flare:MakeWritable()

            flare.excluded = true
        end
    end
end)