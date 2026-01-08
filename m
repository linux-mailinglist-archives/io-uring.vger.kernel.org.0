Return-Path: <io-uring+bounces-11463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 208F1D016F9
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:39:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F2912306C414
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D6033D50B;
	Thu,  8 Jan 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="SJBGHDfS"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC833271E8;
	Thu,  8 Jan 2026 07:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857816; cv=none; b=d5Aie5x49xB2BSic7KMft4XfztUUFkRsNryyWYw3rLMp4g7s6/OG9UufVsyXa11prOXlyuaHPXvSj2wHvE5f+vsHPXZV0pP3CKz/w/pGQN8GCThAyBAgCY9dKcrPNwd2dtcSYlO5Jw3EIflB6E0xwHW2ZBLeZfdXumLQHtCY/3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857816; c=relaxed/simple;
	bh=qpbEh74C7X6CMdyErt/mFhuRxl7OR107Lve/D1Fg8nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRTciJFXG5BnPi1mZ2y3ra8T9Gon1I/bLWb31SxBQsaYGMUBvJmAlEU8GQcZK6O//EnwB4ux7o+e/IkcMRMrcu0bt3atnjbycFb2qGceQBc4LO4IldQ4dyJfIyiuu0CxPLPVvVNPqAEjC1tu3N9SUS9wchlm/mYLKccKyeLo8aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=SJBGHDfS; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZRNw5T+EPwnN4beWbwOL70l+2wFKlInh6bFNrece6Q0=; b=SJBGHDfSF4NS3XhAPkd/oJgWXF
	ceLCcd5QPdxHJSBAw5PH50PsHI7OSVHjYBlFtTKRDOJ20CFyBNs8ajyxkHhaJ8HcOLDlwN5omhyEV
	sNZC3Pdtwu2mWIDSNA2uS8m/HKp33RPtNGEhFBztxn3NMrYYTJ/gbNGyt9+pFQzsfS2R3Tl9tg5Ah
	N32goI1AtgmtSFno2jt/6uEtwcyGbalVN94ZnlZ81Xi9lZ5Zl3a9Prt5on0jc7Elj3lm/b4sUx7JZ
	HvAymCKRh4NWOHbAZ5cgZS3tvarc7tXl7AbGa/nsASGRydJLVnh1Vf2Vs2kWufJ96UbuIiWSsTjD4
	wgPHYLuw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkas-00000001mjA-2rCj;
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
Subject: [PATCH v4 16/59] fs: hide names_cache behind runtime const machinery
Date: Thu,  8 Jan 2026 07:37:20 +0000
Message-ID: <20260108073803.425343-17-viro@zeniv.linux.org.uk>
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

From: Mateusz Guzik <mjguzik@gmail.com>

s/names_cachep/names_cache/ for consistency with dentry cache.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c                        | 16 ++++++++++------
 include/asm-generic/vmlinux.lds.h |  3 ++-
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9053aeee05d5..15e14802cabb 100644
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


