# LTS-Collection

This is the work I've done in trying to create a lightweight text editor(s). I have done a lot so I have compiled a list.

An explanation to why there is a list, and not just one text editor, I noticed that creating one big, functioning while also being
lightweight was going to be a difficult task, especially since I don't have mastery in any of the tools I am using. I was
also using LÖVE for 3/4 of the LTE(s) created, I was using a tool created for game development, making it so that it does use a lot
of resources was difficult, but I managed to figure it out in LTE_2.

Here's what each folder means (in order of creation):
- **LTE**: This is the first lightweight text editor I tried to create, this does not have syntax highlighting and editing features, 
and it is inspired by vim (in other words, *a command bar* instead of gui). It does not have copy and paste features. 
**Created using LÖVE 11.1**
- **jLTE**: This is my second LTE, this one was created using Java. I did think what I should use before choosing, but I came to the
conclusion that I had the most experience with this language to create a multi platform text editor.
It is important to note that I was using Java after many years, so I was practically *a beginner*, although I managed to get by and 
create a text editor that is practically a *notepad with tabs*.
**Created using Java 10 (although requires 0 to minimal changes to make it work with previous Java versions) and Swing**
- **LTE_2**: This was an actually LTE with *GUI*, I am happy with this one. It's the successor of LTE, it is much more
*lightweight and user friendly*, with it going to 0% or to almost 0% CPU and GPU (if it is not going to 0% usage when you're not using it, 
please create an issue). **Created using LÖVE 11.1**
- **LTE_Syntax_Highlighting**: This is a very basic editor with no features, besides *syntax highlighting*, which the rest of the
editors did not have. **Created using LÖVE 11.1**

It is **license free**, in the other words you're free to use the code for any purposes and I will not be related in any way with what you've done.

With it being separated by feature/style/method, makes it easier for me to combine them into a new text editor, although it still would be
difficult to make it lightweight, and it would require a lot of time and so attention.

It may require some time for me, but it is possible to combine the LTE(s) together to create one text editor, but it would require a lot of 
optimization to make it lightweight and what I mentioned earlier about it being a difficult task.
