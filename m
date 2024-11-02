Return-Path: <io-uring+bounces-4343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E26C9B9D9C
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:28:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2028282AE0
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2D914A630;
	Sat,  2 Nov 2024 07:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="N+AXVitA"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2386C482EB;
	Sat,  2 Nov 2024 07:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532522; cv=none; b=mL09ZlRNW93nwEiPjhuAtKXxFtIQ798+GwYjwd5wonfuqABLUqZeToJMCZKLBoUaPve7NS63HKNGckMgepMyRpCjXljVUii5GOl5abxpr23lERvd96mhc8jEPssjv+kXQGmpCBEwg2nmBE0Wx/Qzepa2O3/8n4NBCIeJVE1LSOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532522; c=relaxed/simple;
	bh=e1WyBJo0Ob7wuX6XkavSMCd6VoJn+8yKC6VMxrHljwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUdXGVWVkfw+IeIbv8LehTZehv7baBxNeqNjzrjyZGXx0l0A/WDGoG+2arIHj5Qu9q4Z+3Th9pcZ0BApKkoh1YWdY0DAssUwLjTYQkIHtfZp6oBIN9T3eSpqzuwP6KPlAgGkElCl7LK+hphZvM+nHVoclUkeEv2FhfFE9DvhFuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=N+AXVitA; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=KdyJHo0XKh4gXumMYq9TRebmNovfgvgV8NKhslnw/FY=; b=N+AXVitAvONnjcXLYcIHZngRTs
	wNuOtCjCKg1hf0YE6aMSilC8dNLDViRsxbMWMMkG79aur7OoN5llN5P6OmA1P4QILCd0uukfGVK5V
	QBiiUq9nPVWZ8D3/dy/j/74QTBsuZzUNxmRln6R6LbrrpbMFOAsAk8l4FxMM4Jns1Ou51kg9nDbkL
	nffN/C6U+4U6NO/PLecFyyFzf2VGyNBBj9zU4kkMtZudeEM611jsUtnTp1va7P+nOV9lv9Ng31IX7
	ZRoCjJleJnjxNrf/bPA0vS/gdkfF/9wZvw+HbuvOsgkwFhW80UhHqj20IZnV/sDr8txuHU6Ukd3rj
	wdYnWCSA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78Yk-0000000AJA2-0C5v;
	Sat, 02 Nov 2024 07:28:34 +0000
Date: Sat, 2 Nov 2024 07:28:34 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org,
	Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Subject: [RFC][PATCHES v2] xattr stuff and interactions with io_uring
Message-ID: <20241102072834.GQ1350452@ZenIV>
References: <20241002011011.GB4017910@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241002011011.GB4017910@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

	Changes since v1:
