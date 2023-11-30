Return-Path: <io-uring+bounces-178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17DF67FFBC3
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 20:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2289282785
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 19:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35EB52F96;
	Thu, 30 Nov 2023 19:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vAMIYsl8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0780D67
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:50 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-35cfd975a53so1082485ab.1
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701373609; x=1701978409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2HWi279rh64gXCrH8f0I7iMcUE2uT/adU0g3wTQ5Ao=;
        b=vAMIYsl8PY1UMjiDH2QCgnklTbIZDsI5fINv7UrbS+66CUCjEIjHRrbx274E4JzURZ
         1KTjBZ/Wtwigb80WSyms8NvChNatDoWF/X+k7C92UO9TlaTO8xe/+e87LpISSUvwBofv
         TAfQffBN9yne/sdbO8Kj9I5FwaECDb5w1LugWGqb63qpvdMoBMMRJzHSlHXEoV/TH8YI
         +BXc9JGyupte/lGrrBlL1Q1fkAaspQ5HZUFuDFGu2IZc+nSrLH0nHdVTQPJUH5QS+PRm
         fKX+GJIA0BXSd70UjMnzDiA++/gaVM+lvfqhyB1M3jZ7HQ9FhlBM4gl/UdZ4qfcsFF5J
         G9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701373609; x=1701978409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2HWi279rh64gXCrH8f0I7iMcUE2uT/adU0g3wTQ5Ao=;
        b=nleAfnFZWKs5pHO9rQ3H4j7VGRF9vOQNam4WdhLaFskrQAxfGYCGJZx8HPMZDpj76c
         eo9i+jxJqWWPKRRuKlbS9+MG54tjlwXEeUoeSOHHcILsCnt3udptDA9Lze3nHxnuN6k+
         pTkxnzbpX0ESJSXSLkjxCsfHUlEzOwF4rUF/grs2uEeRlXHrByHEL6CwiYt/3EU4UTCO
         3m9KEufDoHPXBv2Pl3jtM9N9FjPsZuJDrGKz7abrY+f7MV2uThkCh/I6L2JHrqocOd5r
         P+A281fnV/92i7y0QKBSOlfrbdp5mKkLoQC+w67BC9oUHAqExGbAsDORkpTzxc2LiZju
         kxQg==
X-Gm-Message-State: AOJu0Yx7c54maywQkZsciY74ygvXWBgSMXtw+UFhaxLj7MpSN8aIiNJs
	2syuq8gP+VSxrk4/gNPtnJqi0ALgXYDH2NE6+dU0DA==
X-Google-Smtp-Source: AGHT+IFt1rr2No8HuHyy980pqzaVmvIIQ1typwkiS5GFSscUFuIxnKkRNCW4o7sR79g/HFhnu22t2Q==
X-Received: by 2002:a5d:9c18:0:b0:79f:a8c2:290d with SMTP id 24-20020a5d9c18000000b0079fa8c2290dmr23173995ioe.0.1701373609558;
        Thu, 30 Nov 2023 11:46:49 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a029f92000000b004667167d8cdsm461179jam.116.2023.11.30.11.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:46:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 7/8] io_uring: free io_buffer_list entries via RCU
Date: Thu, 30 Nov 2023 12:45:53 -0700
Message-ID: <20231130194633.649319-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231130194633.649319-1-axboe@kernel.dk>
References: <20231130194633.649319-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mmap_lock nests under uring_lock out of necessity, as we may be doing
user copies with uring_lock held. However, for mmap of provided buffer
rings, we attempt to grab uring_lock with mmap_lock already held from
do_mmap(). This makes lockdep, rightfully, complain:

WARNING: possible circular locking dependency detected
6.7.0-rc1-00009-gff3337ebaf94-dirty #4438 Not tainted
------------------------------------------------------
buf-ring.t/442 is trying to acquire lock:
ffff00020e1480a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_uring_validate_mmap_request.isra.0+0x4c/0x140

