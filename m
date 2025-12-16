Return-Path: <io-uring+bounces-11087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DEA2CC0C8A
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C3963037CDA
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84343218DD;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="I4oZEuRa"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7550131280C;
	Tue, 16 Dec 2025 03:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857296; cv=none; b=Ha17TZcR93PjcuN2AfL10WucbcL5oC+snqpYTxVsHV7OkO2UccBJdEH3PJqeUbviprS1BGlOFrVrv2PtQAYuvLBrLBiZnO3dMxfoNM2AVsHb/e7qGRRxM0iXiFwi0Px3Do9W0++yaZdBx0tMuXwmEIt5HM70jiE4WvuDkuApODo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857296; c=relaxed/simple;
	bh=6qpyFK2govkWOfmk2uMNwh+jtWB+MRRvQWNt/yKPv3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcD3F2EjWLITK+DpDsSq7aNJOEVDOc4L+b4IJrQBqi2nxDJNOEcTtxHvVLvrtRiWIwtk/eOODAjm5TnMg0+v5vrlgAYFcoC4t6BsuDen/S7IfSM6eLKoJVxCim9yInETKzGYKCNEDpOvRSSUqrn1I0qCuZQOKz7MizADni2eGKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=I4oZEuRa; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oBPWH03KZC7C+i5s+hKkc6dG7iGxlWmunfoRedkQcCU=; b=I4oZEuRaHcvs9knQhEoLjvRTXx
	zY/g3DMi8+fRxVvE1muzjMG3Iapr0nBKU+fTzLHRPDnbkq6WH+We8AjNr/UJ0/8CS7hrndbcjVMNm
	T1lZEQr8XWqWzqlZCXOd9HgiGKjSXwCSKynIFIssC9IRYOAoa8LTesxWc2hHkRN2Ad52GPQyNNMHU
	gpDQs9o2rkpIoxYbu72g7OaLMi5yTpDqGeJeN4yyA+2K8kaCDfln53B00ZWa5o8EiLnT0pN0p+aFR
	mXRYJ9ioe/5khGpSp36OFEDsuD41N9AjQEwkttQJENDtFX0dOE7cSb2gPkd3Wo8s+6lb8L2yAclFc
	c4gyr/0g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9g-0000000GwJY-02CU;
	Tue, 16 Dec 2025 03:55:20 +0000
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
Subject: [RFC PATCH v3 14/59] struct filename: use names_cachep only for getname() and friends
Date: Tue, 16 Dec 2025 03:54:33 +0000
Message-ID: <20251216035518.4037331-15-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
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
index dc2fff4811d1..cf865c12cdf9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3290,10 +3290,6 @@ static void __init dcache_init(void)
 	runtime_const_init(ptr, dentry_hashtable);
 }
 
-/* SLAB cache for __getname() consumers */
-struct kmem_cache *names_cachep __ro_after_init;
-EXPORT_SYMBOL(names_cachep);
-
 void __init vfs_caches_init_early(void)
 {
 	int i;
@@ -3307,9 +3303,7 @@ void __init vfs_caches_init_early(void)
 
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
index ab638d41ab81..e44146117a42 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -71,6 +71,8 @@ struct dentry *start_dirop(struct dentry *parent, struct qstr *name,
 			   unsigned int lookup_flags);
 int lookup_noperm_common(struct qstr *qname, struct dentry *base);
 
+void __init filename_init(void);
+
 /*
  * namespace.c
  */
diff --git a/fs/namei.c b/fs/namei.c
index 471e4db2dbdb..468e3db62f53 100644
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
 
 	if (unlikely(name->name != name->iname)) {
-		__putname(name->name);
+		free_filename((struct filename *)name->name);
 		kfree(name);
 	} else
-		__putname(name);
+		free_filename(name);
 }
 EXPORT_SYMBOL(putname);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f48149f3c086..c2ce1dc388cb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2533,10 +2533,8 @@ static inline int finish_open_simple(struct file *file, int error)
 extern void __init vfs_caches_init_early(void);
 extern void __init vfs_caches_init(void);
 
-extern struct kmem_cache *names_cachep;
-
-#define __getname()		kmem_cache_alloc(names_cachep, GFP_KERNEL)
-#define __putname(name)		kmem_cache_free(names_cachep, (void *)(name))
+#define __getname()		kmalloc(PATH_MAX, GFP_KERNEL)
+#define __putname(name)		kfree(name)
 
 void emergency_thaw_all(void);
 extern int sync_filesystem(struct super_block *);
-- 
2.47.3


