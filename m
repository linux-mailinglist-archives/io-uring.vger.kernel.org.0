Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFAB12BEAC
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfL1TVZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:21:25 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42009 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfL1TVZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:21:25 -0500
Received: by mail-pl1-f195.google.com with SMTP id p9so13063065plk.9
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q19loTP7U+g3e+v/t1nURvhfh/VLHOd9ZGZmii6Mbd8=;
        b=Pfp3JsoAzBsPTJDD/oZASYbiZdun+eacW3RvXDKZc2l7QazSw/c+reX839My3oGKpN
         XLnHW9AH6Ocdp4TM8B/MhCewkPp35tFQK/6cSIbuIDMnr8VVOclXkVsrrQIN0pPPpIqa
         uM+EMnv8NKNdT3tSxQlrR2jrU7Mg/sR44GAj3SvOkpmTC7pExpcTxLIlnjN//rWNabxI
         9+eClPg4077OlR8toJ8dKJh5Pb70T55h9LTbmfoaVwLmqLY2NOsIN/RtGCGDEafcw/5j
         FJZeQnDvq6UPGs8s+TkCSZTuqo4Tm+22DM07uq6e5MaMVovV/WPqe31OcSjPc+C5cLPM
         f7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q19loTP7U+g3e+v/t1nURvhfh/VLHOd9ZGZmii6Mbd8=;
        b=MJXa27Oc7cIRqKF2ReSuUXNLrU75Z56IKjU4jyMFyMdu3Q5LQpj8iMCUjpAfbnQT6U
         zsvPrILCwvBZs2BJR1decHTcGdqE0hJeRp8XCRAqhOOps+cQEs1PJaSYygZQ8yNbNZ+b
         j0x4KHOU2UndnOaEAKOibsTuBGA1Y+EdY9ykwvAvGuzwsr+Zab9l7Q8KMK23yPaY6A29
         kngntYOwaKBqsxpHROVcgjSRsVeCjuWaWvNN+rNNbyONFKfoxJkwRnfkmtGqDREZXI/n
         HSSYSNLb8+nyentCUfMKfCibKsyLPlogQTfA5jTO82WLtOIWVbh/2cmO6bDeTSU5foEn
         KodA==
X-Gm-Message-State: APjAAAXUSnY/LwcagHjhRz/BpE9fGRmFTw/46cqWoTB+TmWgKOrJsNi+
        6Zxn3T/i3xQU4p+dRexlsrmnbUXov87fGg==
X-Google-Smtp-Source: APXvYqzuj85iWg7axbreG/Tb12I50fOQL3Ywodst7zJCpqIw8V5SwzDO/3Y999alFJ61G/oQF48Qmw==
X-Received: by 2002:a17:90a:a05:: with SMTP id o5mr35015481pjo.77.1577560884389;
        Sat, 28 Dec 2019 11:21:24 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z30sm47067902pfq.154.2019.12.28.11.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:21:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/9] io_uring: improve poll completion performance
