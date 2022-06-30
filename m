Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C994561632
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbiF3JVW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiF3JVP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:21:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB2C39B9D
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:11 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0LWxI011927
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hUv0aS3UVJpreLVSdL6VbkdoulaNK83YOmZ7vgRjojs=;
 b=YKK8MW3Yr1iw8TS4CaRY8asPhchtSkCN+MRg/4aChuGjaUugjK6dNXZShXXS3MstHJln
 2LVtCmrvrJOWGD6T11XTaMuXZikACni3Im/FHRBrRsTrZaI9CEvs7dTNXLXx5YvzbPwY
 KaZF3TPZ9TGmsl9lr2zGeqRLvnz08GDT4hU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0rk5wxg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:08 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:21:07 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id B80462599FDA; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 07/12] io_uring: add allow_overflow to io_post_aux_cqe
Date:   Thu, 30 Jun 2022 02:12:26 -0700
Message-ID: <20220630091231.1456789-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: JSCIYcAk1yl5h1ISN0MZ9Otmb5wHjBFU
X-Proofpoint-GUID: JSCIYcAk1yl5h1ISN0MZ9Otmb5wHjBFU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some use cases of io_post_aux_cqe would not want to overflow as is, but
might want to change the flags/result. For example multishot receive
requires in order CQE, and so if there is an overflow it would need to
stop receiving until the overflow is taken care of.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 14 ++++++++++----
 io_uring/io_uring.h |  3 ++-
 io_uring/msg_ring.c |  4 ++--
 io_uring/net.c      |  2 +-
 io_uring/poll.c     |  2 +-
 io_uring/rsrc.c     |  4 ++--
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 745264938a48..523b6ebad15a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -736,7 +736,8 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx =
*ctx)
 }
=20
 static bool io_fill_cqe_aux(struct io_ring_ctx *ctx,
-			    u64 user_data, s32 res, u32 cflags)
+			    u64 user_data, s32 res, u32 cflags,
+			    bool allow_overflow)
 {
 	struct io_uring_cqe *cqe;
=20
@@ -760,16 +761,21 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx=
,
 		}
 		return true;
 	}
-	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+
+	if (allow_overflow)
+		return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+
+	return false;
 }
=20
 bool io_post_aux_cqe(struct io_ring_ctx *ctx,
-		     u64 user_data, s32 res, u32 cflags)
+		     u64 user_data, s32 res, u32 cflags,
+		     bool allow_overflow)
 {
 	bool filled;
=20
 	io_cq_lock(ctx);
-	filled =3D io_fill_cqe_aux(ctx, user_data, res, cflags);
+	filled =3D io_fill_cqe_aux(ctx, user_data, res, cflags, allow_overflow)=
;
 	io_cq_unlock_post(ctx);
 	return filled;
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e8da70781fa3..e022d71c177a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -31,7 +31,8 @@ void io_req_complete_failed(struct io_kiocb *req, s32 r=
es);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
 void __io_req_complete_post(struct io_kiocb *req);
-bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
+		     bool allow_overflow);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
=20
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *n=
pages);
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 939205b30c8b..753d16734319 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -31,7 +31,7 @@ static int io_msg_ring_data(struct io_kiocb *req)
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
=20
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
 		return 0;
=20
 	return -EOVERFLOW;
@@ -113,7 +113,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsig=
ned int issue_flags)
 	 * completes with -EOVERFLOW, then the sender must ensure that a
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
 		ret =3D -EOVERFLOW;
 out_unlock:
 	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
diff --git a/io_uring/net.c b/io_uring/net.c
index 0268c4603f5d..c3600814b308 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -658,7 +658,7 @@ int io_accept(struct io_kiocb *req, unsigned int issu=
e_flags)
=20
 	if (ret < 0)
 		return ret;
-	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE))
+	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, tr=
ue))
 		goto retry;
 	return -ECANCELED;
 }
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 64d426d696ab..e8f922a4f6d7 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -243,7 +243,7 @@ static int io_poll_check_events(struct io_kiocb *req,=
 bool *locked)
 						    req->apoll_events);
=20
 			if (!io_post_aux_cqe(ctx, req->cqe.user_data,
-					     mask, IORING_CQE_F_MORE))
+					     mask, IORING_CQE_F_MORE, true))
 				return -ECANCELED;
 		} else {
 			ret =3D io_poll_issue(req, locked);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 6a75d2f57e8e..1182cf0ea1fc 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -175,10 +175,10 @@ static void __io_rsrc_put_work(struct io_rsrc_node =
*ref_node)
 		if (prsrc->tag) {
 			if (ctx->flags & IORING_SETUP_IOPOLL) {
 				mutex_lock(&ctx->uring_lock);
-				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
+				io_post_aux_cqe(ctx, prsrc->tag, 0, 0, true);
 				mutex_unlock(&ctx->uring_lock);
 			} else {
-				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
+				io_post_aux_cqe(ctx, prsrc->tag, 0, 0, true);
 			}
 		}
=20
--=20
2.30.2

