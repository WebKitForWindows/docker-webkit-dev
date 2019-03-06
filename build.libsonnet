local windows_pipe = '\\\\\\\\.\\\\pipe\\\\docker_engine';
local windows_pipe_volume = 'docker_pipe';

{
  pipeline(name, steps, volumes, depends_on):: {
    kind: 'pipeline',
    name: name,
    platform: {
      os: 'windows',
      arch: 'amd64',
    },
    steps: steps,
    volumes: if std.length(volumes) > 0 then volumes,
    depends_on: if std.length(depends_on) > 0 then depends_on,
    trigger: {
      ref: [
        'refs/heads/master',
        'refs/tags/**',
      ],
    },
  },

  docker_pipeline(name, images, tag)::
    self.pipeline(
        name, 
        self.docker_build_all(images, tag),
        [{ name: windows_pipe_volume, host: { path: windows_pipe } }],
        []
    ),

  docker_build_all(images, tag)::
    [
      self.docker_build(image, tag)
      for image in images
    ],

  docker_build(image, tag):: {
    local is_base = image == 'base',
    local dockerfile = if !is_base then 'Dockerfile' else 'Dockerfile.' + tag,
    name: 'build-' + image,
    image: 'plugins/docker',
    pull: 'always',
    settings: {
      context: image,
      dockerfile: image + '/' + dockerfile,
      repo: 'webkitdev/' + image,
      build_args: if !is_base then ['IMAGE_TAG=' + tag] else [],
      auto_tag: true,
      auto_tag_suffix: tag,
      username: { from_secret: 'docker_username' },
      password: { from_secret: 'docker_password' },
      // Windows specific settings due to lack of DIND
      daemon_off: true,
      // Workaround for https://github.com/drone/drone-cli/issues/117
      purge: 'false',
    },
    volumes: [{ name: windows_pipe_volume, path: windows_pipe }],
  },

  manifest_pipeline(name, images, depends_on)::
    self.pipeline(name, self.manifest_publish_all(images), [], depends_on),

  manifest_publish_all(images)::
    [
      self.manifest_publish(image)
      for image in images
    ],

  manifest_publish(image):: {
    name: 'publish-manifest-' + image,
    image: 'plugins/manifest',
    pull: 'always',
    settings: {
      username: { from_secret: 'docker_username' },
      password: { from_secret: 'docker_password' },
      spec: image + '/manifest.tmpl',
      ignore_missing: true,
    },
  },
}
