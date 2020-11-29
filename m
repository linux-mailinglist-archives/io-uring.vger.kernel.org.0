Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6573E2C7707
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgK2Auv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbgK2Auu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:50 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61819C061A4F;
        Sat, 28 Nov 2020 16:50:13 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u2so4493232pls.10;
        Sat, 28 Nov 2020 16:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2gj0ON+mqEUUZ94wbfZ2SPBrPmWh8UceI9pRzYBaMVs=;
        b=eC3DpPsmAFqst6vx/VtYKnLaTIHx6GWUVnqSCxBRrvlUOZvovFESHTW5HZ9+baVS2H
         aUynSRiETakIQ9Ae2SSNTphPna9C18q26+JOVvWrhhGZBu4yq7h9lZKK+E8cp5eggbqq
         hvcZGYEY4oYpC7Y6iP8urzGMKWN7oWS8qgzAqB7EsrM0CaGnDfVcm4A19KRs+pon+bg0
         CYYoKtx9EsP3/hlU40fVqCxBGxEgL6Qgac0iCUGbfXk4JcM4O7Ca+h0LuN4oN7LDrZY5
         xS4iBzrJpSy5P+urdX7lEFbQX7WaxgIKqt9weRNRVsA/3apQFIk8RuMJIHDn86zKYk+2
         qcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2gj0ON+mqEUUZ94wbfZ2SPBrPmWh8UceI9pRzYBaMVs=;
        b=eiBKFxcvrw5vRn9Vpb0sZGADjPW4jhGp5kmxmQtvNbCK+Nq1zCkrDg6Lg7XQ/60hsE
         vxUrFIQDjljBP9/JDw9TKCWirm4XNJ2KTRMyJTwkrZUaOGMsSpI6hM5EQflXmkoIF/H8
         w1Q4TLTQ9xmlq3ML1g27nEqD9awvPP8xceinjI0wtYNCa4a7o1yjRh2LsvWUW8giizbj
         M8M3LSwmCU8hTGsxbzZKdCfzVsxKpTRNBXkvn6Low936jpc+t12iPzDR+5jZcZ63UjE+
         Mxrv/vZMbDayCeG0s22zPZJ+WuFJPrYnSSvXhJiLducQ0bJyP+TM7G4Uc7A6q1pRLUp4
         rbnA==
X-Gm-Message-State: AOAM533GoSdXmzv4Nh8pT894TYJv+c90O81hoZpujyuK2cLmOFNklQNW
        6fwWehPrC3CYSHIcJWhCJRkGTeevK8NihQ==
X-Google-Smtp-Source: ABdhPJyzRjZi7nWDgmeoE5ZA6p2uor3N06OR99UdPtUey4z1BqHNg8yllIz15XS1Cj7BvlaZBdNFbw==
X-Received: by 2002:a17:902:ec03:b029:d7:c7c2:145a with SMTP id l3-20020a170902ec03b02900d7c7c2145amr12949791pld.33.1606611012417;
        Sat, 28 Nov 2020 16:50:12 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:50:11 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 12/13] fs/userfaultfd: kmem-cache for wait-queue objects
Date:   Sat, 28 Nov 2020 16:45:47 -0800
Message-Id: <20201129004548.1619714-13-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Allocating work-queue objects on the stack has usually negative
performance side-effects. First, it is hard to ensure alignment to
cache-lines without increasing the stack size. Second, it might cause
false sharing. Third, it is more likely to encounter TLB misses as
objects are more likely reside on different pages.

Allocate userfaultfd wait-queue objects on the heap using kmem-cache for
better performance.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c | 60 +++++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 5c22170544e3..224b595ec758 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -32,6 +32,7 @@
 int sysctl_unprivileged_userfaultfd __read_mostly = 1;
 
 static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
+static struct kmem_cache *userfaultfd_wait_queue_cachep __read_mostly;
 
 enum userfaultfd_state {
 	UFFD_STATE_WAIT_API,
@@ -904,14 +905,15 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
 static void dup_fctx(struct userfaultfd_fork_ctx *fctx)
 {
 	struct userfaultfd_ctx *ctx = fctx->orig;
-	struct userfaultfd_wait_queue ewq;
+	struct userfaultfd_wait_queue *ewq = kmem_cache_zalloc(userfaultfd_wait_queue_cachep, GFP_KERNEL);
 
-	msg_init(&ewq.msg);
+	msg_init(&ewq->msg);
 
-	ewq.msg.event = UFFD_EVENT_FORK;
-	ewq.msg.arg.reserved.reserved1 = (unsigned long)fctx->new;
+	ewq->msg.event = UFFD_EVENT_FORK;
+	ewq->msg.arg.reserved.reserved1 = (unsigned long)fctx->new;
 
-	userfaultfd_event_wait_completion(ctx, &ewq);
+	userfaultfd_event_wait_completion(ctx, ewq);
+	kmem_cache_free(userfaultfd_wait_queue_cachep, ewq);
 }
 
 void dup_userfaultfd_complete(struct list_head *fcs)
@@ -951,7 +953,7 @@ void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *vm_ctx,
 				 unsigned long len)
 {
 	struct userfaultfd_ctx *ctx = vm_ctx->ctx;
-	struct userfaultfd_wait_queue ewq;
+	struct userfaultfd_wait_queue *ewq = kmem_cache_zalloc(userfaultfd_wait_queue_cachep, GFP_KERNEL);
 
 	if (!ctx)
 		return;
@@ -961,14 +963,15 @@ void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *vm_ctx,
 		return;
 	}
 
