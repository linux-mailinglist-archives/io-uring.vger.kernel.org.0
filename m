Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7E5635B16
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbiKWLHf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbiKWLHF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:07:05 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEFD5E9C3
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:45 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB4Hcw001800
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=brQDbixN8YISRVn8bXZa4Sh7F8LuNzI2WbiGkYXarKo=;
 b=l3LWc6LpxCjvgD+dRKGdOXBk1ZZukVH4uE51XtZH6Ypm+OM6q3eu+C4XpIp1srZj58+7
 klUk2Ad6JtKpgJ2nVSCz/a9u8ilg940c8gutYtr72rscOEyNW5i8CvY+e6sZ6joYqbaF
 ddDlQMoODFNNhNB/Hn1JelumiJm08jYLZ9r0hfLTpySksjVS1+bocbyjKZm+HNruISmw
 LpeIcSkXHK6+dTJVupwuSPmLH5VTf2QPmnANkrlN5QGteMilQwO7VL40AtPxDjJMzs6u
 xom5olhueG9TrxB2JVr2l86XQ8YedBMFSJbVbihVM6BXZ3Ei1p/T1aK8c1nheoug91kv 9w== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m0javkw8w-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:45 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:42 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C7F89A0804BD; Wed, 23 Nov 2022 03:06:26 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 03/13] io_uring: split io_req_complete_failed into post/defer
Date:   Wed, 23 Nov 2022 03:06:04 -0800
Message-ID: <20221123110614.3297343-4-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: cufm7jwLAk6w4zDgp0s54PxgJkc-91SE
X-Proofpoint-GUID: cufm7jwLAk6w4zDgp0s54PxgJkc-91SE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Different use cases might want to defer failure completion if available,
or post the completion immediately if the lock is not definitely taken.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 28 ++++++++++++++++++++--------
 io_uring/io_uring.h |  2 +-
 io_uring/poll.c     |  2 +-
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0741a728fb6a..1e23adb7b0c5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -864,7 +864,7 @@ inline void __io_req_complete(struct io_kiocb *req, u=
nsigned issue_flags)
 		io_req_complete_post(req);
 }
=20
-void io_req_complete_failed(struct io_kiocb *req, s32 res)
+static inline void io_req_prep_failed(struct io_kiocb *req, s32 res)
 {
 	const struct io_op_def *def =3D &io_op_defs[req->opcode];
=20
@@ -872,6 +872,18 @@ void io_req_complete_failed(struct io_kiocb *req, s3=
2 res)
 	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
 	if (def->fail)
 		def->fail(req);
+}
+
+static void io_req_defer_failed(struct io_kiocb *req, s32 res)
+	__must_hold(&ctx->uring_lock)
+{
+	io_req_prep_failed(req, res);
+	io_req_complete_defer(req);
+}
+
+void io_req_post_failed(struct io_kiocb *req, s32 res)
+{
+	io_req_prep_failed(req, res);
 	io_req_complete_post(req);
 }
=20
@@ -1245,7 +1257,7 @@ static void io_req_task_cancel(struct io_kiocb *req=
, bool *locked)
 {
 	/* not needed for normal modes, but SQPOLL depends on it */
 	io_tw_lock(req->ctx, locked);
-	io_req_complete_failed(req, req->cqe.res);
+	io_req_defer_failed(req, req->cqe.res);
 }
=20
 void io_req_task_submit(struct io_kiocb *req, bool *locked)
@@ -1255,7 +1267,7 @@ void io_req_task_submit(struct io_kiocb *req, bool =
*locked)
 	if (likely(!(req->task->flags & PF_EXITING)))
 		io_queue_sqe(req);
 	else
-		io_req_complete_failed(req, -EFAULT);
+		io_req_defer_failed(req, -EFAULT);
 }
=20
 void io_req_task_queue_fail(struct io_kiocb *req, int ret)
@@ -1633,7 +1645,7 @@ static __cold void io_drain_req(struct io_kiocb *re=
q)
 	ret =3D io_req_prep_async(req);
 	if (ret) {
 fail:
-		io_req_complete_failed(req, ret);
+		io_req_defer_failed(req, ret);
 		return;
 	}
 	io_prep_async_link(req);
@@ -1863,7 +1875,7 @@ static void io_queue_async(struct io_kiocb *req, in=
t ret)
 	struct io_kiocb *linked_timeout;
=20
 	if (ret !=3D -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
-		io_req_complete_failed(req, ret);
+		io_req_defer_failed(req, ret);
 		return;
 	}
=20
@@ -1913,14 +1925,14 @@ static void io_queue_sqe_fallback(struct io_kiocb=
 *req)
 		 */
 		req->flags &=3D ~REQ_F_HARDLINK;
 		req->flags |=3D REQ_F_LINK;
-		io_req_complete_failed(req, req->cqe.res);
+		io_req_defer_failed(req, req->cqe.res);
 	} else if (unlikely(req->ctx->drain_active)) {
 		io_drain_req(req);
 	} else {
 		int ret =3D io_req_prep_async(req);
=20
 		if (unlikely(ret))
-			io_req_complete_failed(req, ret);
+			io_req_defer_failed(req, ret);
 		else
 			io_queue_iowq(req, NULL);
 	}
@@ -2847,7 +2859,7 @@ static __cold bool io_cancel_defer_files(struct io_=
ring_ctx *ctx,
 	while (!list_empty(&list)) {
 		de =3D list_first_entry(&list, struct io_defer_entry, list);
 		list_del_init(&de->list);
-		io_req_complete_failed(de->req, -ECANCELED);
+		io_req_post_failed(de->req, -ECANCELED);
 		kfree(de);
 	}
 	return true;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 83013ee584d6..4d2d0926a42b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -30,7 +30,7 @@ bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
-void io_req_complete_failed(struct io_kiocb *req, s32 res);
+void io_req_post_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
diff --git a/io_uring/poll.c b/io_uring/poll.c
index cd4d98d622d2..ceb8255b54eb 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -316,7 +316,7 @@ static void io_apoll_task_func(struct io_kiocb *req, =
bool *locked)
 	else if (ret =3D=3D IOU_POLL_DONE)
 		io_req_task_submit(req, locked);
 	else
-		io_req_complete_failed(req, ret);
+		io_req_post_failed(req, ret);
 }
=20
 static void __io_poll_execute(struct io_kiocb *req, int mask)
--=20
2.30.2

