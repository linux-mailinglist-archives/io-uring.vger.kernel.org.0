Return-Path: <io-uring+bounces-3351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A03898CA5F
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E650728256B
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D416210E9;
	Wed,  2 Oct 2024 01:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="gh+X8RpE"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8A879CC;
	Wed,  2 Oct 2024 01:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831419; cv=none; b=jUGPVgphR67r24Ug8MRS8fCkaJLgAK66r/Rz0HZihUVxspBObGKYibSaxCnotGlrHb5s8pT8O1v6CTE3Z1jTkC/QIQg5d7nPgTkbrBp59d9cpjdtVTeipUzHRVdz8KrXsp2xPk85XC3LgA0q99rXySvioHgLW7a+Z6Jfsy9XBfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831419; c=relaxed/simple;
	bh=44fAzCjY1PpAx7Orq+TgduSggoQ/opp11CjHO4oKOas=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SYFp4mjB8rnEeb7KS8AHGAFVVGtBwxjxcOrFk5aWNGWGRMXGIW3sqFE6CUh7QYNFi5yfPckKsY/aQfL4j+yzoBvFd59cVVj4PJZUMsabSVDJjaNyVmDDqA7OCG3jExPSUW+bVW0lvKsT02LHKVkutBIGqn46wg0mP6Z26runV3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=gh+X8RpE; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RDv6TPZivj590q7UmSENHpD7Mo5EUEKBoexMJ9K4HVo=; b=gh+X8RpEJWYWvLvdpXmrYogMKz
	yfyE/0VWmFFrw/bxV4sqlJBnXW+NhB20yVx7/70cur10z51e7QbLFKIrOzwjhDWF9rBjRdfmjnyF/
	+b/Uh1SsahJKcW/eK2MlnN8/ZATeJ+kKjUa4j+Lf0mfUsprlHQ3WJvr44ywIbSqK+jG36tEKyJwzq
	tqMvXqxzkZL/rUD1PpcXHnzzsz6fPdvrEmeh1LASH/ikCXgmAnuhCeNzJ9Lq3wtxbrskp1QiACE+X
	Kqez4iC/sA2szVoaXE9vGJAMHdGkj69vcb4+n2BpUvjFiwrW8tmlbrXDVA/uAdIY261GK4yYue6J7
	IdbAEXzQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svnsZ-0000000HVcQ-0hKU;
	Wed, 02 Oct 2024 01:10:11 +0000
Date: Wed, 2 Oct 2024 02:10:11 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org,
	Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Subject: [RFC][PATCHES] xattr stuff and interactions with io_uring
Message-ID: <20241002011011.GB4017910@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>

	The series below is a small-scale attempt at sanitizing the
interplay between io_uring and normal syscalls.  It is limited to
xattr-related syscalls and I would like to have a similar approach taken
a lot further than that.

	Right now we have an ad-hoc mess, with io_uring stuff hooked
at different layers to syscall guts.  And it keeps growing and getting
messier.

	As far as I can tell, the general rules are

* we want arguments copied in when request is submitted to io_uring.
Rationale: userland caller should be able to have that stuff on his
stack frame, rather than keeping it around until the request completion.
Fair enough.

* destination for the stuff we want copied _out_ (results of read(),
etc.)  has to stay around until the IO completion.  In other words, such
references remain as userland pointers until the request is executed.
Fair enough.

* the things get less clear-cut where we are talking about bulk data
copied _in_ - write() arguments, for example.  In some cases we do
handle that at request execution time, in some we do not (setsockopt
vs. setxattr vs. write, for example).  Decided on individual basis?

* some argument validation is done when request is submitted; however,
anything related to resolving pathnames (at least - there may be other
such areas) is done only at the time request is processed.  Rationale:
previous requests might alter the state in question and we want the
effects of such changes visible to our request.

* pathnames are copied in at submission time and resolved at execution
time; descriptors are resolved at submission time, except when used in
dirfd role.

	What I propose for xattr stuff (and what could serve as a model
for other cases) is two families of helpers; one takes struct file
reference + whatever other arguments we want, another - dfd + filename +
lookup_flags + other arguments; filename is passed as a struct filename
reference, which is consumed by the helper.

	Normal syscalls are easily expressed via those; io_uring side is
also apparently OK.  Not sure if it's flexible enough, though - e.g.
IORING_OP_MKDIRAT et.al. end up resolving the descriptor _twice_
and can't have it coming from io_uring analogue of descriptor table.
It might make more sense to allow a variant that would have dirfd already
resolved to file reference.  It's not that hard to do on fs/namei.c side
(set_nameidata() and path_init() would have to be taught about that,
and that's more of less it), but... we need to figure out whether it
makes better sense to have descriptor resolution prompt or delayed on
the io_uring side - i.e. at submission or at execution time.

	Anyway, for now I'm following the model we have for do_mkdirat()
et.al.  It's definitely flexible enough on the syscall side; in particular,
rebasing ...xattrat(2) patch on top of that had been trivial.  It also
promises some fairly nice simplifications wrt struct filename vs. audit,
but that's a separate story.

	Currently the branch lives in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.xattr
Individual patches in followups.

1/9)	switch to CLASS(fd) use.  Obvious.

2/9)	rename struct xattr_ctx to kernel_xattr_ctx
prep from the ...xattrat() series, to reduce the PITA for rebase

3/9)	io_[gs]etxattr_prep(): just use getname()
getname_flags(_, LOOKUP_FOLLOW) is ridiculous.

4/9)	new helper: import_xattr_name()
exact same logics for copying the xattr name in, dealing with
overflows, etc. in a lot of places.  

5/9)	replace do_setxattr() with saner helpers
file_setxattr(file, ctx) and filename_setxattr(dfd, filename, lookup_flags, ctx).
Don't mess with do_setxattr() directly - use those.  In particular, don't
bother with the ESTALE loop in io_uring - it doesn't belong there.

6/9)	replace do_getxattr() with saner helpers
Same on getxattr() side.

7/9)	new helpers: file_listxattr(), filename_listxattr()
Same, except that io_uring doesn't use those, so the helpers are left static.

8/9)	new helpers: file_removexattr(), filename_removexattr()
Ditto

9/9)	fs/xattr: add *at family syscalls
Rebased patch introducing those, with a bunch of fixes folded in so we don't
create bisect hazard there.  Potentially interesting bit is the pathname-handling
logics - getname_xattr(pathname, flags) returns a struct filename reference
if no AT_EMPTY_PATH had been given or if the pathname was non-NULL and turned out
to be non-empty.  With (NULL,AT_EMPTY_PATH) or (empty string, AT_EMPTY_PATH) it
returns NULL (and it tries to skip the allocation using the same trick with
get_user() that vfs_empty_path() uses).  That helper simplifies a lot of things,
and it should be cheap enough to convert fsetxattr(2) et.al. to the unified
path_setxattrat() and its ilk.  IF we get a slowdown on those, we can always
expand and simplify the calls in fsetxattr(2) and friends.

Anyway, comments, review and testing would be very welcome.

