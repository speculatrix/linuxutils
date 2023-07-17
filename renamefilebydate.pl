#!/usr/bin/perl -w
# version 1.1 - 20130209 - doesn't care about file extension, added example
# version 1.0 - 20121216a
# renamefilebydate written by PaulM
# licensed under GPL latest
# it renames a file by date in a safe manner and allows additional ways to mangle the file
#

if (!defined($ARGV[0]))
{
	print "Usage: renamefilebydate.pl filename.n.gz\n";
	print "renamed file to filename-YYYYMMDD.gz, but only if the target doesn't already exist (safe)!\n";
	print "this script's purpose is for renaming log files when logrotate's rename/rotate is changed to dateext\n";
	print "\n";
	print "Options:\n\t-n\tdry run, don't rename\n\t-k\tkeep the original file name\n\t-a\tappend string to name\n\t-p\tprepend string to name\n";
	print "\n\n";
	print "Example usage:\n\tfor X in 000*MTS; do renamefilebydate.pl -d -a -1080p \$X; done";
}

$dbgLevel = 0;

# process options
my $dryRun = 0;
my $keep = 0;
my $interactiveMode = 0;
my $orig = '';
my $append = '';
my $prepend = '';

while (defined $ARGV[0])
{
	if ($ARGV[0] =~ /^-n$/)
	{
		$dryRun++;
	}
	elsif ($ARGV[0] =~ /^-a$/)
	{
		$append = $ARGV[1];
		print "append $append\n" if ($dbgLevel);
		shift;
	}
	elsif ($ARGV[0] =~ /^-p$/)
	{
		$prepend = $ARGV[1];
		print "prepend $prepend\n" if ($dbgLevel);
		shift;
	}
	elsif ($ARGV[0] =~ /^-d$/)
	{
		$dbgLevel++;
		print "dbgLevel is now $dbgLevel\n";
	}
	elsif ($ARGV[0] =~ /^-k$/)
	{
		$keep++;
	}
	elsif ($ARGV[0] =~ /^-i$/)
	{
		$interactiveMode++;
	}
	else
	{
		$orig = $ARGV[0];
	}
	shift;
}

#if ((! -f $orig ) && (! $dryRun ) && (! $dbgLevel ))
if (! -f $orig )
{
	print "Error, no such file $orig\n";
	exit 1;
}

if (!($orig =~ /^(.*)\.(.*)$/))
{
	print "Error, failed to extract prefix in the source file name $orig\n";
	exit 1;
}
else
{
	my $prefix = '';
	$prefix = $1 . '-'  if ($keep == 1);
	my $exten = $2;
	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size, $atime,$mtime,$ctime,$blksize,$blocks) = stat($orig);
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($mtime);
	my $dest = sprintf("%s%s%04d%02d%02d-%02d%02d%02d%s.%s", $prepend, $prefix, $year + 1900, $mon + 1, $mday, $hour, $min, $sec, $append, $exten);

	if (-f $dest)
	{
		print "Error, destination file already exists\n";
		exit 1;
	}

	if (! $dryRun)
	{
		my $confirmRename = 0;
		if ($interactiveMode)
		{
			print "Confirm rename $orig to $dest: ";
			my $response = <STDIN>;
			if ($response =~ /^(y|Y|yes|Yes)$/)
			{
				++$confirmRename;
			}
		}
		else
		{
			$confirmRename = 1;
		}
		rename $orig, $dest if ($confirmRename);
		print "renamed $orig to $dest\n" if ($confirmRename);
	}
	else
	{
		print "rename $orig to $dest not done as -n option used\n";
	}
}

# end renamefilebydate.pl
