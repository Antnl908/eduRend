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
