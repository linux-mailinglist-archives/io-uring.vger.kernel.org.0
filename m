Return-Path: <io-uring+bounces-11471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 662E0D016D2
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 515ED3008794
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0604329E59;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="gF57Iqs/"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3408D32694A;
	Thu,  8 Jan 2026 07:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857818; cv=none; b=ciRvZ1zuonmWaVCP7f2w3k8nNepaLVsfTCvO9GRMbg3aDsAvmHkbDLhI4bRBQyVrVrQUM7pUyUBPq8wBLdLuJlEpQ3LdCEylzGDqlIcEhY3ltkMOvCjQb9MiRnFN2/muivJMTjzebMyqXhcKRbxhdmMiPVocicWGhrKHLtC4258=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857818; c=relaxed/simple;
	bh=wuiiTj2gHGbhqKFHp0+2ykKm5YAOGcMAqs2NXJoAroA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHsRTw5IsdCAbQ84gMZ7VlO6IS0n72xuBsvjCzNMoF+hzyqsJjbCyj6GNN8/zHpzmc6rPx3lYvrGi7yFZ3MNFBhCtdkWaATs5wuHGHvNHc/sK3S9pBuBMPS5IBi8dHUtL9bs/I4vZ5Kdf9PAQ1hJZu4rblPtpIwWv8uYp3ShxLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=gF57Iqs/; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ba/co7KFgEinr4WiBkpTr42dNi6tPXfJUwGTV27Gjfk=; b=gF57Iqs/gZloDf8ToDSHKs//lf
	G1WoOSaE62kzEYxnJxOv4QXerwPxyU3vq5Ks+hjPE/r1J+egDWHMZAK+BAX5YnExZXyyTKcZ2Pk0w
	wgTCsr7oyvAQnMKRsj1o0fyb+z5ZMVPJ6Z5Vl9Ayit+4bhyIJaallqznDAqx4YBJfmsk5eY+UsDG6
	QUPCFvCMG6eOrQysGjYCQdAfWprMB90f0Lnu+YE4//CGAoORDppL8N8wls8T0pcdpMoiFr/WTw1AO
	ANFbptdupnAy+0IcO9Hou6Z97/c0ZjKHRYtY7EXcEDDQ0xOnjv6PKAU4dBUxyQ04XEjx5bvsS+OSm
	R7qDrdZA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkas-00000001mj2-28p8;
	Thu, 08 Jan 2026 07:38:06 +0000
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
Subject: [PATCH v4 15/59] struct filename: saner handling of long names
Date: Thu,  8 Jan 2026 07:37:19 +0000
Message-ID: <20260108073803.425343-16-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Always allocate struct filename from names_cachep, long name or short;
short names would be embedded into struct filename.  Longer ones do
not cannibalize the original struct filename - put them into kmalloc'ed
buffers (PATH_MAX-sized for import from userland, strlen() + 1 - for
ones originating kernel-side, where we know the length beforehand).

Cutoff length for short names is chosen so that struct filename would be
192 bytes long - that's both a multiple of 64 and large enough to cover
the majority of real-world uses.

Simplifies logics in getname()/putname() and friends.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c         | 87 ++++++++++++++++++----------------------------
 include/linux/fs.h | 10 ++++--
 2 files changed, 41 insertions(+), 56 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 468e3db62f53..9053aeee05d5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -123,15 +123,14 @@
  * PATH_MAX includes the nul terminator --RR.
  */
 
-#define EMBEDDED_NAME_MAX	(PATH_MAX - offsetof(struct filename, iname))
-
 /* SLAB cache for struct filename instances */
 static struct kmem_cache *names_cachep __ro_after_init;
 
 void __init filename_init(void)
 {
-	names_cachep = kmem_cache_create_usercopy("names_cache", PATH_MAX, 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, 0, PATH_MAX, NULL);
+	names_cachep = kmem_cache_create_usercopy("names_cache", sizeof(struct filename), 0,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC, offsetof(struct filename, iname),
+						EMBEDDED_NAME_MAX, NULL);
 }
 
 static inline struct filename *alloc_filename(void)
@@ -150,30 +149,23 @@ static inline void initname(struct filename *name)
 	atomic_set(&name->refcnt, 1);
 }
 
