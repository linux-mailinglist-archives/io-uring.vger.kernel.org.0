Return-Path: <io-uring+bounces-10844-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 916BAC94540
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:04:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E0B83A49B6
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2647C30FF26;
	Sat, 29 Nov 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="p+4D+0L+"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B7A20F067;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435700; cv=none; b=avI1PDdwIPK9e+cAsoK2DkhX6webzKHR1lVfqCpHokSprZ37fEa15DdtORCorIlOGj0WT0ELnx4s+7Iw92sQ3HQdcALO439M+EwZZgBn7wk49RUYVImhp+VtGuuiOvMGjmvusZDTSizqA4XHVPIrY8FgaBkKwDdpPC1FXyIhO9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435700; c=relaxed/simple;
	bh=49FiEVBHs+2Yb6QoEAjIfI/mvZLn22Bl178dPbFAuX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMDOWOnQHMcGVgwUPI/nOdVNhBPntt+Y9XkaWoYP9QYGrAxpanvuBGpmwPTeQcLzQHaMKs0QCXk0sU6UrIvLBJGX0iNwwLF5UxyYpS1BX9ZHcy0Bae570fG1MB24Ald5cC6i4+5wzRYzT6ALDkHDcSuKDASS2zGmLAwiFyrVWts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=p+4D+0L+; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MmYojoihxUlkkrJ+q54l2bER8BdW5OmyjSqNTHuXJwc=; b=p+4D+0L+dBg6HBdTcQKXVWRoqa
	TOQAq3FFbBM/H7BqlVIXndAZW3/LDhgIeZyPOuTTVHklh2GVAlrbHx0Lky35NJEK3ZW7OynsnXiFE
	mdtpyLNqg1gKoEOjO2bpzszCiMSLMGFsCbh+nfuhBNxesQliSRlx4ic4aB4wpupIdhbN07WO3PgyQ
	NPomGWW0PufCGAc9q9HSKz25l9a81cYNRWulKVlJN+h9aScPap6NU2gnrLgI0339CKeFTT/goPAx8
	CsJ/wrg17qVaON/bY/conZN4zMn1fFYcgQaLCvOnNG/tlUkx5ieI8KjYTIgcFIoI5wZoVCy4i03uN
	s1+8QtFA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dDI-3m1s;
	Sat, 29 Nov 2025 17:01:43 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH v2 15/18] struct filename: saner handling of long names
Date: Sat, 29 Nov 2025 17:01:39 +0000
Message-ID: <20251129170142.150639-16-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Always allocate struct filename from names_cachep, long name or short;
names shorter than 128 characters would be embedded into struct filename.
Longer ones do not cannibalize the original struct filename - put them
into PATH_MAX-sized kmalloc'ed buffers.

Simplifies logics in getname()/putname() and friends.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c         | 87 ++++++++++++++++++----------------------------
 include/linux/fs.h |  4 ++-
 2 files changed, 36 insertions(+), 55 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index cf7d8608ce4e..fc04f938d7e1 100644
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
 
-	if (name->name != name->iname) {
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
index 59c5c67985ab..0b01adcfa425 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2833,11 +2833,13 @@ extern struct kobject *fs_kobj;
 
 /* fs/open.c */
 struct audit_names;
+
+#define EMBEDDED_NAME_MAX	128
 struct filename {
 	const char		*name;	/* pointer to actual string */
 	atomic_t		refcnt;
 	struct audit_names	*aname;
-	const char		iname[];
+	const char		iname[EMBEDDED_NAME_MAX];
 };
 static_assert(offsetof(struct filename, iname) % sizeof(long) == 0);
 
-- 
2.47.3


