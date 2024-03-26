
Texture2D texDiffuse : register(t0);

struct PSIn
{
	float4 Pos  : SV_Position;
	float3 Normal : NORMAL;
	float2 TexCoord : TEX;
	float3 PosWorld : WORLD_POSITION;
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
	
	//return float4(input.Normal*0.5+0.5, 1);


	/*float3 lightDir = normalize(lightPos.xyz - input.PosWorld);
	float3 viewDir = normalize(cameraPos.xyz - input.PosWorld);
	float3 reflDir = reflect(-lightDir, input.Normal);
	float diffFac = max(0.0f, dot(input.Normal, lightDir));

	float specFac = pow(max(0.0f, dot(reflDir, viewDir)), 64);

	float4 finalC = float4(diffFac + specFac, diffFac + specFac, diffFac + specFac, 1.0f);

	return finalC;*/
	
	//ambient + summa av diffuse + specular
    //float4 L = normalize(lightPos - input.PosWorld);
    float3 L = normalize(lightPos.xyz - input.PosWorld);
	//skalär av normalen och dir
    float LN = max(0.0f, dot(input.Normal, L));

	float3 R = reflect(-L, input.Normal);

	//float4 V = normalize(cameraPos - input.PosWorld);
	float3 V = normalize(cameraPos.xyz - input.PosWorld);

	//float  RV = pow(max( 0.0f, dot(R, V) - 0.03f), 64.0f);
	float  RV = pow(max( 0.0f, dot(R, V) - 0.03f), specular.w);

	float4 i = ambient + ((diffuse * LN) + (specular * RV));

	return i;

    //return float4(input.Normal * 0.5 + 0.5, 1);
	
	/* Debug shading #2: map and return texture coordinates as a color (blue = 0)
	return float4(input.TexCoord, 0, 1);*/
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