
## This is my repo full of useful tools

### _commit_and_push_by_type_by_plugins_folder_auto.ps1
Used for pushing big folders inside the Assets/Plugins folder

####
Pushes each folder inside the plugin folder one by one and also one by one by type. This way you can push a lot of things without timeout.

### SymLink_Unity_Folder
Hey since Android is hot stuff right now, I have pretty nice solution for everyone who wants to have one git REPO + 2 unity instances (one android, one windows)
Since there is no way to do this using default unity ways (like having two libraries) I have created this script with Mr. Gippity.
I have debugged it already, so you don't have to worry about symlinking to Windows32 like I did with first iteration, hehe

#### Only thing you have to do is:
1. Have a folder which will be source controlled. For me, this will be only used to git track files, but not actually used for Unity. But it can be some already existing unity repo you have. (For me, [PROJECT])
2. Create another folder which will be linking to the first one. (For me, [PROJECT_PC] and [PROJECT_ANDROID])
3. Put this script into this new folder and change the $path_to_stuff variable to the git repo folder (for me $path_to_stuff = "D:\UnityProjects\[PROJECT]")
4. Run the script by right clicking and hitting run or other methods for running ps1 files, it will ask for admin rights cause they are required for symlinking and it will also show you from where to where you will be linking (For me, Hey, you are about to copy files from D:\UnityProjects\[PROJECT] to D:\UnityProjects\[PROJECT_PC], are you sure about that? (y/N))
5. You either confirm using Y/y or cancel using any key
6. It will write you all the operations it did and it will skip any files which are already linked.

#### Something to note:
1. I recommend manually copying all the solution files + UserSettings + .idea folder. This will help you speed up stuff
2. Unity will disable directory monitoring, so unity will have to recheck all files for it to get info about asset changes. Might be heavy on some PCs
3. You will get warning that using symlinks might corrupt assets. I personally don't know how likely this is or how impactful this is. Since we use source control there doesn't seem to be much of risk, but be vary as modifying files could create broken references. I think if the whole Assets folder is symlinked there should be no issue.
4. The linked folders are not source controlled and probably shouldn't be since git has trouble looking through the symlinks and thinks the directory is empty (this might be fixable with some config though). So if you add any item into the linked directories it will not be tracked. You have treat them only as references to the real repo and be a bit careful around them. Also if we every add more items into the top level of project repo then you will have to link those using this tool again by adding the item name into the ps1. This almost never happens though.
5. Rider works perfectly and doesn't even complain that something is off. Maybe it doesn't know, after all SymLinks are kinda like pointers to the files.