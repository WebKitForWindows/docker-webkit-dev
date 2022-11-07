local build = import 'build.libsonnet';

local images = [
  'base',
  'scripts',
  'scm',
  'tools',
  'msbuild-2019',
  'msbuild-2022',
  'buildbot-worker',
];

local tags = [
  '1809',
  '2022',
  'aws',
  'windows-1809',
  'windows-aws'
];

local pipeline_name(tag) =
  local windows_image = std.startsWith(tag, 'windows-');
  local prefix = if windows_image then 'Windows' else 'ServerCore';
  local tag_name = if windows_image then std.split(tag, '-')[1] else tag;
  prefix + ' ' + tag_name + ' Images';

[
  build.docker_pipeline(pipeline_name(tag), images, tag)
  for tag in tags
] +
[
  build.manifest_pipeline(
    'Image Manifest',
    images,
    [
      pipeline_name(tag)
      for tag in tags
    ]
  ),
]
