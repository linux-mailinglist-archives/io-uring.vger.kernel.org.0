Return-Path: <io-uring+bounces-7002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16193A56D42
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:12:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 533E9188601E
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFBC226D0C;
	Fri,  7 Mar 2025 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZ612EOX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C08F13C682;
	Fri,  7 Mar 2025 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363930; cv=none; b=USreHzdQweaVqfi0zt0Ljikt5ohFr7h13JGNj9wgm0U1R+g6SCZFQ3CAOquycQyVVxRUK0oxrvZpXLoA/WOm7y3JMs0OzkvI7IEKEsi1bxyP9qrK0ghHQU+mrTyVI1pRnbM0utPHF2f001MQ9DC6lhuImWqO16Zl/L9OeOO+ih0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363930; c=relaxed/simple;
	bh=fPyYtc4uUeCe+TxmHHxBNxl29fqS4EHIQEWiLkOCn3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mVfifKlHgSH6wqBzE9/dqS1uUvG6b/YHHPwgv7yGfePOL/JEtdu3IWk4cj8/IqZZAGAA1Z/qFL3ZEhZoqftJAKBpOArkPL7UYgNEUf8C3tBLO5oy18AlvZwGcJTElTun3UpKArCd8r7s1GObkLPujnuFbml3QozyYmFQ49d7jx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZ612EOX; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac0b6e8d96cso288954766b.0;
        Fri, 07 Mar 2025 08:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363927; x=1741968727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aut8eMv1fZRM/0QttFTrqNuiPm5SDhwugOF4K2UNTVE=;
        b=IZ612EOXuYTYk9r4Oagw3thHMxy8QUlBRl8fch8HHXhOPGLv7+pkAphPONgF3n/LKS
         ngsnFeJlLUU+6LbDepTv3kKqmxxCAHxDGKlTiNGDZ+mEFDShhCyQkkKEi/lcDqMTR3i6
         HWu/rTkkYpBqdsEuMvAMP8pirjmZAedaq9G7Z3As6asiwd93Fo1oe4euzHOmpO7pD0Ll
         SOPP5VZM0o4xkxWrIeiOrZwcYi3rBO1AiCPxEjQnHiMgRUegk1P9KWvPQA194Wps5JMa
         Uj5kG5nbG4EwmsYcqLqvpxWIO4tzLcqCeVnPfzNRFbPHSamkYZtKIsEjq/aDWInJ9pW0
         9Nqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363927; x=1741968727;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aut8eMv1fZRM/0QttFTrqNuiPm5SDhwugOF4K2UNTVE=;
        b=JesEVvaj7Ak8vnjDMfiQQ/PFRj+tB1zTKqsR+Mr0akXXUW5mUvZCxixoPufWO6BMHB
         pxfoLdLv4PJ5GLrBFV1/CTQNcyu09MdiCkF4yt6KVvjjgjMeJkhlj5FD0cpWQCPWmcJS
         AyoLH70OgJgtqknftAK3Brl6QCTRMfIHoKW4KsYiUTtJBjaSRwSTxFnlHcCaUg8Q0Axu
         AGj/rEFwCjjaIQpi1vhRhxoa0r2JObNKjDZu6XAXHHGZ/aWJ4UQD2Py5nQhdMhKwsCrO
         k+zWRHIjhAOwtIEbsgr9cv3rJ4sPy16WnX5V+vQb517Gy3oHTcLBbyo6dAYHZynJPuav
         NI0w==
X-Forwarded-Encrypted: i=1; AJvYcCUNRFgXdvChtdLPM5wYjuce/bZsjSMnO230p8e0k4kskJA7dowbzeJ0GPxPd49fg56OrijRpA==@vger.kernel.org, AJvYcCURA6ULaW1F6UbcS+QIslyTt2PenmwFHXM0i3Yi7NWJzXLggbTtyvvGj9/sHwVaKjvgKR7qqcIB2gM=@vger.kernel.org, AJvYcCVzFshqjGHaVmDKN4S7FNFkto1QPY5C7yIT7FrWEd8m2YRLTq+cZt4kb2H/AG5gbd64+lU8nfQX5rwPUJKO/A==@vger.kernel.org, AJvYcCWRmYU69R+tVdvakBWYo0/NoPQVxkTv6dpOU84a3YzJCIL9mvCSZIwxVKoi1zHvBvxX1V/I5zkdo8UUHFAM@vger.kernel.org
X-Gm-Message-State: AOJu0YwKdbRno7HEVdx1ddcpvhCJQSnPZsemKpK2cRXLdEni+rUkcMXr
	fzMkWY7htNqCOY2XT4R5kF6oj6zOJqvfxBRT8eNzkvef4DXePQGa
