Return-Path: <io-uring+bounces-11107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C212DCC0D17
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:00:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 30710303D26A
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED59332ABD0;
	Tue, 16 Dec 2025 03:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="fzeqbQ7J"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9D4311955;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857298; cv=none; b=tGHKMIGR/PYqKYdVBSOW36x0fWjBGI8/JF2oZ5hnrf/sinrszNPjF5fSFNFRFk/ZBRfeqfsA4+U9/qyRq1oFbv8KyJevk0i3o2M0djCbA5qILAshj4y7c2Gpd3oBHz7OSQp54lVf5GVuKzrmMgaVMfQ4yimz9+/Ov8f7OwNvWTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857298; c=relaxed/simple;
	bh=Jw+FsY0+YyKEuFj2ggSB57u9K4FdlAxgmcIIzmmXnSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dLML4KjIL9HWepyBAc3Anc9XZ5jJwt9awh8Rjt3xLbUlgAPx0limflM6uL3l8n7kLaNlR0VQCNbgM2XzzPgvvxtuIEMoU9IYOCoph204xG/enhpZq1Dlpghb1GALFHHPw8lvG3JrdxDbgEYbH+QzAf4CO8+1v7s3SR8bCl7dhUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=fzeqbQ7J; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=V2GQveWCk6oazsaZDx3Fayxa7OvWoQ/wztA7ekVFvTc=; b=fzeqbQ7J/dBe+5hedSpXH7osht
	6jPHsdhraZBm1KBdQilrDVganZbh1tBGkogMRTpjxC+eWtny65tRx7aAN1lFQbcim+Occme/KXVyB
	R9kx9FCBSIHgGRaSV2YJCRgJsl+aKyPucbRSown4y2JAH2fmjD6aj8TxNS4Lq8mIZ6P2YyrGfcf97
	ag1rA+ykZY8R3dUwueyfzQEKkzKvcv9sQWCLuelxpTC7dvn68wwYypDUCTT+gORjE+pGPxJpjUdD/
	2GpUSvpDrCWUtp0rkyk2PrM4AcEi8Tv2g+hKm+8xTJtPrBnPAzjC7kI4GXZwsIEgCEBUHL1iCFIQT
	tluder7Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9e-0000000GwIU-26TC;
	Tue, 16 Dec 2025 03:55:18 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 00/59] struct filename work
Date: Tue, 16 Dec 2025 03:54:19 +0000
Message-ID: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

[Considerably grown since the last time it had been posted - see
https://lore.kernel.org/all/20251129170142.150639-1-viro@zeniv.linux.org.uk/
for previous variant]

Changes compared to v2:
	* rebased to v6.19-rc1, dropped mguzik's patch merged in mainline
	* size of embedded name bumped up, so that sizeof(struct filename)
ends up being 192 bytes (64-byte aligned and large enough to cover everything
realistic).
	* in #17 ("allow incomplete imports of filenames") don't open-code
getname_kernel() in the "copy" case.
	* taken out ntfs (ab)uses of names_cachep added this cycle
	* add CLASS() machinery for struct filename; it fits most of the
users.  Plenty of conversions later in the series...
	* most of the pathwalk-related API does the right thing on ERR_PTR()
passed as filename; the only exception is do_filp_open(), that needs to have
that checked in its callers.  Moved the check into it, simplified the callers
(and in some cases callers of callers, and...)
	* renamed 'do_filp_open' to 'do_file_open' - should've been called
that way from the very beginning.  My fault, back in 2.1.128, when cretinous
filp_open() had been added ;-/
	* alpha osf_mount() device name imports are done the same way as
the regular mount() does - strndup_user()
	* sysfs(2) (no relation to sysfs) used to abuse getname() for
importing filesystem type name; no more.

The branch lives in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.filename
now; individual patches in followups.

Review and testing would be very welcome; it seems to survive the local
beating, but...

Shortlog:

