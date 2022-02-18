Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F4A4BC0E0
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238771AbiBRT6t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238872AbiBRT6p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:45 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AAD27152
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:13 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IILs8D019472
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=m7R3dJAKrUEsvG26XZ2mFpvf/1rBYnaS20bgcY9YfUw=;
 b=ZmDtLQllDscjg0knEmFQQwKMsFFw4JfgvDQyhVazn0X9DdAcXueYqK7E/mLLvycSWq4a
 O35As7lgpW+lY8ICwxk3KWJ8d4Jcsmd7lDixpigfSNT7hF4zo+fywgETmRJIpbfkG/L3
 mPlrxgRdVs1UVxsTZvP5OZvPhLKZ6kORNNA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea6knvaxw-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:12 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:08 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id CDF36AEB6615; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 12/13] io_uring: support write throttling for async buffered writes
Date:   Fri, 18 Feb 2022 11:57:38 -0800
Message-ID: <20220218195739.585044-13-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Ie9FvRFkSxnXAU83Ay9T4FFXBV1N55tw
X-Proofpoint-GUID: Ie9FvRFkSxnXAU83Ay9T4FFXBV1N55tw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_08,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180121
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the process-level throttling for the block layer for async
buffered writes to io-uring.In io_write the code now checks if the write
needs to be throttled. If this is required, it adds the request to the
list of pending io requests and starts a timer. After the timer expires,
it submits the list of pending writes.

- Add new list called pending_ios for delayed writes (throttled writes)
  to struct io_uring_task. The list is protected by the task_lock spin
  lock.
- Add new timer to struct io_uring_task.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 91 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 792ca4b6834d..8a48e5ee4e5e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -461,6 +461,11 @@ struct io_ring_ctx {
 	};
 };
=20
+struct pending_list {
+	struct list_head list;
+	struct io_kiocb *req;
+};
+
 struct io_uring_task {
 	/* submission side */
 	int			cached_refs;
@@ -477,6 +482,9 @@ struct io_uring_task {
 	struct io_wq_work_list	prior_task_list;
 	struct callback_head	task_work;
 	bool			task_running;
+
+	struct pending_list	pending_ios;
+	struct timer_list	timer;
 };
=20
 /*
@@ -1134,13 +1142,14 @@ static void io_rsrc_put_work(struct work_struct *=
work);
=20
 static void io_req_task_queue(struct io_kiocb *req);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
-static int io_req_prep_async(struct io_kiocb *req);
+static int io_req_prep_async(struct io_kiocb *req, bool force);
=20
 static int io_install_fixed_file(struct io_kiocb *req, struct file *file=
,
 				 unsigned int issue_flags, u32 slot_index);
 static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags=
);
=20
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
+static void delayed_write_fn(struct timer_list *tmr);
=20
 static struct kmem_cache *req_cachep;
=20
@@ -2462,6 +2471,31 @@ static void io_req_task_queue_reissue(struct io_ki=
ocb *req)
 	io_req_task_work_add(req, false);
 }
=20
+static int io_req_task_queue_reissue_delayed(struct io_kiocb *req)
+{
+	struct io_uring_task *tctx =3D req->task->io_uring;
+	struct pending_list *pending =3D kmalloc(sizeof(struct pending_list), G=
FP_KERNEL);
+	bool empty;
+
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
@@ -2770,7 +2804,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 	struct io_async_rw *rw =3D req->async_data;
=20
 	if (!req_has_async_data(req))
-		return !io_req_prep_async(req);
+		return !io_req_prep_async(req, false);
 	iov_iter_restore(&rw->s.iter, &rw->s.iter_state);
 	return true;
 }
@@ -3751,6 +3785,38 @@ static int io_write_prep(struct io_kiocb *req, con=
st struct io_uring_sqe *sqe)
 	return io_prep_rw(req, sqe);
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
@@ -3759,6 +3825,18 @@ static int io_write(struct io_kiocb *req, unsigned=
 int issue_flags)
 	bool force_nonblock =3D issue_flags & IO_URING_F_NONBLOCK;
 	ssize_t ret, ret2;
=20
+	/* Write throttling active? */
+	if (unlikely(write_delay()) && !(kiocb->ki_flags & IOCB_DIRECT)) {
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
@@ -6596,9 +6674,9 @@ static int io_req_prep(struct io_kiocb *req, const =
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
@@ -6608,6 +6686,10 @@ static int io_req_prep_async(struct io_kiocb *req)
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
@@ -6617,6 +6699,7 @@ static int io_req_prep_async(struct io_kiocb *req)
 	case IORING_OP_CONNECT:
 		return io_connect_prep_async(req);
 	}
+
 	printk_once(KERN_WARNING "io_uring: prep_async() bad opcode %d\n",
 		    req->opcode);
 	return -EFAULT;
@@ -6650,7 +6733,7 @@ static __cold void io_drain_req(struct io_kiocb *re=
q)
 	}
 	spin_unlock(&ctx->completion_lock);
=20
-	ret =3D io_req_prep_async(req);
+	ret =3D io_req_prep_async(req, false);
 	if (ret) {
 fail:
 		io_req_complete_failed(req, ret);
@@ -7145,7 +7228,7 @@ static void io_queue_sqe_fallback(struct io_kiocb *=
req)
 	} else if (unlikely(req->ctx->drain_active)) {
 		io_drain_req(req);
 	} else {
-		int ret =3D io_req_prep_async(req);
+		int ret =3D io_req_prep_async(req, false);
=20
 		if (unlikely(ret))
 			io_req_complete_failed(req, ret);
@@ -7344,7 +7427,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, s=
truct io_kiocb *req,
 		struct io_kiocb *head =3D link->head;
=20
 		if (!(req->flags & REQ_F_FAIL)) {
-			ret =3D io_req_prep_async(req);
+			ret =3D io_req_prep_async(req, false);
 			if (unlikely(ret)) {
 				req_fail_link_node(req, ret);
 				if (!(head->flags & REQ_F_FAIL))
@@ -8784,6 +8867,7 @@ static __cold int io_uring_alloc_task_context(struc=
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

