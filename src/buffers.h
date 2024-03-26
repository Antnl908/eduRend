/**
 * @file buffers.h
 * @brief Contains constant buffers
*/

#pragma once

#include "vec/mat.h"

/**
 * @brief Contains transformation matrices.
*/
struct TransformationBuffer
{
	linalg::mat4f ModelToWorldMatrix; //!< Matrix for converting from object space to world space.
	linalg::mat4f WorldToViewMatrix; //!< Matrix for converting from world space to view space.
	linalg::mat4f ProjectionMatrix; //!< Matrix for converting from view space to clip cpace.
};

struct CameraAndLightBuffer
{
	linalg::vec4f cameraPos;
	linalg::vec4f lightPos;
};

struct MaterialBuffer
{
	linalg::vec4f ambient;
	linalg::vec4f diffuse;
	linalg::vec4f specular;
	//specular.w är shininess

	std::string name; //material name

	//paths
	std::string diffuseTexturePath;
	std::string normalTexturePath;

	//texture
	alignas(16) Texture diffuseTexture;
};