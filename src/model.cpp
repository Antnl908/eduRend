#include "model.h"
#define ASSERT

Model::Model(ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_context)
	: m_dxdevice(dxdevice), m_dxdevice_context(dxdevice_context)
{
	HRESULT hr;
	sd =
	{
		D3D11_FILTER_ANISOTROPIC,
		D3D11_TEXTURE_ADDRESS_WRAP,
		D3D11_TEXTURE_ADDRESS_WRAP,
		D3D11_TEXTURE_ADDRESS_WRAP,
		0.0f,
		4,
		D3D11_COMPARISON_NEVER,
		{ 1.0f, 1.0f, 1.0f },
		-FLT_MAX,
		FLT_MAX,
	};
	ASSERT(hr = m_dxdevice->CreateSamplerState(&sd, &samplerState));
};

void Model::Render() const
{
	m_dxdevice_context->PSSetSamplers(0, 1, &samplerState);
};

void Model::ComputeTB(Vertex& v0, Vertex& v1, Vertex& v2) const
{
	vec3f D, E, T, B;
	vec2f F, G;

	//Start
	D = v1.Position - v0.Position;
	E = v2.Position - v0.Position;
	F = v1.TexCoord - v0.TexCoord;
	G = v2.TexCoord - v0.TexCoord;

	//Test
	//D = F.x * T + F.y * B
	//E = G.x * T + G.y * B

	/*mat3f TB = 
		(1/((F.x * G.y) - (F.y * G.x)))
		* mat2f{G.y, -F.y, -G.x, F.x}
		* mat3f{ D.x, D.y, D.z, E.x, E.y, E.z, 0,0,0 };*/

	T.x = G.y * D.x + -F.y * E.x;
	T.y = G.y * D.y + -F.y * E.y;
	T.z = G.y * D.z + -F.y * E.z;

	B.x = -G.x * D.x + F.x * E.x;
	B.y = -G.x * D.y + F.x * E.y;
	B.x = -G.x * D.z + F.x * E.z;

	T.normalize();
	B.normalize();

	v0.Tangent = v1.Tangent = v2.Tangent = T;
	v0.Binormal = v1.Binormal = v2.Binormal = B;

};
