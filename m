Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD30E55221A
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 18:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240977AbiFTQT1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 12:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236809AbiFTQT0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 12:19:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36916559
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:25 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KFYQNU027232
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9CDkBmWADP2uAPuqCsYz0U9kZWynYEQ7Z/MI31M+C1U=;
 b=Y05WSgxAi1e+d8zktLQhsiaUcEn128zjUjNROabbWXsQiArjci4GxHYr1/LgIoDKJJif
 ypsox7zPO5Gxj/uW6VoaHX4KRZ/+P7aMNrlOWVRr1QIcx8SypVRrms9aoTQ/fGM/Lquq
 kLAQAMLMxaEVK/ovYyYM5ffOqLZFfGT7hsg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gtunfr9s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:25 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 09:19:24 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 7A3E31EB943A; Mon, 20 Jun 2022 09:19:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC for-next 1/8] io_uring: remove priority tw list optimisation
Date:   Mon, 20 Jun 2022 09:18:54 -0700
Message-ID: <20220620161901.1181971-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620161901.1181971-1-dylany@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 91KatCrxPhgsKeqv8S5VqGOvHG26vSz3
X-Proofpoint-ORIG-GUID: 91KatCrxPhgsKeqv8S5VqGOvHG26vSz3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This optimisation has some built in assumptions that make it easy to
introduce bugs. It also does not have clear wins that make it worth keepi=
ng.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 77 +++++++--------------------------------------
 io_uring/io_uring.h |  1 -
 io_uring/rw.c       |  2 +-
 io_uring/tctx.c     |  1 -
 io_uring/tctx.h     |  1 -
 5 files changed, 12 insertions(+), 70 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index afda42246d12..cc524d33748d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -986,44 +986,6 @@ static void ctx_flush_and_put(struct io_ring_ctx *ct=
x, bool *locked)
 	percpu_ref_put(&ctx->refs);
 }
=20
-static void handle_prev_tw_list(struct io_wq_work_node *node,
-				struct io_ring_ctx **ctx, bool *uring_locked)
-{
-	if (*ctx && !*uring_locked)
-		spin_lock(&(*ctx)->completion_lock);
-
-	do {
-		struct io_wq_work_node *next =3D node->next;
-		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
-						    io_task_work.node);
-
-		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
-
-		if (req->ctx !=3D *ctx) {
-			if (unlikely(!*uring_locked && *ctx))
-				io_cq_unlock_post(*ctx);
-
-			ctx_flush_and_put(*ctx, uring_locked);
-			*ctx =3D req->ctx;
-			/* if not contended, grab and improve batching */
-			*uring_locked =3D mutex_trylock(&(*ctx)->uring_lock);
-			percpu_ref_get(&(*ctx)->refs);
-			if (unlikely(!*uring_locked))
-				io_cq_lock(*ctx);
-		}
-		if (likely(*uring_locked)) {
-			req->io_task_work.func(req, uring_locked);
-		} else {
-			req->cqe.flags =3D io_put_kbuf_comp(req);
-			__io_req_complete_post(req);
-		}
-		node =3D next;
-	} while (node);
-
-	if (unlikely(!*uring_locked))
-		io_cq_unlock_post(*ctx);
-}
-
 static void handle_tw_list(struct io_wq_work_node *node,
 			   struct io_ring_ctx **ctx, bool *locked)
 {
@@ -1054,27 +1016,20 @@ void tctx_task_work(struct callback_head *cb)
 						  task_work);
=20
 	while (1) {
-		struct io_wq_work_node *node1, *node2;
+		struct io_wq_work_node *node;
=20
 		spin_lock_irq(&tctx->task_lock);
-		node1 =3D tctx->prio_task_list.first;
-		node2 =3D tctx->task_list.first;
+		node =3D tctx->task_list.first;
 		INIT_WQ_LIST(&tctx->task_list);
-		INIT_WQ_LIST(&tctx->prio_task_list);
-		if (!node2 && !node1)
+		if (!node)
 			tctx->task_running =3D false;
 		spin_unlock_irq(&tctx->task_lock);
-		if (!node2 && !node1)
+		if (!node)
 			break;
-
-		if (node1)
-			handle_prev_tw_list(node1, &ctx, &uring_locked);
-		if (node2)
-			handle_tw_list(node2, &ctx, &uring_locked);
+		handle_tw_list(node, &ctx, &uring_locked);
 		cond_resched();
=20
-		if (data_race(!tctx->task_list.first) &&
-		    data_race(!tctx->prio_task_list.first) && uring_locked)
+		if (data_race(!tctx->task_list.first) && uring_locked)
 			io_submit_flush_completions(ctx);
 	}
