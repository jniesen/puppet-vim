# Installs vim and vim-pathogen

# Examples
#
#   include vim
#   vim::loader
#   vim::bundle { 'syntastic':
#     source => 'scrooloose/syntastic',
#   }
#
class vim {
  require python

  $home = "/Users/${::boxen_user}"
  $vimrc = "${home}/.vimrc"
  $vimdir = "${home}/.vim"

  package { 'vim':
    require => Package['mercurial']
  }

  # Install mercurial since the vim brew package don't satisfy the requirement (vim is fetched using $ hg)
  python::pip { 'mercurial':
    virtualenv => '/opt/boxen/homebrew',
  }

  # docutils is required by mercurial.
  # https://github.com/boxen/puppet-vim/issues/12
  python::pip { 'docutils':
    virtualenv => '/opt/boxen/homebrew',
  }

  file { [$vimdir,
    "${vimdir}/autoload",
    "${vimdir}/bundle"]:
    ensure  => directory,
    recurse => true,
  }

  repository { "${vimdir}/vim-pathogen":
    source => 'tpope/vim-pathogen'
  }

  file { "${vimdir}/autoload/pathogen.vim":
    target  => "${vimdir}/vim-pathogen/autoload/pathogen.vim",
    require => [
      File[$vimdir],
      File["${vimdir}/autoload"],
      File["${vimdir}/bundle"],
      Repository["${vimdir}/vim-pathogen"]
    ]
  }
}
