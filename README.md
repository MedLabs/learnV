# Learn V

### A web App built on V and Vweb to practice the language.
You can clone this repo and run it on your computer to see what it does, then open the source code and try to re-create the app from scratch.  

#### Install V
First of all you need to install V
```
git clone https://github.com/vlang/v
cd v
make
# HINT: Using Windows? run make.bat in a cmd shell, or ./make.bat in PowerShell
```

#### Clone this repo
```
git clone https://github.com/medlabs/learnV.git
// then enter the cloned folder
cd learnV
// start a vweb server
v -d vweb_livereload watch run .
// a vweb server should start at http://localhost:8081
```

#### Explore and learn
Open the `learnV` folder in your code editor, and read explore the code.  
Open the app in your browser at http://localhost:8081
Now compare the components in the app with the code.
Try to reproduce it from scratch...
You should keep two pages open, so you can get more informations about how V works.
- https://modules.vlang.io
- https://github.com/vlang/v/blob/master/doc/docs.md

#### What's New ?
I'm trying to generate automatically the Vlang docs into an organized docs page using `markdown` and `htmx`

#### TODO
- more components and pages will be added to learnV.
- more comments will be added to the code.