* moved on top of (and makes use of) getname_maybe_null() stuff
(first two commits here, form #base.getname-fixed)
* fixed a leak on io_uring side spotted by Jens
* putname(ERR_PTR(-E...)) is a no-op; allows to simplify things on
io_uring side.
* applied reviewed-by
* picked a generic_listxattr() cleanup from Colin Ian King

	Help with review and testing would be welcome; if nobody objects,
to #for-next it goes...

The branch lives in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.xattr2
Individual patches in followups.
 
Diffstat:
 arch/alpha/kernel/syscalls/syscall.tbl      |   4 +
 arch/arm/tools/syscall.tbl                  |   4 +
 arch/m68k/kernel/syscalls/syscall.tbl       |   4 +
 arch/microblaze/kernel/syscalls/syscall.tbl |   4 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |   4 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |   4 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |   4 +
 arch/parisc/kernel/syscalls/syscall.tbl     |   4 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |   4 +
 arch/s390/kernel/syscalls/syscall.tbl       |   4 +
 arch/sh/kernel/syscalls/syscall.tbl         |   4 +
 arch/sparc/kernel/syscalls/syscall.tbl      |   4 +
 arch/x86/entry/syscalls/syscall_32.tbl      |   4 +
 arch/x86/entry/syscalls/syscall_64.tbl      |   4 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |   4 +
 fs/internal.h                               |  17 +-
 fs/namei.c                                  |  34 ++-
 fs/stat.c                                   |  28 +-
 fs/xattr.c                                  | 446 ++++++++++++++++++----------
 include/asm-generic/audit_change_attr.h     |   6 +
 include/linux/fs.h                          |  10 +
 include/linux/syscalls.h                    |  13 +
 include/linux/xattr.h                       |   4 +
 include/uapi/asm-generic/unistd.h           |  11 +-
 include/uapi/linux/xattr.h                  |   7 +
 io_uring/xattr.c                            |  97 ++----
 26 files changed, 466 insertions(+), 267 deletions(-)

Shortog:

Al Viro (9):
      teach filename_lookup() to treat NULL filename as ""
      getname_maybe_null() - the third variant of pathname copy-in
      io_[gs]etxattr_prep(): just use getname()
      xattr: switch to CLASS(fd)
      new helper: import_xattr_name()
      replace do_setxattr() with saner helpers.
      replace do_getxattr() with saner helpers.
      new helpers: file_listxattr(), filename_listxattr()
      new helpers: file_removexattr(), filename_removexattr()

Christian Göttsche (2):
      fs: rename struct xattr_ctx to kernel_xattr_ctx
      fs/xattr: add *at family syscalls

Colin Ian King (1):
      xattr: remove redundant check on variable err

Jens Axboe (1):
      io_uring: IORING_OP_F[GS]ETXATTR is fine with REQ_F_FIXED_FILE

Patch summaries:

getname_maybe_null() introduction (#getname.base-fixed):
01/13) teach filename_lookup() to treat NULL filename as ""
02/13) getname_maybe_null() - the third variant of pathname copy-in

io_uring-side prep:
03/13) io_uring: IORING_OP_F[GS]ETXATTR is fine with REQ_F_FIXED_FILE
04/13) io_[gs]etxattr_prep(): just use getname()
	getname_flags(_, LOOKUP_FOLLOW) is ridiculous.

05/13)	switch to CLASS(fd) use.  Obvious.

06/13)	rename struct xattr_ctx to kernel_xattr_ctx
prep from the ...xattrat() series, to reduce the PITA for rebase

07/13)	new helper: import_xattr_name()
exact same logics for copying the xattr name in, dealing with
overflows, etc. in a lot of places.  

08/13)	replace do_setxattr() with saner helpers
file_setxattr(file, ctx) and filename_setxattr(dfd, filename, lookup_flags, ctx).
Don't mess with do_setxattr() directly - use those.  In particular, don't
bother with the ESTALE loop in io_uring - it doesn't belong there.
 
09/13)	replace do_getxattr() with saner helpers
Same on getxattr() side.

10/13)	new helpers: file_listxattr(), filename_listxattr()
Same, except that io_uring doesn't use those, so the helpers are left static.

11/13)	new helpers: file_removexattr(), filename_removexattr()
Ditto

12/13)	fs/xattr: add *at family syscalls
Rebased patch introducing those, with a bunch of fixes folded in so we don't
create bisect hazard there.  Potentially interesting bit is the pathname-handling
logics - getname_maybe_null(pathname, flags) returns a struct filename reference
if no AT_EMPTY_PATH had been given or if the pathname was non-NULL and turned out
to be non-empty.  With (NULL,AT_EMPTY_PATH) or (empty string, AT_EMPTY_PATH) it
returns NULL (and it tries to skip the allocation using the same trick with
get_user() that vfs_empty_path() uses).  That helper simplifies a lot of things,
and it should be cheap enough to convert fsetxattr(2) et.al. to the unified
path_setxattrat() and its ilk.  IF we get a slowdown on those, we can always
expand and simplify the calls in fsetxattr(2) and friends.

13/13) xattr: remove redundant check on variable err