Al Viro (58):
  do_faccessat(): import pathname only once
  do_fchmodat(): import pathname only once
  do_fchownat(): import pathname only once
  do_utimes_path(): import pathname only once
  chdir(2): import pathname only once
  chroot(2): import pathname only once
  user_statfs(): import pathname only once
  do_sys_truncate(): import pathname only once
  do_readlinkat(): import pathname only once
  get rid of audit_reusename()
  ntfs: ->d_compare() must not block
  getname_flags() massage, part 1
  getname_flags() massage, part 2
  struct filename: use names_cachep only for getname() and friends
  struct filename: saner handling of long names
  allow incomplete imports of filenames
  struct filename ->refcnt doesn't need to be atomic
  allow to use CLASS() for struct filename *
  file_getattr(): filename_lookup() accepts ERR_PTR() as filename
  file_setattr(): filename_lookup() accepts ERR_PTR() as filename
  move_mount(): filename_lookup() accepts ERR_PTR() as filename
  ksmbd_vfs_path_lookup(): vfs_path_parent_lookup() accepts ERR_PTR() as name
  ksmbd_vfs_rename(): vfs_path_parent_lookup() accepts ERR_PTR() as name
  do_filp_open(): DTRT when getting ERR_PTR() as pathname
  rename do_filp_open() to do_file_open()
  do_sys_openat2(): get rid of useless check, switch to CLASS(filename)
  simplify the callers of file_open_name()
  simplify the callers of do_open_execat()
  simplify the callers of alloc_bprm()
  switch {alloc,free}_bprm() to CLASS()
  file_[gs]etattr(2): switch to CLASS(filename_maybe_null)
  mount_setattr(2): don't mess with LOOKUP_EMPTY
  do_open_execat(): don't care about LOOKUP_EMPTY
  vfs_open_tree(): use CLASS(filename_uflags)
  name_to_handle_at(): use CLASS(filename_uflags)
  fspick(2): use CLASS(filename_flags)
  do_fchownat(): unspaghettify a bit...
  chdir(2): unspaghettify a bit...
  do_utimes_path(): switch to CLASS(filename_uflags)
  do_sys_truncate(): switch to CLASS(filename)
  do_readlinkat(): switch to CLASS(filename_flags)
  do_f{chmod,chown,access}at(): use CLASS(filename_uflags)
  io_openat2(): use CLASS(filename_complete_delayed)
  io_statx(): use CLASS(filename_complete_delayed)
  do_{renameat2,linkat,symlinkat}(): use CLASS(filename_consume)
  do_{mknodat,mkdirat,unlinkat,rmdir}(): use CLASS(filename_consume)
  namei.c: convert getname_kernel() callers to CLASS(filename_kernel)
  namei.c: switch user pathname imports to CLASS(filename{,_flags})
  filename_...xattr(): don't consume filename reference
  move_mount(2): switch to CLASS(filename_maybe_null)
  chroot(2): switch to CLASS(filename)
  quotactl_block(): switch to CLASS(filename)
  statx: switch to CLASS(filename_maybe_null)
  user_statfs(): switch to CLASS(filename)
  mqueue: switch to CLASS(filename)
  ksmbd: use CLASS(filename_kernel)
  alpha: switch osf_mount() to strndup_user()
  sysfs(2): fs_index() argument is _not_ a pathname

Mateusz Guzik (1):
  fs: hide names_cache behind runtime const machinery

Diffstat:

 arch/alpha/kernel/osf_sys.c       |  34 +--
 fs/dcache.c                       |   8 +-
 fs/exec.c                         |  99 +++-----
 fs/fhandle.c                      |   5 +-
 fs/file_attr.c                    |  12 +-
 fs/filesystems.c                  |   9 +-
 fs/fsopen.c                       |   6 +-
 fs/internal.h                     |   4 +-
 fs/namei.c                        | 359 ++++++++++++++++--------------
 fs/namespace.c                    |  22 +-
 fs/ntfs3/inode.c                  |   6 +-
 fs/ntfs3/namei.c                  |   8 +-
 fs/open.c                         | 119 ++++------
 fs/quota/quota.c                  |   3 +-
 fs/smb/server/vfs.c               |  15 +-
 fs/stat.c                         |  28 +--
 fs/statfs.c                       |   3 +-
 fs/utimes.c                       |   8 +-
 fs/xattr.c                        |  33 +--
 include/asm-generic/vmlinux.lds.h |   3 +-
 include/linux/audit.h             |  11 -
 include/linux/fs.h                |  42 ++--
 io_uring/fs.c                     | 101 +++++----
 io_uring/openclose.c              |  26 +--
 io_uring/statx.c                  |  17 +-
 io_uring/xattr.c                  |  30 +--
 ipc/mqueue.c                      |  11 +-
 kernel/acct.c                     |   4 +-
 kernel/auditsc.c                  |  23 +-
 mm/huge_memory.c                  |  15 +-
 mm/swapfile.c                     |  21 +-
 31 files changed, 459 insertions(+), 626 deletions(-)

Rough overview:
1--9:
	moving pathname import out of retry loops
10:
	now we can get rid of "reuse the struct filename if
we'd just imported it from the same address _and_ audit is
enabled" logics.
11:
	get rid of names_cachep abuse in ntfs
12--15:
	embed reasonably short pathnames into struct filename,
*always* get struct filename out names_cachep, take the long
names into explicitly kmalloc'ed objects.
NB: EMBEDDED_NAME_MAX is 128 at the moment; might make sense
to increase it - the nearest kmalloc cache size is 192 bytes,
so we are leaving gaps anyway.  40 bytes increase, at least?
More on 32bit...
16:
	runtime_const machinery for names_cachep; there's
a potentially better variant (statically allocated kmem_cache),
but that's a separate series.
17:
	delayed_filename machinery, solves the audit vs. io_uring
problems.
18:
	now we don't need filename->refcnt to be atomic.
19:
	infrastructure for CLASS(filename...)
20--24:
	simplify checks in callers of pathwalk primitives -
	they (with exception of do_filp_open()) will do
	the right thing if given ERR_PTR() for name.
25--31:	... get rid of that one exception and simplify
	more callers.
32--57:
	conversions to CLASS(filename...), cleanups
58, 59:
	... and these should not have been using getname().

-- 
2.47.3