but task is already holding lock:
ffff0000dc226190 (&mm->mmap_lock){++++}-{3:3}, at: vm_mmap_pgoff+0x124/0x264

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_lock){++++}-{3:3}:
       __might_fault+0x90/0xbc
       io_register_pbuf_ring+0x94/0x488
       __arm64_sys_io_uring_register+0x8dc/0x1318
       invoke_syscall+0x5c/0x17c
       el0_svc_common.constprop.0+0x108/0x130
       do_el0_svc+0x2c/0x38
       el0_svc+0x4c/0x94
       el0t_64_sync_handler+0x118/0x124
       el0t_64_sync+0x168/0x16c

-> #0 (&ctx->uring_lock){+.+.}-{3:3}:
       __lock_acquire+0x19a0/0x2d14
       lock_acquire+0x2e0/0x44c
       __mutex_lock+0x118/0x564
       mutex_lock_nested+0x20/0x28
       io_uring_validate_mmap_request.isra.0+0x4c/0x140
       io_uring_mmu_get_unmapped_area+0x3c/0x98
       get_unmapped_area+0xa4/0x158
       do_mmap+0xec/0x5b4
       vm_mmap_pgoff+0x158/0x264
       ksys_mmap_pgoff+0x1d4/0x254
       __arm64_sys_mmap+0x80/0x9c
       invoke_syscall+0x5c/0x17c
       el0_svc_common.constprop.0+0x108/0x130
       do_el0_svc+0x2c/0x38
       el0_svc+0x4c/0x94
       el0t_64_sync_handler+0x118/0x124
       el0t_64_sync+0x168/0x16c

From that mmap(2) path, we really just need to ensure that the buffer
list doesn't go away from underneath us. For the lower indexed entries,
they never go away until the ring is freed and we can always sanely
reference those as long as the caller has a file reference. For the
higher indexed ones in our xarray, we just need to ensure that the
buffer list remains valid while we return the address of it.

Free the higher indexed io_buffer_list entries via RCU. With that we can
avoid needing ->uring_lock inside mmap(2), and simply hold the RCU read
lock around the buffer list lookup and address check.

To ensure that the arrayed lookup either returns a valid fully formulated
entry via RCU lookup, add an 'is_ready' flag that we access with store
and release memory ordering. This isn't needed for the xarray lookups,
but doesn't hurt either. Since this isn't a fast path, retain it across
both types. Similarly, for the allocated array inside the ctx, ensure
we use the proper load/acquire as setup could in theory be running in
parallel with mmap.

While in there, add a few lockdep checks for documentation purposes.