-static struct filename *getname_long(struct filename *old,
-				     const char __user *filename)
+static int getname_long(struct filename *name, const char __user *filename)
 {
 	int len;
-	/*
-	 * size is chosen that way we to guarantee that
-	 * p->iname[0] is within the same object and that
-	 * p->name can't be equal to p->iname, no matter what.
-	 */
-	const size_t size = offsetof(struct filename, iname[1]);
-	struct filename *p __free(kfree) = kzalloc(size, GFP_KERNEL);
+	char *p __free(kfree) = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (unlikely(!p))
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
-	memmove(old, &old->iname, EMBEDDED_NAME_MAX);
-	p->name = (char *)old;
-	len = strncpy_from_user((char *)old + EMBEDDED_NAME_MAX,
+	memcpy(p, &name->iname, EMBEDDED_NAME_MAX);
+	len = strncpy_from_user(p + EMBEDDED_NAME_MAX,
 				filename + EMBEDDED_NAME_MAX,
 				PATH_MAX - EMBEDDED_NAME_MAX);
 	if (unlikely(len < 0))
-		return ERR_PTR(len);
+		return len;
 	if (unlikely(len == PATH_MAX - EMBEDDED_NAME_MAX))
-		return ERR_PTR(-ENAMETOOLONG);
-	return no_free_ptr(p);
+		return -ENAMETOOLONG;
+	name->name = no_free_ptr(p);
+	return 0;
 }
 
 struct filename *
@@ -199,16 +191,9 @@ getname_flags(const char __user *filename, int flags)
 	 * Handle both empty path and copy failure in one go.
 	 */
 	if (unlikely(len <= 0)) {
-		if (unlikely(len < 0)) {
-			free_filename(result);
-			return ERR_PTR(len);
-		}
-
 		/* The empty path is special. */
-		if (!(flags & LOOKUP_EMPTY)) {
-			free_filename(result);
-			return ERR_PTR(-ENOENT);
-		}
+		if (!len && !(flags & LOOKUP_EMPTY))
+			len = -ENOENT;
 	}
 
 	/*
@@ -217,14 +202,13 @@ getname_flags(const char __user *filename, int flags)
 	 * names_cache allocation for the pathname, and re-do the copy from
 	 * userland.
 	 */
-	if (unlikely(len == EMBEDDED_NAME_MAX)) {
-		struct filename *p = getname_long(result, filename);
-		if (IS_ERR(p)) {
-			free_filename(result);
-			return p;
-		}
-		result = p;
+	if (unlikely(len == EMBEDDED_NAME_MAX))
+		len = getname_long(result, filename);
+	if (unlikely(len < 0)) {
+		free_filename(result);
+		return ERR_PTR(len);
 	}
+
 	initname(result);
 	audit_getname(result);
 	return result;
@@ -260,29 +244,26 @@ struct filename *getname_kernel(const char * filename)
 {
 	struct filename *result;
 	int len = strlen(filename) + 1;
+	char *p;
+
+	if (unlikely(len > PATH_MAX))
+		return ERR_PTR(-ENAMETOOLONG);
 
 	result = alloc_filename();
 	if (unlikely(!result))
 		return ERR_PTR(-ENOMEM);
 
 	if (len <= EMBEDDED_NAME_MAX) {
-		result->name = (char *)result->iname;
-	} else if (len <= PATH_MAX) {
-		const size_t size = offsetof(struct filename, iname[1]);
-		struct filename *tmp;
-
-		tmp = kmalloc(size, GFP_KERNEL);
-		if (unlikely(!tmp)) {
+		p = (char *)result->iname;
+		memcpy(p, filename, len);
+	} else {
+		p = kmemdup(filename, len, GFP_KERNEL);
+		if (unlikely(!p)) {
 			free_filename(result);
 			return ERR_PTR(-ENOMEM);
 		}
-		tmp->name = (char *)result;
-		result = tmp;
-	} else {
-		free_filename(result);
-		return ERR_PTR(-ENAMETOOLONG);
 	}
-	memcpy((char *)result->name, filename, len);
+	result->name = p;
 	initname(result);
 	audit_getname(result);
 	return result;
@@ -305,11 +286,9 @@ void putname(struct filename *name)
 			return;
 	}
 
-	if (unlikely(name->name != name->iname)) {
-		free_filename((struct filename *)name->name);
-		kfree(name);
-	} else
-		free_filename(name);
+	if (unlikely(name->name != name->iname))
+		kfree(name->name);
+	free_filename(name);
 }
 EXPORT_SYMBOL(putname);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e906f157905c..a74ffcbe8407 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2409,13 +2409,19 @@ extern struct kobject *fs_kobj;
 
 /* fs/open.c */
 struct audit_names;
-struct filename {
+
+struct __filename_head {
 	const char		*name;	/* pointer to actual string */
 	atomic_t		refcnt;
 	struct audit_names	*aname;
-	const char		iname[];
+};
+#define EMBEDDED_NAME_MAX	192 - sizeof(struct __filename_head)
+struct filename {
+	struct __filename_head;
+	const char		iname[EMBEDDED_NAME_MAX];
 };
 static_assert(offsetof(struct filename, iname) % sizeof(long) == 0);
+static_assert(sizeof(struct filename) % 64 == 0);
 
 static inline struct mnt_idmap *file_mnt_idmap(const struct file *file)
 {
-- 
2.47.3


