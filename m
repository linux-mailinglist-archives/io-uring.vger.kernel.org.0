Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EBB52FDA9
	for <lists+io-uring@lfdr.de>; Sat, 21 May 2022 17:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbiEUPP1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 May 2022 11:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiEUPP1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 May 2022 11:15:27 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9665156210
        for <io-uring@vger.kernel.org>; Sat, 21 May 2022 08:15:25 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t28so2466716pga.6
        for <io-uring@vger.kernel.org>; Sat, 21 May 2022 08:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=s0wlKp1fVp2rMZ9q9cHDbusyEzhgRJLlRKgP7xg7r/Q=;
        b=BkrVTODOErN/ChEuy6sH0rRpxYVCaHP3OEpt+m6MTBCNcM9rqWaSaFt4i0DQZw8Z2V
         9sX0hgfxsykWdzZdzwHTzIg5/mJmgw7loFQtgTicXXso/15h/TMqpNSoJbt8Yk9OZBGs
         nGGH2ufzbj3aEQIQZ41wVSnhg0G0Ji95gUnCJ9cryZbcvmJ5uaGhdvFRuHsPCQFUWGA6
         VRCrU8e1/ii+p7yFK0/0qedMOZWsWsRlDJBct3UvQg/QvdmMAO0S6epux/Gq+BISR5Oj
         RxlKVw5SqA4RetZRcJ88k/nD24NoNQxsvl2XBS+6Hg8JaJFumQs1HjKV2tEeGe5pZaeX
         lNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=s0wlKp1fVp2rMZ9q9cHDbusyEzhgRJLlRKgP7xg7r/Q=;
        b=vGtO5zfMw+xleDwkzQJ8ELY8tFqjl0HF/EGeEBNhqTWUkmyCNE6v7aw2l7IuRGqmeJ
         C69RaN+yVf3FXzHvy/nkm5FPQVfq+nXIF4R+zGcixpT8bIVR5vkP6OD2K/kqlsv31doi
         /leScA2g+E5cLwBHKeML/oULHpdN1pzfoj8luWxuyfVA66Xt9Y9yxIhwAiZ1Tu44ABW4
         fXI2S2kAp62JoK1Y6rGcOgrTjal97OVLEMXDrwbL4n/FMGdyZtAtT1mC920yUo0FgjZK
         vx+9GXpPshGKWY2jVZRxn6iZWae24KSOqtzXm4LNnyc/VmtEqB30+xc8pIBJXP/eNpJ6
         p66A==
X-Gm-Message-State: AOAM532hTx5a9up1WZh/o5+GZxOK3K77253ulQMe8J691G1iZivIdSH1
        EkbVFlP3F8SPyN779bFyg7WL8aeu223aWQ==
X-Google-Smtp-Source: ABdhPJzStvP/R7HzU8vckquwabusS5N+5dBKjRqQFhaYmyFfUA4EO25cvemEHNIaXqzSqP0M2FYbyQ==
X-Received: by 2002:a63:8bc8:0:b0:3f9:f41d:5bb9 with SMTP id j191-20020a638bc8000000b003f9f41d5bb9mr2399955pge.256.1653146124659;
        Sat, 21 May 2022 08:15:24 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d66-20020a621d45000000b005182fd977e4sm3807200pfd.108.2022.05.21.08.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 May 2022 08:15:23 -0700 (PDT)
Message-ID: <ee17c4dc-80b6-d980-eac2-bb81e936019b@kernel.dk>
Date:   Sat, 21 May 2022 09:15:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: cleanup handling of the two task_work lists
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than pass in a bool for whether or not this work item needs to go
into the priority list or not, provide separate helpers for it. For most
use cases, this also then gets rid of the branch for non-priority task
work.

While at it, rename the prior_task_list to prio_task_list. Prior is
a confusing name for it, as it would seem to indicate that this is the
previous task_work list. prio makes it clear that this is a priority
task_work list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 15faacd6d62c..fd47002e669d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -544,7 +544,7 @@ struct io_uring_task {
 
 	spinlock_t		task_lock;
 	struct io_wq_work_list	task_list;
-	struct io_wq_work_list	prior_task_list;
+	struct io_wq_work_list	prio_task_list;
 	struct callback_head	task_work;
 	struct file		**registered_rings;
 	bool			task_running;
@@ -2951,10 +2951,10 @@ static void tctx_task_work(struct callback_head *cb)
 		struct io_wq_work_node *node1, *node2;
 
 		spin_lock_irq(&tctx->task_lock);
-		node1 = tctx->prior_task_list.first;
+		node1 = tctx->prio_task_list.first;
 		node2 = tctx->task_list.first;
 		INIT_WQ_LIST(&tctx->task_list);
-		INIT_WQ_LIST(&tctx->prior_task_list);
+		INIT_WQ_LIST(&tctx->prio_task_list);
 		if (!node2 && !node1)
 			tctx->task_running = false;
 		spin_unlock_irq(&tctx->task_lock);
@@ -2968,7 +2968,7 @@ static void tctx_task_work(struct callback_head *cb)
 		cond_resched();
 
 		if (data_race(!tctx->task_list.first) &&
-		    data_race(!tctx->prior_task_list.first) && uring_locked)
+		    data_race(!tctx->prio_task_list.first) && uring_locked)
 			io_submit_flush_completions(ctx);
 	}
 