X-Gm-Gg: ASbGncuyLU39B+cNG0uCfzb53KfPI7tA4k/Hee+Jf2UhZMelFsy9509Aa+2c5tJf3VM
	/RkzkjQg/BV0JJXr032TahYDv9397A1TD097WwSqr30oN2VGM9b1IpDOEGTzQL/rKgwWqhQp338
	18Vp56hEMTFrwTnZyxTXQ0lMUy/Gyf7YvlospX1TU3zCxJCdOGGtlVJYSQaMxDObh9NN8OYzmsy
	yAjYGfskjLft7oIDgsj28zbRLjXGgygBUX4UDJ2AwQELLATG17UWMqaH3+o/g0goC4KgQPFJ7/k
	KPrVcRLaUsi23qWSz7tAjnG9sKP0fa0A6sUfHZgW05YURSE78gl2UY+60cO+jp0=
X-Google-Smtp-Source: AGHT+IFpvumDeTJuCryGQ+/lx3TMXKTkpDyzebKmqgzl7UqQldHCIgpUkrGr+TDUR3x5EajiLNLYJQ==
X-Received: by 2002:a17:907:c99b:b0:abf:7af6:ea64 with SMTP id a640c23a62f3a-ac252e9e42cmr375351466b.45.1741363926455;
        Fri, 07 Mar 2025 08:12:06 -0800 (PST)
Received: from f.. (cst-prg-95-226.cust.vodafone.cz. [46.135.95.226])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d4877sm292211266b.169.2025.03.07.08.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:12:05 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	audit@vger.kernel.org,
	axboe@kernel.dk,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH] fs: support filename refcount without atomics
Date: Fri,  7 Mar 2025 17:11:55 +0100
Message-ID: <20250307161155.760949-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Atomics are only needed for a combination of io_uring and audit.

Regular file access (even with audit) gets around fine without them.

With this patch 'struct filename' starts with being refcounted using
regular ops.

In order to avoid API explosion in the getname*() family, a dedicated
routine is added to switch the obj to use atomics.

This leaves the room for merely issuing getname(), not issuing the
switch and still trying to manipulate the refcount from another thread.

Catching such cases is facilitated by CONFIG_DEBUG_VFS-dependent
tracking of who created the given filename object and having refname()
and putname() detect if another thread is trying to modify them.

Benchmarked on Sapphire Rapids issuing access() (ops/s):
before: 5106246
after:	5269678 (+3%)

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

this can be split into 2 patches (refname, initname vs the atomic
change). I also took the liberty to fix up some weird whitespace.

the bench is access1 from will-it-scale (kind of):
https://github.com/antonblanchard/will-it-scale/pull/36

correctness tested with io_uring + audit using the test suite in liburing.

Confirmed mismatched owners show up:
# bpftrace -e 'kprobe:putname /curtask != ((struct filename *)arg0)->owner/ { @[kstack()] = count(); }'
Attaching 1 probe...
^C

@[
    putname+5
    do_renameat2+279
    io_renameat+40
    io_issue_sqe+1159
    io_wq_submit_work+200
    io_worker_handle_work+313
    io_wq_worker+218
    ret_from_fork+49
    ret_from_fork_asm+26
]: 4
@[
    putname+5
    do_renameat2+287
    io_renameat+40
    io_issue_sqe+1159
    io_wq_submit_work+200
    io_worker_handle_work+313
    io_wq_worker+218
    ret_from_fork+49
    ret_from_fork_asm+26
]: 4

 fs/namei.c           | 44 +++++++++++++++++++++++++++++++++-----------
 include/linux/fs.h   | 37 ++++++++++++++++++++++++++++++++++++-
 io_uring/fs.c        |  8 ++++++++
 io_uring/openclose.c |  1 +
 io_uring/statx.c     |  3 +--
 io_uring/xattr.c     |  2 ++
 kernel/auditsc.c     | 12 +++++-------
 7 files changed, 86 insertions(+), 21 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 06765d320e7e..ff76b495abef 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -125,6 +125,17 @@
 
 #define EMBEDDED_NAME_MAX	(PATH_MAX - offsetof(struct filename, iname))
 
+static inline void initname(struct filename *name)
+{
+	name->uptr = NULL;
+	name->aname = NULL;
+	name->is_atomic = false;
+#ifdef CONFIG_DEBUG_VFS
+	name->owner = current;
+#endif
+	atomic_set(&name->refcnt_atomic, 1);
+}
+
 struct filename *
 getname_flags(const char __user *filename, int flags)
 {
@@ -203,10 +214,7 @@ getname_flags(const char __user *filename, int flags)
 			return ERR_PTR(-ENAMETOOLONG);
 		}
 	}
