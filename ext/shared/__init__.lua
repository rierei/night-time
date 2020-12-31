Events:Subscribe('Partition:Loaded', function(partition)
    for _, instance in pairs(partition.instances) do
        if instance:Is('OutdoorLightComponentData') then
            PatchOutdoorLightComponentData(instance)
        elseif instance:Is('SkyComponentData') then
            PatchSkyComponentData(instance)
        elseif instance:Is('FogComponentData') then
            PatchFogComponentData(instance)
        elseif instance:Is('TonemapComponentData') then
            PatchTonemapComponentData(instance)
        elseif instance:Is('ColorCorrectionComponentData') then
            PatchColorCorrectionComponentData(instance)
        elseif instance:Is('EnlightenComponentData') then
            PatchEnlightenComponentData(instance)
        elseif instance:Is('SunFlareComponentData') then
            PatchSunFlareComponentData(instance)
        elseif instance:Is('MeshAsset') then
            PatchMeshAsset(instance)
        elseif instance:Is('MeshMaterialVariation') then
            PatchMeshMaterialVariation(instance)
        elseif instance:Is('EmitterTemplateData') then
            PatchEmitterTemplateData(instance)
        end
    end
end)

function PatchOutdoorLightComponentData(instance)
    local outdoor = OutdoorLightComponentData(instance)
    outdoor:MakeWritable()

    outdoor.sunColor = Vec3(0.01, 0.01, 0.01)
    outdoor.skyColor = Vec3(0.01, 0.01, 0.01)
    outdoor.groundColor = Vec3(0, 0, 0)

    outdoor.skyEnvmapShadowScale = 0.5
end

function PatchSkyComponentData(instance)
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

function PatchFogComponentData(instance)
    local fog = FogComponentData(instance)
    fog:MakeWritable()

    fog.fogColor = Vec3(0.02, 0.02, 0.02)
end

function PatchTonemapComponentData(instance)
    local tonemap = TonemapComponentData(instance)
    tonemap:MakeWritable()

    tonemap.minExposure = 2
    tonemap.maxExposure = 4

    tonemap.exposureAdjustTime = 0.5
    tonemap.middleGray = 0.02

    tonemap.tonemapMethod = TonemapMethod.TonemapMethod_FilmicNeutral
end

function PatchColorCorrectionComponentData(instance)
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

function PatchEnlightenComponentData(instance)
    local enlighten = EnlightenComponentData(instance)
    enlighten:MakeWritable()

    enlighten.enable = false
end

function PatchSunFlareComponentData(instance)
    local flare = SunFlareComponentData(instance)
    flare:MakeWritable()

    flare.excluded = true
end

function PatchMeshAsset(instance)
    if
        instance.partition.name:match('mp_subway/objects/backdrops/mp_subway_smokepillar02') or
        instance.partition.name:match('mp_subway/objects/backdrops/mp15_smokepillarwhite_01') or
        instance.partition.name:match('mp_011/objects/mp011_backdrop') or
        instance.partition.name:match('mp_012/terrain/mp012_matte') or
        instance.partition.name:match('mp_012/objects/smokestacks') or
        instance.partition.name:match('mp_013/props/mp013_cloudlayer') or
        instance.partition.name:match('mp_018/terrain/mp018_matte')
    then
        local mesh = MeshAsset(instance)
        mesh:MakeWritable()

        for _, value in pairs(mesh.materials) do
            value:MakeWritable()
            value.shader.shader = nil
        end
    end
end

function PatchMeshMaterialVariation(instance)
    if instance.partition.name:match('mp_012/objects/smokestacks') then
        local variation = MeshMaterialVariation(instance)
        variation:MakeWritable()
        variation.shader.shader = nil
    end
end

function PatchEmitterTemplateData(instance)

    if
        -- MP_Subway
        instance.partition.name == 'fx/ambient/levelspecific/mp15/emitters/em_amb_mp15_background_smokepillar_m_01' or

        -- MP_007
        instance.partition.name == 'fx/ambient/levelspecific/mp_07/emitters/em_mp7_distancemist_xxl_smoke' or
        instance.partition.name == 'fx/ambient/levelspecific/mp_07/emitters/em_mp7_battlesmoke_xl_smoke' or
        instance.partition.name == 'fx/ambient/levelspecific/mp_07/emitters/em_amb_mp_07_godrays_01' or

        -- MP_013
        instance.partition.name == 'fx/ambient/levelspecific/mp_013/emitters_clouds/em_amb_mp_013_clouds_area_s_01' or
        instance.partition.name == 'fx/ambient/levelspecific/mp_013/emitters_clouds/em_amb_mp_013_clouds_background_area_s_01' or
        instance.partition.name == 'fx/ambient/levelspecific/mp_013/emitters_clouds/em_amb_mp_013_clouds_background_downwards_area_s_01' or
        instance.partition.name == 'fx/ambient/levelspecific/mp_013/emitters_clouds/em_amb_mp_013_clouds_jumpthrough_01' or

        -- MP_018
        instance.partition.name == 'levels/mp_018/fx/em_fogarea_smoke_m' or
        instance.partition.name == 'levels/mp_018/fx/em_fogarea_smoke_xl' or
        instance.partition.name == 'levels/mp_018/fx/em_fogarea_lowend_smoke_m' or
        instance.partition.name == 'levels/mp_018/fx/em_fogarea_lowend_smoke_xl'
    then
        local template = EmitterTemplateData(instance)
        template:MakeWritable()

        template.emissive = false
    end
end