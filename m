Return-Path: <io-uring+bounces-11458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 101DDD016E7
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05A79305CCF3
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BAD233C514;
	Thu,  8 Jan 2026 07:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="M/OMdZOe"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA9830FF1E;
	Thu,  8 Jan 2026 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857815; cv=none; b=dho5KPtnEAm9/17uRFQRlj5Nxm0CXwWuAGCSrBkd86zHwvewoQWW0n6TnQrBHxF2lh+Bc2v1hy/jByuuJ7KcEqhsfcaNRvlJLAk2NUHMIzy+tYUETH4i2ziURK7KMXOJ4XVRpHiTMKGJu4tYBBCV4gJfwr2nZilxtBKx8/Co0Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857815; c=relaxed/simple;
	bh=3CwEx7g4XxzBUc0Q+bIGX7rkAAwNZQrWabi2+H1hf6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pafPl1bPGEzpJqa+A0jJ9P1rFB+IVkoU+bYGzrdqiDGkJRhreaA7ogO1QWRcZZMc2do1K1awbcVFYgnJzVshpFap0H2Nn8IH+3sBCNI2zGJo1TJ3yQUMIjHXJgoAlQ6zMthObSxZBm8JxtbicTdULr2/V64frlwyhoJIQRhW1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=M/OMdZOe; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hW78ad4/blxMqS8sR/BdPAXHAf9Mx4sVWDJCcUn/Rm4=; b=M/OMdZOerK7ZZ97QjzAv3mDicA
	ZeQlbslxgxaMCaBmHUGWInXKo39jS3nfGgQiQu+A2xpy9vO0rESVhva8Oveu6iWZwG30MBZ9WrK2a
	+j2eeMhznnlK4PVQONzgiyXqHfazsFpBYMLmusuq8HUJ5l/AXkEALouvs4T6H5R0WLl1iV09KIRfQ
	SMRyFM/Sv9iwUAzjfHSPbPbYIyCEXxQgjQDdVMBkkeBf/FNISmWwfEMLAy6dUNMz9PyrTdu1qiyGz
	D37y0Pq6vJi0YHM4qJUBhBx4IuPLaX1GIOPIuvW9C8c6eEJq6O/+Br2USL7oJLVoLXA0LGE+/Kv/Y
	GhtRbJFg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkap-00000001mee-2yf9;
	Thu, 08 Jan 2026 07:38:03 +0000
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
Subject: [PATCH v4 00/59] struct filename series
Date: Thu,  8 Jan 2026 07:37:04 +0000
Message-ID: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

[See https://lore.kernel.org/all/20251216035518.4037331-1-viro@zeniv.linux.org.uk/
for previous variant]

Changes compared to v3:
	* rebased to v6.19-rc4
	* the size of embedded name is increased to the point where struct filename
is 192 bytes long
	* introduction of CLASS machinery moved up by several commits, so
that "allow incomplete imports of filenames" could make use of it immediately;
as the result, a couple of followups in io_uring/* fold into it.
	* __getname_maybe_null() makes use of CLASS(filename_flags)
	* calls of refname() (all 3 of them, all in kernel/auditsc.c) expanded.
	* convert init_mkdir() et.al. to use of do_mkdirat() and friends, similar
to how init_rmdir() and init_unlink() are done.

Practically all destructor calls are done via CLASS(filename...) now;
only 3 explicit calls left (one in audit, dropping the references it has
grabbed for itself, two in the vicinity of fsconfig - separate story).
No uses of __free(putname) remain; I haven't removed DEFINE_FREE yet,
but it's really tempting.

I've got some continuations for that series (non-consuming variants of
do_renameat2() and friends, now that it can be done with minimal PITA
in the callers; with that added we get almost all constructors done via
CLASS(...); the only exceptions are around fsconfig), but that's in
a separate branch (#experimental.filename) on top of this one.

The branch lives in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.filename
now; individual patches in followups.

Please, review; if nobody objects, I'm putting that in #for-next on Saturday.

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
16:
	runtime_const machinery for names_cachep; there's
a potentially better variant (statically allocated kmem_cache),
but that's a separate series.
17:
	infrastructure for CLASS(filename...)
18:
	switch __getname_maybe_null() to that.
19:
	delayed_filename machinery, solves the audit vs. io_uring
problems.
20:
	now we don't need filename->refcnt to be atomic.
21--25:
	simplify checks in callers of pathwalk primitives -
	they (with exception of do_filp_open()) will do
	the right thing if given ERR_PTR() for name.
26--32:	... get rid of that one exception and simplify
	more callers.
33--56:
	conversions to CLASS(filename...), cleanups
57, 58:
	... and these should not have been using getname().
59:
	trimming fs/init.c down - doing to init_mkdir() et.al. what's
	already been done to init_rmdir() and init_unlink().

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
      allow to use CLASS() for struct filename *
      switch __getname_maybe_null() to CLASS(filename_flags)
      allow incomplete imports of filenames
      struct filename ->refcnt doesn't need to be atomic
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
      switch init_mkdir() to use of do_mkdirat(), etc.

Mateusz Guzik (1):
      fs: hide names_cache behind runtime const machinery

Diffstat:
 arch/alpha/kernel/osf_sys.c       |  34 ++--
 fs/dcache.c                       |   8 +-
 fs/exec.c                         |  99 ++++------
 fs/fhandle.c                      |   5 +-
 fs/file_attr.c                    |  12 +-
 fs/filesystems.c                  |   9 +-
 fs/fsopen.c                       |   6 +-
 fs/init.c                         |  88 +--------
 fs/internal.h                     |   5 +-
 fs/namei.c                        | 370 ++++++++++++++++++++------------------
 fs/namespace.c                    |  22 +--
 fs/ntfs3/dir.c                    |   5 +-
 fs/ntfs3/fsntfs.c                 |   4 +-
 fs/ntfs3/inode.c                  |  13 +-
 fs/ntfs3/namei.c                  |  17 +-
 fs/ntfs3/xattr.c                  |   5 +-
 fs/open.c                         | 119 +++++-------
 fs/quota/quota.c                  |   3 +-
 fs/smb/server/vfs.c               |  15 +-
 fs/stat.c                         |  28 +--
 fs/statfs.c                       |   3 +-
 fs/utimes.c                       |   8 +-
 fs/xattr.c                        |  33 +---
 include/asm-generic/vmlinux.lds.h |   3 +-
 include/linux/audit.h             |  11 --
 include/linux/fs.h                |  42 +++--
 io_uring/fs.c                     | 101 ++++++-----
 io_uring/openclose.c              |  26 +--
 io_uring/statx.c                  |  17 +-
 io_uring/xattr.c                  |  30 ++--
 ipc/mqueue.c                      |  11 +-
 kernel/acct.c                     |   4 +-
 kernel/auditsc.c                  |  29 +--
 mm/huge_memory.c                  |  15 +-
 mm/swapfile.c                     |  21 +--
 35 files changed, 483 insertions(+), 738 deletions(-)

