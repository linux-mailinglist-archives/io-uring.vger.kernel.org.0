Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA76518BFBD
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2020 19:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgCSS4q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Mar 2020 14:56:46 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42122 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgCSS4q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Mar 2020 14:56:46 -0400
Received: by mail-io1-f67.google.com with SMTP id q128so3410605iof.9
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2020 11:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gU+O1WteBcrbPMf10+D5JPQiWvQWUBrSXCg5rSPskIs=;
        b=o/I8UfFhZC9kVwao/dtLBxWYXO2jA8R+0lRUj4/HZz3x7ZfCjgoVOwl/z/x2RZD7JN
         f77ESLLyaTo+nQCzYLubsflly/tTTThYFo4Jc3Ab5mzZ3MRDMi1QNzS+LSwfqBnJh9za
         hcNuyqXLmOhHPgofcr56xuT4iAdVMdxQTjmZYC5Z+PvwYoXGJiUkYX2dUjqVZ2h799X4
         QwZz6Rge5pY1P9juYLAtI4zog+vSJqBLlDV4BVjZ7vgn4LzUYVJ9dDD1Gqz5x/E1rxj7
         bwdKCX6gqcFQTZBpWNjBKYjgiOdNRkJRQYMPzLjklnFmbUwt79glB0ZgzlhFjNOhgLr8
         CEsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gU+O1WteBcrbPMf10+D5JPQiWvQWUBrSXCg5rSPskIs=;
        b=eQ5/H5QLIo5HKIfmUZ70sgD4vn4nlrl8W0F4HMM/i7swyjPd7QtgR9HTIXeYiMvfl5
         mBP7P/lU3wa0HdEuJVHdVCFFDoj4heyKT2Lbk/iTmAtIFy4MxoVXftDXaizqWf1n5D6+
         +4noCTGlBIZl4iae2OIkmxXSO7xgrmNVu6jKF76eKexXioGt+g2tXe4SasW/ZbiIGhfA
         GrokISaDUr12WbRkwrgwli/I9avrm1mQ/kLR8P6V79REfDwyo0GJ2NjaIXX5vogDtgRO
         jbzdBYB2qMWLHnbBW+6sye9yDZZGe6SJ1PTV62tME8C9rPfcGYD7I1cMs/aUeyIOCe7L
         zRXw==
X-Gm-Message-State: ANhLgQ3IuP9rX72u16dF+iNMxHcXZTWnem+9TqLnJE4M6QsK4sl21boF
        XB86Vv5Rk1DZ4BwWPvMu+BkiJx2elt5Dsg==
X-Google-Smtp-Source: ADFU+vvlVwcJcOynWKRtaPzXKockoI7Fodl5T3ap0ktK1e7AsqWJ2allhN7vJ/LABoUc8WFANxzhiA==
X-Received: by 2002:a02:9003:: with SMTP id w3mr3950592jaf.18.1584644203200;
        Thu, 19 Mar 2020 11:56:43 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f15sm1029523iof.16.2020.03.19.11.56.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 11:56:42 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io-wq: handle hashed writes in chains
Message-ID: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
Date:   Thu, 19 Mar 2020 12:56:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

When looking for a new work item, build a chain of identicaly hashed
work items, and then hand back that batch. Until the batch is done, the
caller doesn't have to synchronize with the wqe or worker locks again.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Changes:
- Don't overwrite passed back work


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9541df2729de..8402c6e417e1 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -380,32 +380,65 @@ static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 	return work->flags >> IO_WQ_HASH_SHIFT;
 }
 
