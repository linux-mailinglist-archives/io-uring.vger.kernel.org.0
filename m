Return-Path: <io-uring+bounces-11676-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2424FD1C5E1
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0D1C23013BE9
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738F233033C;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="MtNfXA6o"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85CD2DFF1D;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365118; cv=none; b=UQ8AUv4uQ/WJ3tAVydDTqWhHdMEB2eU9xjwZkTPxzLnY/K0HrQmuRndTrFOCe8eigITBuRuU7iqdBX26i5h2iKdpeTXISEL9FBOuBxH31p7deDqdpoC1dnhv6JrQb8BY5ikoaJA4a1CYQe9Pq3gBA4RdXEyEfjhzQKBQx2LtwVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365118; c=relaxed/simple;
	bh=GITWtUBN9369T2YKJrqBUomNGh4WA/xgnfod+ffrsZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A2RgL2fCP98oIF2DdtqRnFKrzJtyjmOaKdpyyueadj5ubZE2qA/cEYHE2KuQGY0D7D6Zj4VE1lr0o1eU4V65jkeltsz/qSvINb9sUFT5gZ3+8dmxonqGHH8YwapG5x2py/dRduonKdQid1g9M2dCgNy67f//QlWIb/l969erBGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=MtNfXA6o; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=zv6rARXDVHobRjswplRLW7oQe9XaQw7o/2HgOZ+Y/fQ=; b=MtNfXA6oVL6iBByIlW4pL3nuXF
	3ZdsDZekEI9e5MbK9ybDk2iEgrqLCMEfYxoLYcYSeSqiA77wdquH/hGb+XFA+PRfU4Q4I7OSpHdDQ
	xglQwoPjuhn7AdnqcLgRcWlDyry8+crRev/5R1Ak/tZYhQx22xYJWVq3PrkYL+5EOTnl3otVPQiAr
	xD07ANLoSeYajZx+ZXxFe89NFDYNKsHHYUNh/+2n6gFl7ABmKB8oko4dKCtShTus92ADOYU6HF79D
	a1P22qnjzXXwqsiPIMAqxtSJiWaEc+waBSBL8GOH0cJ/Xvvy+s7GsS5JOJ2SrraLpR/LKL9j6i9Cz
	3FZdgTtA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZC-0000000GImx-17du;
	Wed, 14 Jan 2026 04:33:10 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 00/68] struct filename series
Date: Wed, 14 Jan 2026 04:32:02 +0000
Message-ID: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

[See https://lore.kernel.org/all/20260108073803.425343-1-viro@zeniv.linux.org.uk
for previous variant]

Changes compared to v4:
	* rebased to v6.19-rc5
	* replaced do_renameat2() et.al. with variants (filename_renameat2(), etc.)
