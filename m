Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8530554B82
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 15:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbiFVNky (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 09:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348395AbiFVNky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 09:40:54 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF94C30F4C
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:49 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LN9GQB022963
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zYGS/n8k3uvuGZObQMwbKXywpH8/6iQ9ZHJq1Rfri/0=;
 b=Z+YsaSkakNrFxKHH8vpststAvs/VGtSjQ5JzNAC7XeddN7nNa+z8uMOetQqt7qD44PaZ
 HDCIFCC9kIBhBI4/xG1guYGdEnLAC50ai9X3tEzryUlMtaJD1WODNdUmoakBmfb3seBk
 mhI1bzDHPSbQuxTd1hEJqEeyn/14lb9K8Vw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3guc93rkp5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:49 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 22 Jun 2022 06:40:48 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A41012013A9C; Wed, 22 Jun 2022 06:40:30 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 3/8] io_uring: lockless task list
Date:   Wed, 22 Jun 2022 06:40:23 -0700
Message-ID: <20220622134028.2013417-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622134028.2013417-1-dylany@fb.com>
References: <20220622134028.2013417-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _pelSGmXF_DG0yCGlNN94Ua9bt31PyLn
X-Proofpoint-ORIG-GUID: _pelSGmXF_DG0yCGlNN94Ua9bt31PyLn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-22_04,2022-06-22_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With networking use cases we see contention on the spinlock used to
protect the task_list when multiple threads try and add completions at on=
ce.
Instead we can use a lockless list, and assume that the first caller to
add to the list is responsible for kicking off task work.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 38 ++++++++--------------------------
 io_uring/tctx.c                |  3 +--
 io_uring/tctx.h                |  6 +++---
 4 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 5987f8acca38..918165a20053 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -428,7 +428,7 @@ typedef void (*io_req_tw_func_t)(struct io_kiocb *req=
, bool *locked);
=20
 struct io_task_work {
 	union {
-		struct io_wq_work_node	node;
+		struct llist_node	node;
 		struct llist_node	fallback_node;
 	};
 	io_req_tw_func_t		func;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e1523b62103b..985b46dfebb6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -986,11 +986,12 @@ static void ctx_flush_and_put(struct io_ring_ctx *c=
tx, bool *locked)
 	percpu_ref_put(&ctx->refs);
 }
=20
-static void handle_tw_list(struct io_wq_work_node *node,
+
+static void handle_tw_list(struct llist_node *node,
 			   struct io_ring_ctx **ctx, bool *locked)
 {
 	do {
-		struct io_wq_work_node *next =3D node->next;
+		struct llist_node *next =3D node->next;
 		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
 						    io_task_work.node);
=20
@@ -1014,23 +1015,11 @@ void tctx_task_work(struct callback_head *cb)
 	struct io_ring_ctx *ctx =3D NULL;
 	struct io_uring_task *tctx =3D container_of(cb, struct io_uring_task,
 						  task_work);
+	struct llist_node *node =3D llist_del_all(&tctx->task_list);
=20
-	while (1) {
-		struct io_wq_work_node *node;
-
-		spin_lock_irq(&tctx->task_lock);
-		node =3D tctx->task_list.first;
-		INIT_WQ_LIST(&tctx->task_list);
-		if (!node)
-			tctx->task_running =3D false;
-		spin_unlock_irq(&tctx->task_lock);
-		if (!node)
-			break;
+	if (node) {
 		handle_tw_list(node, &ctx, &uring_locked);
 		cond_resched();
-
-		if (data_race(!tctx->task_list.first) && uring_locked)
-			io_submit_flush_completions(ctx);
 	}
=20
 	ctx_flush_and_put(ctx, &uring_locked);
@@ -1044,16 +1033,10 @@ void io_req_task_work_add(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx =3D req->task->io_uring;
 	struct io_ring_ctx *ctx =3D req->ctx;
-	struct io_wq_work_node *node;
-	unsigned long flags;
+	struct llist_node *node;
 	bool running;
=20
-	spin_lock_irqsave(&tctx->task_lock, flags);
-	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
-	running =3D tctx->task_running;
-	if (!running)
-		tctx->task_running =3D true;
-	spin_unlock_irqrestore(&tctx->task_lock, flags);
+	running =3D !llist_add(&req->io_task_work.node, &tctx->task_list);
=20
 	/* task_work already pending, we're done */
 	if (running)
@@ -1065,11 +1048,8 @@ void io_req_task_work_add(struct io_kiocb *req)
 	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_meth=
od)))
 		return;
=20
-	spin_lock_irqsave(&tctx->task_lock, flags);
-	tctx->task_running =3D false;
-	node =3D tctx->task_list.first;
-	INIT_WQ_LIST(&tctx->task_list);
-	spin_unlock_irqrestore(&tctx->task_lock, flags);
+
+	node =3D llist_del_all(&tctx->task_list);
=20
 	while (node) {
 		req =3D container_of(node, struct io_kiocb, io_task_work.node);
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 7a68ba9beec3..7f97d97fef0a 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -86,8 +86,7 @@ __cold int io_uring_alloc_task_context(struct task_stru=
ct *task,
 	atomic_set(&tctx->in_idle, 0);
 	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring =3D tctx;
-	spin_lock_init(&tctx->task_lock);
-	INIT_WQ_LIST(&tctx->task_list);
+	init_llist_head(&tctx->task_list);
 	init_task_work(&tctx->task_work, tctx_task_work);
 	return 0;
 }
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index c8566ea5dca4..8a33ff6e5d91 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
=20
+#include <linux/llist.h>
+
 /*
  * Arbitrary limit, can be raised if need be
  */
@@ -19,9 +21,7 @@ struct io_uring_task {
 	struct percpu_counter		inflight;
=20
 	struct { /* task_work */
-		spinlock_t		task_lock;
-		bool			task_running;
-		struct io_wq_work_list	task_list;
+		struct llist_head	task_list;
 		struct callback_head	task_work;
 	} ____cacheline_aligned_in_smp;
 };
--=20
2.30.2

