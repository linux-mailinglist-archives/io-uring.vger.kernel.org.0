Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5FE508626
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 12:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244679AbiDTKnA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 06:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377760AbiDTKm6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 06:42:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2464C120A7
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id d23-20020a17090a115700b001d2bde6c234so3256907pje.1
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nhtujozxE2E+zSWUrf0rsiavclTCqtlhiZCEiaP3Em0=;
        b=EE6v+sBZejOoY/XE8uFvRrzoTcsIIMCz6TwcLL09byDdhqGbhHATeulY1hYrV+U5Mf
         xAa3xnBJMQ1K4AwU82ceLIa3W4QKRUywNP/vuh4aht6Asm+qzhYHMgKWA1F2Gei91dZQ
         J0+fut1l8rV8G6N7aWizPLHI5/0LKYBcxt8u7npqahALoqpZNAX8GvN8+VEx881raoOQ
         zBreb2ytk2XdkteRX9vS/WmFSJrR0+bwv0G5EXGHroLlc4D1CQ4w+ZP7tCMVlmD0BrEk
         pR/9cGpiN/mbX7friR5aAJbTFGDPAEQbL1+NqUyruSuGak2jb0BEcKwEclkfycZIVwcK
         NSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nhtujozxE2E+zSWUrf0rsiavclTCqtlhiZCEiaP3Em0=;
        b=Phzdt8RMZaSX+9czd3OeqNx/m2+ox0fAh2EzqqBxQVzX+tHMb0iO4WGs2YzHAqfwIv
         Uh7OHfYrn8A8b5jOQKywal/c1wVnDGHQkcr/9/SFBOylUjI178kkjlBpCVho//qxcmQl
         /rcZ3+B5PWDQ+JzGKRm3c0G4U/egnwrxeP6xDVJosZNclOrjYEjdF2EyHo+To10NptO7
         14IYhYhDA399UrUfc87OI470Ny6Evbe8SyQyym8sBDOo+Vlme0+Effq8doZJvE4YX2Is
         Ipy9Uykdl5OV0R0FHoGXKb7ouD+OVMU1umk168kk7V9pRqzWePY5kCzg3HDLa1W5E1s/
         +Sdw==
X-Gm-Message-State: AOAM530LBH7346Ej/J7ZtQljqBiweAytZgBKOAEeGvmH0ZyM3iTNdasR
        ED3s9JJ/CO/Rf1EFhcjxia90joatt0WocA==
X-Google-Smtp-Source: ABdhPJzGceabEBrThomCpJ5UkCnEXtPCEWufbKmm5mZwuAwqs+Qebu98Ap8SbT3Cbr0IKQzjYaXovw==
X-Received: by 2002:a17:90a:72ce:b0:1cb:6ec7:cd61 with SMTP id l14-20020a17090a72ce00b001cb6ec7cd61mr3653878pjk.213.1650451211528;
        Wed, 20 Apr 2022 03:40:11 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm19491670pge.23.2022.04.20.03.40.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 03:40:11 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 8/9] io-wq: batch the handling of fixed worker private works
Date:   Wed, 20 Apr 2022 18:39:59 +0800
Message-Id: <20220420104000.23214-9-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220420104000.23214-1-haoxu.linux@gmail.com>
References: <20220420104000.23214-1-haoxu.linux@gmail.com>
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
index 8fa5bfb298dc..807985249f62 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -539,8 +539,23 @@ static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
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
@@ -548,6 +563,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	unsigned int stall_hash = -1U;
 	struct io_wqe *wqe = worker->wqe;
 
+	conditional_acct_lock(acct, needs_lock);
 	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int hash;
 
@@ -556,6 +572,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&acct->work_list, node, prev);
+			conditional_acct_unlock(acct, needs_lock);
 			return work;
 		}
 
@@ -567,6 +584,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
 			wqe->hash_tail[hash] = NULL;
 			wq_list_cut(&acct->work_list, &tail->list, prev);
+			conditional_acct_unlock(acct, needs_lock);
 			return work;
 		}
 		if (stall_hash == -1U)
@@ -583,15 +601,16 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
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
@@ -625,7 +644,7 @@ static void io_assign_current_work(struct io_worker *worker,
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
 static void io_worker_handle_work(struct io_worker *worker,
-				  struct io_wqe_acct *acct)
+				  struct io_wqe_acct *acct, bool needs_lock)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
@@ -641,9 +660,7 @@ static void io_worker_handle_work(struct io_worker *worker,
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		raw_spin_lock(&acct->lock);
-		work = io_get_next_work(acct, worker);
-		raw_spin_unlock(&acct->lock);
+		work = io_get_next_work(acct, worker, needs_lock);
 		if (work) {
 			__io_worker_busy(wqe, worker);
 
@@ -700,12 +717,19 @@ static void io_worker_handle_work(struct io_worker *worker,
 
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
index dbecd27656c7..98befe7b0081 100644
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