that do not consume filename references
	* did the same (sans renaming, since it's static in file) to
do_execveat(); folded its callers into their sole callers.
	* CLASS(filename_consume) dropped; no users left.
	* fixed an embarrassing braino in EMBEDDED_NAME_MAX definition
	* reordered things a bit

Practically all destructor calls are done via CLASS(filename...) now;
only 3 explicit calls left (one in audit, dropping the references it has
grabbed for itself, two in the vicinity of fsconfig - separate story).
Only two explicit calls of constructors left (around fsconfig).
No uses of __free(putname) remain; I haven't removed DEFINE_FREE yet,
but it's really tempting.

The branch lives in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.filename
now; individual patches in followups.

Please, review.

Rough overview:
	Preliminary bits:

1--4:	get rid of open-coded duplicates of do_mkdirat() et.al. in
	fs/init.c
5:	CLASS(filename...) definitions (part of old #17)

	Trimming struct filename down, saner allocation, io_uring
interactions, etc. (that's old core of the series - ##1--16,18--20)

6--15:	moving pathname import out of retry loops.
15:	now we can get rid of "reuse the struct filename if
we'd just imported it from the same address _and_ audit is
enabled" logics.
16:	get rid of names_cachep abuse in ntfs
17--20: embed reasonably short pathnames into struct filename,
*always* get struct filename out names_cachep, take the long
names into explicitly kmalloc'ed objects.
21:	runtime_const machinery for names_cachep; there's
a potentially better variant (statically allocated kmem_cache),
but that's a separate series.
22:	switch __getname_maybe_null() to CLASS(filename)
23:	delayed_filename machinery, solves the audit vs. io_uring
problems.
24:	now we don't need filename->refcnt to be atomic.

	Calling conventions work:
25--29:
	simplify checks in callers of pathwalk primitives - they
	(with exception of do_filp_open()) will do the right
	thing if given ERR_PTR() for name.
30--45:	... get rid of that one exception and simplify
	more callers; get saner calling conventions for
	do_execveat_common() (lift consuming the filename into
	callers), do_renameat2() et.al. (renamed to filename_...())
	and filename_...xattr().

46--66:
	conversions to CLASS(filename...), cleanups
67, 68:
	... and these should not have been using getname().

Shortlog:
Al Viro (67):
  init_mknod(): turn into a trivial wrapper for do_mknodat()
  init_mkdir(): turn into a trivial wrapper for do_mkdirat()
  init_symlink(): turn into a trivial wrapper for do_symlinkat()
  init_link(): turn into a trivial wrapper for do_linkat()
  allow to use CLASS() for struct filename *
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
  switch __getname_maybe_null() to CLASS(filename_flags)
  allow incomplete imports of filenames
  struct filename ->refcnt doesn't need to be atomic
  file_getattr(): filename_lookup() accepts ERR_PTR() as filename
  file_setattr(): filename_lookup() accepts ERR_PTR() as filename
  move_mount(): filename_lookup() accepts ERR_PTR() as filename
  ksmbd_vfs_path_lookup(): vfs_path_parent_lookup() accepts ERR_PTR() as
    name
  ksmbd_vfs_rename(): vfs_path_parent_lookup() accepts ERR_PTR() as name
  do_filp_open(): DTRT when getting ERR_PTR() as pathname
  rename do_filp_open() to do_file_open()
  do_sys_openat2(): get rid of useless check, switch to CLASS(filename)
  simplify the callers of file_open_name()
  simplify the callers of do_open_execat()
  simplify the callers of alloc_bprm()
  execve: fold {compat_,}do_execve{,at}() into their sole callers
  do_execveat_common(): don't consume filename reference
  switch {alloc,free}_bprm() to CLASS()
  non-consuming variant of do_renameat2()
  non-consuming variant of do_linkat()
  non-consuming variant of do_symlinkat()
  non-consuming variant of do_mkdirat()
  non-consuming variant of do_mknodat()
  non-consuming variants of do_{unlinkat,rmdir}()
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
 Documentation/filesystems/porting.rst |   8 +
 arch/alpha/kernel/osf_sys.c           |  34 +--
 fs/coredump.c                         |   3 +-
 fs/dcache.c                           |   8 +-
 fs/exec.c                             | 178 ++++-------
 fs/fhandle.c                          |   5 +-
 fs/file_attr.c                        |  12 +-
 fs/filesystems.c                      |   9 +-
 fs/fsopen.c                           |   6 +-
 fs/init.c                             |  98 +-----
 fs/internal.h                         |  17 +-
 fs/namei.c                            | 420 ++++++++++++++------------
 fs/namespace.c                        |  22 +-
 fs/ntfs3/dir.c                        |   5 +-
 fs/ntfs3/fsntfs.c                     |   4 +-
 fs/ntfs3/inode.c                      |  13 +-
 fs/ntfs3/namei.c                      |  17 +-
 fs/ntfs3/xattr.c                      |   5 +-
 fs/open.c                             | 119 +++-----
 fs/quota/quota.c                      |   3 +-
 fs/smb/server/vfs.c                   |  15 +-
 fs/stat.c                             |  28 +-
 fs/statfs.c                           |   3 +-
 fs/utimes.c                           |   8 +-
 fs/xattr.c                            |  33 +-
 include/asm-generic/vmlinux.lds.h     |   3 +-
 include/linux/audit.h                 |  11 -
 include/linux/fs.h                    |  41 ++-
 io_uring/fs.c                         | 106 ++++---
 io_uring/openclose.c                  |  26 +-
 io_uring/statx.c                      |  17 +-
 io_uring/xattr.c                      |  30 +-
 ipc/mqueue.c                          |  11 +-
 kernel/acct.c                         |   4 +-
 kernel/auditsc.c                      |  29 +-
 mm/huge_memory.c                      |  15 +-
 mm/swapfile.c                         |  21 +-
 37 files changed, 560 insertions(+), 827 deletions(-)

-- 
2.47.3


