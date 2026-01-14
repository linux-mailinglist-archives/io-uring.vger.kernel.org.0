Return-Path: <io-uring+bounces-11677-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E25FD1C680
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4AA1C30B24F5
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC10330B34;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="O+4URxOr"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9BC2D94A0;
	Wed, 14 Jan 2026 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365118; cv=none; b=MRlorpbI1JHdwj3hW0K1ra3jRzT/RELrfh7eY9rXZgU4fWiMh9nCLA1QenlEYxKcWjtu5SxZt+glBWg3RkruN3IA9Iy5uAqjd9B7p91ACv+Mil/M4oen9/1d+0e0sPW81R6m0CtoO11extRkSrNfIvlOqtm3hs+vvEUPQoCW87U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365118; c=relaxed/simple;
	bh=2VlP+6+MBKxgN1IclcGfQgfePCUJ8rHRKFNxyM5IFBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ob7RO1zbh48hpp5rlqP0LHSk6412X6qkeFj4lGDCx9E61UL5flbWX8g9czCU8KMvrTWgFJ8z9WhNCEu0vmhdGK0Iar70SDVjK5g713DamwAVCzS6Vw2Ad5VskRnvWi4HXcrhhrcacPox962yae7yhxPNn3ngYjNp0lhZqfi7jcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=O+4URxOr; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kwEcrMngjLvIom2pOPUPNRKbOgmBlUmQNcYUZgCeoow=; b=O+4URxOr5Gw6nUvw0x/mlrFrWm
	XbiZ+3MDYQm6/eQGPx/vhpySVjF93m4sQ2Pyc1qa8CwwOyCrUOVUWRcYZXnW2nLnCsfyh9sL8SS93
	yQXpnF/izfEZzmTcP9vrvJHQR6xtUkh1EMoVXEk3N2ACeJymH60LQ6YERQUlkJwQ0JbYESO4i7M5A
	Wpe8y9Z0OOvAUJtBWfEBs16/mEqq608r21PNfGIEuUXPal2PRcI5KfpKO5NyYczJ0hqAJkhz339YW
	BL5lKmJEbuAblzeQfsdvZLdUE0RU6+Epf+Y0O618C/4qi12DUYWGFTTvoNDEbndiJ9zDN3IiOlm/d
	H902vmww==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZF-0000000GInl-0hi2;
	Wed, 14 Jan 2026 04:33:13 +0000
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
Subject: [PATCH v5 21/68] fs: hide names_cache behind runtime const machinery
Date: Wed, 14 Jan 2026 04:32:23 +0000
Message-ID: <20260114043310.3885463-22-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

From: Mateusz Guzik <mjguzik@gmail.com>

s/names_cachep/names_cache/ for consistency with dentry cache.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c                        | 16 ++++++++++------
 include/asm-generic/vmlinux.lds.h |  3 ++-
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 57043b81fe27..06d60808b0ff 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -41,6 +41,8 @@
 #include <linux/init_task.h>
 #include <linux/uaccess.h>
 
+#include <asm/runtime-const.h>
+
 #include "internal.h"
 #include "mount.h"
 
@@ -124,23 +126,25 @@
  */
 
 /* SLAB cache for struct filename instances */
-static struct kmem_cache *names_cachep __ro_after_init;
+static struct kmem_cache *__names_cache __ro_after_init;
+#define names_cache	runtime_const_ptr(__names_cache)
 
 void __init filename_init(void)
 {
-	names_cachep = kmem_cache_create_usercopy("names_cache", sizeof(struct filename), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, offsetof(struct filename, iname),
-						EMBEDDED_NAME_MAX, NULL);
+	__names_cache = kmem_cache_create_usercopy("names_cache", sizeof(struct filename), 0,
+			 SLAB_HWCACHE_ALIGN|SLAB_PANIC, offsetof(struct filename, iname),
+			 EMBEDDED_NAME_MAX, NULL);
+	runtime_const_init(ptr, __names_cache);
 }
 
 static inline struct filename *alloc_filename(void)
 {
-	return kmem_cache_alloc(names_cachep, GFP_KERNEL);
+	return kmem_cache_alloc(names_cache, GFP_KERNEL);
 }
 
 static inline void free_filename(struct filename *p)
 {
-	kmem_cache_free(names_cachep, p);
+	kmem_cache_free(names_cache, p);
 }
 
 static inline void initname(struct filename *name)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8ca130af301f..eeb070f330bd 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -972,7 +972,8 @@
 #define RUNTIME_CONST_VARIABLES						\
 		RUNTIME_CONST(shift, d_hash_shift)			\
 		RUNTIME_CONST(ptr, dentry_hashtable)			\
-		RUNTIME_CONST(ptr, __dentry_cache)
+		RUNTIME_CONST(ptr, __dentry_cache)			\
+		RUNTIME_CONST(ptr, __names_cache)
 
 /* Alignment must be consistent with (kunit_suite *) in include/kunit/test.h */
 #define KUNIT_TABLE()							\
-- 
2.47.3


