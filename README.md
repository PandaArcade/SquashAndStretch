# SquashAndStretch

We're making a game called Pico Tanks - Multiplayer Mayhem and we often create fun stuff that we want to share with the community.
http://www.pandaarcade.com/picotanks

I was thinking of using something like this for a goo cannon in Pico Tanks but it turned out to be overkill for what we needed.

This repo is Unity 2018.10b12 project where I am experimenting with a squash and stretch shader.  The shader is created with Amplify Shader Editor (ASE v1.5.2 dev 03) plugin but you don't need it to run the project, edit or use the shader.  ASE will make understanding and editing the shader much easier.
http://amplify.pt/unity/amplify-shader-editor

What is in the project?
A shader that squashes and stretches a mesh based on the given radius and squash values and a script to set those values.

I have also included a version of the shader that uses partial derivation to generate the new normals for the deformed mesh.  Thanks to ASE for the following example which I copied/referenced to recreate my normals.
https://www.reddit.com/r/Unity3D/comments/75qurr/amplify_shader_editor_new_vertex_normal/

This YouTube video does a good job of explaining how you can use partial derivation to reconstruct normals in Shader Forge.
https://www.youtube.com/watch?v=FBGtjw9KviU

The shader achieves its translucent feel with a MatCap texture that is included in the repo.

I hope someone appreciates the share :) Have fun!
