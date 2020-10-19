Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB8029242A
	for <lists+io-uring@lfdr.de>; Mon, 19 Oct 2020 11:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgJSJCI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Oct 2020 05:02:08 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:58253 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728300AbgJSJCI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Oct 2020 05:02:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UCU-WaB_1603098116;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UCU-WaB_1603098116)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 19 Oct 2020 17:01:56 +0800
Subject: Re: [PATCH] io_uring: use blk_queue_nowait() to check if NOWAIT
 supported
From:   JeffleXu <jefflexu@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com,
        xiaoguang.wang@linux.alibaba.com
References: <20201019084737.110965-1-jefflexu@linux.alibaba.com>
Message-ID: <85121e10-74b3-924b-0de9-b36cbf6c642c@linux.alibaba.com>
Date:   Mon, 19 Oct 2020 17:01:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201019084737.110965-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 10/19/20 4:47 PM, Jeffle Xu wrote:
> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") add a new helper
> function blk_queue_nowait() to check if the bdev supports handling of
> REQ_NOWAIT or not. Since then bio-based dm device can also support
> REQ_NOWAIT, and currently only dm-linear supports that since
> commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable it for
> linear target").
>
> Fixes: 4503b7676a2e ("io_uring: catch -EIO from buffered issue request failure")
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>   fs/io_uring.c         |   2 +-
>   scripts/checkpatch.pl | 313 ++++++++++++------------------------------
>   2 files changed, 85 insertions(+), 230 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2e1dc354cd08..7d8615df3c01 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2601,7 +2601,7 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
>   static bool io_bdev_nowait(struct block_device *bdev)
>   {
>   #ifdef CONFIG_BLOCK
> -	return !bdev || queue_is_mq(bdev_get_queue(bdev));
> +	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
>   #else
>   	return true;
>   #endif
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl


Sorry for getting the checkpatch.pl stuff involved. I've sent the clean 
v2 patch.


> index 4223a9ac7059..4c820607540b 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -59,13 +59,12 @@ my $spelling_file = "$D/spelling.txt";
>   my $codespell = 0;
>   my $codespellfile = "/usr/share/codespell/dictionary.txt";
>   my $conststructsfile = "$D/const_structs.checkpatch";
> -my $typedefsfile;
> +my $typedefsfile = "";
>   my $color = "auto";
>   my $allow_c99_comments = 1; # Can be overridden by --ignore C99_COMMENT_TOLERANCE
>   # git output parsing needs US English output, so first set backtick child process LANGUAGE
>   my $git_command ='export LANGUAGE=en_US.UTF-8; git';
>   my $tabsize = 8;
> -my ${CONFIG_} = "CONFIG_";
>   
>   sub help {
>   	my ($exitcode) = @_;
> @@ -128,8 +127,6 @@ Options:
>     --typedefsfile             Read additional types from this file
>     --color[=WHEN]             Use colors 'always', 'never', or only when output
>                                is a terminal ('auto'). Default is 'auto'.
> -  --kconfig-prefix=WORD      use WORD as a prefix for Kconfig symbols (default
> -                             ${CONFIG_})
>     -h, --help, --version      display this help and exit
>   
>   When FILE is - read standard input.
> @@ -238,7 +235,6 @@ GetOptions(
>   	'color=s'	=> \$color,
>   	'no-color'	=> \$color,	#keep old behaviors of -nocolor
>   	'nocolor'	=> \$color,	#keep old behaviors of -nocolor
> -	'kconfig-prefix=s'	=> \${CONFIG_},
>   	'h|help'	=> \$help,
>   	'version'	=> \$help
>   ) or help(1);
> @@ -592,8 +588,6 @@ our @mode_permission_funcs = (
>   	["__ATTR", 2],
>   );
>   
> -my $word_pattern = '\b[A-Z]?[a-z]{2,}\b';
> -
>   #Create a search pattern for all these functions to speed up a loop below
>   our $mode_perms_search = "";
>   foreach my $entry (@mode_permission_funcs) {
> @@ -762,7 +756,7 @@ sub read_words {
>   				next;
>   			}
>   
> -			$$wordsRef .= '|' if (defined $$wordsRef);
> +			$$wordsRef .= '|' if ($$wordsRef ne "");
>   			$$wordsRef .= $line;
>   		}
>   		close($file);
> @@ -772,18 +766,16 @@ sub read_words {
>   	return 0;
>   }
>   
> -my $const_structs;
> -if (show_type("CONST_STRUCT")) {
> -	read_words(\$const_structs, $conststructsfile)
> -	    or warn "No structs that should be const will be found - file '$conststructsfile': $!\n";
> -}
> +my $const_structs = "";
> +read_words(\$const_structs, $conststructsfile)
> +    or warn "No structs that should be const will be found - file '$conststructsfile': $!\n";
>   
> -if (defined($typedefsfile)) {
> -	my $typeOtherTypedefs;
> +my $typeOtherTypedefs = "";
> +if (length($typedefsfile)) {
>   	read_words(\$typeOtherTypedefs, $typedefsfile)
>   	    or warn "No additional types will be considered - file '$typedefsfile': $!\n";
> -	$typeTypedefs .= '|' . $typeOtherTypedefs if (defined $typeOtherTypedefs);
>   }
> +$typeTypedefs .= '|' . $typeOtherTypedefs if ($typeOtherTypedefs ne "");
>   
>   sub build_types {
>   	my $mods = "(?x:  \n" . join("|\n  ", (@modifierList, @modifierListFile)) . "\n)";
> @@ -848,6 +840,7 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant|$String)};
>   our $declaration_macros = qr{(?x:
>   	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
>   	(?:$Storage\s+)?[HLP]?LIST_HEAD\s*\(|
> +	(?:$Storage\s+)?${Type}\s+uninitialized_var\s*\(|
>   	(?:SKCIPHER_REQUEST|SHASH_DESC|AHASH_REQUEST)_ON_STACK\s*\(
>   )};
>   
> @@ -974,16 +967,6 @@ sub seed_camelcase_includes {
>   	}
>   }
>   
> -sub git_is_single_file {
> -	my ($filename) = @_;
> -
> -	return 0 if ((which("git") eq "") || !(-e "$gitroot"));
> -
> -	my $output = `${git_command} ls-files -- $filename 2>/dev/null`;
> -	my $count = $output =~ tr/\n//;
> -	return $count eq 1 && $output =~ m{^${filename}$};
> -}
> -
>   sub git_commit_info {
>   	my ($commit, $id, $desc) = @_;
>   
> @@ -1057,9 +1040,6 @@ my $vname;
>   $allow_c99_comments = !defined $ignore_type{"C99_COMMENT_TOLERANCE"};
>   for my $filename (@ARGV) {
>   	my $FILE;
> -	my $is_git_file = git_is_single_file($filename);
> -	my $oldfile = $file;
> -	$file = 1 if ($is_git_file);
>   	if ($git) {
>   		open($FILE, '-|', "git format-patch -M --stdout -1 $filename") ||
>   			die "$P: $filename: git format-patch failed - $!\n";
> @@ -1104,7 +1084,6 @@ for my $filename (@ARGV) {
>   	@modifierListFile = ();
>   	@typeListFile = ();
>   	build_types();
> -	$file = $oldfile if ($is_git_file);
>   }
>   
>   if (!$quiet) {
> @@ -1181,10 +1160,10 @@ sub parse_email {
>   		}
>   	}
>   
> -	$comment = trim($comment);
>   	$name = trim($name);
>   	$name =~ s/^\"|\"$//g;
> -	if ($name =~ s/(\s*\([^\)]+\))\s*//) {
> +	$name =~ s/(\s*\([^\)]+\))\s*//;
> +	if (defined($1)) {
>   		$name_comment = trim($1);
>   	}
>   	$address = trim($address);
> @@ -1199,12 +1178,10 @@ sub parse_email {
>   }
>   
>   sub format_email {
> -	my ($name, $name_comment, $address, $comment) = @_;
> +	my ($name, $address) = @_;
>   
>   	my $formatted_email;
>   
> -	$name_comment = trim($name_comment);
> -	$comment = trim($comment);
>   	$name = trim($name);
>   	$name =~ s/^\"|\"$//g;
>   	$address = trim($address);
> @@ -1217,9 +1194,9 @@ sub format_email {
>   	if ("$name" eq "") {
>   		$formatted_email = "$address";
>   	} else {
> -		$formatted_email = "$name$name_comment <$address>";
> +		$formatted_email = "$name <$address>";
>   	}
> -	$formatted_email .= "$comment";
> +
>   	return $formatted_email;
>   }
>   
> @@ -1227,23 +1204,17 @@ sub reformat_email {
>   	my ($email) = @_;
>   
>   	my ($email_name, $name_comment, $email_address, $comment) = parse_email($email);
> -	return format_email($email_name, $name_comment, $email_address, $comment);
> +	return format_email($email_name, $email_address);
>   }
>   
>   sub same_email_addresses {
> -	my ($email1, $email2, $match_comment) = @_;
> +	my ($email1, $email2) = @_;
>   
>   	my ($email1_name, $name1_comment, $email1_address, $comment1) = parse_email($email1);
>   	my ($email2_name, $name2_comment, $email2_address, $comment2) = parse_email($email2);
>   
> -	if ($match_comment != 1) {
> -		return $email1_name eq $email2_name &&
> -		       $email1_address eq $email2_address;
> -	}
>   	return $email1_name eq $email2_name &&
> -	       $email1_address eq $email2_address &&
> -	       $name1_comment eq $name2_comment &&
> -	       $comment1 eq $comment2;
> +	       $email1_address eq $email2_address;
>   }
>   
>   sub which {
> @@ -2373,7 +2344,6 @@ sub process {
>   	my $signoff = 0;
>   	my $author = '';
>   	my $authorsignoff = 0;
> -	my $author_sob = '';
>   	my $is_patch = 0;
>   	my $is_binding_patch = -1;
>   	my $in_header_lines = $file ? 0 : 1;
> @@ -2666,8 +2636,8 @@ sub process {
>   
>   # Check if the commit log has what seems like a diff which can confuse patch
>   		if ($in_commit_log && !$commit_log_has_diff &&
> -		    (($line =~ m@^\s+diff\b.*a/([\w/]+)@ &&
> -		      $line =~ m@^\s+diff\b.*a/[\w/]+\s+b/$1\b@) ||
> +		    (($line =~ m@^\s+diff\b.*a/[\w/]+@ &&
> +		      $line =~ m@^\s+diff\b.*a/([\w/]+)\s+b/$1\b@) ||
>   		     $line =~ m@^\s*(?:\-\-\-\s+a/|\+\+\+\s+b/)@ ||
>   		     $line =~ m/^\s*\@\@ \-\d+,\d+ \+\d+,\d+ \@\@/)) {
>   			ERROR("DIFF_IN_COMMIT_MSG",
> @@ -2688,10 +2658,6 @@ sub process {
>   # Check the patch for a From:
>   		if (decode("MIME-Header", $line) =~ /^From:\s*(.*)/) {
>   			$author = $1;
> -			my $curline = $linenr;
> -			while(defined($rawlines[$curline]) && ($rawlines[$curline++] =~ /^[ \t]\s*(.*)/)) {
> -				$author .= $1;
> -			}
>   			$author = encode("utf8", $author) if ($line =~ /=\?utf-8\?/i);
>   			$author =~ s/"//g;
>   			$author = reformat_email($author);
> @@ -2701,37 +2667,9 @@ sub process {
>   		if ($line =~ /^\s*signed-off-by:\s*(.*)/i) {
>   			$signoff++;
>   			$in_commit_log = 0;
> -			if ($author ne ''  && $authorsignoff != 1) {
> -				if (same_email_addresses($1, $author, 1)) {
> +			if ($author ne '') {
> +				if (same_email_addresses($1, $author)) {
>   					$authorsignoff = 1;
> -				} else {
> -					my $ctx = $1;
> -					my ($email_name, $email_comment, $email_address, $comment1) = parse_email($ctx);
> -					my ($author_name, $author_comment, $author_address, $comment2) = parse_email($author);
> -
> -					if ($email_address eq $author_address && $email_name eq $author_name) {
> -						$author_sob = $ctx;
> -						$authorsignoff = 2;
> -					} elsif ($email_address eq $author_address) {
> -						$author_sob = $ctx;
> -						$authorsignoff = 3;
> -					} elsif ($email_name eq $author_name) {
> -						$author_sob = $ctx;
> -						$authorsignoff = 4;
> -
> -						my $address1 = $email_address;
> -						my $address2 = $author_address;
> -
> -						if ($address1 =~ /(\S+)\+\S+(\@.*)/) {
> -							$address1 = "$1$2";
> -						}
> -						if ($address2 =~ /(\S+)\+\S+(\@.*)/) {
> -							$address2 = "$1$2";
> -						}
> -						if ($address1 eq $address2) {
> -							$authorsignoff = 5;
> -						}
> -					}
>   				}
>   			}
>   		}
> @@ -2788,7 +2726,7 @@ sub process {
>   			}
>   
>   			my ($email_name, $name_comment, $email_address, $comment) = parse_email($email);
> -			my $suggested_email = format_email(($email_name, $name_comment, $email_address, $comment));
> +			my $suggested_email = format_email(($email_name, $email_address));
>   			if ($suggested_email eq "") {
>   				ERROR("BAD_SIGN_OFF",
>   				      "Unrecognized email address: '$email'\n" . $herecurr);
> @@ -2798,9 +2736,9 @@ sub process {
>   				$dequoted =~ s/" </ </;
>   				# Don't force email to have quotes
>   				# Allow just an angle bracketed address
> -				if (!same_email_addresses($email, $suggested_email, 0)) {
> +				if (!same_email_addresses($email, $suggested_email)) {
>   					WARN("BAD_SIGN_OFF",
> -					     "email address '$email' might be better as '$suggested_email'\n" . $herecurr);
> +					     "email address '$email' might be better as '$suggested_email$comment'\n" . $herecurr);
>   				}
>   			}
>   
> @@ -3046,42 +2984,6 @@ sub process {
>   			}
>   		}
>   
> -# check for repeated words separated by a single space
> -		if ($rawline =~ /^\+/ || $in_commit_log) {
> -			while ($rawline =~ /\b($word_pattern) (?=($word_pattern))/g) {
> -
> -				my $first = $1;
> -				my $second = $2;
> -
> -				if ($first =~ /(?:struct|union|enum)/) {
> -					pos($rawline) += length($first) + length($second) + 1;
> -					next;
> -				}
> -
> -				next if ($first ne $second);
> -				next if ($first eq 'long');
> -
> -				if (WARN("REPEATED_WORD",
> -					 "Possible repeated word: '$first'\n" . $herecurr) &&
> -				    $fix) {
> -					$fixed[$fixlinenr] =~ s/\b$first $second\b/$first/;
> -				}
> -			}
> -
> -			# if it's a repeated word on consecutive lines in a comment block
> -			if ($prevline =~ /$;+\s*$/ &&
> -			    $prevrawline =~ /($word_pattern)\s*$/) {
> -				my $last_word = $1;
> -				if ($rawline =~ /^\+\s*\*\s*$last_word /) {
> -					if (WARN("REPEATED_WORD",
> -						 "Possible repeated word: '$last_word'\n" . $hereprev) &&
> -					    $fix) {
> -						$fixed[$fixlinenr] =~ s/(\+\s*\*\s*)$last_word /$1/;
> -					}
> -				}
> -			}
> -		}
> -
>   # ignore non-hunk lines and lines being removed
>   		next if (!$hunk_line || $line =~ /^-/);
>   
> @@ -3140,7 +3042,11 @@ sub process {
>   
>   				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate|prompt)\s*["']/) {
>   					$is_start = 1;
> -				} elsif ($lines[$ln - 1] =~ /^\+\s*(?:---)?help(?:---)?$/) {
> +				} elsif ($lines[$ln - 1] =~ /^\+\s*(?:help|---help---)\s*$/) {
> +					if ($lines[$ln - 1] =~ "---help---") {
> +						WARN("CONFIG_DESCRIPTION",
> +						     "prefer 'help' over '---help---' for new help texts\n" . $herecurr);
> +					}
>   					$length = -1;
>   				}
>   
> @@ -3308,12 +3214,6 @@ sub process {
>   			}
>   		}
>   
> -# check for embedded filenames
> -		if ($rawline =~ /^\+.*\Q$realfile\E/) {
> -			WARN("EMBEDDED_FILENAME",
> -			     "It's generally not useful to have the filename in the file\n" . $herecurr);
> -		}
> -
>   # check we are in a valid source file if not then ignore this hunk
>   		next if ($realfile !~ /\.(h|c|s|S|sh|dtsi|dts)$/);
>   
> @@ -3501,7 +3401,7 @@ sub process {
>   		if ($realfile =~ m@^(drivers/net/|net/)@ &&
>   		    $prevrawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
>   		    $rawline =~ /^\+[ \t]*\*/ &&
> -		    $realline > 3) { # Do not warn about the initial copyright comment block after SPDX-License-Identifier
> +		    $realline > 2) {
>   			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
>   			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
>   		}
> @@ -3960,17 +3860,6 @@ sub process {
>   #ignore lines not being added
>   		next if ($line =~ /^[^\+]/);
>   
> -# check for self assignments used to avoid compiler warnings
> -# e.g.:	int foo = foo, *bar = NULL;
> -#	struct foo bar = *(&(bar));
> -		if ($line =~ /^\+\s*(?:$Declare)?([A-Za-z_][A-Za-z\d_]*)\s*=/) {
> -			my $var = $1;
> -			if ($line =~ /^\+\s*(?:$Declare)?$var\s*=\s*(?:$var|\*\s*\(?\s*&\s*\(?\s*$var\s*\)?\s*\)?)\s*[;,]/) {
> -				WARN("SELF_ASSIGNMENT",
> -				     "Do not use self-assignments to avoid compiler warnings\n" . $herecurr);
> -			}
> -		}
> -
>   # check for dereferences that span multiple lines
>   		if ($prevline =~ /^\+.*$Lval\s*(?:\.|->)\s*$/ &&
>   		    $line =~ /^\+\s*(?!\#\s*(?!define\s+|if))\s*$Lval/) {
> @@ -4346,12 +4235,6 @@ sub process {
>   			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
>   		}
>   
> -# trace_printk should not be used in production code.
> -		if ($line =~ /\b(trace_printk|trace_puts|ftrace_vprintk)\s*\(/) {
> -			WARN("TRACE_PRINTK",
> -			     "Do not use $1() in production code (this can be ignored if built only with a debug config option)\n" . $herecurr);
> -		}
> -
>   # ENOSYS means "bad syscall nr" and nothing else.  This will have a small
>   # number of false positives, but assembly files are not checked, so at
>   # least the arch entry code will not trigger this warning.
> @@ -5018,17 +4901,6 @@ sub process {
>   			}
>   		}
>   
> -# check if a statement with a comma should be two statements like:
> -#	foo = bar(),	/* comma should be semicolon */
> -#	bar = baz();
> -		if (defined($stat) &&
> -		    $stat =~ /^\+\s*(?:$Lval\s*$Assignment\s*)?$FuncArg\s*,\s*(?:$Lval\s*$Assignment\s*)?$FuncArg\s*;\s*$/) {
> -			my $cnt = statement_rawlines($stat);
> -			my $herectx = get_stat_here($linenr, $cnt, $here);
> -			WARN("SUSPECT_COMMA_SEMICOLON",
> -			     "Possible comma where semicolon could be used\n" . $herectx);
> -		}
> -
>   # return is not a function
>   		if (defined($stat) && $stat =~ /^.\s*return(\s*)\(/s) {
>   			my $spacing = $1;
> @@ -5149,30 +5021,8 @@ sub process {
>   			my ($s, $c) = ($stat, $cond);
>   
>   			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
> -				if (ERROR("ASSIGN_IN_IF",
> -					  "do not use assignment in if condition\n" . $herecurr) &&
> -				    $fix && $perl_version_ok) {
> -					if ($rawline =~ /^\+(\s+)if\s*\(\s*(\!)?\s*\(\s*(($Lval)\s*=\s*$LvalOrFunc)\s*\)\s*(?:($Compare)\s*($FuncArg))?\s*\)\s*(\{)?\s*$/) {
> -						my $space = $1;
> -						my $not = $2;
> -						my $statement = $3;
> -						my $assigned = $4;
> -						my $test = $8;
> -						my $against = $9;
> -						my $brace = $15;
> -						fix_delete_line($fixlinenr, $rawline);
> -						fix_insert_line($fixlinenr, "$space$statement;");
> -						my $newline = "${space}if (";
> -						$newline .= '!' if defined($not);
> -						$newline .= '(' if (defined $not && defined($test) && defined($against));
> -						$newline .= "$assigned";
> -						$newline .= " $test $against" if (defined($test) && defined($against));
> -						$newline .= ')' if (defined $not && defined($test) && defined($against));
> -						$newline .= ')';
> -						$newline .= " {" if (defined($brace));
> -						fix_insert_line($fixlinenr + 1, $newline);
> -					}
> -				}
> +				ERROR("ASSIGN_IN_IF",
> +				      "do not use assignment in if condition\n" . $herecurr);
>   			}
>   
>   			# Find out what is on the end of the line after the
> @@ -5388,9 +5238,9 @@ sub process {
>   			$dstat =~ s/\s*$//s;
>   
>   			# Flatten any parentheses and braces
> -			while ($dstat =~ s/\([^\(\)]*\)/1u/ ||
> -			       $dstat =~ s/\{[^\{\}]*\}/1u/ ||
> -			       $dstat =~ s/.\[[^\[\]]*\]/1u/)
> +			while ($dstat =~ s/\([^\(\)]*\)/1/ ||
> +			       $dstat =~ s/\{[^\{\}]*\}/1/ ||
> +			       $dstat =~ s/.\[[^\[\]]*\]/1/)
>   			{
>   			}
>   
> @@ -5431,7 +5281,6 @@ sub process {
>   			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
>   			    $dstat !~ /^(?:\#\s*$Ident|\#\s*$Constant)\s*$/ &&		# stringification #foo
>   			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...} while (...); // do {...} while (...)
> -			    $dstat !~ /^while\s*$Constant\s*$Constant\s*$/ &&		# while (...) {...}
>   			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
>   			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
>   			    $dstat !~ /^do\s*{/ &&					# do {...
> @@ -6054,7 +5903,8 @@ sub process {
>   		my $barriers = qr{
>   			mb|
>   			rmb|
> -			wmb
> +			wmb|
> +			read_barrier_depends
>   		}x;
>   		my $barrier_stems = qr{
>   			mb__before_atomic|
> @@ -6103,6 +5953,12 @@ sub process {
>   			}
>   		}
>   
> +# check for smp_read_barrier_depends and read_barrier_depends
> +		if (!$file && $line =~ /\b(smp_|)read_barrier_depends\s*\(/) {
> +			WARN("READ_BARRIER_DEPENDS",
> +			     "$1read_barrier_depends should only be used in READ_ONCE or DEC Alpha code\n" . $herecurr);
> +		}
> +
>   # check of hardware specific defines
>   		if ($line =~ m@^.\s*\#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
>   			CHK("ARCH_DEFINES",
> @@ -6474,7 +6330,8 @@ sub process {
>   			if (defined $cond) {
>   				substr($s, 0, length($cond), '');
>   			}
> -			if ($s =~ /^\s*;/)
> +			if ($s =~ /^\s*;/ &&
> +			    $function_name ne 'uninitialized_var')
>   			{
>   				WARN("AVOID_EXTERNS",
>   				     "externs should be avoided in .c files\n" .  $herecurr);
> @@ -6493,13 +6350,17 @@ sub process {
>   		}
>   
>   # check for function declarations that have arguments without identifier names
> +# while avoiding uninitialized_var(x)
>   		if (defined $stat &&
> -		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*\(\s*([^{]+)\s*\)\s*;/s &&
> -		    $1 ne "void") {
> -			my $args = trim($1);
> +		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*(?:($Ident)|\(\s*\*\s*$Ident\s*\))\s*\(\s*([^{]+)\s*\)\s*;/s &&
> +		    (!defined($1) ||
> +		     (defined($1) && $1 ne "uninitialized_var")) &&
> +		     $2 ne "void") {
> +			my $args = trim($2);
>   			while ($args =~ m/\s*($Type\s*(?:$Ident|\(\s*\*\s*$Ident?\s*\)\s*$balanced_parens)?)/g) {
>   				my $arg = trim($1);
> -				if ($arg =~ /^$Type$/ && $arg !~ /enum\s+$Ident$/) {
> +				if ($arg =~ /^$Type$/ &&
> +					$arg !~ /enum\s+$Ident$/) {
>   					WARN("FUNCTION_ARGUMENTS",
>   					     "function definition argument '$arg' should also have an identifier name\n" . $herecurr);
>   				}
> @@ -6617,22 +6478,41 @@ sub process {
>   			}
>   		}
>   
> -# check for IS_ENABLED() without CONFIG_<FOO> ($rawline for comments too)
> -		if ($rawline =~ /\bIS_ENABLED\s*\(\s*(\w+)\s*\)/ && $1 !~ /^${CONFIG_}/) {
> -			WARN("IS_ENABLED_CONFIG",
> -			     "IS_ENABLED($1) is normally used as IS_ENABLED(${CONFIG_}$1)\n" . $herecurr);
> -		}
> -
>   # check for #if defined CONFIG_<FOO> || defined CONFIG_<FOO>_MODULE
> -		if ($line =~ /^\+\s*#\s*if\s+defined(?:\s*\(?\s*|\s+)(${CONFIG_}[A-Z_]+)\s*\)?\s*\|\|\s*defined(?:\s*\(?\s*|\s+)\1_MODULE\s*\)?\s*$/) {
> +		if ($line =~ /^\+\s*#\s*if\s+defined(?:\s*\(?\s*|\s+)(CONFIG_[A-Z_]+)\s*\)?\s*\|\|\s*defined(?:\s*\(?\s*|\s+)\1_MODULE\s*\)?\s*$/) {
>   			my $config = $1;
>   			if (WARN("PREFER_IS_ENABLED",
> -				 "Prefer IS_ENABLED(<FOO>) to ${CONFIG_}<FOO> || ${CONFIG_}<FOO>_MODULE\n" . $herecurr) &&
> +				 "Prefer IS_ENABLED(<FOO>) to CONFIG_<FOO> || CONFIG_<FOO>_MODULE\n" . $herecurr) &&
>   			    $fix) {
>   				$fixed[$fixlinenr] = "\+#if IS_ENABLED($config)";
>   			}
>   		}
>   
> +# check for case / default statements not preceded by break/fallthrough/switch
> +		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
> +			my $has_break = 0;
> +			my $has_statement = 0;
> +			my $count = 0;
> +			my $prevline = $linenr;
> +			while ($prevline > 1 && ($file || $count < 3) && !$has_break) {
> +				$prevline--;
> +				my $rline = $rawlines[$prevline - 1];
> +				my $fline = $lines[$prevline - 1];
> +				last if ($fline =~ /^\@\@/);
> +				next if ($fline =~ /^\-/);
> +				next if ($fline =~ /^.(?:\s*(?:case\s+(?:$Ident|$Constant)[\s$;]*|default):[\s$;]*)*$/);
> +				$has_break = 1 if ($rline =~ /fall[\s_-]*(through|thru)/i);
> +				next if ($fline =~ /^.[\s$;]*$/);
> +				$has_statement = 1;
> +				$count++;
> +				$has_break = 1 if ($fline =~ /\bswitch\b|\b(?:break\s*;[\s$;]*$|exit\s*\(\b|return\b|goto\b|continue\b)/);
> +			}
> +			if (!$has_break && $has_statement) {
> +				WARN("MISSING_BREAK",
> +				     "Possible switch case/default not preceded by break or fallthrough comment\n" . $herecurr);
> +			}
> +		}
> +
>   # check for /* fallthrough */ like comment, prefer fallthrough;
>   		my @fallthroughs = (
>   			'fallthrough',
> @@ -6748,8 +6628,7 @@ sub process {
>   
>   # check for various structs that are normally const (ops, kgdb, device_tree)
>   # and avoid what seem like struct definitions 'struct foo {'
> -		if (defined($const_structs) &&
> -		    $line !~ /\bconst\b/ &&
> +		if ($line !~ /\bconst\b/ &&
>   		    $line =~ /\bstruct\s+($const_structs)\b(?!\s*\{)/) {
>   			WARN("CONST_STRUCT",
>   			     "struct $1 should normally be const\n" . $herecurr);
> @@ -6980,33 +6859,9 @@ sub process {
>   		if ($signoff == 0) {
>   			ERROR("MISSING_SIGN_OFF",
>   			      "Missing Signed-off-by: line(s)\n");
> -		} elsif ($authorsignoff != 1) {
> -			# authorsignoff values:
> -			# 0 -> missing sign off
> -			# 1 -> sign off identical
> -			# 2 -> names and addresses match, comments mismatch
> -			# 3 -> addresses match, names different
> -			# 4 -> names match, addresses different
> -			# 5 -> names match, addresses excluding subaddress details (refer RFC 5233) match
> -
> -			my $sob_msg = "'From: $author' != 'Signed-off-by: $author_sob'";
> -
> -			if ($authorsignoff == 0) {
> -				ERROR("NO_AUTHOR_SIGN_OFF",
> -				      "Missing Signed-off-by: line by nominal patch author '$author'\n");
> -			} elsif ($authorsignoff == 2) {
> -				CHK("FROM_SIGN_OFF_MISMATCH",
> -				    "From:/Signed-off-by: email comments mismatch: $sob_msg\n");
> -			} elsif ($authorsignoff == 3) {
> -				WARN("FROM_SIGN_OFF_MISMATCH",
> -				     "From:/Signed-off-by: email name mismatch: $sob_msg\n");
> -			} elsif ($authorsignoff == 4) {
> -				WARN("FROM_SIGN_OFF_MISMATCH",
> -				     "From:/Signed-off-by: email address mismatch: $sob_msg\n");
> -			} elsif ($authorsignoff == 5) {
> -				WARN("FROM_SIGN_OFF_MISMATCH",
> -				     "From:/Signed-off-by: email subaddress mismatch: $sob_msg\n");
> -			}
> +		} elsif (!$authorsignoff) {
> +			WARN("NO_AUTHOR_SIGN_OFF",
> +			     "Missing Signed-off-by: line by nominal patch author '$author'\n");
>   		}
>   	}
>   