=20
@@ -1086,8 +1041,7 @@ void tctx_task_work(struct callback_head *cb)
 }
=20
 static void __io_req_task_work_add(struct io_kiocb *req,
-				   struct io_uring_task *tctx,
-				   struct io_wq_work_list *list)
+				   struct io_uring_task *tctx)
 {
 	struct io_ring_ctx *ctx =3D req->ctx;
 	struct io_wq_work_node *node;
@@ -1095,7 +1049,7 @@ static void __io_req_task_work_add(struct io_kiocb =
*req,
 	bool running;
=20
 	spin_lock_irqsave(&tctx->task_lock, flags);
-	wq_list_add_tail(&req->io_task_work.node, list);
+	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
 	running =3D tctx->task_running;
 	if (!running)
 		tctx->task_running =3D true;
@@ -1113,7 +1067,8 @@ static void __io_req_task_work_add(struct io_kiocb =
*req,
=20
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	tctx->task_running =3D false;
-	node =3D wq_list_merge(&tctx->prio_task_list, &tctx->task_list);
+	node =3D tctx->task_list.first;
+	INIT_WQ_LIST(&tctx->task_list);
 	spin_unlock_irqrestore(&tctx->task_lock, flags);
=20
 	while (node) {
@@ -1129,17 +1084,7 @@ void io_req_task_work_add(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx =3D req->task->io_uring;
=20
-	__io_req_task_work_add(req, tctx, &tctx->task_list);
-}
-
-void io_req_task_prio_work_add(struct io_kiocb *req)
-{
-	struct io_uring_task *tctx =3D req->task->io_uring;
-
-	if (req->ctx->flags & IORING_SETUP_SQPOLL)
-		__io_req_task_work_add(req, tctx, &tctx->prio_task_list);
-	else
-		__io_req_task_work_add(req, tctx, &tctx->task_list);
+	__io_req_task_work_add(req, tctx);
 }
=20
 static void io_req_tw_post(struct io_kiocb *req, bool *locked)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 7a00bbe85d35..864e552c76a5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -35,7 +35,6 @@ struct file *io_file_get_fixed(struct io_kiocb *req, in=
t fd,
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_work_add(struct io_kiocb *req);
-void io_req_task_prio_work_add(struct io_kiocb *req);
 void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
 void io_req_task_queue(struct io_kiocb *req);
 void io_queue_iowq(struct io_kiocb *req, bool *dont_use);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9166d8166b82..caf72f50c341 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -215,7 +215,7 @@ static void io_complete_rw(struct kiocb *kiocb, long =
res)
 		return;
 	io_req_set_res(req, res, 0);
 	req->io_task_work.func =3D io_req_task_complete;
-	io_req_task_prio_work_add(req);
+	io_req_task_work_add(req);
 }
=20
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 9b30fb0d3603..7a68ba9beec3 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -88,7 +88,6 @@ __cold int io_uring_alloc_task_context(struct task_stru=
ct *task,
 	task->io_uring =3D tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
-	INIT_WQ_LIST(&tctx->prio_task_list);
 	init_task_work(&tctx->task_work, tctx_task_work);
 	return 0;
 }
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index dead0ed00429..c8566ea5dca4 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -22,7 +22,6 @@ struct io_uring_task {
 		spinlock_t		task_lock;
 		bool			task_running;
 		struct io_wq_work_list	task_list;
-		struct io_wq_work_list	prio_task_list;
 		struct callback_head	task_work;
 	} ____cacheline_aligned_in_smp;
 };
--=20
2.30.2

