
Texture2D texDiffuse : register(t0);
Texture2D texNormal : register(t1);
Texture3D cubeMap : register(t3);
SamplerState texSampler : register(s0);

struct PSIn
{
	float4 Pos  : SV_Position;
	float3 Normal : NORMAL;
	float3 Tangent : TANGENT;
	float3 Binormal : BINORMAL;
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
	//bool hasNormal;
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


	////Funkar
	//float3 NPrime = ((texNormal.Sample(texSampler, input.TexCoord).xyz) * 2 - 1);

	//float3 NN = normalize(input.Normal);
	//float3 TN = normalize(input.Tangent);
	//float3 BN = normalize(input.Binormal);

	////float3x3 TBN = { TN, BN, NN };
	//float3x3 TBN =  transpose(float3x3(TN, BN, NN));

	//float3 NBis = normalize(mul(TBN, NPrime));


	////Phong
 //   float3 L = normalize(lightPos.xyz - input.PosWorld);
 //   //float3 L = normalize(lightPos.xyz - input.Pos.xyz);
	////skalär av normalen och dir
 //   float LN = max(0.0f, dot(input.Normal, L));
 //   float LNBis = max(0.0f, dot(NBis, L));
 //   
	//float3 R = reflect(-L, input.Normal);
	//float3 RNBis = reflect(-L, NBis);

	////float4 V = normalize(cameraPos - input.PosWorld);
	//float3 V = normalize(cameraPos.xyz - input.PosWorld);
	////float3 V = normalize(cameraPos.xyz - input.Pos.xyz);

	////float  RV = pow(max( 0.0f, dot(R, V) - 0.03f), 64.0f);
	////float  RV = pow(max( 0.0f, dot(R, V) - 0.03f), specular.w);
	//float  RV = pow(max( 0.0f, dot(R, V)), specular.w);
	//float  RVBis = pow(max( 0.0f, dot(RNBis, V)), specular.w);

	////float4 i = ambient + ((diffuse * LN) + (specular * RV));
	//float4 i = ambient + (((texDiffuse.Sample(texSampler, input.TexCoord)) * LN) + (specular * RV));
	////float4 i = ambient + (((texDiffuse.Sample(texSampler, input.TexCoord)) * LNBis) + (specular * RVBis));
	////slut funkar



	//Experiment
	float4 i;
	float3 NPrime = ((texNormal.Sample(texSampler, input.TexCoord).xyz) * 2 - 1);
	if (NPrime.x == -1)
	{
		float3 L = normalize(lightPos.xyz - input.PosWorld);
		float LN = max(0.0f, dot(input.Normal, L));
		float3 R = reflect(-L, input.Normal);
		float3 V = normalize(cameraPos.xyz - input.PosWorld);
		float  RV = pow(max(0.0f, dot(R, V)), specular.w);
		i = ambient + (((texDiffuse.Sample(texSampler, input.TexCoord)) * LN) + (specular * RV));
	}
	else
	{
		float3 NN = normalize(input.Normal);
		float3 TN = normalize(input.Tangent);
		float3 BN = normalize(input.Binormal);
		float3x3 TBN = transpose(float3x3(TN, BN, NN));
		float3 NBis = normalize(mul(TBN, NPrime));
		float3 L = normalize(lightPos.xyz - input.PosWorld);
		float LNBis = max(0.0f, dot(NBis, L));
		float3 RNBis = reflect(-L, NBis);
		float3 V = normalize(cameraPos.xyz - input.PosWorld);
		float  RVBis = pow(max(0.0f, dot(RNBis, V)), specular.w);
		i = ambient + (((texDiffuse.Sample(texSampler, input.TexCoord)) * LNBis) + (specular * RVBis));
	}

	//float3 NN = normalize(input.Normal);
	//float3 TN = normalize(input.Tangent);
	//float3 BN = normalize(input.Binormal);

	////float3x3 TBN = { TN, BN, NN };
	//float3x3 TBN = transpose(float3x3(TN, BN, NN));

	//float3 NBis = normalize(mul(TBN, NPrime));


	////Phong
	//float3 L = normalize(lightPos.xyz - input.PosWorld);
	////float3 L = normalize(lightPos.xyz - input.Pos.xyz);
	////skalär av normalen och dir
	//float LN = max(0.0f, dot(input.Normal, L));
	//float LNBis = max(0.0f, dot(NBis, L));

	//float3 R = reflect(-L, input.Normal);
	//float3 RNBis = reflect(-L, NBis);

	////float4 V = normalize(cameraPos - input.PosWorld);
	//float3 V = normalize(cameraPos.xyz - input.PosWorld);
	////float3 V = normalize(cameraPos.xyz - input.Pos.xyz);

	////float  RV = pow(max( 0.0f, dot(R, V) - 0.03f), 64.0f);
	////float  RV = pow(max( 0.0f, dot(R, V) - 0.03f), specular.w);
	//float  RV = pow(max(0.0f, dot(R, V)), specular.w);
	//float  RVBis = pow(max(0.0f, dot(RNBis, V)), specular.w);

	////float4 i = ambient + ((diffuse * LN) + (specular * RV));
	//float4 i = ambient + (((texDiffuse.Sample(texSampler, input.TexCoord)) * LN) + (specular * RV));
	//float4 i = ambient + (((texDiffuse.Sample(texSampler, input.TexCoord)) * LNBis) + (specular * RVBis));
	//slut experiment


	return i;



	//return texDiffuse.Sample(texSampler, input.TexCoord);

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