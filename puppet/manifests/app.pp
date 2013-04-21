# ensure that apt update is run before any packages are installed
class apt {
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }

  # Ensure apt-get update has been run before installing any packages
  Exec["apt-update"] -> Package <| |>

}

include apt

exec { "add-apt":
  command => "/usr/bin/add-apt-repository -y ppa:developmentseed/mapbox && /usr/bin/apt-get update",
  subscribe => Package["python-software-properties"]
}

package { "libmapnik": ensure => "installed", subscribe => Exec['add-apt'] }
package { "mapnik-utils": ensure => "installed", subscribe => Exec['add-apt'] }
package { "python-mapnik": ensure => "latest", subscribe => Exec['add-apt'] }
package { "tilemill": ensure => "latest", subscribe => Exec['add-apt'] }
package { "nodejs": ensure => "latest", subscribe => Exec['add-apt'] }
package { "build-essential": ensure => "installed"}
package { "python-software-properties": ensure => "installed"}
package { "git-core": ensure => "latest"}
package { "vim": ensure => "latest"}
package { "python-psycopg2": ensure => "latest"}
package { "python-virtualenv": ensure => "latest"}
package { "python-pip": ensure => "latest"}
package { "python-dev": ensure => "latest"}
package { "redis-server": ensure => "latest"}
package { "supervisor": ensure => "latest"}
package { "python-imaging": ensure => "latest"}
package { "libjpeg8": ensure => "latest"}
package { "libfreetype6": ensure => "latest"}

pip::install {"pip-app":
  requirements => "/usr/local/app/requirements.txt",
  require => [File["/usr/local/app/requirements.txt"],],
}
file { "/usr/local/app/requirements.txt":
  path => "/usr/local/app/requirements.txt",
  ensure => "present"
}

package {'uwsgi': ensure => "latest"}
package {'uwsgi-plugin-python': ensure => "latest"}
file { "tilestache.ini":
  path => "/etc/uwsgi/apps-available/tilestache.ini",
  content => template("tilestache.uwsgi.ini"),
  require => [Package['uwsgi'], Package['uwsgi-plugin-python']]
}
file { "/etc/uwsgi/apps-enabled/tilestache.ini":
   ensure => 'link',
   target => '/etc/uwsgi/apps-available/tilestache.ini',
   require => File['tilestache.ini']
}

package {'nginx-full': ensure => "latest"}
file {"tiles":
  path => "/etc/nginx/sites-available/tiles",
  content => template("tiles.nginx"),
  require => Package['nginx-full']
}
file { "/etc/nginx/sites-enabled/tiles":
   ensure => 'link',
   target => '/etc/nginx/sites-available/tiles',
   require => File['tiles']
}
file { "/etc/nginx/sites-enabled/default":
   ensure => 'absent',
   require => Package['nginx-full']
}

file { "tilemill.conf":
  path => "/etc/init/tilemill.conf",
  content => template("tilemill.conf")
}
file { "tilemill.config":
  path => "/etc/tilemill/tilemill.config",
  content => template("tilemill.config")
}
# TODO http://stackoverflow.com/questions/5068518/what-does-redis-do-when-it-runs-out-of-memory