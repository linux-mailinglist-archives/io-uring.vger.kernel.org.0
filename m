Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207FA631EBD
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiKUKso (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiKUKsP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:48:15 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6321001
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:48:14 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKNmo8b024223
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:48:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=8yNetuLxtxYQ4CH6zKHEwvu3Z56G4Zn4RgL48kPZoKw=;
 b=KQSqXeoPs9jOScsaUqM4gNWHQ+0vrYDHdkPigH9uC4WHEU3NHGyT1r/5LlN+jbHho2Wb
 S2ZXBIzijPXg3NAE93ONxW8c3+sZZ13M6/XnY9ZhbWipcGRtwNZ1NGmyZO1XJIXMTTaj
 lE0jenYUA+Q1Ar+Ox0fG48h4tZIQyaoL+e6CcTxTRgw+qKSI6hg3wRMHrGIgU5tyV9nd
 vfoIpg7wywpP5czjtoffAMJhi/jUrOvJYZDqFCWpibbi+56QwBId6ERuwgI1OJJY6tGC
 SA/JT/8+NCqAby4/8vajd2v7gOP9qFnUPtLrxKY+qXXCreLVe0zSnD8bENOYAPSdGbDy 1g== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kxyb9b64p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:48:14 -0800
Received: from twshared0705.02.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:48:13 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 586999E66F6D; Mon, 21 Nov 2022 02:03:55 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 03/10] io_uring: split io_req_complete_failed into post/defer
Date:   Mon, 21 Nov 2022 02:03:46 -0800
Message-ID: <20221121100353.371865-4-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121100353.371865-1-dylany@meta.com>
References: <20221121100353.371865-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: qeJMVzEJkraU2CyT4h20jx0aZI-jrd7U
X-Proofpoint-ORIG-GUID: qeJMVzEJkraU2CyT4h20jx0aZI-jrd7U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
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
index 208afb944b0c..d9bd18e3a603 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -868,7 +868,7 @@ inline void __io_req_complete(struct io_kiocb *req, u=
nsigned issue_flags)
 		io_req_complete_post(req);
 }
=20
-void io_req_complete_failed(struct io_kiocb *req, s32 res)
+static inline void io_req_prep_failed(struct io_kiocb *req, s32 res)
 {
 	const struct io_op_def *def =3D &io_op_defs[req->opcode];
=20
@@ -876,6 +876,18 @@ void io_req_complete_failed(struct io_kiocb *req, s3=
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
@@ -1249,7 +1261,7 @@ static void io_req_task_cancel(struct io_kiocb *req=
, bool *locked)
 {
 	/* not needed for normal modes, but SQPOLL depends on it */
 	io_tw_lock(req->ctx, locked);
-	io_req_complete_failed(req, req->cqe.res);
+	io_req_defer_failed(req, req->cqe.res);
 }
=20
 void io_req_task_submit(struct io_kiocb *req, bool *locked)
@@ -1259,7 +1271,7 @@ void io_req_task_submit(struct io_kiocb *req, bool =
*locked)
 	if (likely(!(req->task->flags & PF_EXITING)))
 		io_queue_sqe(req);
 	else
-		io_req_complete_failed(req, -EFAULT);
+		io_req_defer_failed(req, -EFAULT);
 }
=20
 void io_req_task_queue_fail(struct io_kiocb *req, int ret)
@@ -1637,7 +1649,7 @@ static __cold void io_drain_req(struct io_kiocb *re=
q)
 	ret =3D io_req_prep_async(req);
 	if (ret) {
 fail:
-		io_req_complete_failed(req, ret);
+		io_req_defer_failed(req, ret);
 		return;
 	}
 	io_prep_async_link(req);
@@ -1867,7 +1879,7 @@ static void io_queue_async(struct io_kiocb *req, in=
t ret)
 	struct io_kiocb *linked_timeout;
=20
 	if (ret !=3D -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
-		io_req_complete_failed(req, ret);
+		io_req_defer_failed(req, ret);
 		return;
 	}
=20
@@ -1917,14 +1929,14 @@ static void io_queue_sqe_fallback(struct io_kiocb=
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
@@ -2851,7 +2863,7 @@ static __cold bool io_cancel_defer_files(struct io_=
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
index af3f82bd4017..ee3139947fcc 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -29,7 +29,7 @@ bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
-void io_req_complete_failed(struct io_kiocb *req, s32 res);
+void io_req_post_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 989b72a47331..e0a4faa010b3 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -304,7 +304,7 @@ static void io_apoll_task_func(struct io_kiocb *req, =
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

