use ExtUtils::MakeMaker;

use File::Copy;
if ($^O eq 'darwin'){
  unlink('megam');
  copy('megam.osx','megam');
}
else{
  unlink('megam');
  copy('megam_i686.opt','megam');
}


WriteMakefile(
    NAME              => 'Lingua::Align',
    VERSION_FROM      => 'lib/Lingua/Align.pm',
    ABSTRACT_FROM     => 'lib/Lingua/Align.pm',
    EXE_FILES         => [ 
	'bin/treealign',
	'bin/treealigneval',
	'bin/megam', 
	'bin/sta2moses',
	'bin/sta2penn',
	'bin/sta2phrases',
	'bin/tiger2penn',
	'bin/tiger2text',
	'bin/tiger2alpino',
	'bin/stanford2tiger',
	'bin/penn2tiger',
	'bin/alpino2tiger',
	'bin/convert_treebank'
    ],
    AUTHOR            => 'Joerg Tiedemann',
    PREREQ_PM         => {
        'XML::Parser' => 0,
	'IPC::Open3' => 0
    },
);
