Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CC35105CD
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353636AbiDZRrm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353637AbiDZRr0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:26 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5389E183FB9
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:15 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQeTJ011897
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mbAvC92rI1EsvzhIR0QndNiDkUnX2q7rjdmc5cpJViU=;
 b=WficPSFXL/2vOV4EGOwHyF7vH6QwiLItKM8YEvJnAAbwNNqYxbxKsJdXZpAcbKIc3ZBA
 eFuA4WsesxW/psIzpxfOAvKJM3gtzmLk4Q3WkYqcNi7ESaSoB/jrfxWCZRHor2OpufjO
 Wk5zp0c1Jl3h1Lkm6/Zl6oldC5J4+O/K6cg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmeyu3nyk-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:14 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:44:12 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id DBAD6E2D4875; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 17/18] io_uring: support write throttling for async buffered writes
Date:   Tue, 26 Apr 2022 10:43:34 -0700
Message-ID: <20220426174335.4004987-18-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fp3TKBK3dQRSqlS9G7XMkWbkgSYpwAUR
X-Proofpoint-ORIG-GUID: fp3TKBK3dQRSqlS9G7XMkWbkgSYpwAUR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the process-level throttling for the block layer for async
buffered writes to io-uring. In io_write the code now checks if the write
needs to be throttled. If this is required, it adds the request to the
list of pending io requests and starts a timer. After the timer expires,
it submits the list of pending writes.

- Add new list called pending_ios for delayed writes (throttled writes)
  to struct io_uring_task. The list is protected by the task_lock spin
  lock.
