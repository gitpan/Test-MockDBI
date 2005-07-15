
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Test::MockDBI',
    'VERSION_FROM'	=> 'lib/Test/MockDBI.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (AUTHOR     => 'Todd Caine <tcaine@localdomain>') : ()),
);
