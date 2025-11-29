Return-Path: <io-uring+bounces-10854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C58E7C94519
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0A87D4E53C9
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A70D4311C13;
	Sat, 29 Nov 2025 17:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ji4yXAAl"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3FE24111D;
	Sat, 29 Nov 2025 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435703; cv=none; b=Tv+Ks9lvPUavGCu2w62ALkUktI7pnaXELfcEM/ogKaioF0XAQ9sEpH5dw4vRJP+OZzg13/yCpTJ3ingu9YZHWYBYaQ6+SO/C0QhpyJZ0AsXrN3tDzd6MkKCbKbObzlDEhp5IHy1CKIM7E3eGiMZ/IMnxR6C6DuKG0CmVeJp73l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435703; c=relaxed/simple;
	bh=gSa3erVK1eCx1MDa7RSMZLkBrcegXQHmTb/pVP2dlv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYPOx/4CUdgIOquBuu5SKbsalEHOKkOIDk1JL3V/nD0c3w2u35UU9eutwoH4NHYzC2GNIBNgD5maMsFvTITKgfaNh/b7Gjnay0XlEOo9yMkPONXTFkfY2J5IN73D3hOCDL9hujGjhrrhmqcIIpCRJlIn2F6gqYj4XQ8uzgjPwbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ji4yXAAl; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DcYWl/EHvWXFU6YbNDJg2t6W+OVZCU4RQWjm21d53dI=; b=ji4yXAAlVvGPlu7ioUWq9XFAon
	h2if9seoaWa42cV1MBPFUZ7xHzrLnTAQz63Dqr8JYdSbcjfcWO0Ueniq76oT6PQkrDdp4ziXpwS8X
	jQ9jgpYBCnn+Pe83euBRC6E8o/wW/uh+BJlb2qBd34z9dZnPwQ56TtTZSP1tyG0Mkx0PdOKFU5zwu
	npoQqzJzhXFpr1k1URfS1V2rq+NoebnPiUnD8MEyjX1ZJkC1+zxg+sN5ElrQzNbHxCiCEIvh/mKzg
	4++sal0ixgAb2+sJW86vT3MSi0y0eH98aevlkiQvK26y4GNWlGOY17yUmOEjg823iU0dkD9LHba6m
	wHMfe8Yg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dDE-3Opr;
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
Subject: [RFC PATCH v2 14/18] struct filename: use names_cachep only for getname() and friends
Date: Sat, 29 Nov 2025 17:01:38 +0000
Message-ID: <20251129170142.150639-15-viro@zeniv.linux.org.uk>
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

        Instances of struct filename come from names_cachep (via
__getname()).  That is done by getname_flags() and getname_kernel()
and these two are the main callers of __getname().  However, there are
other callers that simply want to allocate PATH_MAX bytes for uses that
have nothing to do with struct filename.

	We want saner allocation rules for long pathnames, so that struct
filename would *always* come from names_cachep, with the out-of-line
pathname getting kmalloc'ed.  For that we need to be able to change the
size of objects allocated by getname_flags()/getname_kernel().

	That requires the rest of __getname() users to stop using
names_cachep; we could explicitly switch all of those to kmalloc(),
but that would cause quite a bit of noise.  So the plan is to switch
getname_...() to new helpers and turn __getname() into a wrapper for
kmalloc().  Remaining __getname() users could be converted to explicit
kmalloc() at leisure, hopefully along with figuring out what size do
they really want - PATH_MAX is an overkill for some of them, used out
of laziness ("we have a convenient helper that does 4K allocations and
that's large enough, let's use it").

	As a side benefit, names_cachep is no longer used outside
of fs/namei.c, so we can move it there and be done with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c        |  8 +-------
 fs/internal.h      |  2 ++
 fs/namei.c         | 37 ++++++++++++++++++++++++++++---------
 include/linux/fs.h |  6 ++----
 4 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 035cccbc9276..761283f13200 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3246,10 +3246,6 @@ static void __init dcache_init(void)
 	runtime_const_init(ptr, dentry_hashtable);
 }
 
