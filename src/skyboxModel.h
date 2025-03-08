#pragma once

#include "model.h"

class SkyboxModel : public Model
{
	unsigned m_number_of_indices = 0;
public:

	SkyboxModel(ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_context);
	//SkyboxModel(const std::string& objfile, ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_context);

	struct IndexRange
	{
		unsigned int Start;
		unsigned int Size;
		unsigned Offset;
		int MaterialIndex;
	};

	std::vector<IndexRange> m_index_ranges;
	std::vector<Material> m_materials;

	void append_materials(const std::vector<Material>& mtl_vec)
	{
		m_materials.insert(m_materials.end(), mtl_vec.begin(), mtl_vec.end());
	}

	//virtual void Render() const;

	void Render() const;

	//void TestRender() const;

	void UpdateMaterial() const;
	/*virtual void UpdateMaterial() const;*/
	//virtual void Render(ID3D11Buffer* material) const;

	~SkyboxModel() { }
};