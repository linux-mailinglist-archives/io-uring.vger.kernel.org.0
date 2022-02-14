Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C484B5958
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 19:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357327AbiBNSHe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 13:07:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357328AbiBNSHd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 13:07:33 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2C465171
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 10:07:24 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21EHPoRc019259
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 10:07:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=AimZSu1ByHcSlGDGVCxro9XCMzf2EZs3GuiN3k4vOFM=;
 b=Qg1JjsYH/Cfwq8I7wJd5U7gmzvauAt6HZGVcbsssG76yCyt14Md4hoiD+H3l+2gZiNTh
 mukjA/nLyXazVLN+is4mzNTH+SpB2LiP14qunz8CS9Ss6mygitInID9NPamrDZ6pKNdh
 I2uqa+oqGV2RRJ0Z4yi6K+cphvQsZVE4nDo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3e7ufp8eu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 10:07:23 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 10:07:22 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id CD7E5ABC052D; Mon, 14 Feb 2022 10:04:33 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 2/2] io-uring: Make tracepoints consistent.
Date:   Mon, 14 Feb 2022 10:04:30 -0800
Message-ID: <20220214180430.70572-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214180430.70572-1-shr@fb.com>
References: <20220214180430.70572-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tEoiC0rriOsa9xIiGdzJ63NtB3URf6By
X-Proofpoint-GUID: tEoiC0rriOsa9xIiGdzJ63NtB3URf6By
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=999
 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140107
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

This makes the io-uring tracepoints consistent. Where it makes sense
the tracepoints start with the following four fields:
- context (ring)
- request
- user_data
- opcode.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c                   |  24 +--
 include/trace/events/io_uring.h | 320 +++++++++++++++-----------------
 2 files changed, 167 insertions(+), 177 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b5f207fbe9a3..4117ae5476a2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1610,8 +1610,8 @@ static void io_queue_async_work(struct io_kiocb *re=
q, bool *dont_use)
 	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
 		req->work.flags |=3D IO_WQ_WORK_CANCEL;
=20
-	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
-					&req->work, req->flags);
+	trace_io_uring_queue_async_work(ctx, req, req->user_data, req->opcode, =
req->flags,
+					&req->work, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
 		io_queue_linked_timeout(link);
@@ -1922,7 +1922,7 @@ static inline bool __fill_cqe(struct io_ring_ctx *c=
tx, u64 user_data,
=20
 static inline bool __io_fill_cqe(struct io_kiocb *req, s32 res, u32 cfla=
gs)
 {
-	trace_io_uring_complete(req->ctx, req->user_data, res, cflags);
+	trace_io_uring_complete(req->ctx, req, req->user_data, res, cflags);
 	return __fill_cqe(req->ctx, req->user_data, res, cflags);
 }
=20
@@ -1936,7 +1936,7 @@ static noinline bool io_fill_cqe_aux(struct io_ring=
_ctx *ctx, u64 user_data,
 				     s32 res, u32 cflags)
 {
 	ctx->cq_extra++;
-	trace_io_uring_complete(ctx, user_data, res, cflags);
+	trace_io_uring_complete(ctx, NULL, user_data, res, cflags);
 	return __fill_cqe(ctx, user_data, res, cflags);
 }
=20
@@ -2188,7 +2188,9 @@ static void io_fail_links(struct io_kiocb *req)
 		nxt =3D link->link;
 		link->link =3D NULL;
=20
-		trace_io_uring_fail_link(req, link);
+		trace_io_uring_fail_link(req->ctx, req, req->user_data,
+					req->opcode, link);
+
 		if (!ignore_cqes) {
 			link->flags &=3D ~REQ_F_CQE_SKIP;
 			io_fill_cqe_req(link, res, 0);
@@ -5614,7 +5616,7 @@ static void __io_poll_execute(struct io_kiocb *req,=
 int mask)
 	else
 		req->io_task_work.func =3D io_apoll_task_func;
=20
-	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
+	trace_io_uring_task_add(req->ctx, req, req->user_data, req->opcode, mas=
k);
 	io_req_task_work_add(req, false);
 }
=20
@@ -5843,7 +5845,7 @@ static int io_arm_poll_handler(struct io_kiocb *req=
)
 	if (ret || ipt.error)
 		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
=20
-	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
+	trace_io_uring_poll_arm(ctx, req, req->user_data, req->opcode,
 				mask, apoll->poll.events);
 	return IO_APOLL_OK;
 }
@@ -6652,7 +6654,7 @@ static __cold void io_drain_req(struct io_kiocb *re=
q)
 		goto queue;
 	}
