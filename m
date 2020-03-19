Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BF118BB28
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2020 16:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgCSPbM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Mar 2020 11:31:12 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:38154 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgCSPbM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Mar 2020 11:31:12 -0400
Received: by mail-il1-f193.google.com with SMTP id p1so2615547ils.5
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2020 08:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=aKSQG1ESUtsahsJpfdgswSjnQZNRh/+4OB+/Q2Y0XPc=;
        b=zQN/eIUWu7w/8j9cNrekIn7vY2+mIyn6etKgY3MOmNrKE/hAjkWDy0YxbSHtlsdnXi
         X1dM5+gvg01z9dlPqX/ieKoVAa5qtfvYBXtBN6Fn3W6zfpfwGJwIv1eMm62guSflAzGA
         CH/cKFAWec01WGImFVuPlvscwMiGJ2pcMIxEUrHZ+1dbtAZgM035k5INw7kVKk1vAjxV
         Qb5DR4jk058f3niypX4FHEqjv7I/gKfD4aPJZTtaLOX+Ij7/6AZjb7EWJvpnpBSFZi8W
         sDSfBR6SIDW50zFe5tOTJ852pqvxFziQAcMd5L30m1XVEepJc5wu94s0BFGRiXp6MkfP
         mpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=aKSQG1ESUtsahsJpfdgswSjnQZNRh/+4OB+/Q2Y0XPc=;
        b=J4q+sk9OU8kIu8LOpmijYb7lKIfgZEviar/So273IuraXTl3kS/Lq08rVMx7n1bWwL
         8BOe33Cz+UEH566CWA2Qg/arguha7H/smLv4NNa5mMatoWfp/0i1z4fW7/yeRzX2o9+H
         Tj9F5M07jgK2w0HKmwnfTMYEJUy5xRCO7NuOWabAcFnSmMLqXXaUCt3jiIT6KSw+OtEX
         w2VSi3o4lLEkGRgGARLZxGT4AaApLF4NTRJ9CQBrmXzbRjvtljH9CcfXs89jLmiitOVi
         9dQkZnXdOVNryTpDFTENvSXArojZ0Wrb7OXPh0R1r6j2DUrAW/iMr83DPki/YEYIWFVB
         JCGA==
X-Gm-Message-State: ANhLgQ2PGc7zweluNYDSTXpq/Oq5XezxTfPYvfUZHQaJZ7D2ZULhw8GX
        M94HpnK+2urWWXysrvISM978cKEnv7FfhQ==
X-Google-Smtp-Source: ADFU+vvl00UPmLE5kKnnpi3uuCLvTpnudbyeE4jWDV2jX+LAb6ktuWdg/PbPKs6fhZQRAsCHX4qAXA==
X-Received: by 2002:a92:3993:: with SMTP id h19mr3869571ilf.177.1584631867679;
        Thu, 19 Mar 2020 08:31:07 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q17sm968695ilm.85.2020.03.19.08.31.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 08:31:06 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: handle hashed writes in chains
Message-ID: <fcb504f5-28b1-bf16-68e2-8718b7c00f3a@kernel.dk>
Date:   Thu, 19 Mar 2020 09:31:05 -0600
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

Since rfc v2:
- Add and use wq_first_entry()
- Add __wq_node_del() for the common case of prev == NULL
- Cleanups and comments

Could potentially split this into two, with the first patch being the
wq_node_del() and wq_first_entry() changes...

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9541df2729de..f4c32e594b9a 100644
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
@@ -530,6 +565,21 @@ static void io_worker_handle_work(struct io_worker *worker)
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
+				work = wq_first_entry(&list, struct io_wq_work,
+							list);
+				if (work) {
+					wq_node_del(&list, &work->list);
+					goto got_work;
+				}
+
 				spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
@@ -910,7 +960,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
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