-	msg_init(&ewq.msg);
+	msg_init(&ewq->msg);
 
-	ewq.msg.event = UFFD_EVENT_REMAP;
-	ewq.msg.arg.remap.from = from;
-	ewq.msg.arg.remap.to = to;
-	ewq.msg.arg.remap.len = len;
+	ewq->msg.event = UFFD_EVENT_REMAP;
+	ewq->msg.arg.remap.from = from;
+	ewq->msg.arg.remap.to = to;
+	ewq->msg.arg.remap.len = len;
 
-	userfaultfd_event_wait_completion(ctx, &ewq);
+	userfaultfd_event_wait_completion(ctx, ewq);
+	kmem_cache_free(userfaultfd_wait_queue_cachep, ewq);
 }
 
 bool userfaultfd_remove(struct vm_area_struct *vma,
@@ -976,23 +979,25 @@ bool userfaultfd_remove(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct userfaultfd_ctx *ctx;
-	struct userfaultfd_wait_queue ewq;
+	struct userfaultfd_wait_queue *ewq;
 
 	ctx = vma->vm_userfaultfd_ctx.ctx;
 	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_REMOVE))
 		return true;
 
+	ewq = kmem_cache_zalloc(userfaultfd_wait_queue_cachep, GFP_KERNEL);
 	userfaultfd_ctx_get(ctx);
 	WRITE_ONCE(ctx->mmap_changing, true);
 	mmap_read_unlock(mm);
 
-	msg_init(&ewq.msg);
+	msg_init(&ewq->msg);
 
-	ewq.msg.event = UFFD_EVENT_REMOVE;
-	ewq.msg.arg.remove.start = start;
-	ewq.msg.arg.remove.end = end;
+	ewq->msg.event = UFFD_EVENT_REMOVE;
+	ewq->msg.arg.remove.start = start;
+	ewq->msg.arg.remove.end = end;
 
-	userfaultfd_event_wait_completion(ctx, &ewq);
+	userfaultfd_event_wait_completion(ctx, ewq);
+	kmem_cache_free(userfaultfd_wait_queue_cachep, ewq);
 
 	return false;
 }
@@ -1040,20 +1045,21 @@ int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 void userfaultfd_unmap_complete(struct mm_struct *mm, struct list_head *uf)
 {
 	struct userfaultfd_unmap_ctx *ctx, *n;
-	struct userfaultfd_wait_queue ewq;
+	struct userfaultfd_wait_queue *ewq = kmem_cache_zalloc(userfaultfd_wait_queue_cachep, GFP_KERNEL);
 
 	list_for_each_entry_safe(ctx, n, uf, list) {
-		msg_init(&ewq.msg);
+		msg_init(&ewq->msg);
 
-		ewq.msg.event = UFFD_EVENT_UNMAP;
-		ewq.msg.arg.remove.start = ctx->start;
-		ewq.msg.arg.remove.end = ctx->end;
+		ewq->msg.event = UFFD_EVENT_UNMAP;
+		ewq->msg.arg.remove.start = ctx->start;
+		ewq->msg.arg.remove.end = ctx->end;
 
-		userfaultfd_event_wait_completion(ctx->ctx, &ewq);
+		userfaultfd_event_wait_completion(ctx->ctx, ewq);
 
 		list_del(&ctx->list);
 		kfree(ctx);
 	}
+	kmem_cache_free(userfaultfd_wait_queue_cachep, ewq);
 }
 
 static void userfaultfd_cancel_async_reads(struct userfaultfd_ctx *ctx)
@@ -2471,6 +2477,12 @@ static int __init userfaultfd_init(void)
 						0,
 						SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 						init_once_userfaultfd_ctx);
+
+	userfaultfd_wait_queue_cachep = kmem_cache_create("userfaultfd_wait_queue_cache",
+						sizeof(struct userfaultfd_wait_queue),
+						0,
+						SLAB_HWCACHE_ALIGN|SLAB_PANIC,
+						NULL);
 	return 0;
 }
 __initcall(userfaultfd_init);
-- 
2.25.1

