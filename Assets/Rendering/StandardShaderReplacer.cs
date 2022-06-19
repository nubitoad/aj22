using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Assertions;

[ExecuteInEditMode]
public class StandardShaderReplacer : MonoBehaviour
{
    public Shader[] allowedShaders;
    public Shader pbrDefaultShader;

    void OnGUI()
    {
        Assert.IsNotNull(pbrDefaultShader);
        Assert.IsTrue(allowedShaders.Length != 0);
        
        var matToId = new Dictionary<string, int>();
        var objId = 0;
        var idsChanged = false;
        
        foreach (var renderer in (Renderer[]) Object.FindObjectsOfType(typeof(Renderer)))
        {
            foreach (var mat in renderer.sharedMaterials) {
                if (!allowedShaders.Contains(mat.shader))
                {
                    Debug.LogWarning("Replacing shader on '" + renderer.gameObject.name + "'...");
                    mat.shader = pbrDefaultShader;
                    mat.enableInstancing = true;
                }

                if (!matToId.ContainsKey(mat.name))
                {
                    matToId[mat.name] = objId++;
                }
                MaterialPropertyBlock props = new MaterialPropertyBlock();
                renderer.GetPropertyBlock(props);
                if (props.GetInt("_ID") != matToId[mat.name])
                {
                    props.SetInt("_ID", matToId[mat.name]);
                    renderer.SetPropertyBlock(props);
                    idsChanged = true;
                }
            }
        }

        if (idsChanged)
        {
            Debug.LogWarning(objId + " material ids generated.");
        }
    }
}
