local enlightenGuid = Guid('2422B27D-693F-4B66-A869-C873AF04FE42', 'D')
local fogGuid = Guid('37D8977A-9D12-445A-8214-757752E02108', 'D')
local sunFlareGuid = Guid('314DFD9A-C8D6-4249-AE32-92FDD1F5E07C', 'D')
local characterLightingGuid = Guid('A04E9F4F-463F-4309-87FD-72B71F0DD90B', 'D')

local flashLight1PGuid = Guid('995E49EE-8914-4AFD-8EF5-59125CA8F9CD', 'D')
local flashLight3PGuid = Guid('5FBA51D6-059F-4284-B5BB-6E20F145C064', 'D')

local function patchEnlighten(instance)
	if instance == nil then
		return
	end

	local enlighten = EnlightenComponentData(instance)
	enlighten:MakeWritable()

	enlighten.enable = false
end

local function patchFog(instance)
	if instance == nil then
		return
	end

	local fog = FogComponentData(instance)
	fog:MakeWritable()

	fog.start = 20
	fog.endValue = 2500

	fog.enable = false
	fog.fogColorEnable = false
end

local function patchSunFlare(instance)
	if instance == nil then
		return
	end

	local sunFlare = SunFlareComponentData(instance)
	sunFlare:MakeWritable()

	sunFlare.enable = true
	sunFlare.element1Enable = false
	sunFlare.element2Enable = false
	sunFlare.element3Enable = false
	sunFlare.element4Enable = false
	sunFlare.element5Enable = false
end

local function patchCharacterLighting(instance)
	if instance == nil then
		return
	end

	local lighting = CharacterLightingComponentData(instance)
	lighting:MakeWritable()

	lighting.characterLightEnable = false
	lighting.topLight = Vec3(0, 0, 0)
end

local function patchFlashLight(instance)
	if instance == nil then
		return
	end

	local spotLight = SpotLightEntityData(instance)
	instance:MakeWritable()

	spotLight.radius = 100
	spotLight.intensity = 2
	spotLight.coneOuterAngle = 80
	spotLight.orthoWidth = 5
	spotLight.orthoHeight = 5
	spotLight.frustumFov = 50
	spotLight.castShadowsEnable = true
	spotLight.castShadowsMinLevel = QualityLevel.QualityLevel_Low
end

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

            fog.fogColor = Vec3(0.1, 0.1, 0.1)
        end

        if instance:Is('TonemapComponentData') then
            local tonemap = TonemapComponentData(instance)
            tonemap:MakeWritable()

            tonemap.maxExposure = 4
            tonemap.middleGray = 0.02
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

        if instance.instanceGuid == flashLight1PGuid then
            patchFlashLight(instance)
        elseif instance.instanceGuid == flashLight3PGuid then
            patchFlashLight(instance)
		elseif instance.instanceGuid == enlightenGuid then
			patchEnlighten(instance)
        elseif instance.instanceGuid == fogGuid then
			patchFog(instance)
		elseif instance.instanceGuid == sunFlareGuid then
			patchSunFlare(instance)
        elseif instance.instanceGuid == characterLightingGuid then
			patchCharacterLighting(instance)
        end

    end
end)
