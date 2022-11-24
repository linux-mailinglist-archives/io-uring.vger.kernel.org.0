Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A161637542
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiKXJg3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiKXJg3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:29 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5E3109589
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:28 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANHsDrB024521
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=uJ6b5V/7s0WTTTLrp0iHQXvNPAcNVs0y33SVziYDgp0=;
 b=WXAC2kvsumo91eFezRKPoNJ5yOqQW8dyVqlkV/Tf8aXA+ypo8VMf0w30/hSPVuGlfc/K
 V5cyVFX/uPPumV5XwoWrgzZFUNo9VDXcOkeDWkDrm9Q+vig5mt6S+5UqiVsZUAfSoKoR
 mZ9+c5VizhwxFug0BkPFnThePiTyC7IkU3IYOZrWtwwWZH8oDKdHed9NkSPnLrn10Qlt
 Y7AW5ohnt2EIdhYIG3SN86a66ZkXrcRhYs017QG1JF6YKW3/XfjiIlVlbxX5lRHKX3cL
 BbuLhpjp/asuPuuxSU8mXE1OD2ezfyunnPGUEXvSwuCVN0YI/QUazJFPCgPBIo9W0EdZ Jw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1cg3s8wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:28 -0800
Received: from twshared0705.02.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:27 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1B33FA173A10; Thu, 24 Nov 2022 01:36:19 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 3/9] io_uring: defer all io_req_complete_failed
Date:   Thu, 24 Nov 2022 01:35:53 -0800
Message-ID: <20221124093559.3780686-4-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IuVVdh6wHwPL9oQ6hJX4K5pjxq1Qt0-0
X-Proofpoint-GUID: IuVVdh6wHwPL9oQ6hJX4K5pjxq1Qt0-0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All failures happen under lock now, and can be deferred. To be consistent
when the failure has happened after some multishot cqe has been
deferred (and keep ordering), always defer failures.

To make this obvious at the caller (and to help prevent a future bug)
rename io_req_complete_failed to io_req_defer_failed.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 17 ++++++++---------
 io_uring/io_uring.h |  2 +-
 io_uring/poll.c     |  2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ec23ebb63489..cbd271b6188a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -866,7 +866,7 @@ void io_req_complete_post(struct io_kiocb *req, unsig=
ned issue_flags)
 	}
 }
=20
-void io_req_complete_failed(struct io_kiocb *req, s32 res)
+void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	__must_hold(&ctx->uring_lock)
 {
 	const struct io_op_def *def =3D &io_op_defs[req->opcode];
@@ -877,7 +877,7 @@ void io_req_complete_failed(struct io_kiocb *req, s32=
 res)
 	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
 	if (def->fail)
 		def->fail(req);
-	io_req_complete_post(req, 0);
+	io_req_complete_defer(req);
 }
=20
 /*
@@ -1233,9 +1233,8 @@ int io_run_local_work(struct io_ring_ctx *ctx)
=20
 static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 {
-	/* not needed for normal modes, but SQPOLL depends on it */
 	io_tw_lock(req->ctx, locked);
-	io_req_complete_failed(req, req->cqe.res);
+	io_req_defer_failed(req, req->cqe.res);
 }
=20
 void io_req_task_submit(struct io_kiocb *req, bool *locked)
@@ -1245,7 +1244,7 @@ void io_req_task_submit(struct io_kiocb *req, bool =
*locked)
 	if (likely(!(req->task->flags & PF_EXITING)))
 		io_queue_sqe(req);
 	else
-		io_req_complete_failed(req, -EFAULT);
+		io_req_defer_failed(req, -EFAULT);
 }
=20
 void io_req_task_queue_fail(struct io_kiocb *req, int ret)
@@ -1632,7 +1631,7 @@ static __cold void io_drain_req(struct io_kiocb *re=
q)
 	ret =3D io_req_prep_async(req);
 	if (ret) {
 fail:
-		io_req_complete_failed(req, ret);
+		io_req_defer_failed(req, ret);
 		return;
 	}
 	io_prep_async_link(req);
@@ -1862,7 +1861,7 @@ static void io_queue_async(struct io_kiocb *req, in=
t ret)
 	struct io_kiocb *linked_timeout;
=20
 	if (ret !=3D -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
-		io_req_complete_failed(req, ret);
+		io_req_defer_failed(req, ret);
 		return;
 	}
=20
@@ -1912,14 +1911,14 @@ static void io_queue_sqe_fallback(struct io_kiocb=
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
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b5b80bf03385..a26d5aa7f3f3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -30,7 +30,7 @@ bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
-void io_req_complete_failed(struct io_kiocb *req, s32 res);
+void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
 		     bool allow_overflow);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 42aa10b50f6c..4bd43e6f5b72 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -317,7 +317,7 @@ static void io_apoll_task_func(struct io_kiocb *req, =
bool *locked)
 	else if (ret =3D=3D IOU_POLL_DONE)
 		io_req_task_submit(req, locked);
 	else
-		io_req_complete_failed(req, ret);
+		io_req_defer_failed(req, ret);
 }
=20
 static void __io_poll_execute(struct io_kiocb *req, int mask)
--=20
2.30.2