-static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
+/*
+ * Returns the next work item to process, if any. For hashed work that hash
+ * to the same key, we can't process N+1 before N is done. To make the
+ * processing more efficient, return N+1 and later identically hashed work
+ * in the passed in list. This avoids repeated hammering on the wqe lock for,
+ * as the caller can just process items in the on-stack list.
+ */
+static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
+					   struct io_wq_work_list *list)
 	__must_hold(wqe->lock)
 {
-	struct io_wq_work_node *node, *prev;
-	struct io_wq_work *work;
-	unsigned int hash;
+	struct io_wq_work *ret = NULL;
 
-	wq_list_for_each(node, prev, &wqe->work_list) {
-		work = container_of(node, struct io_wq_work, list);
+	do {
+		unsigned int new_hash, hash;
+		struct io_wq_work *work;
+
+		work = wq_first_entry(&wqe->work_list, struct io_wq_work, list);
+		if (!work)
+			break;
 
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
-			wq_node_del(&wqe->work_list, node, prev);
-			return work;
+			/* already have hashed work, let new worker get this */
+			if (ret) {
+				struct io_wqe_acct *acct;
+
+				/* get new worker for unhashed, if none now */
+				acct = io_work_get_acct(wqe, work);
+				if (!atomic_read(&acct->nr_running))
+					io_wqe_wake_worker(wqe, acct);
+				break;
+			}
+			wq_node_del(&wqe->work_list, &work->list);
+			ret = work;
+			break;
 		}
 
 		/* hashed, can run if not already running */
-		hash = io_get_work_hash(work);
-		if (!(wqe->hash_map & BIT(hash))) {
+		new_hash = io_get_work_hash(work);
+		if (wqe->hash_map & BIT(new_hash))
+			break;
+
+		if (!ret) {
+			hash = new_hash;
 			wqe->hash_map |= BIT(hash);
-			wq_node_del(&wqe->work_list, node, prev);
-			return work;
+		} else if (hash != new_hash) {
+			break;
 		}
-	}
 
-	return NULL;
+		wq_node_del(&wqe->work_list, &work->list);
+		/* return first node, add subsequent same hash to the list */
+		if (!ret)
+			ret = work;
+		else
+			wq_list_add_tail(&work->list, list);
+	} while (1);
+
+	return ret;
 }
 
 static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
@@ -481,6 +514,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
+	struct io_wq_work_list list = { .first = NULL, .last = NULL };
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
@@ -495,7 +529,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(wqe);
+		work = io_get_next_work(wqe, &list);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
 		else if (!wq_list_empty(&wqe->work_list))
@@ -504,6 +538,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		spin_unlock_irq(&wqe->lock);
 		if (!work)
 			break;
+got_work:
 		io_assign_current_work(worker, work);
 
 		/* handle a whole dependent link */
@@ -530,6 +565,24 @@ static void io_worker_handle_work(struct io_worker *worker)
 				work = NULL;
 			}
 			if (hash != -1U) {
+				/*
+				 * If the local list is non-empty, then we
+				 * have work that hashed to the same key.
+				 * No need for a lock round-trip, or fiddling
+				 * the the free/busy state of the worker, or
+				 * clearing the hashed state. Just process the
+				 * next one.
+				 */
+				if (!work) {
+					work = wq_first_entry(&list,
+							      struct io_wq_work,
+							      list);
+					if (work) {
+						wq_node_del(&list, &work->list);
+						goto got_work;
+					}
+				}
+
 				spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
@@ -910,7 +963,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 		work = container_of(node, struct io_wq_work, list);
 
 		if (match->fn(work, match->data)) {
-			wq_node_del(&wqe->work_list, node, prev);
+			__wq_node_del(&wqe->work_list, node, prev);
 			found = true;
 			break;
 		}
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 298b21f4a4d2..9a194339bd9d 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -40,9 +40,9 @@ static inline void wq_list_add_tail(struct io_wq_work_node *node,
 	}
 }
 
-static inline void wq_node_del(struct io_wq_work_list *list,
-			       struct io_wq_work_node *node,
-			       struct io_wq_work_node *prev)
+static inline void __wq_node_del(struct io_wq_work_list *list,
+				struct io_wq_work_node *node,
+				struct io_wq_work_node *prev)
 {
 	if (node == list->first)
 		WRITE_ONCE(list->first, node->next);
@@ -53,6 +53,21 @@ static inline void wq_node_del(struct io_wq_work_list *list,
 	node->next = NULL;
 }
 
+
+static inline void wq_node_del(struct io_wq_work_list *list,
+			       struct io_wq_work_node *node)
+{
+	__wq_node_del(list, node, NULL);
+}
+
+#define wq_first_entry(list, type, member)				\
+({									\
+	struct io_wq_work *__work = NULL;				\
+	if (!wq_list_empty((list)))					\
+		__work = container_of((list)->first, type, member);	\
+	__work;								\
+})
+
 #define wq_list_for_each(pos, prv, head)			\
 	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
 
-- 
Jens Axboe

