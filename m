Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D583878D12D
	for <lists+io-uring@lfdr.de>; Wed, 30 Aug 2023 02:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjH3AhG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Aug 2023 20:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240106AbjH3Ago (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Aug 2023 20:36:44 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BA5CCE
        for <io-uring@vger.kernel.org>; Tue, 29 Aug 2023 17:36:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A72E11F74D;
        Wed, 30 Aug 2023 00:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693355798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HnYAkw8WwYPDOlpAPbX/VXjPx94zhPgdpO7ntrZ5AB8=;
        b=Z3Jef9q/CLKfQFOWlIfSASaAGcmu29MqVxetHCrngTjeaTJTy1E7599f6AmaMlWACd1RPU
        Zby/vy02nIONEuKsxLq/vFaNV9oUeusDTUgPGc+dFNkPhZGwBkxwuv46CNsmv0BvrAQ4m6
        +zQJ1msAcAbTH3cwslDqXYHOidIbho8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693355798;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HnYAkw8WwYPDOlpAPbX/VXjPx94zhPgdpO7ntrZ5AB8=;
        b=HAseHJifExFUfBTR1INoR2aXzhqJRbxXwx0BEChChbnB31wV4JP3zQJR7k4izEAcC6nvwH
        DPVJ38beJIa69kAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7312513301;
        Wed, 30 Aug 2023 00:36:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8xrEFhaP7mRWKgAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 30 Aug 2023 00:36:38 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] io_uring: Use slab for struct io_buffer objects
Date:   Tue, 29 Aug 2023 20:36:34 -0400
Message-ID: <20230830003634.31568-1-krisman@suse.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The allocation of struct io_buffer for metadata of provided buffers is
done through a custom allocator that directly gets pages and
fragments them.  But, slab would do just fine, as this is not a hot path
(in fact, it is a deprecated feature) and, by keeping a custom allocator
implementation we lose benefits like tracking, poisoning,
sanitizers. Finally, the custom code is more complex and requires
keeping the list of pages in struct ctx for no good reason.  This patch
cleans this path up and just uses slab.

I microbenchmarked it by forcing the allocation of a large number of
objects with the least number of io_uring commands possible (keeping
nbufs=USHRT_MAX), with and without the patch.  There is a slight
increase in time spent in the allocation with slab, of course, but even
when allocating to system resources exhaustion, which is not very
realistic and happened around 1/2 billion provided buffers for me, it
wasn't a significant hit in system time.  Specially if we think of a
real-world scenario, an application doing register/unregister of
provided buffers will hit ctx->io_buffers_cache more often than actually
going to slab.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/io_uring_types.h |  2 --
 io_uring/io_uring.c            |  5 +++-
 io_uring/io_uring.h            |  1 +
 io_uring/kbuf.c                | 47 +++++++++++++++++++---------------
 4 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f04ce513fadb..45da4895d832 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -346,8 +346,6 @@ struct io_ring_ctx {
 	struct wait_queue_head		rsrc_quiesce_wq;
 	unsigned			rsrc_quiesce;
 
-	struct list_head		io_buffers_pages;
-
 	#if defined(CONFIG_UNIX)
 		struct socket		*ring_sock;
 	#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e1a23f4993d3..556b42cddf75 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -314,7 +314,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
-	INIT_LIST_HEAD(&ctx->io_buffers_pages);
 	INIT_LIST_HEAD(&ctx->io_buffers_comp);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
@@ -4622,6 +4621,10 @@ static int __init io_uring_init(void)
 				offsetof(struct io_kiocb, cmd.data),
 				sizeof_field(struct io_kiocb, cmd.data), NULL);
 
+	io_buf_cachep = kmem_cache_create("io_buffer", sizeof(struct io_buffer), 0,
+					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT,
+					  NULL);
+
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3e6ff3cd9a24..5e4e9b1362e1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -338,6 +338,7 @@ static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
 }
 
 extern struct kmem_cache *req_cachep;
+extern struct kmem_cache *io_buf_cachep;
 
 static inline struct io_kiocb *io_extract_req(struct io_ring_ctx *ctx)
 {
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 2f0181521c98..38141735dc46 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -19,6 +19,8 @@
 
 #define BGID_ARRAY	64
 
+struct kmem_cache *io_buf_cachep;
+
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
@@ -259,6 +261,8 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
+	struct list_head *item, *tmp;
+	struct io_buffer *buf;
 	unsigned long index;
 	int i;
 
@@ -274,12 +278,9 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 		kfree(bl);
 	}
 
-	while (!list_empty(&ctx->io_buffers_pages)) {
-		struct page *page;
-
-		page = list_first_entry(&ctx->io_buffers_pages, struct page, lru);
-		list_del_init(&page->lru);
-		__free_page(page);
+	list_for_each_safe(item, tmp, &ctx->io_buffers_cache) {
+		buf = list_entry(item, struct io_buffer, list);
+		kmem_cache_free(io_buf_cachep, buf);
 	}
 }
 
@@ -362,11 +363,12 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
+#define IO_BUFFER_ALLOC_BATCH (PAGE_SIZE/sizeof(struct io_buffer))
+
 static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
 {
-	struct io_buffer *buf;
-	struct page *page;
-	int bufs_in_page;
+	struct io_buffer *bufs[IO_BUFFER_ALLOC_BATCH];
+	int allocated;
 
 	/*
 	 * Completions that don't happen inline (eg not under uring_lock) will
@@ -386,22 +388,25 @@ static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
 
 	/*
 	 * No free buffers and no completion entries either. Allocate a new
-	 * page worth of buffer entries and add those to our freelist.
+	 * batch of buffer entries and add those to our freelist.
 	 */
-	page = alloc_page(GFP_KERNEL_ACCOUNT);
-	if (!page)
-		return -ENOMEM;
 
-	list_add(&page->lru, &ctx->io_buffers_pages);
-
-	buf = page_address(page);
-	bufs_in_page = PAGE_SIZE / sizeof(*buf);
-	while (bufs_in_page) {
-		list_add_tail(&buf->list, &ctx->io_buffers_cache);
-		buf++;
-		bufs_in_page--;
+	allocated = kmem_cache_alloc_bulk(io_buf_cachep, GFP_KERNEL_ACCOUNT,
+					  ARRAY_SIZE(bufs), (void **) bufs);
+	if (unlikely(allocated <= 0)) {
+		/*
+		 * Bulk alloc is all-or-nothing. If we fail to get a batch,
+		 * retry single alloc to be on the safe side.
+		 */
+		bufs[0] = kmem_cache_alloc(io_buf_cachep, GFP_KERNEL);
+		if (!bufs[0])
+			return -ENOMEM;
+		allocated = 1;
 	}
 
+	while (allocated)
+		list_add_tail(&bufs[--allocated]->list, &ctx->io_buffers_cache);
+
 	return 0;
 }
 
-- 
2.41.0

