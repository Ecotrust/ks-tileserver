# vagrant-webmaps

### Automated dev environment wtih a full-featured tile server and editing environment

First, you've got to install the Pre-requisites: Vagrant, VirtualBox. 
Optionally, you might want git, python, fabric.

Now [download the code](https://github.com/perrygeo/vagrant-webmaps/archive/master.zip) or 
checkout a copy with git. Inside the code directory, just run:

```
vagrant up
```

Now go get some coffee and come back in roughly 30 minutes. Point
your favorite browser to http://localhost:8088 and get working on 
those fast, beautiful web maps.

vagrant-webmaps handles the following:

* Builds your virtual server with a single command using Vagrant
* Automatically installs and configures software with Puppet
* Remote management with Fabric
* Allows you to edit maps with Tilemill web interface and the CartoCSS language
* Serves them with uwsgi and nginx
* Caches them with TileStache and Redis
* Renders them with Mapnik
* Allows you to view the maps in a web browser with the OpenLayers-based Madrona layer manager.

### Deploying to a "real" server
If you're not using VirtualBox VMs for a real-world deployment (you're not, right?) then you miss out on a lot
of the fancy handwaving that vagrant provides. Instead, the process needs a bit more hand-holding, 
follow the [deploy instructions](https://github.com/Ecotrust/ks-tileserver/wiki/Deploy-Tileserver) on the wiki.

### URLs

Some helpful URLs to find your way around:

* http://localhost:8088/  : TileMill interface for creating your maps
* http://localhost:8088/tiles/test_countries/  : simple viewer and base URL for the default TileStache layer `test_countries`
* http://localhost:8088/viewer/  : Example OpenLayers viewer

### Workflow

I envision this being used to fire up remote servers, load data, style it with TileMill, export 
the styling to a Mapnik XML file which then gets added to the Tilestache server as auto-magically 
as possible. 

One could also just export MBTiles from TileMill and serve those directly from TileStache if the 
geographic extent and zoom levels allowed for small enough tilesets. For maps with very detailed 
zoom levels over large areas, it is largely a waste to pregenerate the hundreds of millions of tiles
necessary; tile rendering on-the-fly is a much better option. 

### Fabric 

If you have python and the fabric module installed locally, you can run local commands 
to interact with the remote server for most common tasks

```
$ fab --list
Available commands:

    all               Use all servers
    dev               Use development server settings
    prod              Use production server settings

    clear_cache       Clears ALL the data from the cache. You've been warned.
    clear_layer       Delete keys for a given layer; `clear_layer:test_countr...
    reconfigure       Looks for new mapnik xml files and creates new config fi..
    restart_services  Restart all map services to ensure config file changes ...
    runserver         Run the test tilestache server for debugging; port 8080...
    tail_log          Watch the tilestache logs

$ fab dev restart_services
```

### TODO 

This is a work in progress, probably not fully bulletproof yet. YMMV. 

Here's a [list of what I have planned](https://github.com/perrygeo/vagrant-webmaps/wiki/vagrant-webmaps-TODO)