=20
-	trace_io_uring_defer(ctx, req, req->user_data);
+	trace_io_uring_defer(ctx, req, req->user_data, req->opcode);
 	de->req =3D req;
 	de->seq =3D seq;
 	list_add_tail(&de->list, &ctx->defer_list);
@@ -6986,7 +6988,7 @@ static struct file *io_file_get_normal(struct io_ri=
ng_ctx *ctx,
 {
 	struct file *file =3D fget(fd);
=20
-	trace_io_uring_file_get(ctx, fd);
+	trace_io_uring_file_get(ctx, req, req->user_data, fd);
=20
 	/* we don't allow fixed io_uring files */
 	if (file && unlikely(file->f_op =3D=3D &io_uring_fops))
@@ -7284,7 +7286,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, s=
truct io_kiocb *req,
=20
 	ret =3D io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
-		trace_io_uring_req_failed(sqe, ret);
+		trace_io_uring_req_failed(sqe, ctx, req, ret);
=20
 		/* fail even hard links since we don't submit */
 		if (link->head) {
@@ -7311,7 +7313,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, s=
truct io_kiocb *req,
 	}
=20
 	/* don't need @sqe from now on */
-	trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
+	trace_io_uring_submit_sqe(ctx, req, req->user_data, req->opcode,
 				  req->flags, true,
 				  ctx->flags & IORING_SETUP_SQPOLL);
=20
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 7346f0164cf4..079a861bfeeb 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -29,15 +29,15 @@ TRACE_EVENT(io_uring_create,
 	TP_ARGS(fd, ctx, sq_entries, cq_entries, flags),
=20
 	TP_STRUCT__entry (
-		__field(  int,		fd			)
-		__field(  void *,	ctx			)
+		__field(  int,		fd		)
+		__field(  void *,	ctx		)
 		__field(  u32,		sq_entries	)
 		__field(  u32,		cq_entries	)
 		__field(  u32,		flags		)
 	),
=20
 	TP_fast_assign(
-		__entry->fd			=3D fd;
+		__entry->fd		=3D fd;
 		__entry->ctx		=3D ctx;
 		__entry->sq_entries	=3D sq_entries;
 		__entry->cq_entries	=3D cq_entries;
@@ -73,12 +73,12 @@ TRACE_EVENT(io_uring_register,
 	TP_ARGS(ctx, opcode, nr_files, nr_bufs, eventfd, ret),
=20
 	TP_STRUCT__entry (
-		__field(  void *,	ctx			)
-		__field(  unsigned,	opcode		)
-		__field(  unsigned,	nr_files	)
-		__field(  unsigned,	nr_bufs		)
-		__field(  bool,		eventfd		)
-		__field(  long,		ret			)
+		__field(  void *,	ctx	)
+		__field(  unsigned,	opcode	)
+		__field(  unsigned,	nr_files)
+		__field(  unsigned,	nr_bufs	)
+		__field(  bool,		eventfd	)
+		__field(  long,		ret	)
 	),
=20
 	TP_fast_assign(
@@ -100,6 +100,8 @@ TRACE_EVENT(io_uring_register,
  * io_uring_file_get - called before getting references to an SQE file
  *
  * @ctx:	pointer to a ring context structure
+ * @req:	pointer to a submitted request
+ * @user_data:	user data associated with the request
  * @fd:		SQE file descriptor
  *
  * Allows to trace out how often an SQE file reference is obtained, whic=
h can
@@ -108,59 +110,71 @@ TRACE_EVENT(io_uring_register,
  */
 TRACE_EVENT(io_uring_file_get,
=20
-	TP_PROTO(void *ctx, int fd),
+	TP_PROTO(void *ctx, void *req, unsigned long long user_data, int fd),
=20
-	TP_ARGS(ctx, fd),
+	TP_ARGS(ctx, req, user_data, fd),
=20
 	TP_STRUCT__entry (
-		__field(  void *,	ctx	)
-		__field(  int,		fd	)
+		__field(  void *,	ctx		)
+		__field(  void *,	req		)
+		__field(  u64,		user_data	)
+		__field(  int,		fd		)
 	),
=20
 	TP_fast_assign(
-		__entry->ctx	=3D ctx;
+		__entry->ctx		=3D ctx;
+		__entry->req		=3D req;
+		__entry->user_data	=3D user_data;
 		__entry->fd		=3D fd;
 	),
=20
-	TP_printk("ring %p, fd %d", __entry->ctx, __entry->fd)
+	TP_printk("ring %p, req %p, user_data %llu, fd %d",
+		__entry->ctx, __entry->req, __entry->user_data, __entry->fd)
 );
=20
 /**
  * io_uring_queue_async_work - called before submitting a new async work
  *
  * @ctx:	pointer to a ring context structure
- * @hashed:	type of workqueue, hashed or normal
  * @req:	pointer to a submitted request
+ * @user_data:	user data associated with the request
+ * @opcode:	opcode of request
+ * @flags	request flags
  * @work:	pointer to a submitted io_wq_work
+ * @rw:		type of workqueue, hashed or normal
  *
  * Allows to trace asynchronous work submission.
  */
 TRACE_EVENT(io_uring_queue_async_work,
=20
-	TP_PROTO(void *ctx, int rw, void * req, struct io_wq_work *work,
-			 unsigned int flags),
+	TP_PROTO(void *ctx, void * req, unsigned long long user_data, u8 opcode=
,
+		unsigned int flags, struct io_wq_work *work, int rw),
=20
-	TP_ARGS(ctx, rw, req, work, flags),
+	TP_ARGS(ctx, req, user_data, flags, opcode, work, rw),
=20
 	TP_STRUCT__entry (
-		__field(  void *,			ctx	)
-		__field(  int,				rw	)
-		__field(  void *,			req	)
-		__field(  struct io_wq_work *,		work	)
-		__field(  unsigned int,			flags	)
+		__field(  void *,			ctx		)
+		__field(  void *,			req		)
+		__field(  u64,				user_data	)
+		__field(  u8,				opcode		)
+		__field(  unsigned int,			flags		)
+		__field(  struct io_wq_work *,		work		)
+		__field(  int,				rw		)
 	),
=20
 	TP_fast_assign(
-		__entry->ctx	=3D ctx;
-		__entry->rw	=3D rw;
-		__entry->req	=3D req;
-		__entry->work	=3D work;
-		__entry->flags	=3D flags;
+		__entry->ctx		=3D ctx;
+		__entry->req		=3D req;
+		__entry->user_data	=3D user_data;
+		__entry->flags		=3D flags;
+		__entry->opcode		=3D opcode;
+		__entry->work		=3D work;
+		__entry->rw		=3D rw;
 	),
=20
-	TP_printk("ring %p, request %p, flags %d, %s queue, work %p",
-			  __entry->ctx, __entry->req, __entry->flags,
-			  __entry->rw ? "hashed" : "normal", __entry->work)
+	TP_printk("ring %p, request %p, user_data %llu, opcode %d, flags %d, %s=
 queue, work %p",
+		__entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
+		__entry->flags, __entry->rw ? "hashed" : "normal", __entry->work)
 );
=20
 /**
@@ -169,30 +183,33 @@ TRACE_EVENT(io_uring_queue_async_work,
  * @ctx:	pointer to a ring context structure
  * @req:	pointer to a deferred request
  * @user_data:	user data associated with the request
+ * @opcode:	opcode of request
  *
  * Allows to track deferred requests, to get an insight about what reque=
sts are
  * not started immediately.
  */
 TRACE_EVENT(io_uring_defer,
=20
-	TP_PROTO(void *ctx, void *req, unsigned long long user_data),
+	TP_PROTO(void *ctx, void *req, unsigned long long user_data, u8 opcode)=
,
=20
-	TP_ARGS(ctx, req, user_data),
+	TP_ARGS(ctx, req, user_data, opcode),
=20
 	TP_STRUCT__entry (
-		__field(  void *,	ctx		)
-		__field(  void *,	req		)
-		__field(  unsigned long long, data	)
+		__field(  void *,		ctx	)
+		__field(  void *,		req	)
+		__field(  unsigned long long,	data	)
+		__field(  u8,			opcode	)
 	),
=20
 	TP_fast_assign(
 		__entry->ctx	=3D ctx;
 		__entry->req	=3D req;
 		__entry->data	=3D user_data;
+		__entry->opcode	=3D opcode;
 	),
=20
-	TP_printk("ring %p, request %p user_data %llu", __entry->ctx,
-			__entry->req, __entry->data)
+	TP_printk("ring %p, request %p, user_data %llu, opcode %d",
+		__entry->ctx, __entry->req, __entry->data, __entry->opcode)
 );
=20
 /**
@@ -250,7 +267,7 @@ TRACE_EVENT(io_uring_cqring_wait,
 	),
=20
 	TP_fast_assign(
-		__entry->ctx	=3D ctx;
+		__entry->ctx		=3D ctx;
 		__entry->min_events	=3D min_events;
 	),
=20
@@ -260,7 +277,10 @@ TRACE_EVENT(io_uring_cqring_wait,
 /**
  * io_uring_fail_link - called before failing a linked request
  *
+ * @ctx:	pointer to a ring context structure
  * @req:	request, which links were cancelled
+ * @user_data:	user data associated with the request
+ * @opcode:	opcode of request
  * @link:	cancelled link
  *
  * Allows to track linked requests cancellation, to see not only that so=
me work
@@ -268,27 +288,36 @@ TRACE_EVENT(io_uring_cqring_wait,
  */
 TRACE_EVENT(io_uring_fail_link,
=20
-	TP_PROTO(void *req, void *link),
+	TP_PROTO(void *ctx, void *req, unsigned long long user_data, u8 opcode,=
 void *link),
=20
-	TP_ARGS(req, link),
+	TP_ARGS(ctx, req, user_data, opcode, link),
=20
 	TP_STRUCT__entry (
-		__field(  void *,	req	)
-		__field(  void *,	link	)
+		__field(  void *,		ctx		)
+		__field(  void *,		req		)
+		__field(  unsigned long long,	user_data	)
+		__field(  u8,			opcode		)
+		__field(  void *,		link		)
 	),
=20
 	TP_fast_assign(
-		__entry->req	=3D req;
-		__entry->link	=3D link;
+		__entry->ctx		=3D ctx;
+		__entry->req		=3D req;
+		__entry->user_data	=3D user_data;
+		__entry->opcode		=3D opcode;
+		__entry->link		=3D link;
 	),
=20
-	TP_printk("request %p, link %p", __entry->req, __entry->link)
+	TP_printk("ring %p, request %p, user_data %llu, opcode %d, link %p",
+		__entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
+		__entry->link)
 );
=20
 /**
  * io_uring_complete - called when completing an SQE
  *
  * @ctx:		pointer to a ring context structure
+ * @req:		pointer to a submitted request
  * @user_data:		user data associated with the request
  * @res:		result of the request
  * @cflags:		completion flags
@@ -296,12 +325,13 @@ TRACE_EVENT(io_uring_fail_link,
  */
 TRACE_EVENT(io_uring_complete,
=20
-	TP_PROTO(void *ctx, u64 user_data, int res, unsigned cflags),
+	TP_PROTO(void *ctx, void *req, u64 user_data, int res, unsigned cflags)=
,
=20
-	TP_ARGS(ctx, user_data, res, cflags),
+	TP_ARGS(ctx, req, user_data, res, cflags),
=20
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
+		__field(  void *,	req		)
 		__field(  u64,		user_data	)
 		__field(  int,		res		)
 		__field(  unsigned,	cflags		)
@@ -309,14 +339,16 @@ TRACE_EVENT(io_uring_complete,
=20
 	TP_fast_assign(
 		__entry->ctx		=3D ctx;
+		__entry->req		=3D req;
 		__entry->user_data	=3D user_data;
 		__entry->res		=3D res;
 		__entry->cflags		=3D cflags;
 	),
=20
-	TP_printk("ring %p, user_data 0x%llx, result %d, cflags %x",
-			  __entry->ctx, (unsigned long long)__entry->user_data,
-			  __entry->res, __entry->cflags)
+	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags %x",
+		__entry->ctx, __entry->req,
+		(unsigned long long)__entry->user_data,
+		__entry->res, __entry->cflags)
 );
=20
 /**
@@ -324,8 +356,8 @@ TRACE_EVENT(io_uring_complete,
  *
  * @ctx:		pointer to a ring context structure
  * @req:		pointer to a submitted request
- * @opcode:		opcode of request
  * @user_data:		user data associated with the request
+ * @opcode:		opcode of request
  * @flags		request flags
  * @force_nonblock:	whether a context blocking or not
  * @sq_thread:		true if sq_thread has submitted this SQE
@@ -335,34 +367,34 @@ TRACE_EVENT(io_uring_complete,
  */
 TRACE_EVENT(io_uring_submit_sqe,
=20
-	TP_PROTO(void *ctx, void *req, u8 opcode, u64 user_data, u32 flags,
+	TP_PROTO(void *ctx, void *req, unsigned long long user_data, u8 opcode,=
 u32 flags,
 		 bool force_nonblock, bool sq_thread),
=20
-	TP_ARGS(ctx, req, opcode, user_data, flags, force_nonblock, sq_thread),
+	TP_ARGS(ctx, req, user_data, opcode, flags, force_nonblock, sq_thread),
=20
 	TP_STRUCT__entry (
-		__field(  void *,	ctx		)
-		__field(  void *,	req		)
-		__field(  u8,		opcode		)
-		__field(  u64,		user_data	)
-		__field(  u32,		flags		)
-		__field(  bool,		force_nonblock	)
-		__field(  bool,		sq_thread	)
+		__field(  void *,		ctx		)
+		__field(  void *,		req		)
+		__field(  unsigned long long,	user_data	)
+		__field(  u8,			opcode		)
+		__field(  u32,			flags		)
+		__field(  bool,			force_nonblock	)
+		__field(  bool,			sq_thread	)
 	),
=20
 	TP_fast_assign(
 		__entry->ctx		=3D ctx;
 		__entry->req		=3D req;
-		__entry->opcode		=3D opcode;
 		__entry->user_data	=3D user_data;
+		__entry->opcode		=3D opcode;
 		__entry->flags		=3D flags;
 		__entry->force_nonblock	=3D force_nonblock;
 		__entry->sq_thread	=3D sq_thread;
 	),
=20
-	TP_printk("ring %p, req %p, op %d, data 0x%llx, flags %u, "
+	TP_printk("ring %p, req %p, user_data %llu, opcode %d, flags %u, "
 		  "non block %d, sq_thread %d", __entry->ctx, __entry->req,
-		  __entry->opcode, (unsigned long long)__entry->user_data,
+		  __entry->user_data, __entry->opcode,
 		  __entry->flags, __entry->force_nonblock, __entry->sq_thread)
 );
=20
@@ -371,8 +403,8 @@ TRACE_EVENT(io_uring_submit_sqe,
  *
  * @ctx:		pointer to a ring context structure
  * @req:		pointer to the armed request
- * @opcode:		opcode of request
  * @user_data:		user data associated with the request
+ * @opcode:		opcode of request
  * @mask:		request poll events mask
  * @events:		registered events of interest
  *
@@ -381,155 +413,110 @@ TRACE_EVENT(io_uring_submit_sqe,
  */
 TRACE_EVENT(io_uring_poll_arm,
=20
-	TP_PROTO(void *ctx, void *req, u8 opcode, u64 user_data,
+	TP_PROTO(void *ctx, void *req, u64 user_data, u8 opcode,
 		 int mask, int events),
=20
-	TP_ARGS(ctx, req, opcode, user_data, mask, events),
+	TP_ARGS(ctx, req, user_data, opcode, mask, events),
=20
 	TP_STRUCT__entry (
-		__field(  void *,	ctx		)
-		__field(  void *,	req		)
-		__field(  u8,		opcode		)
-		__field(  u64,		user_data	)
-		__field(  int,		mask		)
-		__field(  int,		events		)
+		__field(  void *,		ctx		)
+		__field(  void *,		req		)
+		__field(  unsigned long long,	user_data	)
+		__field(  u8,			opcode		)
+		__field(  int,			mask		)
+		__field(  int,			events		)
 	),
=20
 	TP_fast_assign(
 		__entry->ctx		=3D ctx;
 		__entry->req		=3D req;
-		__entry->opcode		=3D opcode;
 		__entry->user_data	=3D user_data;
+		__entry->opcode		=3D opcode;
 		__entry->mask		=3D mask;
 		__entry->events		=3D events;
 	),
=20
-	TP_printk("ring %p, req %p, op %d, data 0x%llx, mask 0x%x, events 0x%x"=
,
-		  __entry->ctx, __entry->req, __entry->opcode,
-		  (unsigned long long) __entry->user_data,
+	TP_printk("ring %p, req %p, user_data %llu, opcode %d, mask 0x%x, event=
s 0x%x",
+		  __entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
 		  __entry->mask, __entry->events)
 );
=20
-TRACE_EVENT(io_uring_poll_wake,
-
-	TP_PROTO(void *ctx, u8 opcode, u64 user_data, int mask),
-
-	TP_ARGS(ctx, opcode, user_data, mask),
-
-	TP_STRUCT__entry (
-		__field(  void *,	ctx		)
-		__field(  u8,		opcode		)
-		__field(  u64,		user_data	)
-		__field(  int,		mask		)
-	),
-
-	TP_fast_assign(
-		__entry->ctx		=3D ctx;
-		__entry->opcode		=3D opcode;
-		__entry->user_data	=3D user_data;
-		__entry->mask		=3D mask;
-	),
-
-	TP_printk("ring %p, op %d, data 0x%llx, mask 0x%x",
-			  __entry->ctx, __entry->opcode,
-			  (unsigned long long) __entry->user_data,
-			  __entry->mask)
-);
-
-TRACE_EVENT(io_uring_task_add,
-
-	TP_PROTO(void *ctx, u8 opcode, u64 user_data, int mask),
-
-	TP_ARGS(ctx, opcode, user_data, mask),
-
-	TP_STRUCT__entry (
-		__field(  void *,	ctx		)
-		__field(  u8,		opcode		)
-		__field(  u64,		user_data	)
-		__field(  int,		mask		)
-	),
-
-	TP_fast_assign(
-		__entry->ctx		=3D ctx;
-		__entry->opcode		=3D opcode;
-		__entry->user_data	=3D user_data;
-		__entry->mask		=3D mask;
-	),
-
-	TP_printk("ring %p, op %d, data 0x%llx, mask %x",
-			  __entry->ctx, __entry->opcode,
-			  (unsigned long long) __entry->user_data,
-			  __entry->mask)
-);
-
 /*
- * io_uring_task_run - called when task_work_run() executes the poll eve=
nts
- *                     notification callbacks
+ * io_uring_task_add - called after adding a task
  *
  * @ctx:		pointer to a ring context structure
- * @req:		pointer to the armed request
- * @opcode:		opcode of request
+ * @req:		pointer to request
  * @user_data:		user data associated with the request
+ * @opcode:		opcode of request
+ * @mask:		request poll events mask
  *
- * Allows to track when notified poll events are processed
  */
-TRACE_EVENT(io_uring_task_run,
+TRACE_EVENT(io_uring_task_add,
=20
-	TP_PROTO(void *ctx, void *req, u8 opcode, u64 user_data),
+	TP_PROTO(void *ctx, void *req, unsigned long long user_data, u8 opcode,=
 int mask),
=20
-	TP_ARGS(ctx, req, opcode, user_data),
+	TP_ARGS(ctx, req, user_data, opcode, mask),
=20
 	TP_STRUCT__entry (
-		__field(  void *,	ctx		)
-		__field(  void *,	req		)
-		__field(  u8,		opcode		)
-		__field(  u64,		user_data	)
+		__field(  void *,		ctx		)
+		__field(  void *,		req		)
+		__field(  unsigned long long,	user_data	)
+		__field(  u8,			opcode		)
+		__field(  int,			mask		)
 	),
=20
 	TP_fast_assign(
 		__entry->ctx		=3D ctx;
 		__entry->req		=3D req;
-		__entry->opcode		=3D opcode;
 		__entry->user_data	=3D user_data;
+		__entry->opcode		=3D opcode;
+		__entry->mask		=3D mask;
 	),
=20
-	TP_printk("ring %p, req %p, op %d, data 0x%llx",
-		  __entry->ctx, __entry->req, __entry->opcode,
-		  (unsigned long long) __entry->user_data)
+	TP_printk("ring %p, req %p, user_data %llu, opcode %d, mask %x",
+		__entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
+		__entry->mask)
 );
=20
 /*
  * io_uring_req_failed - called when an sqe is errored dring submission
  *
  * @sqe:		pointer to the io_uring_sqe that failed
+ * @ctx:		pointer to a ring context structure
+ * @req:		pointer to request
  * @error:		error it failed with
  *
  * Allows easier diagnosing of malformed requests in production systems.
  */
 TRACE_EVENT(io_uring_req_failed,
=20
-	TP_PROTO(const struct io_uring_sqe *sqe, int error),
+	TP_PROTO(const struct io_uring_sqe *sqe, void *ctx, void *req, int erro=
r),
=20
-	TP_ARGS(sqe, error),
+	TP_ARGS(sqe, ctx, req, error),
=20
 	TP_STRUCT__entry (
-		__field(  u8,	opcode )
-		__field(  u8,	flags )
-		__field(  u8,	ioprio )
-		__field( u64,	off )
-		__field( u64,	addr )
-		__field( u32,	len )
-		__field( u32,	op_flags )
-		__field( u64,	user_data )
-		__field( u16,	buf_index )
-		__field( u16,	personality )
-		__field( u32,	file_index )
-		__field( u64,	pad1 )
-		__field( u64,	pad2 )
-		__field( int,	error )
+		__field(  void *,		ctx		)
+		__field(  void *,		req		)
+		__field(  unsigned long long,	user_data	)
+		__field(  u8,			opcode		)
+		__field(  u8,			flags		)
+		__field(  u8,			ioprio		)
+		__field( u64,			off		)
+		__field( u64,			addr		)
+		__field( u32,			len		)
+		__field( u32,			op_flags	)
+		__field( u16,			buf_index	)
+		__field( u16,			personality	)
+		__field( u32,			file_index	)
+		__field( u64,			pad1		)
+		__field( u64,			pad2		)
+		__field( int,			error		)
 	),
=20
 	TP_fast_assign(
+		__entry->ctx		=3D ctx;
+		__entry->req		=3D req;
+		__entry->user_data	=3D sqe->user_data;
 		__entry->opcode		=3D sqe->opcode;
 		__entry->flags		=3D sqe->flags;
 		__entry->ioprio		=3D sqe->ioprio;
@@ -537,7 +524,6 @@ TRACE_EVENT(io_uring_req_failed,
 		__entry->addr		=3D sqe->addr;
 		__entry->len		=3D sqe->len;
 		__entry->op_flags	=3D sqe->rw_flags;
-		__entry->user_data	=3D sqe->user_data;
 		__entry->buf_index	=3D sqe->buf_index;
 		__entry->personality	=3D sqe->personality;
 		__entry->file_index	=3D sqe->file_index;
@@ -546,13 +532,15 @@ TRACE_EVENT(io_uring_req_failed,
 		__entry->error		=3D error;
 	),
=20
-	TP_printk("op %d, flags=3D0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
-		  "len=3D%u, rw_flags=3D0x%x, user_data=3D0x%llx, buf_index=3D%d, "
+	TP_printk("ring %p, req %p, user_data %llu, "
+		"op %d, flags=3D0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
+		  "len=3D%u, rw_flags=3D0x%x, buf_index=3D%d, "
 		  "personality=3D%d, file_index=3D%d, pad=3D0x%llx/%llx, error=3D%d",
+		  __entry->ctx, __entry->req, __entry->user_data,
 		  __entry->opcode, __entry->flags, __entry->ioprio,
 		  (unsigned long long)__entry->off,
 		  (unsigned long long) __entry->addr, __entry->len,
-		  __entry->op_flags, (unsigned long long) __entry->user_data,
+		  __entry->op_flags,
 		  __entry->buf_index, __entry->personality, __entry->file_index,
 		  (unsigned long long) __entry->pad1,
 		  (unsigned long long) __entry->pad2, __entry->error)
--=20
2.30.2

