# Type: shibboleth_idp::metadata::provider
#
# This type represents an SP metadata provider
#

define shibboleth_idp::metadata::provider (
  $id = $name,
  $filename = "${name}-metadata.xml",
  $owner = undef,
  $group = undef,
  $mode = '0644',
  $source_path = undef,
  $source_file = undef,
) {

  $_source_file = $source_file ? {
    undef   => $filename,
    default => $source_file,
  }

  concat::fragment { "metadata_providers_${id}":
    target  => 'metadata-providers.xml',
    order   => '80',
    content => template("${module_name}/shibboleth/metadata_providers/_provider.erb"),
  }

  ensure_resource('file', "${shibboleth_idp::shib_install_base}/metadata",
    {
      ensure  => directory,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      require => File[$shibboleth_idp::shib_install_base],
    }
  )

  file { "${shibboleth_idp::shib_install_base}/metadata/${filename}":
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    source  => "${source_path}/${_source_file}",
    require => File["${shibboleth_idp::shib_install_base}/metadata"],
    notify  => Class['shibboleth_idp::service'],
  }

}
