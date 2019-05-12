# LTS-Collection

This is the work I've done in trying to create a lightweight text editor(s). I have done a lot so I have compiled a list.

An explanation to why there is a list, and not just one text editor, I noticed that creating one big, functioning while also being
lightweight was going to be a difficult task, especially since I don't have mastery in any of the tools I am using. I was
also using LÖVE for 3/4 of the LTE(s) created, I was using a tool created for game development, making it so that it does not use a lot
of resources was difficult, but I managed to figure it out in LTE_2.

Here's what each folder means, you can find more details if you scroll down (in order of creation):
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

It is **MIT licensed**, in the other words you're free to use the code for all purposes and I will not be related in any way with what you used it for.

With it being separated by feature/style/method, makes it easier for me to combine them into a new text editor, although it still would be
difficult to make it lightweight, and it would require a lot of time and so attention.

It may require some time for me, but it is possible to combine the LTE(s) together to create one text editor, but it would require a lot of 
optimization to make it lightweight and what I mentioned earlier about it being a difficult task.

---
# Images for what kind of problems I ran into, and how it looks, and a quick description:

**LTE**: https://imgur.com/a/6JRiMtq

You'll notice that the LTE had a GUI first, but I wasn't able to make it good, and I was suggested about user friendliness, this was a weak area for me at the time, so I decided to solve this by making it a command line like VIM.

**jLTE**: https://imgur.com/a/iH8VZMz

The first picture shows how it looks, and the third picture (after the errors) shows the functionality of tabs. The last image is the research I've done before choosing Java, and then you'll see how I got by as being a beginner in Java. I must say that designing the UI was very difficult, but I managed to do it in the end.

**LTE_2**: https://imgur.com/a/uEh1Yqi

The UI does not distort/mess up when the window is resized, it automatically resizes itself or positions it self in the right manner.  The last image shows how it looks. You can also see how much of an improvement I made in the UI designing when compared to the LTE and also arguably jLTE. To know how I found out how I could make it less performance demanding can be seen here: https://love2d.org/wiki/love.run

**LTE_Syntax_Highlighting**:

![Syntax highlighting proof](https://i.imgur.com/mRv5HDA.png)

There are still some strange errors in writing text, but the syntax highlighting works and that was the purpose of this LTE, the code can be easily extracted, and you could include more syntax higlighting keywords in the theme.lua.
