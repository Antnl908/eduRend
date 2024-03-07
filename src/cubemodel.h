#pragma once

#include "Model.h"

class CubeModel : public Model
{
	unsigned m_number_of_indices = 0;
public:

	CubeModel(ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_context);

	virtual void Render() const;

	~CubeModel() { }
};