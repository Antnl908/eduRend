
Texture2D texDiffuse : register(t0);

struct PSIn
{
	float4 Pos  : SV_Position;
	float3 Normal : NORMAL;
	float2 TexCoord : TEX;
};

cbuffer CameraAndLightBuffer : register(b0)
{
    float4 cameraPos;
    float4 lightPos;
};

cbuffer MaterialBuffer : register(b1)
{
    float4 ambient;
    float4 diffuse;
    float4 specular;
};

//-----------------------------------------------------------------------------------------
// Pixel Shader
//-----------------------------------------------------------------------------------------

float4 PS_main(PSIn input) : SV_Target
{
	// Debug shading #1: map and return normal as a color, i.e. from [-1,1]->[0,1] per component
	// The 4:th component is opacity and should be = 1
	
	return float4(input.Normal*0.5+0.5, 1);
	
	//ambient + summa av diffuse + specular
    float4 dir = normalize(lightPos - input.Pos);
	//skalär av normalen och dir
    float dif = dor(input.Normal, dir);

    ambient + (diffuse * dif) + (specular * )

    return float4(input.Normal * 0.5 + 0.5, 1);
	
	// Debug shading #2: map and return texture coordinates as a color (blue = 0)
//	return float4(input.TexCoord, 0, 1);
}

//float4 PS_Phong(PSIn input) : SV_Target
//{
//	// Debug shading #1: map and return normal as a color, i.e. from [-1,1]->[0,1] per component
//	// The 4:th component is opacity and should be = 1

//	//ambient + summa av diffuse + specular
//    float4 dir = normalize(lightPos - Pos);
//	//skalär av normalen och dir
//    float dif = dor(Normal, dir);

//    ambient + (diffuse * dif) + (specular * )

//    return float4(input.Normal * 0.5 + 0.5, 1);
	
//	// Debug shading #2: map and return texture coordinates as a color (blue = 0)
////	return float4(input.TexCoord, 0, 1);
//}