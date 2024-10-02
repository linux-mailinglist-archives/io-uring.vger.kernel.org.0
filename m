Return-Path: <io-uring+bounces-3359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B423B98CAB9
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D76D51C2251E
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CA2FBF6;
	Wed,  2 Oct 2024 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Y72uVuZL"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FFCB674;
	Wed,  2 Oct 2024 01:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832155; cv=none; b=JHiw/1XPWTeHIqzotpoAXXWhvR2yaaFIY3rRqEBfIGNdeo4gVHAzfOUvsv9MrAbAt7FRX3sib6afoCyjqSq/hu8auIIp85woOL5J1Bfs/1lZ3mGzmeOlDqRW9ZVOa39f/u0ssASm7dbnJNy2wJA5Z++7U9ZmHmrTEl5N3kyfG38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832155; c=relaxed/simple;
	bh=z/1wNhbPZY84KptqS48Zoxu9t/L4UZTAjkm8ShjUhos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J6F2eLqU8HAJecvBJ3rKXSCju/e6GKjA+oao39FN99dxi0NCNxQg+e8uH30QXPM89ogGQyolJreSffr6KUe3t8zvHoaiYHYQWRUJ5fe7Pzh2avAQVfjyZT4JcLNrOCM3gGGVVPSsPryHgn8DE5s5WU+q0/hktnDXgq/HcoTywVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Y72uVuZL; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=dpW4U1vUG7v5XSgdCL9t9GpdlJAruZ4zMZf+McI+BFg=; b=Y72uVuZLBMHyqH7lfh4FUl5YLG
	FZvghEHC7XPv0RlrotXe+QVfKRDKK5bO5gBAIu8wJid8v9q0z3ulyeDONF6X7Ii9KCrEWvWRzAghI
	sfzuF5LcD+M2/qUTtDwWA48nck5wGNsftwPW137cDkFqlVQglNEVwU0GD/bXJaX1ZIzvRS17LDIpT
	GzIAP2hA/+B60GH3knh5KIIXLCdS6ef6muCaLi4w9GFacrJDN76eQq/ETC96rZmycIItYynAI9Chy
	LIuTe4xcwtaL/n3Ai1Dt+Bu/zyiREhH00r8zJiRBfTD1vryr646lLEgKmehSQsK7OdKiS+kK5hXew
	Eov4syLg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svo4V-0000000HW0o-0Tfz;
	Wed, 02 Oct 2024 01:22:31 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: brauner@kernel.org,
	io-uring@vger.kernel.org,
	cgzones@googlemail.com
Subject: [PATCH 9/9] fs/xattr: add *at family syscalls
Date: Wed,  2 Oct 2024 02:22:30 +0100
Message-ID: <20241002012230.4174585-9-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

From: Christian Göttsche <cgzones@googlemail.com>

Add the four syscalls setxattrat(), getxattrat(), listxattrat() and
removexattrat().  Those can be used to operate on extended attributes,
especially security related ones, either relative to a pinned directory
or on a file descriptor without read access, avoiding a
/proc/<pid>/fd/<fd> detour, requiring a mounted procfs.

One use case will be setfiles(8) setting SELinux file contexts
("security.selinux") without race conditions and without a file
descriptor opened with read access requiring SELinux read permission.

Use the do_{name}at() pattern from fs/open.c.

Pass the value of the extended attribute, its length, and for
setxattrat(2) the command (XATTR_CREATE or XATTR_REPLACE) via an added
struct xattr_args to not exceed six syscall arguments and not
merging the AT_* and XATTR_* flags.

