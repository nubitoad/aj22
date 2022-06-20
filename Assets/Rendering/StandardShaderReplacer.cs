using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Assertions;
using Object = UnityEngine.Object;

[ExecuteInEditMode]
public class StandardShaderReplacer : MonoBehaviour {
    public Shader[] allowedShaders;
    public Shader pbrDefaultShader;
    private Dictionary<Material, Tuple<Renderer, int>> matToId = new();

    void OnGUI() {
        if (Application.isPlaying) {
            return;
        }

        Assert.IsNotNull(pbrDefaultShader);
        Assert.IsTrue(allowedShaders.Length != 0);

        var mats = new Dictionary<Material, Tuple<Renderer, int>>();
        foreach (var renderer in (Renderer[])Object.FindObjectsOfType(typeof(Renderer))) {
            foreach (var mat in renderer.sharedMaterials) {
                if (!mats.ContainsKey(mat)) {
                    mats[mat] = Tuple.Create(renderer, mats.Count);
                }
            }
        }

        if ((mats.Count != matToId.Count || mats.Except(matToId).Any())) {
            matToId = mats;
            foreach (KeyValuePair<Material, Tuple<Renderer, int>> entry in matToId) {
                var mat = entry.Key;
                var renderer = entry.Value.Item1;
                var id = entry.Value.Item2;
                mat.shader = pbrDefaultShader;
                mat.enableInstancing = true;
                MaterialPropertyBlock props = new MaterialPropertyBlock();
                renderer.GetPropertyBlock(props);
                props.SetInt("_ID", id);
                renderer.SetPropertyBlock(props);
            }

            Debug.LogWarning(matToId.Count + " material ids generated.");
        }
    }
}