-/* SLAB cache for __getname() consumers */
-struct kmem_cache *names_cachep __ro_after_init;
-EXPORT_SYMBOL(names_cachep);
-
 void __init vfs_caches_init_early(void)
 {
 	int i;
@@ -3263,9 +3259,7 @@ void __init vfs_caches_init_early(void)
 
 void __init vfs_caches_init(void)
 {
-	names_cachep = kmem_cache_create_usercopy("names_cache", PATH_MAX, 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, 0, PATH_MAX, NULL);
-
+	filename_init();
 	dcache_init();
 	inode_init();
 	files_init();
diff --git a/fs/internal.h b/fs/internal.h
index 9b2b4d116880..e16e72b246c2 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -68,6 +68,8 @@ int vfs_tmpfile(struct mnt_idmap *idmap,
 		struct file *file, umode_t mode);
 struct dentry *d_hash_and_lookup(struct dentry *, struct qstr *);
 
+void __init filename_init(void);
+
 /*
  * namespace.c
  */
diff --git a/fs/namei.c b/fs/namei.c
index 62e992e4f152..cf7d8608ce4e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -125,6 +125,25 @@
 
 #define EMBEDDED_NAME_MAX	(PATH_MAX - offsetof(struct filename, iname))
 
+/* SLAB cache for struct filename instances */
+static struct kmem_cache *names_cachep __ro_after_init;
+
+void __init filename_init(void)
+{
+	names_cachep = kmem_cache_create_usercopy("names_cache", PATH_MAX, 0,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC, 0, PATH_MAX, NULL);
+}
+
+static inline struct filename *alloc_filename(void)
+{
+	return kmem_cache_alloc(names_cachep, GFP_KERNEL);
+}
+
+static inline void free_filename(struct filename *p)
+{
+	kmem_cache_free(names_cachep, p);
+}
+
 static inline void initname(struct filename *name)
 {
 	name->aname = NULL;
@@ -164,7 +183,7 @@ getname_flags(const char __user *filename, int flags)
 	char *kname;
 	int len;
 
-	result = __getname();
+	result = alloc_filename();
 	if (unlikely(!result))
 		return ERR_PTR(-ENOMEM);
 
@@ -181,13 +200,13 @@ getname_flags(const char __user *filename, int flags)
 	 */
 	if (unlikely(len <= 0)) {
 		if (unlikely(len < 0)) {
-			__putname(result);
+			free_filename(result);
 			return ERR_PTR(len);
 		}
 
 		/* The empty path is special. */
 		if (!(flags & LOOKUP_EMPTY)) {
-			__putname(result);
+			free_filename(result);
 			return ERR_PTR(-ENOENT);
 		}
 	}
@@ -201,7 +220,7 @@ getname_flags(const char __user *filename, int flags)
 	if (unlikely(len == EMBEDDED_NAME_MAX)) {
 		struct filename *p = getname_long(result, filename);
 		if (IS_ERR(p)) {
-			__putname(result);
+			free_filename(result);
 			return p;
 		}
 		result = p;
@@ -242,7 +261,7 @@ struct filename *getname_kernel(const char * filename)
 	struct filename *result;
 	int len = strlen(filename) + 1;
 
-	result = __getname();
+	result = alloc_filename();
 	if (unlikely(!result))
 		return ERR_PTR(-ENOMEM);
 
@@ -254,13 +273,13 @@ struct filename *getname_kernel(const char * filename)
 
 		tmp = kmalloc(size, GFP_KERNEL);
 		if (unlikely(!tmp)) {
-			__putname(result);
+			free_filename(result);
 			return ERR_PTR(-ENOMEM);
 		}
 		tmp->name = (char *)result;
 		result = tmp;
 	} else {
-		__putname(result);
+		free_filename(result);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 	memcpy((char *)result->name, filename, len);
@@ -287,10 +306,10 @@ void putname(struct filename *name)
 	}
 
 	if (name->name != name->iname) {
-		__putname(name->name);
+		free_filename((struct filename *)name->name);
 		kfree(name);
 	} else
-		__putname(name);
+		free_filename(name);
 }
 EXPORT_SYMBOL(putname);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bbae3cfdc338..59c5c67985ab 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2957,10 +2957,8 @@ static inline int finish_open_simple(struct file *file, int error)
 extern void __init vfs_caches_init_early(void);
 extern void __init vfs_caches_init(void);
 
-extern struct kmem_cache *names_cachep;
-
-#define __getname()		kmem_cache_alloc(names_cachep, GFP_KERNEL)
-#define __putname(name)		kmem_cache_free(names_cachep, (void *)(name))
+#define __getname()		kmalloc(PATH_MAX, GFP_KERNEL)
+#define __putname(name)		kfree(name)
 
 extern struct super_block *blockdev_superblock;
 static inline bool sb_is_blkdev_sb(struct super_block *sb)
-- 
2.47.3