[AV: fixes by Christian Brauner folded in, the entire thing rebased on
top of {filename,file}_...xattr() primitives, treatment of empty
pathnames regularized.  As the result, AT_EMPTY_PATH+NULL handling
is cheap, so f...(2) can use it]

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Link: https://lore.kernel.org/r/20240426162042.191916-1-cgoettsche@seltendoof.de
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
CC: x86@kernel.org
CC: linux-alpha@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org
CC: linux-ia64@vger.kernel.org
CC: linux-m68k@lists.linux-m68k.org
CC: linux-mips@vger.kernel.org
CC: linux-parisc@vger.kernel.org
CC: linuxppc-dev@lists.ozlabs.org
CC: linux-s390@vger.kernel.org
CC: linux-sh@vger.kernel.org
CC: sparclinux@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
CC: audit@vger.kernel.org
CC: linux-arch@vger.kernel.org
CC: linux-api@vger.kernel.org
CC: linux-security-module@vger.kernel.org
CC: selinux@vger.kernel.org
[brauner: slight tweaks]
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
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
 fs/xattr.c                                  | 271 ++++++++++++++------
 include/asm-generic/audit_change_attr.h     |   6 +
 include/linux/syscalls.h                    |  13 +
 include/linux/xattr.h                       |   4 +
 include/uapi/asm-generic/unistd.h           |  11 +-
 include/uapi/linux/xattr.h                  |   7 +
 21 files changed, 286 insertions(+), 86 deletions(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 74720667fe09..c59d53d6d3f3 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -502,3 +502,7 @@
 570	common	lsm_set_self_attr		sys_lsm_set_self_attr
 571	common	lsm_list_modules		sys_lsm_list_modules
 572	common  mseal				sys_mseal
+573	common	setxattrat			sys_setxattrat
+574	common	getxattrat			sys_getxattrat
+575	common	listxattrat			sys_listxattrat
+576	common	removexattrat			sys_removexattrat
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 23c98203c40f..49eeb2ad8dbd 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -477,3 +477,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index 22a3cbd4c602..f5ed71f1910d 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -462,3 +462,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 2b81a6bd78b2..680f568b77f2 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -468,3 +468,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 953f5b7dc723..0b9b7e25b69a 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -401,3 +401,7 @@
 460	n32	lsm_set_self_attr		sys_lsm_set_self_attr
 461	n32	lsm_list_modules		sys_lsm_list_modules
 462	n32	mseal				sys_mseal
+463	n32	setxattrat			sys_setxattrat
+464	n32	getxattrat			sys_getxattrat
+465	n32	listxattrat			sys_listxattrat
+466	n32	removexattrat			sys_removexattrat
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 1464c6be6eb3..c844cd5cda62 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -377,3 +377,7 @@
 460	n64	lsm_set_self_attr		sys_lsm_set_self_attr
 461	n64	lsm_list_modules		sys_lsm_list_modules
 462	n64	mseal				sys_mseal
+463	n64	setxattrat			sys_setxattrat
+464	n64	getxattrat			sys_getxattrat
+465	n64	listxattrat			sys_listxattrat
+466	n64	removexattrat			sys_removexattrat
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 2439a2491cff..349b8aad1159 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -450,3 +450,7 @@
 460	o32	lsm_set_self_attr		sys_lsm_set_self_attr
 461	o32	lsm_list_modules		sys_lsm_list_modules
 462	o32	mseal				sys_mseal
+463	o32	setxattrat			sys_setxattrat
+464	o32	getxattrat			sys_getxattrat
+465	o32	listxattrat			sys_listxattrat
+466	o32	removexattrat			sys_removexattrat
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 66dc406b12e4..d9fc94c86965 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -461,3 +461,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index ebae8415dfbb..d8b4ab78bef0 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -553,3 +553,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 01071182763e..e9115b4d8b63 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -465,3 +465,7 @@
 460  common	lsm_set_self_attr	sys_lsm_set_self_attr		sys_lsm_set_self_attr
 461  common	lsm_list_modules	sys_lsm_list_modules		sys_lsm_list_modules
 462  common	mseal			sys_mseal			sys_mseal
+463  common	setxattrat		sys_setxattrat			sys_setxattrat
+464  common	getxattrat		sys_getxattrat			sys_getxattrat
+465  common	listxattrat		sys_listxattrat			sys_listxattrat
+466  common	removexattrat		sys_removexattrat		sys_removexattrat
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index c55fd7696d40..c8cad33bf250 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -466,3 +466,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index cfdfb3707c16..727f99d333b3 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -508,3 +508,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal 				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 534c74b14fab..4d0fb2fba7e2 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -468,3 +468,7 @@
 460	i386	lsm_set_self_attr	sys_lsm_set_self_attr
 461	i386	lsm_list_modules	sys_lsm_list_modules
 462	i386	mseal 			sys_mseal
+463	i386	setxattrat		sys_setxattrat
+464	i386	getxattrat		sys_getxattrat
+465	i386	listxattrat		sys_listxattrat
+466	i386	removexattrat		sys_removexattrat
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 7093ee21c0d1..5eb708bff1c7 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -386,6 +386,10 @@
 460	common	lsm_set_self_attr	sys_lsm_set_self_attr
 461	common	lsm_list_modules	sys_lsm_list_modules
 462 	common  mseal			sys_mseal
+463	common	setxattrat		sys_setxattrat
+464	common	getxattrat		sys_getxattrat
+465	common	listxattrat		sys_listxattrat
+466	common	removexattrat		sys_removexattrat
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index 67083fc1b2f5..37effc1b134e 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -433,3 +433,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal 				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
diff --git a/fs/xattr.c b/fs/xattr.c
index 6f87f23c0e84..59cdb524412e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -597,6 +597,32 @@ int import_xattr_name(struct xattr_name *kname, const char __user *name)
 	return 0;
 }
 
