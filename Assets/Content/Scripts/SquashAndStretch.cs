using UnityEngine;

public class SquashAndStretch : MonoBehaviour
{
    private static readonly int SquashID = Shader.PropertyToID("_Squash");
    private static readonly int RadiusID = Shader.PropertyToID("_Radius");
    private static MaterialPropertyBlock _mpb;

    public MeshRenderer MeshRenderer;
    public float CollisionRadius = 0.5f;

    [Header("Spring")]
    public float Strength = 15f;
    public float Dampening = 0.3f;
    public float VelocityStretch;

    [Header("Debug")]
    public bool Test;
    [Range(-2f, 2f)]
    public float Squash;

    private float _squash;
    private float _squashVelocity;
    private Vector3 _lastPosition;

    void LateUpdate()
    {
        //If no MeshRenderer is selected then return.
        if (MeshRenderer == null)
            return;

        //If _mpb is null then create a new Material Property Block.
        if (_mpb == null)
            _mpb = new MaterialPropertyBlock();

        //Calculate the velocity. Store the current position calculating the velocity next update.
        Vector3 velocity = (transform.position - _lastPosition) / Time.deltaTime;
        _lastPosition = transform.position;

        //If the sphere is position low enough to be colliding with the ground...
        if (transform.position.y < CollisionRadius)
        {
            //Calculate how mush the sphere needs to be squashed to avoid intersecting with the ground.
            float targetSquash = (CollisionRadius - transform.position.y) / CollisionRadius;

            //Store the squash velocity.
            _squashVelocity = targetSquash - _squash;

            //Store the current squash value.
            _squash = targetSquash;
        }
        else
        {
            //Calculate the desired squash amount based on the current Y axis velocity.
            float targetSquash = -Mathf.Abs(velocity.y) * VelocityStretch;

            //Adjust the squash velocity.
            _squashVelocity += (targetSquash - _squash) * Strength * Time.deltaTime;

            //Apply dampening to the squash velocity.
            _squashVelocity = ((_squashVelocity / Time.deltaTime) * (1f - Dampening)) * Time.deltaTime;

            //Apply the velocity to the squash value.
            _squash += _squashVelocity;
        }

        //If testing then...
        if (Test)
        {
            //Set the squash value to equal the debugging squash value and set the squash velocity to zero.
            _squash = Squash;
            _squashVelocity = 0f;
        }

        //Update the material property block with the squash and radius value.
        _mpb.SetFloat(SquashID, _squash);
        _mpb.SetFloat(RadiusID, CollisionRadius);

        //Set the material property block on the MeshRenderer.
        MeshRenderer.SetPropertyBlock(_mpb);
    }

    void OnDrawGizmos()
    {
        if (Test)
            Gizmos.DrawWireSphere(transform.position, CollisionRadius);
    }
}