Date:   Sat, 28 Dec 2019 12:21:13 -0700
Message-Id: <20191228192118.4005-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228192118.4005-1-axboe@kernel.dk>
References: <20191228192118.4005-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For busy IORING_OP_POLL_ADD workloads, we can have enough contention
on the completion lock that we fail the inline completion path quite
often as we fail the trylock on that lock. Add a list for deferred
completions that we can use in that case. This helps reduce the number
of async offloads we have to do, as if we get multiple completions in
a row, we'll piggy back on to the poll_llist instead of having to queue
our own offload.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 108 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 88 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6f99a52c350c..0ee9115a599d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -286,7 +286,8 @@ struct io_ring_ctx {
 
 	struct {
 		spinlock_t		completion_lock;
-		bool			poll_multi_file;
+		struct llist_head	poll_llist;
+
 		/*
 		 * ->poll_list is protected by the ctx->uring_lock for
 		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
@@ -296,6 +297,7 @@ struct io_ring_ctx {
 		struct list_head	poll_list;
 		struct hlist_head	*cancel_hash;
 		unsigned		cancel_hash_bits;
+		bool			poll_multi_file;
 
 		spinlock_t		inflight_lock;
 		struct list_head	inflight_list;
@@ -453,7 +455,14 @@ struct io_kiocb {
 	};
 
 	struct io_async_ctx		*io;
-	struct file			*ring_file;
+	union {
+		/*
+		 * ring_file is only used in the submission path, and
+		 * llist_node is only used for poll deferred completions
+		 */
+		struct file		*ring_file;
+		struct llist_node	llist_node;
+	};
 	int				ring_fd;
 	bool				has_user;
 	bool				in_async;
@@ -727,6 +736,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
+	init_llist_head(&ctx->poll_llist);
 	INIT_LIST_HEAD(&ctx->poll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
@@ -1322,6 +1332,20 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
 }
 
+static inline bool io_req_multi_free(struct io_kiocb *req)
+{
+	/*
+	 * If we're not using fixed files, we have to pair the completion part
+	 * with the file put. Use regular completions for those, only batch
+	 * free for fixed file and non-linked commands.
+	 */
+	if (((req->flags & (REQ_F_FIXED_FILE|REQ_F_LINK)) == REQ_F_FIXED_FILE)
+	    && !io_is_fallback_req(req) && !req->io)
+		return true;
+
+	return false;
+}
+
 /*
  * Find and free completed poll iocbs
  */
@@ -1341,14 +1365,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		(*nr_events)++;
 
 		if (refcount_dec_and_test(&req->refs)) {
-			/* If we're not using fixed files, we have to pair the
-			 * completion part with the file put. Use regular
-			 * completions for those, only batch free for fixed
-			 * file and non-linked commands.
-			 */
-			if (((req->flags & (REQ_F_FIXED_FILE|REQ_F_LINK)) ==
-			    REQ_F_FIXED_FILE) && !io_is_fallback_req(req) &&
-			    !req->io) {
+			if (io_req_multi_free(req)) {
 				reqs[to_free++] = req;
 				if (to_free == ARRAY_SIZE(reqs))
 					io_free_req_many(ctx, reqs, &to_free);
@@ -3082,6 +3099,44 @@ static void io_poll_complete_work(struct io_wq_work **workptr)
 		*workptr = &nxt->work;
 }
 
+static void __io_poll_flush(struct io_ring_ctx *ctx, struct llist_node *nodes)
+{
+	void *reqs[IO_IOPOLL_BATCH];
+	struct io_kiocb *req, *tmp;
+	int to_free = 0;
+
+	spin_lock_irq(&ctx->completion_lock);
+	llist_for_each_entry_safe(req, tmp, nodes, llist_node) {
+		hash_del(&req->hash_node);
+		io_poll_complete(req, req->result, 0);
+
+		if (refcount_dec_and_test(&req->refs)) {
+			if (io_req_multi_free(req)) {
+				reqs[to_free++] = req;
+				if (to_free == ARRAY_SIZE(reqs))
+					io_free_req_many(ctx, reqs, &to_free);
+			} else {
+				req->flags |= REQ_F_COMP_LOCKED;
+				io_free_req(req);
+			}
+		}
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	io_free_req_many(ctx, reqs, &to_free);
+}
+
+static void io_poll_flush(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct llist_node *nodes;
+
+	nodes = llist_del_all(&req->ctx->poll_llist);
+	if (nodes)
+		__io_poll_flush(req->ctx, nodes);
+}
+
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
@@ -3089,7 +3144,6 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
 	struct io_ring_ctx *ctx = req->ctx;
 	__poll_t mask = key_to_poll(key);
-	unsigned long flags;
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
@@ -3103,17 +3157,31 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	 * If we have a link timeout we're going to need the completion_lock
 	 * for finalizing the request, mark us as having grabbed that already.
 	 */
-	if (mask && spin_trylock_irqsave(&ctx->completion_lock, flags)) {
-		hash_del(&req->hash_node);
-		io_poll_complete(req, mask, 0);
-		req->flags |= REQ_F_COMP_LOCKED;
-		io_put_req(req);
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	if (mask) {
+		unsigned long flags;
 
-		io_cqring_ev_posted(ctx);
-	} else {
-		io_queue_async_work(req);
+		if (llist_empty(&ctx->poll_llist) &&
+		    spin_trylock_irqsave(&ctx->completion_lock, flags)) {
+			hash_del(&req->hash_node);
+			io_poll_complete(req, mask, 0);
+			req->flags |= REQ_F_COMP_LOCKED;
+			io_put_req(req);
+			spin_unlock_irqrestore(&ctx->completion_lock, flags);
+
+			io_cqring_ev_posted(ctx);
+			req = NULL;
+		} else {
+			req->result = mask;
+			req->llist_node.next = NULL;
+			/* if the list wasn't empty, we're done */
+			if (!llist_add(&req->llist_node, &ctx->poll_llist))
+				req = NULL;
+			else
+				req->work.func = io_poll_flush;
+		}
 	}
+	if (req)
+		io_queue_async_work(req);
 
 	return 1;
 }
-- 
2.24.1