-
-	atomic_set(&result->refcnt, 1);
-	result->uptr = filename;
-	result->aname = NULL;
+	initname(result);
 	audit_getname(result);
 	return result;
 }
@@ -264,26 +272,40 @@ struct filename *getname_kernel(const char * filename)
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 	memcpy((char *)result->name, filename, len);
-	result->uptr = NULL;
-	result->aname = NULL;
-	atomic_set(&result->refcnt, 1);
+	initname(result);
 	audit_getname(result);
-
 	return result;
 }
 EXPORT_SYMBOL(getname_kernel);
 
 void putname(struct filename *name)
 {
+	int refcnt;
+
 	if (IS_ERR_OR_NULL(name))
 		return;
 
-	if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
-		return;
+	VFS_BUG_ON(name->owner != current && !name->is_atomic);
 
-	if (!atomic_dec_and_test(&name->refcnt))
+	refcnt = atomic_read(&name->refcnt_atomic);
+	if (WARN_ON_ONCE(!refcnt))
 		return;
 
+	/*
+	 * If refcnt == 1 then there is nobody who can legally change it.
+	 * Short-circuiting this case saves a branch in the common case and
+	 * an atomic op for the last unref (for the ->is_atomic variant).
+	 */
+	if (refcnt != 1) {
+		if (name->is_atomic) {
+			if (!atomic_dec_and_test(&name->refcnt_atomic))
+				return;
+		} else {
+			if (--name->refcnt)
+				return;
+		}
+	}
+
 	if (name->name != name->iname) {
 		__putname(name->name);
 		kfree(name);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 110d95d04299..b559a611dd15 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2765,11 +2765,19 @@ struct audit_names;
 struct filename {
 	const char		*name;	/* pointer to actual string */
 	const __user char	*uptr;	/* original userland pointer */
-	atomic_t		refcnt;
+	union {
+		atomic_t	refcnt_atomic;
+		int		refcnt;
+	};
+#ifdef CONFIG_DEBUG_VFS
+	struct task_struct	*owner;
+#endif
+	bool			is_atomic;
 	struct audit_names	*aname;
 	const char		iname[];
 };
 static_assert(offsetof(struct filename, iname) % sizeof(long) == 0);
+static_assert(sizeof(int) == sizeof(atomic_t)); /* refcount */
 
 static inline struct mnt_idmap *file_mnt_idmap(const struct file *file)
 {
@@ -2864,6 +2872,33 @@ static inline struct filename *getname_maybe_null(const char __user *name, int f
 extern void putname(struct filename *name);
 DEFINE_FREE(putname, struct filename *, if (!IS_ERR_OR_NULL(_T)) putname(_T))
 
+static inline void makeatomicname(struct filename *name)
+{
+	VFS_BUG_ON(IS_ERR_OR_NULL(name));
+	/*
+	 * The name can legitimately already be atomic if it was cached by audit.
+	 * If switching the refcount to atomic, we need not to know we are the
+	 * only non-atomic user.
+	 */
+	VFS_BUG_ON(name->owner != current && !name->is_atomic);
+	/*
+	 * Don't bother branching, this is a store to an already dirtied cacheline.
+	 */
+	name->is_atomic = true;
+}
+
+static inline struct filename *refname(struct filename *name)
+{
+	VFS_BUG_ON(name->owner != current && !name->is_atomic);
+
+	if (name->is_atomic)
+		atomic_inc(&name->refcnt_atomic);
+	else
+		name->refcnt++;
+
+	return name;
+}
+
 extern int finish_open(struct file *file, struct dentry *dentry,
 			int (*open)(struct inode *, struct file *));
 extern int finish_no_open(struct file *file, struct dentry *dentry);
diff --git a/io_uring/fs.c b/io_uring/fs.c
index eccea851dd5a..db8d4fe4290d 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -66,12 +66,14 @@ int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ren->oldpath = getname(oldf);
 	if (IS_ERR(ren->oldpath))
 		return PTR_ERR(ren->oldpath);
+	makeatomicname(ren->oldpath);
 
 	ren->newpath = getname(newf);
 	if (IS_ERR(ren->newpath)) {
 		putname(ren->oldpath);
 		return PTR_ERR(ren->newpath);
 	}
+	makeatomicname(ren->newpath);
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	req->flags |= REQ_F_FORCE_ASYNC;
@@ -121,6 +123,7 @@ int io_unlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	un->filename = getname(fname);
 	if (IS_ERR(un->filename))
 		return PTR_ERR(un->filename);
+	makeatomicname(un->filename);
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	req->flags |= REQ_F_FORCE_ASYNC;
@@ -168,6 +171,7 @@ int io_mkdirat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	mkd->filename = getname(fname);
 	if (IS_ERR(mkd->filename))
 		return PTR_ERR(mkd->filename);
+	makeatomicname(mkd->filename);
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	req->flags |= REQ_F_FORCE_ASYNC;
@@ -212,12 +216,14 @@ int io_symlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sl->oldpath = getname(oldpath);
 	if (IS_ERR(sl->oldpath))
 		return PTR_ERR(sl->oldpath);
+	makeatomicname(sl->oldpath);
 
 	sl->newpath = getname(newpath);
 	if (IS_ERR(sl->newpath)) {
 		putname(sl->oldpath);
 		return PTR_ERR(sl->newpath);
 	}
+	makeatomicname(sl->newpath);
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	req->flags |= REQ_F_FORCE_ASYNC;
@@ -257,12 +263,14 @@ int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	lnk->oldpath = getname_uflags(oldf, lnk->flags);
 	if (IS_ERR(lnk->oldpath))
 		return PTR_ERR(lnk->oldpath);
+	makeatomicname(lnk->oldpath);
 
 	lnk->newpath = getname(newf);
 	if (IS_ERR(lnk->newpath)) {
 		putname(lnk->oldpath);
 		return PTR_ERR(lnk->newpath);
 	}
+	makeatomicname(lnk->newpath);
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	req->flags |= REQ_F_FORCE_ASYNC;
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index e3357dfa14ca..d1213bd2911b 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -70,6 +70,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		open->filename = NULL;
 		return ret;
 	}
+	makeatomicname(open->filename);
 
 	open->file_slot = READ_ONCE(sqe->file_index);
 	if (open->file_slot && (open->how.flags & O_CLOEXEC))
diff --git a/io_uring/statx.c b/io_uring/statx.c
index 6bc4651700a2..892c85a29e5f 100644
--- a/io_uring/statx.c
+++ b/io_uring/statx.c
@@ -37,13 +37,12 @@ int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sx->flags = READ_ONCE(sqe->statx_flags);
 
 	sx->filename = getname_uflags(path, sx->flags);
-
 	if (IS_ERR(sx->filename)) {
 		int ret = PTR_ERR(sx->filename);
-
 		sx->filename = NULL;
 		return ret;
 	}
+	makeatomicname(sx->filename);
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	req->flags |= REQ_F_FORCE_ASYNC;
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index de5064fcae8a..73acc6036187 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -96,6 +96,7 @@ int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ix->filename = getname(path);
 	if (IS_ERR(ix->filename))
 		return PTR_ERR(ix->filename);
+	makeatomicname(ix->filename);
 
 	return 0;
 }
@@ -172,6 +173,7 @@ int io_setxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ix->filename = getname(path);
 	if (IS_ERR(ix->filename))
 		return PTR_ERR(ix->filename);
+	makeatomicname(ix->filename);
 
 	return 0;
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9c853cde9abe..78fd876a5473 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2207,10 +2207,8 @@ __audit_reusename(const __user char *uptr)
 	list_for_each_entry(n, &context->names_list, list) {
 		if (!n->name)
 			continue;
-		if (n->name->uptr == uptr) {
-			atomic_inc(&n->name->refcnt);
-			return n->name;
-		}
+		if (n->name->uptr == uptr)
+			return refname(n->name);
 	}
 	return NULL;
 }
@@ -2237,7 +2235,7 @@ void __audit_getname(struct filename *name)
 	n->name = name;
 	n->name_len = AUDIT_NAME_FULL;
 	name->aname = n;
-	atomic_inc(&name->refcnt);
+	refname(name);
 }
 
 static inline int audit_copy_fcaps(struct audit_names *name,
@@ -2369,7 +2367,7 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
 		return;
 	if (name) {
 		n->name = name;
-		atomic_inc(&name->refcnt);
+		refname(name);
 	}
 
 out:
@@ -2496,7 +2494,7 @@ void __audit_inode_child(struct inode *parent,
 		if (found_parent) {
 			found_child->name = found_parent->name;
 			found_child->name_len = AUDIT_NAME_FULL;
-			atomic_inc(&found_child->name->refcnt);
+			refname(found_child->name);
 		}
 	}
 
-- 
2.43.0


