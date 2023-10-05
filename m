Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAB77B9915
	for <lists+io-uring@lfdr.de>; Thu,  5 Oct 2023 02:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243988AbjJEAFt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Oct 2023 20:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244182AbjJEAFs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Oct 2023 20:05:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C70990
        for <io-uring@vger.kernel.org>; Wed,  4 Oct 2023 17:05:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3A4CA2184B;
        Thu,  5 Oct 2023 00:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696464344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YBshpperKhubn24wfhSIwOb1gp69Nh4dUsekeGMOoRM=;
        b=EgEsyG6ffT5/EdEDLvIewrNBa53lyg2INerwNnhb1gRm37fZ8d5kMoW6ivKRX5OE05PA0H
        3m2QJgg9JnAMsdKS7N6PqLEg8nDHm1V0vTbwaDlUC3g7HVaHd5v9WJPDsJClTtn6DuW5fL
        svfjaCB1uTL6JhjRPyajvPkhUjHIcuA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696464344;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YBshpperKhubn24wfhSIwOb1gp69Nh4dUsekeGMOoRM=;
        b=4MigbfN4fKyCeL0rG91y4mOI2zGUxwCqGRvvMIfVeHzaQiDI58iEl8XOSbDAzqdyNChijb
        EyoUANE2sfEEAbCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 06E4E1331E;
        Thu,  5 Oct 2023 00:05:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dBvtN9f9HWWHDQAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 05 Oct 2023 00:05:43 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 3/3] io_uring: Use slab for struct io_buffer objects
Date:   Wed,  4 Oct 2023 20:05:31 -0400
Message-ID: <20231005000531.30800-4-krisman@suse.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231005000531.30800-1-krisman@suse.de>
References: <20231005000531.30800-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
changes from v1
  - reduce batch size to limit stack usage. (Jeff)
  - Don't check kmem_cache_alloc_bulk return for < 0 (Jeff)
---
 include/linux/io_uring_types.h |  2 --
 io_uring/io_uring.c            |  4 ++-
 io_uring/io_uring.h            |  1 +
 io_uring/kbuf.c                | 47 +++++++++++++++++++---------------
 4 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 13d19b9be9f4..9dca731b1ca8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -342,8 +342,6 @@ struct io_ring_ctx {
 	struct wait_queue_head		rsrc_quiesce_wq;
 	unsigned			rsrc_quiesce;
 
-	struct list_head		io_buffers_pages;
-
 	#if defined(CONFIG_UNIX)
 		struct socket		*ring_sock;
 	#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 783ed0fff71b..548c32fc1e28 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -338,7 +338,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
-	INIT_LIST_HEAD(&ctx->io_buffers_pages);
 	INIT_LIST_HEAD(&ctx->io_buffers_comp);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
@@ -4681,6 +4680,9 @@ static int __init io_uring_init(void)
 				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
 				offsetof(struct io_kiocb, cmd.data),
 				sizeof_field(struct io_kiocb, cmd.data), NULL);
+	io_buf_cachep = kmem_cache_create("io_buffer", sizeof(struct io_buffer), 0,
+					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT,
+					  NULL);
 
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 547c30582fb8..2ff719ae1b57 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -330,6 +330,7 @@ static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
 }
 
 extern struct kmem_cache *req_cachep;
+extern struct kmem_cache *io_buf_cachep;
 
 static inline struct io_kiocb *io_extract_req(struct io_ring_ctx *ctx)
 {
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 12a357348733..d5a04467666f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -22,6 +22,8 @@
 /* BIDs are addressed by a 16-bit field in a CQE */
 #define MAX_BIDS_PER_BGID (1 << 16)
 
+struct kmem_cache *io_buf_cachep;
+
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
@@ -258,6 +260,8 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
+	struct list_head *item, *tmp;
+	struct io_buffer *buf;
 	unsigned long index;
 	int i;
 
@@ -273,12 +277,9 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
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
 
@@ -361,11 +362,12 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
+#define IO_BUFFER_ALLOC_BATCH 64
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
@@ -385,22 +387,25 @@ static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
 
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
+	if (unlikely(!allocated)) {
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
2.42.0

