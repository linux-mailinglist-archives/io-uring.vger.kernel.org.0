Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485A718FE4C
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 20:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgCWT61 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 15:58:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41841 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCWT61 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 15:58:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id h9so18691565wrc.8;
        Mon, 23 Mar 2020 12:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UUgQr/51oFOs/+4Z5FZxIsHssDK0n7t7FKjamb+j4TI=;
        b=WJxCIui6uXu9aaVCVPEDwogwL7ANYJLQGOXGTGsjF4Q6kCctRHFTXYZwNsPo+BgaYQ
         naO2g8DoqTwVy6e4aR/lMkQxRUKuT8qj/jZM72pDFvC4cld8+YT6Izpq/4ksGUD+mP/T
         MAFOG13hBBzrj94ELAn35JjaTmEJrNnbdwn4csAC1wuslzCa/73msfdFGjy8ncO1Dq3a
         kgyzuYlmDew6Xv+S3Ai3Zh74yiPvk9D4k3WmdA4JRV90LlWlvYxBicmb+YGAxK2BeA61
         ait+RkP8n2xq8Ik1jDDK+3a8wZVVOZyDV4Y8GIH+/lmVYuZ6DyyPSxybrmmdfQWbqUel
         Msiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UUgQr/51oFOs/+4Z5FZxIsHssDK0n7t7FKjamb+j4TI=;
        b=cCFv5YA3pg5oIWrrAdz59mLjx0Sjxy3HS2+q8ss/y59T9yp3kZgNjPTE+7S9Y11qq/
         u2Z6QdkoeSSxuUR4tE0AYHdThOXh9lzfexrPkTVn3LkjbstJd/zxXSNFbm5yglyUp0ZY
         q5M/hvm05hzGzBtylzEnjwc/u8130/XXMK3rEWIVkbtk20xHtFHuRDCLZSP1mcOxAWlS
         TlRyy2mINeNq6wagUtahCuPGm0zHIT3u8DKqhEdQCFI/kJNylx7Z4/YeJ8F1KbMN8F0D
         sBXYKkcd2pUQqMiPrlbJRk7ERRbWnycKnRpAL54uivdDFCHuTIzUYX7fj+6reeusOcHG
         +FSA==
X-Gm-Message-State: ANhLgQ24kQCrMrt7ye8exy28WxyKByWYxqStC/WMCCE3gkFw8M3xm3Lr
        58H17Fhqaw9KT2FXBFnretSG2rA1
X-Google-Smtp-Source: ADFU+vuB82GhyXE2p8QJIZ1wX+f6ux22j7L8/OxDpODvhsab8YFT+USkcf6A0D6jNc7YVzdmHKmaeg==
X-Received: by 2002:a5d:4f08:: with SMTP id c8mr9719061wru.27.1584993503940;
        Mon, 23 Mar 2020 12:58:23 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id t10sm2587215wrx.38.2020.03.23.12.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 12:58:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] io-wq: handle hashed writes in chains
Date:   Mon, 23 Mar 2020 22:57:22 +0300
Message-Id: <c0e464556675bd40ea47d61ce12e2393603ce43c.1584993396.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We always punt async buffered writes to an io-wq helper, as the core
kernel does not have IOCB_NOWAIT support for that. Most buffered async
writes complete very quickly, as it's just a copy operation. This means
that doing multiple locking roundtrips on the shared wqe lock for each
buffered write is wasteful. Additionally, buffered writes are hashed
work items, which means that any buffered write to a given file is
serialized.

Keep identicaly hashed work items contiguously in @wqe->work_list, and
track a tail for each hash bucket. On dequeue of a hashed item, splice
all of the same hash in one go using the tracked tail. Until the batch
is done, the caller doesn't have to synchronize with the wqe or worker
locks again.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2 (since diff):
- add wq_next_work() helper
- rename list helpers to match list.h naming
- reshuffle io_worker_handle_work() bits, but keeping
  functionally identical

 fs/io-wq.c | 68 ++++++++++++++++++++++++++++++++++++++----------------
 fs/io-wq.h | 45 +++++++++++++++++++++++++++++-------
 2 files changed, 85 insertions(+), 28 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b3fb61ec0870..cc5cf2209fb0 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -69,6 +69,8 @@ struct io_worker {
 #define IO_WQ_HASH_ORDER	5
 #endif
 
+#define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
+
 struct io_wqe_acct {
 	unsigned nr_workers;
 	unsigned max_workers;
@@ -98,6 +100,7 @@ struct io_wqe {
 	struct list_head all_list;
 
 	struct io_wq *wq;
+	struct io_wq_work *hash_tail[IO_WQ_NR_HASH_BUCKETS];
 };
 
 /*
@@ -384,7 +387,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
-	struct io_wq_work *work;
+	struct io_wq_work *work, *tail;
 	unsigned int hash;
 
 	wq_list_for_each(node, prev, &wqe->work_list) {
@@ -392,7 +395,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
-			wq_node_del(&wqe->work_list, node, prev);
+			wq_list_del(&wqe->work_list, node, prev);
 			return work;
 		}
 
@@ -400,7 +403,10 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 		hash = io_get_work_hash(work);
 		if (!(wqe->hash_map & BIT(hash))) {
 			wqe->hash_map |= BIT(hash);
-			wq_node_del(&wqe->work_list, node, prev);
+			/* all items with this hash lie in [work, tail] */
+			tail = wqe->hash_tail[hash];
+			wqe->hash_tail[hash] = NULL;
+			wq_list_cut(&wqe->work_list, &tail->list, prev);
 			return work;
 		}
 	}