- Add new timer to struct io_uring_task.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 92 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ace3a5cdda68..4af654a82366 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -485,6 +485,11 @@ struct io_ring_ctx {
  */
 #define IO_RINGFD_REG_MAX 16
=20
+struct pending_list {
+	struct list_head list;
+	struct io_kiocb *req;
+};
+
 struct io_uring_task {
 	/* submission side */
 	int			cached_refs;
@@ -501,6 +506,9 @@ struct io_uring_task {
 	struct callback_head	task_work;
 	struct file		**registered_rings;
 	bool			task_running;
+
+	struct pending_list	pending_ios;
+	struct timer_list	timer;
 };
=20
 /*
@@ -1193,7 +1201,7 @@ static void io_rsrc_put_work(struct work_struct *wo=
rk);
=20
 static void io_req_task_queue(struct io_kiocb *req);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
-static int io_req_prep_async(struct io_kiocb *req);
+static int io_req_prep_async(struct io_kiocb *req, bool force);
=20
 static int io_install_fixed_file(struct io_kiocb *req, struct file *file=
,
 				 unsigned int issue_flags, u32 slot_index);
@@ -1201,6 +1209,7 @@ static int io_close_fixed(struct io_kiocb *req, uns=
igned int issue_flags);
=20
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
 static void io_eventfd_signal(struct io_ring_ctx *ctx);
+static void delayed_write_fn(struct timer_list *tmr);
=20
 static struct kmem_cache *req_cachep;
=20
@@ -2599,6 +2608,32 @@ static void io_req_task_queue_reissue(struct io_ki=
ocb *req)
 	io_req_task_work_add(req, false);
 }
=20
+static int io_req_task_queue_reissue_delayed(struct io_kiocb *req)
+{
+	struct io_uring_task *tctx =3D req->task->io_uring;
+	struct pending_list *pending;
+	bool empty;
+
+	pending =3D kmalloc(sizeof(struct pending_list), GFP_KERNEL);
+	if (!pending)
+		return -ENOMEM;
+	pending->req =3D req;
+
+	spin_lock_irq(&tctx->task_lock);
+	empty =3D list_empty(&tctx->pending_ios.list);
+	list_add_tail(&pending->list, &tctx->pending_ios.list);
+
+	if (empty) {
+		timer_setup(&tctx->timer, delayed_write_fn, 0);
+
+		tctx->timer.expires =3D current->bdp_pause;
+		add_timer(&tctx->timer);
+	}
+	spin_unlock_irq(&tctx->task_lock);
+
+	return 0;
+}
+
 static inline void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt =3D io_req_find_next(req);
@@ -2916,7 +2951,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 	struct io_async_rw *rw =3D req->async_data;
=20
 	if (!req_has_async_data(req))
-		return !io_req_prep_async(req);
+		return !io_req_prep_async(req, false);
 	iov_iter_restore(&rw->s.iter, &rw->s.iter_state);
 	return true;
 }
@@ -3938,6 +3973,38 @@ static int io_read(struct io_kiocb *req, unsigned =
int issue_flags)
 	return 0;
 }
=20
+static inline unsigned long write_delay(void)
+{
+	if (likely(current->bdp_nr_dirtied_pause =3D=3D -1 ||
+			!time_before(jiffies, current->bdp_pause)))
+		return 0;
+
+	return current->bdp_pause;
+}
+
+static void delayed_write_fn(struct timer_list *tmr)
+{
+	struct io_uring_task *tctx =3D from_timer(tctx, tmr, timer);
+	struct list_head *curr;
+	struct list_head *next;
+	LIST_HEAD(pending_ios);
+
+	/* Move list to temporary list. */
+	spin_lock_irq(&tctx->task_lock);
+	list_splice_init(&tctx->pending_ios.list, &pending_ios);
+	spin_unlock_irq(&tctx->task_lock);
+
+	list_for_each_safe(curr, next, &pending_ios) {
+		struct pending_list *io;
+
+		io =3D list_entry(curr, struct pending_list, list);
+		io_req_task_queue_reissue(io->req);
+
+		list_del(curr);
+		kfree(io);
+	}
+}
+
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s =3D &__s;
@@ -3947,6 +4014,18 @@ static int io_write(struct io_kiocb *req, unsigned=
 int issue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
=20
+	/* Write throttling active? */
+	if (!(kiocb->ki_flags & IOCB_DIRECT) && unlikely(write_delay())) {
+		int ret =3D io_req_prep_async(req, true);
+
+		if (unlikely(ret))
+			io_req_complete_failed(req, ret);
+		else
+			ret =3D io_req_task_queue_reissue_delayed(req);
+
+		return ret;
+	}
+
 	if (!req_has_async_data(req)) {
 		ret =3D io_import_iovec(WRITE, req, &iovec, s, issue_flags);
 		if (unlikely(ret < 0))
@@ -6962,9 +7041,9 @@ static int io_req_prep(struct io_kiocb *req, const =
struct io_uring_sqe *sqe)
 	return -EINVAL;
 }
=20
-static int io_req_prep_async(struct io_kiocb *req)
+static int io_req_prep_async(struct io_kiocb *req, bool force)
 {
-	if (!io_op_defs[req->opcode].needs_async_setup)
+	if (!force && !io_op_defs[req->opcode].needs_async_setup)
 		return 0;
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
@@ -6974,6 +7053,10 @@ static int io_req_prep_async(struct io_kiocb *req)
 	switch (req->opcode) {
 	case IORING_OP_READV:
 		return io_rw_prep_async(req, READ);
+	case IORING_OP_WRITE:
+		if (!force)
+			break;
+		fallthrough;
 	case IORING_OP_WRITEV:
 		return io_rw_prep_async(req, WRITE);
 	case IORING_OP_SENDMSG:
@@ -6983,6 +7066,7 @@ static int io_req_prep_async(struct io_kiocb *req)
 	case IORING_OP_CONNECT:
 		return io_connect_prep_async(req);
 	}
+
 	printk_once(KERN_WARNING "io_uring: prep_async() bad opcode %d\n",
 		    req->opcode);
 	return -EFAULT;
@@ -7016,7 +7100,7 @@ static __cold void io_drain_req(struct io_kiocb *re=
q)
 	}
 	spin_unlock(&ctx->completion_lock);
=20
-	ret =3D io_req_prep_async(req);
+	ret =3D io_req_prep_async(req, false);
 	if (ret) {
 fail:
 		io_req_complete_failed(req, ret);
@@ -7550,7 +7634,7 @@ static void io_queue_sqe_fallback(struct io_kiocb *=
req)
 	} else if (unlikely(req->ctx->drain_active)) {
 		io_drain_req(req);
 	} else {
-		int ret =3D io_req_prep_async(req);
+		int ret =3D io_req_prep_async(req, false);
=20
 		if (unlikely(ret))
 			io_req_complete_failed(req, ret);
@@ -7746,7 +7830,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, s=
truct io_kiocb *req,
 		struct io_kiocb *head =3D link->head;
=20
 		if (!(req->flags & REQ_F_FAIL)) {
-			ret =3D io_req_prep_async(req);
+			ret =3D io_req_prep_async(req, false);
 			if (unlikely(ret)) {
 				req_fail_link_node(req, ret);
 				if (!(head->flags & REQ_F_FAIL))
@@ -9222,6 +9306,7 @@ static __cold int io_uring_alloc_task_context(struc=
t task_struct *task,
 	INIT_WQ_LIST(&tctx->task_list);
 	INIT_WQ_LIST(&tctx->prior_task_list);
 	init_task_work(&tctx->task_work, tctx_task_work);
+	INIT_LIST_HEAD(&tctx->pending_ios.list);
 	return 0;
 }
=20
--=20
2.30.2