+static struct filename *getname_xattr(const char __user *pathname,
+				      unsigned int at_flags)
+{
+	struct filename *name;
+	char c;
+
+	if (!(at_flags & AT_EMPTY_PATH))
+		return getname(pathname);
+
+	if (!pathname)
+		return NULL;
+
+	/* try to save on allocations; will suck on s390 and um, though */
+	if (get_user(c, pathname))
+		return ERR_PTR(-EFAULT);
+	if (!c)
+		return NULL;
+
+	name = getname_flags(pathname, LOOKUP_EMPTY);
+	if (!IS_ERR(name) && !(name->name[0])) {
+		putname(name);
+		name = NULL;
+	}
+	return name;
+}
+
 /*
  * Extended attribute SET operations
  */
@@ -675,69 +701,90 @@ int filename_setxattr(int dfd, struct filename *filename,
 	return error;
 }
 
-static int path_setxattr(const char __user *pathname,
-			 const char __user *name, const void __user *value,
-			 size_t size, int flags, unsigned int lookup_flags)
+static int path_setxattrat(int dfd, const char __user *pathname,
+			   unsigned int at_flags, const char __user *name,
+			   const void __user *value, size_t size, int flags)
 {
 	struct xattr_name kname;
 	struct kernel_xattr_ctx ctx = {
-		.cvalue   = value,
-		.kvalue   = NULL,
-		.size     = size,
-		.kname    = &kname,
-		.flags    = flags,
+		.cvalue	= value,
+		.kvalue	= NULL,
+		.size	= size,
+		.kname	= &kname,
+		.flags	= flags,
 	};
+	struct filename *filename;
+	unsigned int lookup_flags = 0;
 	int error;
 
+	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
+
+	if (at_flags & AT_SYMLINK_NOFOLLOW)
+		lookup_flags = LOOKUP_FOLLOW;
+
 	error = setxattr_copy(name, &ctx);
 	if (error)
 		return error;
 
-	error = filename_setxattr(AT_FDCWD, getname(pathname), lookup_flags,
-				  &ctx);
+	filename = getname_xattr(pathname, at_flags);
+	if (!filename) {
+		CLASS(fd, f)(dfd);
+		if (fd_empty(f))
+			error = -EBADF;
+		else
+			error = file_setxattr(fd_file(f), &ctx);
+	} else {
+		error = filename_setxattr(dfd, filename, lookup_flags, &ctx);
+	}
 	kvfree(ctx.kvalue);
 	return error;
 }
 