@@ -485,7 +491,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 	struct io_wq *wq = wqe->wq;
 
 	do {
-		struct io_wq_work *work, *assign_work;
+		struct io_wq_work *work;
 		unsigned int hash;
 get_next:
 		/*
@@ -508,8 +514,9 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 		/* handle a whole dependent link */
 		do {
-			struct io_wq_work *old_work;
+			struct io_wq_work *old_work, *next_hashed, *linked;
 
+			next_hashed = wq_next_work(work);
 			io_impersonate_work(worker, work);
 			/*
 			 * OK to set IO_WQ_WORK_CANCEL even for uncancellable
@@ -518,22 +525,23 @@ static void io_worker_handle_work(struct io_worker *worker)
 			if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
 				work->flags |= IO_WQ_WORK_CANCEL;
 
-			old_work = work;
 			hash = io_get_work_hash(work);
-			work->func(&work);
-			work = (old_work == work) ? NULL : work;
-
-			assign_work = work;
-			if (work && io_wq_is_hashed(work))
-				assign_work = NULL;
-			io_assign_current_work(worker, assign_work);
+			linked = old_work = work;
+			linked->func(&linked);
+			linked = (old_work == linked) ? NULL : linked;
+
+			work = next_hashed;
+			if (!work && linked && !io_wq_is_hashed(linked)) {
+				work = linked;
+				linked = NULL;
+			}
+			io_assign_current_work(worker, work);
 			wq->free_work(old_work);
 
-			if (work && !assign_work) {
-				io_wqe_enqueue(wqe, work);
-				work = NULL;
-			}
-			if (hash != -1U) {
+			if (linked)
+				io_wqe_enqueue(wqe, linked);
+
+			if (hash != -1U && !next_hashed) {
 				spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
@@ -776,6 +784,26 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 	} while (work);
 }
 
+static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
+{
+	unsigned int hash;
+	struct io_wq_work *tail;
+
+	if (!io_wq_is_hashed(work)) {
+append:
+		wq_list_add_tail(&work->list, &wqe->work_list);
+		return;
+	}
+
+	hash = io_get_work_hash(work);
+	tail = wqe->hash_tail[hash];
+	wqe->hash_tail[hash] = work;
+	if (!tail)
+		goto append;
+
+	wq_list_add_after(&work->list, &tail->list, &wqe->work_list);
+}
+
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
@@ -795,7 +823,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 
 	work_flags = work->flags;
 	spin_lock_irqsave(&wqe->lock, flags);
-	wq_list_add_tail(&work->list, &wqe->work_list);
+	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
@@ -914,7 +942,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 		work = container_of(node, struct io_wq_work, list);
 
 		if (match->fn(work, match->data)) {
-			wq_node_del(&wqe->work_list, node, prev);
+			wq_list_del(&wqe->work_list, node, prev);
 			found = true;
 			break;
 		}
diff --git a/fs/io-wq.h b/fs/io-wq.h
index d2a5684bf673..3ee7356d6be5 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -28,6 +28,18 @@ struct io_wq_work_list {
 	struct io_wq_work_node *last;
 };
 
+static inline void wq_list_add_after(struct io_wq_work_node *node,
+				     struct io_wq_work_node *pos,
+				     struct io_wq_work_list *list)
+{
+	struct io_wq_work_node *next = pos->next;
+
+	pos->next = node;
+	node->next = next;
+	if (!next)
+		list->last = node;
+}
+
 static inline void wq_list_add_tail(struct io_wq_work_node *node,
 				    struct io_wq_work_list *list)
 {
@@ -40,17 +52,26 @@ static inline void wq_list_add_tail(struct io_wq_work_node *node,
 	}
 }
 
-static inline void wq_node_del(struct io_wq_work_list *list,
-			       struct io_wq_work_node *node,
+static inline void wq_list_cut(struct io_wq_work_list *list,
+			       struct io_wq_work_node *last,
 			       struct io_wq_work_node *prev)
 {
-	if (node == list->first)
-		WRITE_ONCE(list->first, node->next);
-	if (node == list->last)
+	/* first in the list, if prev==NULL */
+	if (!prev)
+		WRITE_ONCE(list->first, last->next);
+	else
+		prev->next = last->next;
+
+	if (last == list->last)
 		list->last = prev;
-	if (prev)
-		prev->next = node->next;
-	node->next = NULL;
+	last->next = NULL;
+}
+
+static inline void wq_list_del(struct io_wq_work_list *list,
+			       struct io_wq_work_node *node,
+			       struct io_wq_work_node *prev)
+{
+	wq_list_cut(list, node, prev);
 }
 
 #define wq_list_for_each(pos, prv, head)			\
@@ -78,6 +99,14 @@ struct io_wq_work {
 		*(work) = (struct io_wq_work){ .func = _func };	\
 	} while (0)						\
 
+static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
+{
+	if (!work->list.next)
+		return NULL;
+
+	return container_of(work->list.next, struct io_wq_work, list);
+}
+
 typedef void (free_work_fn)(struct io_wq_work *);
 
 struct io_wq_data {
-- 
2.24.0

