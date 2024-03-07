#include "Camera.h"

using namespace linalg;

void Camera::MoveTo(const vec3f& position) noexcept
{
	m_position = position;
}

void Camera::Move(const vec3f& direction) noexcept
{
	float angle = (yaw / 180.0f * 3.14159f);
	float co = cos(angle);
	float si = sin(angle);

	float angle2 = ((yaw - 90) / 180.0f * 3.14159f);
	float co2 = cos(angle2);
	float si2 = sin(angle2);

	/*player->rb->fx += (si * ((analog_input->y * 0.016f) * -1)) * movement_speed * 100;
	player->rb->fz += (co * ((analog_input->y * 0.016f) * 1)) * movement_speed * 100;

	player->rb->fx += (si2 * ((analog_input->x * 0.016f) * -1)) * movement_speed * 100;
	player->rb->fz += (co2 * ((analog_input->x * 0.016f) * 1)) * movement_speed * 100;*/

	/*m_position.x += (si * direction.z);
	m_position.z += (co * direction.z);
	
	m_position.x += (si2 * direction.x);
	m_position.z += (co2 * direction.x);*/

	mat4f r = mat4f::rotation(0, yaw / 180.0f * 3.14159f, pitch / 180.0f * 3.14159f);
	mat4f t = mat4f::translation(m_position);

	mat4f transform = t * r;

	//linalg::vec3f dir = transform * direction;
	linalg::vec4f forward = (0, 0, -1, 0);
	linalg::vec4f forwardWorld = transform * forward;
	linalg::vec3f f = (forwardWorld.x, forwardWorld.y, forwardWorld.z);

	m_position += f;
}

//void Camera::Look(const vec3f& rotation) noexcept
//{
//	m_rotation += (rotation * sense);
//}

void Camera::Look(float x, float y)
{
	/*linalg::vec3f rotation = {0.0f, (float)x, (float)y};
	m_rotation += (rotation * sense);*/

	yaw += (-x * sense);
	pitch += (-y * sense);
	if (pitch < -45.0f) { pitch = -45.0f; }
	else if (pitch > 45.0f) { pitch = 45.0f; }
}

mat4f Camera::WorldToViewMatrix() const noexcept
{
	// Assuming a camera's position and rotation is defined by matrices T(p) and R,
	// the View-to-World transform is T(p)*R (for a first-person style camera).
	//
	// World-to-View then is the inverse of T(p)*R;
	//		inverse(T(p)*R) = inverse(R)*inverse(T(p)) = transpose(R)*T(-p)
	// Since now there is no rotation, this matrix is simply T(-p)

	mat4f r = mat4f::rotation(0, yaw / 180.0f * 3.14159f, pitch / 180.0f * 3.14159f);

	mat4f t = mat4f::translation(-m_position);

	r.transpose();

	mat4f transform = r * t;
	//mat4f transform = r.inverse() * t.inverse();

	//transform.transpose();

	

	//return mat4f::translation(-m_position);
	
	return transform;
}

mat4f Camera::ProjectionMatrix() const noexcept
{
	return mat4f::projection(m_vertical_fov, m_aspect_ratio, m_near_plane, m_far_plane);
}