+SYSCALL_DEFINE6(setxattrat, int, dfd, const char __user *, pathname, unsigned int, at_flags,
+		const char __user *, name, const struct xattr_args __user *, uargs,
+		size_t, usize)
+{
+	struct xattr_args args = {};
+	int error;
+
+	BUILD_BUG_ON(sizeof(struct xattr_args) < XATTR_ARGS_SIZE_VER0);
+	BUILD_BUG_ON(sizeof(struct xattr_args) != XATTR_ARGS_SIZE_LATEST);
+
+	if (unlikely(usize < XATTR_ARGS_SIZE_VER0))
+		return -EINVAL;
+	if (usize > PAGE_SIZE)
+		return -E2BIG;
+
+	error = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+	if (error)
+		return error;
+
+	return path_setxattrat(dfd, pathname, at_flags, name,
+			       u64_to_user_ptr(args.value), args.size,
+			       args.flags);
+}
+
 SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
 		const char __user *, name, const void __user *, value,
 		size_t, size, int, flags)
 {
-	return path_setxattr(pathname, name, value, size, flags, LOOKUP_FOLLOW);
+	return path_setxattrat(AT_FDCWD, pathname, 0, name, value, size, flags);
 }
 
 SYSCALL_DEFINE5(lsetxattr, const char __user *, pathname,
 		const char __user *, name, const void __user *, value,
 		size_t, size, int, flags)
 {
-	return path_setxattr(pathname, name, value, size, flags, 0);
+	return path_setxattrat(AT_FDCWD, pathname, AT_SYMLINK_NOFOLLOW, name,
+			       value, size, flags);
 }
 
 SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 		const void __user *,value, size_t, size, int, flags)
 {
-	struct xattr_name kname;
-	struct kernel_xattr_ctx ctx = {
-		.cvalue   = value,
-		.kvalue   = NULL,
-		.size     = size,
-		.kname    = &kname,
-		.flags    = flags,
-	};
-	int error;
-
-	CLASS(fd, f)(fd);
-
-	if (fd_empty(f))
-		return -EBADF;
-
-	error = setxattr_copy(name, &ctx);
-	if (error)
-		return error;
-
-	error = file_setxattr(fd_file(f), &ctx);
-	kvfree(ctx.kvalue);
-	return error;
+	return path_setxattrat(fd, NULL, AT_EMPTY_PATH, name,
+			       value, size, flags);
 }
 
 /*
@@ -802,11 +849,10 @@ ssize_t filename_getxattr(int dfd, struct filename *filename,
 	return error;
 }
 
-static ssize_t path_getxattr(const char __user *pathname,
-			     const char __user *name, void __user *value,
-			     size_t size, unsigned int lookup_flags)
+static ssize_t path_getxattrat(int dfd, const char __user *pathname,
+			       unsigned int at_flags, const char __user *name,
+			       void __user *value, size_t size)
 {
-	ssize_t error;
 	struct xattr_name kname;
 	struct kernel_xattr_ctx ctx = {
 		.value    = value,
@@ -814,44 +860,72 @@ static ssize_t path_getxattr(const char __user *pathname,
 		.kname    = &kname,
 		.flags    = 0,
 	};
+	struct filename *filename;
+	ssize_t error;
+
+	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
 
 	error = import_xattr_name(&kname, name);
 	if (error)
 		return error;
-	return filename_getxattr(AT_FDCWD, getname(pathname), lookup_flags, &ctx);
+
+	filename = getname_xattr(pathname, at_flags);
+	if (!filename) {
+		CLASS(fd, f)(dfd);
+		if (fd_empty(f))
+			return -EBADF;
+		return file_getxattr(fd_file(f), &ctx);
+	} else {
+		int lookup_flags = 0;
+		if (at_flags & AT_SYMLINK_NOFOLLOW)
+			lookup_flags = LOOKUP_FOLLOW;
+		return filename_getxattr(dfd, filename, lookup_flags, &ctx);
+	}
+}
+
+SYSCALL_DEFINE6(getxattrat, int, dfd, const char __user *, pathname, unsigned int, at_flags,
+		const char __user *, name, struct xattr_args __user *, uargs, size_t, usize)
+{
+	struct xattr_args args = {};
+	int error;
+
+	BUILD_BUG_ON(sizeof(struct xattr_args) < XATTR_ARGS_SIZE_VER0);
+	BUILD_BUG_ON(sizeof(struct xattr_args) != XATTR_ARGS_SIZE_LATEST);
+
+	if (unlikely(usize < XATTR_ARGS_SIZE_VER0))
+		return -EINVAL;
+	if (usize > PAGE_SIZE)
+		return -E2BIG;
+
+	error = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+	if (error)
+		return error;
+
+	if (args.flags != 0)
+		return -EINVAL;
+
+	return path_getxattrat(dfd, pathname, at_flags, name,
+			       u64_to_user_ptr(args.value), args.size);
 }
 
 SYSCALL_DEFINE4(getxattr, const char __user *, pathname,
 		const char __user *, name, void __user *, value, size_t, size)
 {
-	return path_getxattr(pathname, name, value, size, LOOKUP_FOLLOW);
+	return path_getxattrat(AT_FDCWD, pathname, 0, name, value, size);
 }
 
 SYSCALL_DEFINE4(lgetxattr, const char __user *, pathname,
 		const char __user *, name, void __user *, value, size_t, size)
 {
-	return path_getxattr(pathname, name, value, size, 0);
+	return path_getxattrat(AT_FDCWD, pathname, AT_SYMLINK_NOFOLLOW, name,
+			       value, size);
 }
 
 SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 		void __user *, value, size_t, size)
 {
-	ssize_t error;
-	struct xattr_name kname;
-	struct kernel_xattr_ctx ctx = {
-		.value    = value,
-		.size     = size,
-		.kname    = &kname,
-		.flags    = 0,
-	};
-	CLASS(fd, f)(fd);
-
-	if (fd_empty(f))
-		return -EBADF;
-	error = import_xattr_name(&kname, name);
-	if (error)
-		return error;
-	return file_getxattr(fd_file(f), &ctx);
+	return path_getxattrat(fd, NULL, AT_EMPTY_PATH, name, value, size);
 }
 
 /*
@@ -915,32 +989,50 @@ ssize_t filename_listxattr(int dfd, struct filename *filename,
 	return error;
 }
 
-static ssize_t path_listxattr(const char __user *pathname, char __user *list,
-			      size_t size, unsigned int lookup_flags)
+static ssize_t path_listxattrat(int dfd, const char __user *pathname,
+				unsigned int at_flags, char __user *list,
+				size_t size)
+{
+	struct filename *filename;
+	int lookup_flags;
+
+	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
+
+	filename = getname_xattr(pathname, at_flags);
+	if (!filename) {
+		CLASS(fd, f)(dfd);
+		if (fd_empty(f))
+			return -EBADF;
+		return file_listxattr(fd_file(f), list, size);
+	}
+
+	lookup_flags = (at_flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	return filename_listxattr(dfd, filename, lookup_flags, list, size);
+}
+
+SYSCALL_DEFINE5(listxattrat, int, dfd, const char __user *, pathname,
+		unsigned int, at_flags,
+		char __user *, list, size_t, size)
 {
-	return filename_listxattr(AT_FDCWD, getname(pathname), lookup_flags,
-				  list, size);
+	return path_listxattrat(dfd, pathname, at_flags, list, size);
 }
 
 SYSCALL_DEFINE3(listxattr, const char __user *, pathname, char __user *, list,
 		size_t, size)
 {
-	return path_listxattr(pathname, list, size, LOOKUP_FOLLOW);
+	return path_listxattrat(AT_FDCWD, pathname, 0, list, size);
 }
 
 SYSCALL_DEFINE3(llistxattr, const char __user *, pathname, char __user *, list,
 		size_t, size)
 {
-	return path_listxattr(pathname, list, size, 0);
+	return path_listxattrat(AT_FDCWD, pathname, AT_SYMLINK_NOFOLLOW, list, size);
 }
 
 SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 {
-	CLASS(fd, f)(fd);
-
-	if (fd_empty(f))
-		return -EBADF;
-	return file_listxattr(fd_file(f), list, size);
+	return path_listxattrat(fd, NULL, AT_EMPTY_PATH, list, size);
 }
 
 /*
@@ -992,44 +1084,53 @@ static int filename_removexattr(int dfd, struct filename *filename,
 	return error;
 }
 
-static int path_removexattr(const char __user *pathname,
-			    const char __user *name, unsigned int lookup_flags)
+static int path_removexattrat(int dfd, const char __user *pathname,
+			      unsigned int at_flags, const char __user *name)
 {
 	struct xattr_name kname;
+	struct filename *filename;
+	unsigned int lookup_flags;
 	int error;
 
+	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
+
 	error = import_xattr_name(&kname, name);
 	if (error)
 		return error;
-	return filename_removexattr(AT_FDCWD, getname(pathname), lookup_flags,
-				    &kname);
+
+	filename = getname_xattr(pathname, at_flags);
+	if (!filename) {
+		CLASS(fd, f)(dfd);
+		if (fd_empty(f))
+			return -EBADF;
+		return file_removexattr(fd_file(f), &kname);
+	}
+	lookup_flags = (at_flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	return filename_removexattr(dfd, filename, lookup_flags, &kname);
+}
+
+SYSCALL_DEFINE4(removexattrat, int, dfd, const char __user *, pathname,
+		unsigned int, at_flags, const char __user *, name)
+{
+	return path_removexattrat(dfd, pathname, at_flags, name);
 }
 
 SYSCALL_DEFINE2(removexattr, const char __user *, pathname,
 		const char __user *, name)
 {
-	return path_removexattr(pathname, name, LOOKUP_FOLLOW);
+	return path_removexattrat(AT_FDCWD, pathname, 0, name);
 }
 
 SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
 		const char __user *, name)
 {
-	return path_removexattr(pathname, name, 0);
+	return path_removexattrat(AT_FDCWD, pathname, AT_SYMLINK_NOFOLLOW, name);
 }
 
 SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 {
-	CLASS(fd, f)(fd);
-	struct xattr_name kname;
-	int error;
-
-	if (fd_empty(f))
-		return -EBADF;
-
-	error = import_xattr_name(&kname, name);
-	if (error)
-		return error;
-	return file_removexattr(fd_file(f), &kname);
+	return path_removexattrat(fd, NULL, AT_EMPTY_PATH, name);
 }
 
 int xattr_list_one(char **buffer, ssize_t *remaining_size, const char *name)
diff --git a/include/asm-generic/audit_change_attr.h b/include/asm-generic/audit_change_attr.h
index 331670807cf0..cc840537885f 100644
--- a/include/asm-generic/audit_change_attr.h
+++ b/include/asm-generic/audit_change_attr.h
@@ -11,9 +11,15 @@ __NR_lchown,
 __NR_fchown,
 #endif
 __NR_setxattr,
+#ifdef __NR_setxattrat
+__NR_setxattrat,
+#endif
 __NR_lsetxattr,
 __NR_fsetxattr,
 __NR_removexattr,
+#ifdef __NR_removexattrat
+__NR_removexattrat,
+#endif
 __NR_lremovexattr,
 __NR_fremovexattr,
 #ifdef __NR_fchownat
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 5758104921e6..c6333204d451 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -77,6 +77,7 @@ struct cachestat_range;
 struct cachestat;
 struct statmount;
 struct mnt_id_req;
+struct xattr_args;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -338,23 +339,35 @@ asmlinkage long sys_io_uring_register(unsigned int fd, unsigned int op,
 				void __user *arg, unsigned int nr_args);
 asmlinkage long sys_setxattr(const char __user *path, const char __user *name,
 			     const void __user *value, size_t size, int flags);
+asmlinkage long sys_setxattrat(int dfd, const char __user *path, unsigned int at_flags,
+			       const char __user *name,
+			       const struct xattr_args __user *args, size_t size);
 asmlinkage long sys_lsetxattr(const char __user *path, const char __user *name,
 			      const void __user *value, size_t size, int flags);
 asmlinkage long sys_fsetxattr(int fd, const char __user *name,
 			      const void __user *value, size_t size, int flags);
 asmlinkage long sys_getxattr(const char __user *path, const char __user *name,
 			     void __user *value, size_t size);
+asmlinkage long sys_getxattrat(int dfd, const char __user *path, unsigned int at_flags,
+			       const char __user *name,
+			       struct xattr_args __user *args, size_t size);
 asmlinkage long sys_lgetxattr(const char __user *path, const char __user *name,
 			      void __user *value, size_t size);
 asmlinkage long sys_fgetxattr(int fd, const char __user *name,
 			      void __user *value, size_t size);
 asmlinkage long sys_listxattr(const char __user *path, char __user *list,
 			      size_t size);
+asmlinkage long sys_listxattrat(int dfd, const char __user *path,
+				unsigned int at_flags,
+				char __user *list, size_t size);
 asmlinkage long sys_llistxattr(const char __user *path, char __user *list,
 			       size_t size);
 asmlinkage long sys_flistxattr(int fd, char __user *list, size_t size);
 asmlinkage long sys_removexattr(const char __user *path,
 				const char __user *name);
+asmlinkage long sys_removexattrat(int dfd, const char __user *path,
+				  unsigned int at_flags,
+				  const char __user *name);
 asmlinkage long sys_lremovexattr(const char __user *path,
 				 const char __user *name);
 asmlinkage long sys_fremovexattr(int fd, const char __user *name);
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index d20051865800..86b0d47984a1 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -19,6 +19,10 @@
 #include <linux/user_namespace.h>
 #include <uapi/linux/xattr.h>
 
+/* List of all open_how "versions". */
+#define XATTR_ARGS_SIZE_VER0	16 /* sizeof first published struct */
+#define XATTR_ARGS_SIZE_LATEST	XATTR_ARGS_SIZE_VER0
+
 struct inode;
 struct dentry;
 
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 5bf6148cac2b..88dc393c2bca 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -841,8 +841,17 @@ __SYSCALL(__NR_lsm_list_modules, sys_lsm_list_modules)
 #define __NR_mseal 462
 __SYSCALL(__NR_mseal, sys_mseal)
 
+#define __NR_setxattrat 463
+__SYSCALL(__NR_setxattrat, sys_setxattrat)
+#define __NR_getxattrat 464
+__SYSCALL(__NR_getxattrat, sys_getxattrat)
+#define __NR_listxattrat 465
+__SYSCALL(__NR_listxattrat, sys_listxattrat)
+#define __NR_removexattrat 466
+__SYSCALL(__NR_removexattrat, sys_removexattrat)
+
 #undef __NR_syscalls
-#define __NR_syscalls 463
+#define __NR_syscalls 467
 
 /*
  * 32 bit systems traditionally used different
diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index 9463db2dfa9d..9854f9cff3c6 100644
--- a/include/uapi/linux/xattr.h
+++ b/include/uapi/linux/xattr.h
@@ -11,6 +11,7 @@
 */
 
 #include <linux/libc-compat.h>
+#include <linux/types.h>
 
 #ifndef _UAPI_LINUX_XATTR_H
 #define _UAPI_LINUX_XATTR_H
@@ -20,6 +21,12 @@
 
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
 #define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
+
+struct xattr_args {
+	__aligned_u64 __user value;
+	__u32 size;
+	__u32 flags;
+};
 #endif
 
 /* Namespaces */
-- 
2.39.5


