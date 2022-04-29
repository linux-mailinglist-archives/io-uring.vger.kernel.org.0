Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCD1514683
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357407AbiD2KWh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357397AbiD2KWb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:31 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC8DC6EE8;
        Fri, 29 Apr 2022 03:19:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id bg9so6174291pgb.9;
        Fri, 29 Apr 2022 03:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yaaffhZRdgQzeJaW/txlNp8Y8Fkop4HSJzduw6Zdurk=;
        b=L3ZRc7u0H+ek/0Z+wpKKbgyjKi8oGCwOy6VEPbBCMmy1ihChbHsyMwTbsT030foUh3
         TDoEZJ/+PBxfhOx9Vpv1YeTGtEMeglQVt1uWPQ+OxvnCLd8pDEGwhL4OrRgU9bHb5lTI
         YLBSYIzTcsyhUObxaxyXX8HMW/Drep594/ESiI/SnOLwuyFqAWUwpnsTy/8zCGT0po+j
         FehWPzwiX0vd1awDRkEJAweRDe0kZHddhil8Fnw4EYJXVXmL6J4F0I++ouc2zMkUwe9i
         RoWBQUV7c9gXl9vuf95cBnA51TgaHWdas4Y71alBJoOspVwy+JHi0egws04jxitEwXc2
         wRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yaaffhZRdgQzeJaW/txlNp8Y8Fkop4HSJzduw6Zdurk=;
        b=sUx3mcfTrm0B3ZRvzZROxClkVVb3Sy5DXsf385mMpnzIvORVc9BehHQ4metZbfrQ+t
         4vusloxMVgjJ0xhvtZBCTm3vnRjS/P9x/RMXjecIMPXXhPsVBQ0arv8jIWVvKXn6AUeB
         C1oi70q2FXKZtXdCUK9UyYvwDjAg7vHFo4I0+p4Pmde9UZF9B9aGcW6/Q1Hi88sq3/se
         I9ZLAU1OXgDbotQtIruzKl4ysZxt6I9RoypVbDFrd+YR0HLTb+A6H310HV2F+Cd6F/+d
         wc6v4rFc4mGQwqEILK4ytaD5YfDOdqHCQFuWE8L3I+7fiGfgYg7ScBVih9Tpj1/FgzSK
         aEYQ==
X-Gm-Message-State: AOAM533ZADmzYw2hCKaznjv7wIjMp6cab/y+SB0Oi7HbubW3ISQKTr7+
        D1NvXZKcrBCHPOfcvNZVxXONjVRByNM=
X-Google-Smtp-Source: ABdhPJx58AzAT7mNOSnHmR7deNFVaKnPyEoWDnoyMjWXuXmpKIFKe0Gk8XKY3kzCG6Vznv4IisKXLw==
X-Received: by 2002:a63:e90a:0:b0:3aa:2c41:87b4 with SMTP id i10-20020a63e90a000000b003aa2c4187b4mr31343195pgh.118.1651227553225;
        Fri, 29 Apr 2022 03:19:13 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.19.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:19:12 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] io-wq: batch the handling of fixed worker private works
Date:   Fri, 29 Apr 2022 18:18:57 +0800
Message-Id: <20220429101858.90282-9-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429101858.90282-1-haoxu.linux@gmail.com>
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Reduce acct->lock contension by batching the handling of private work
list for fixed_workers.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 42 +++++++++++++++++++++++++++++++++---------
 fs/io-wq.h |  5 +++++
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index aaa9cea7d39a..df2d480395e8 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -540,8 +540,23 @@ static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	return ret;
 }
 
+static inline void conditional_acct_lock(struct io_wqe_acct *acct,
+					 bool needs_lock)
+{
+	if (needs_lock)
+		raw_spin_lock(&acct->lock);
+}
+
+static inline void conditional_acct_unlock(struct io_wqe_acct *acct,
+					   bool needs_lock)
+{
+	if (needs_lock)
+		raw_spin_unlock(&acct->lock);
+}
+
 static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
-					   struct io_worker *worker)
+					   struct io_worker *worker,
+					   bool needs_lock)
 	__must_hold(acct->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -549,6 +564,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	unsigned int stall_hash = -1U;
 	struct io_wqe *wqe = worker->wqe;
 
+	conditional_acct_lock(acct, needs_lock);
 	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int hash;
 
@@ -557,6 +573,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&acct->work_list, node, prev);
+			conditional_acct_unlock(acct, needs_lock);
 			return work;
 		}
 
@@ -568,6 +585,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
 			wqe->hash_tail[hash] = NULL;
 			wq_list_cut(&acct->work_list, &tail->list, prev);
+			conditional_acct_unlock(acct, needs_lock);
 			return work;
 		}
 		if (stall_hash == -1U)
@@ -584,15 +602,16 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		 * work being added and clearing the stalled bit.
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-		raw_spin_unlock(&acct->lock);
+		conditional_acct_unlock(acct, needs_lock);
 		unstalled = io_wait_on_hash(wqe, stall_hash);
-		raw_spin_lock(&acct->lock);
+		conditional_acct_lock(acct, needs_lock);
 		if (unstalled) {
 			clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 			if (wq_has_sleeper(&wqe->wq->hash->wait))
 				wake_up(&wqe->wq->hash->wait);
 		}
 	}
+	conditional_acct_unlock(acct, needs_lock);
 
 	return NULL;
 }
@@ -626,7 +645,7 @@ static void io_assign_current_work(struct io_worker *worker,
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
 static void io_worker_handle_work(struct io_worker *worker,
-				  struct io_wqe_acct *acct)
+				  struct io_wqe_acct *acct, bool needs_lock)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
@@ -642,9 +661,7 @@ static void io_worker_handle_work(struct io_worker *worker,
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		raw_spin_lock(&acct->lock);
-		work = io_get_next_work(acct, worker);
-		raw_spin_unlock(&acct->lock);
+		work = io_get_next_work(acct, worker, needs_lock);
 		if (work) {
 			__io_worker_busy(wqe, worker);
 
@@ -701,12 +718,19 @@ static void io_worker_handle_work(struct io_worker *worker,
 
 static inline void io_worker_handle_private_work(struct io_worker *worker)
 {
-	io_worker_handle_work(worker, &worker->acct);
+	struct io_wqe_acct acct;
+
+	raw_spin_lock(&worker->acct.lock);
+	acct = worker->acct;
+	wq_list_clean(&worker->acct.work_list);
+	worker->acct.nr_works = 0;
+	raw_spin_unlock(&worker->acct.lock);
+	io_worker_handle_work(worker, &acct, false);
 }
 
 static inline void io_worker_handle_public_work(struct io_worker *worker)
 {
-	io_worker_handle_work(worker, io_wqe_get_acct(worker));
+	io_worker_handle_work(worker, io_wqe_get_acct(worker), true);
 }
 
 static int io_wqe_worker(void *data)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index ba6eee76d028..ef3ce577e6b7 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -40,6 +40,11 @@ struct io_wq_work_list {
 	(list)->first = NULL;					\
 } while (0)
 
+static inline void wq_list_clean(struct io_wq_work_list *list)
+{
+	list->first = list->last = NULL;
+}
+
 static inline void wq_list_add_after(struct io_wq_work_node *node,
 				     struct io_wq_work_node *pos,
 				     struct io_wq_work_list *list)
-- 
2.36.0