@@ -2979,24 +2979,19 @@ static void tctx_task_work(struct callback_head *cb)
 		io_uring_drop_tctx_refs(current);
 }
 
-static void io_req_task_work_add(struct io_kiocb *req, bool priority)
+static void __io_req_task_work_add(struct io_kiocb *req,
+				   struct io_uring_task *tctx,
+				   struct io_wq_work_list *list)
 {
-	struct task_struct *tsk = req->task;
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_uring_task *tctx = tsk->io_uring;
 	struct io_wq_work_node *node;
 	unsigned long flags;
 	bool running;
 
-	WARN_ON_ONCE(!tctx);
-
 	io_drop_inflight_file(req);
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
-	if (priority)
-		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
-	else
-		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+	wq_list_add_tail(&req->io_task_work.node, list);
 	running = tctx->task_running;
 	if (!running)
 		tctx->task_running = true;
@@ -3009,12 +3004,12 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 
-	if (likely(!task_work_add(tsk, &tctx->task_work, ctx->notify_method)))
+	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
 		return;
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	tctx->task_running = false;
-	node = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
+	node = wq_list_merge(&tctx->prio_task_list, &tctx->task_list);
 	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	while (node) {
@@ -3026,6 +3021,23 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	}
 }
 
+static void io_req_task_work_add(struct io_kiocb *req)
+{
+	struct io_uring_task *tctx = req->task->io_uring;
+
+	__io_req_task_work_add(req, tctx, &tctx->task_list);
+}
+
+static void io_req_task_prio_work_add(struct io_kiocb *req)
+{
+	struct io_uring_task *tctx = req->task->io_uring;
+
+	if (req->ctx->flags & IORING_SETUP_SQPOLL)
+		__io_req_task_work_add(req, tctx, &tctx->prio_task_list);
+	else
+		__io_req_task_work_add(req, tctx, &tctx->task_list);
+}
+
 static void io_req_tw_post(struct io_kiocb *req, bool *locked)
 {
 	io_req_complete_post(req, req->cqe.res, req->cqe.flags);
@@ -3036,7 +3048,7 @@ static void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags)
 	req->cqe.res = res;
 	req->cqe.flags = cflags;
 	req->io_task_work.func = io_req_tw_post;
-	io_req_task_work_add(req, false);
+	io_req_task_work_add(req);
 }
 
 static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
@@ -3060,19 +3072,19 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->cqe.res = ret;
 	req->io_task_work.func = io_req_task_cancel;
-	io_req_task_work_add(req, false);
+	io_req_task_work_add(req);
 }
 
 static void io_req_task_queue(struct io_kiocb *req)
 {
 	req->io_task_work.func = io_req_task_submit;
-	io_req_task_work_add(req, false);
+	io_req_task_work_add(req);
 }
 
 static void io_req_task_queue_reissue(struct io_kiocb *req)
 {
 	req->io_task_work.func = io_queue_iowq;
-	io_req_task_work_add(req, false);
+	io_req_task_work_add(req);
 }
 
 static void io_queue_next(struct io_kiocb *req)
@@ -3480,7 +3492,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 		return;
 	req->cqe.res = res;
 	req->io_task_work.func = io_req_task_complete;
-	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
+	io_req_task_prio_work_add(req);
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
@@ -5013,7 +5025,7 @@ void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 
 	req->uring_cmd.task_work_cb = task_work_cb;
 	req->io_task_work.func = io_uring_cmd_work;
-	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
+	io_req_task_prio_work_add(req);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
 
@@ -6999,7 +7011,7 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
 		req->io_task_work.func = io_apoll_task_func;
 
 	trace_io_uring_task_add(req->ctx, req, req->cqe.user_data, req->opcode, mask);
-	io_req_task_work_add(req, false);
+	io_req_task_work_add(req);
 }
 
 static inline void io_poll_execute(struct io_kiocb *req, int res,
@@ -7504,7 +7516,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 
 	req->cqe.res = -ETIME;
 	req->io_task_work.func = io_req_task_complete;
-	io_req_task_work_add(req, false);
+	io_req_task_work_add(req);
 	return HRTIMER_NORESTART;
 }
 
@@ -8627,7 +8639,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
 	req->io_task_work.func = io_req_task_link_timeout;
-	io_req_task_work_add(req, false);
+	io_req_task_work_add(req);
 	return HRTIMER_NORESTART;
 }
 
@@ -10340,7 +10352,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
-	INIT_WQ_LIST(&tctx->prior_task_list);
+	INIT_WQ_LIST(&tctx->prio_task_list);
 	init_task_work(&tctx->task_work, tctx_task_work);
 	return 0;
 }

-- 
Jens Axboe