Cc: stable@vger.kernel.org
Fixes: c56e022c0a27 ("io_uring: add support for user mapped provided buffer ring")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c |  4 +--
 io_uring/kbuf.c     | 64 ++++++++++++++++++++++++++++++++++++---------
 io_uring/kbuf.h     |  3 +++
 3 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3a216f0744dd..05f933dddfde 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3498,9 +3498,9 @@ static void *io_uring_validate_mmap_request(struct file *file,
 		unsigned int bgid;
 
 		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		mutex_lock(&ctx->uring_lock);
+		rcu_read_lock();
 		ptr = io_pbuf_get_address(ctx, bgid);
-		mutex_unlock(&ctx->uring_lock);
+		rcu_read_unlock();
 		if (!ptr)
 			return ERR_PTR(-EINVAL);
 		break;
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 39d15a27eb92..268788305b61 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -40,19 +40,35 @@ struct io_buf_free {
 	int				inuse;
 };
 
+static struct io_buffer_list *__io_buffer_get_list(struct io_ring_ctx *ctx,
+						   struct io_buffer_list *bl,
+						   unsigned int bgid)
+{
+	if (bl && bgid < BGID_ARRAY)
+		return &bl[bgid];
+
+	return xa_load(&ctx->io_bl_xa, bgid);
+}
+
 static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 							unsigned int bgid)
 {
-	if (ctx->io_bl && bgid < BGID_ARRAY)
-		return &ctx->io_bl[bgid];
+	lockdep_assert_held(&ctx->uring_lock);
 
-	return xa_load(&ctx->io_bl_xa, bgid);
+	return __io_buffer_get_list(ctx, ctx->io_bl, bgid);
 }
 
 static int io_buffer_add_list(struct io_ring_ctx *ctx,
 			      struct io_buffer_list *bl, unsigned int bgid)
 {
+	/*
+	 * Store buffer group ID and finally mark the list as visible.
+	 * The normal lookup doesn't care about the visibility as we're
+	 * always under the ->uring_lock, but the RCU lookup from mmap does.
+	 */
 	bl->bgid = bgid;
+	smp_store_release(&bl->is_ready, 1);
+
 	if (bgid < BGID_ARRAY)
 		return 0;
 
@@ -203,18 +219,19 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 static __cold int io_init_bl_list(struct io_ring_ctx *ctx)
 {
+	struct io_buffer_list *bl;
 	int i;
 
-	ctx->io_bl = kcalloc(BGID_ARRAY, sizeof(struct io_buffer_list),
-				GFP_KERNEL);
-	if (!ctx->io_bl)
+	bl = kcalloc(BGID_ARRAY, sizeof(struct io_buffer_list), GFP_KERNEL);
+	if (!bl)
 		return -ENOMEM;
 
 	for (i = 0; i < BGID_ARRAY; i++) {
-		INIT_LIST_HEAD(&ctx->io_bl[i].buf_list);
-		ctx->io_bl[i].bgid = i;
+		INIT_LIST_HEAD(&bl[i].buf_list);
+		bl[i].bgid = i;
 	}
 
+	smp_store_release(&ctx->io_bl, bl);
 	return 0;
 }
 
@@ -303,7 +320,7 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
 		__io_remove_buffers(ctx, bl, -1U);
-		kfree(bl);
+		kfree_rcu(bl, rcu);
 	}
 
 	/*
@@ -497,7 +514,16 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		INIT_LIST_HEAD(&bl->buf_list);
 		ret = io_buffer_add_list(ctx, bl, p->bgid);
 		if (ret) {
-			kfree(bl);
+			/*
+			 * Doesn't need rcu free as it was never visible, but
+			 * let's keep it consistent throughout. Also can't
+			 * be a lower indexed array group, as adding one
+			 * where lookup failed cannot happen.
+			 */
+			if (p->bgid >= BGID_ARRAY)
+				kfree_rcu(bl, rcu);
+			else
+				WARN_ON_ONCE(1);
 			goto err;
 		}
 	}
@@ -636,6 +662,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_buffer_list *bl, *free_bl = NULL;
 	int ret;
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
 
@@ -690,7 +718,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return 0;
 	}
 
-	kfree(free_bl);
+	kfree_rcu(free_bl, rcu);
 	return ret;
 }
 
@@ -699,6 +727,8 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_uring_buf_reg reg;
 	struct io_buffer_list *bl;
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
 	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
@@ -715,7 +745,7 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	__io_remove_buffers(ctx, bl, -1U);
 	if (bl->bgid >= BGID_ARRAY) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
-		kfree(bl);
+		kfree_rcu(bl, rcu);
 	}
 	return 0;
 }
@@ -724,7 +754,15 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 {
 	struct io_buffer_list *bl;
 
-	bl = io_buffer_get_list(ctx, bgid);
+	bl = __io_buffer_get_list(ctx, smp_load_acquire(&ctx->io_bl), bgid);
+
+	/*
+	 * Ensure the list is fully setup. Only strictly needed for RCU lookup
+	 * via mmap, and in that case only for the array indexed groups. For
+	 * the xarray lookups, it's either visible and ready, or not at all.
+	 */
+	if (!smp_load_acquire(&bl->is_ready))
+		return NULL;
 	if (!bl || !bl->is_mmap)
 		return NULL;
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 6c7646e6057c..9be5960817ea 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -15,6 +15,7 @@ struct io_buffer_list {
 			struct page **buf_pages;
 			struct io_uring_buf_ring *buf_ring;
 		};
+		struct rcu_head rcu;
 	};
 	__u16 bgid;
 
@@ -28,6 +29,8 @@ struct io_buffer_list {
 	__u8 is_mapped;
 	/* ring mapped provided buffers, but mmap'ed by application */
 	__u8 is_mmap;
+	/* bl is visible from an RCU point of view for lookup */
+	__u8 is_ready;
 };
 
 struct io_buffer {
-- 
2.42.0


