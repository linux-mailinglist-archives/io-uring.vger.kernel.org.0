Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C93509026
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348146AbiDTTSC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349026AbiDTTSB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:18:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97BBBC9A
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:13 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23KILNag008704
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ulD/KHoDprLRTNxjJUHy1WAlDONDpaTtHukF4zqk2Jc=;
 b=iGeA8ZJ9v8pLM/2zo5eQuJaY8c8rjeQhLTTQ7ygxmcYSqeCz00Z75LKew0Gg7i3SMzFO
 U0ydRNEiKiTFbrgiqYwHkpuNLmIoUDY09Q3NRTALwO7ilHka1xxj3ziXdQw1ujBpDbBL
 UhQmdKgoP4lFcAo25ZGZf0qmReU4O4zHbLA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fj9p1vy0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:13 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:11 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id B59F4DE0C416; Wed, 20 Apr 2022 12:14:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 09/12] io_uring: add tracing for additional CQE32 fields
Date:   Wed, 20 Apr 2022 12:14:48 -0700
Message-ID: <20220420191451.2904439-10-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191451.2904439-1-shr@fb.com>
References: <20220420191451.2904439-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BK07-EIETMaK9t6wgyKCy15QR09Qj4av
X-Proofpoint-GUID: BK07-EIETMaK9t6wgyKCy15QR09Qj4av
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds tracing for the extra1 and extra2 fields.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                   | 11 ++++++-----
 include/trace/events/io_uring.h | 18 ++++++++++++++----
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 50efced63ec9..366f49969b31 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2176,7 +2176,7 @@ static inline bool __io_fill_cqe_req_filled(struct =
io_ring_ctx *ctx,
 	struct io_uring_cqe *cqe;
=20
 	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags);
+				req->cqe.res, req->cqe.flags, 0, 0);
=20
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
@@ -2200,7 +2200,7 @@ static inline bool __io_fill_cqe32_req_filled(struc=
t io_ring_ctx *ctx,
 	u64 extra2 =3D req->extra2;
=20
 	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags);
+				req->cqe.res, req->cqe.flags, extra1, extra2);
=20
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
@@ -2221,7 +2221,7 @@ static inline bool __io_fill_cqe32_req_filled(struc=
t io_ring_ctx *ctx,
=20
 static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 =
cflags)
 {
-	trace_io_uring_complete(req->ctx, req, req->cqe.user_data, res, cflags)=
;
+	trace_io_uring_complete(req->ctx, req, req->cqe.user_data, res, cflags,=
 0, 0);
 	return __io_fill_cqe(req->ctx, req->cqe.user_data, res, cflags);
 }
=20
@@ -2236,7 +2236,8 @@ static void __io_fill_cqe32_req(struct io_kiocb *re=
q, s32 res, u32 cflags,
 	if (req->flags & REQ_F_CQE_SKIP)
 		return;
=20
-	trace_io_uring_complete(ctx, req, req->user_data, res, cflags);
+	trace_io_uring_complete(ctx, req, req->cqe.user_data, res, cflags,
+				extra1, extra2);
=20
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
@@ -2260,7 +2261,7 @@ static noinline bool io_fill_cqe_aux(struct io_ring=
_ctx *ctx, u64 user_data,
 				     s32 res, u32 cflags)
 {
 	ctx->cq_extra++;
-	trace_io_uring_complete(ctx, NULL, user_data, res, cflags);
+	trace_io_uring_complete(ctx, NULL, user_data, res, cflags, 0, 0);
 	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
=20
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 8477414d6d06..2eb4f4e47de4 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -318,13 +318,16 @@ TRACE_EVENT(io_uring_fail_link,
  * @user_data:		user data associated with the request
  * @res:		result of the request
  * @cflags:		completion flags
+ * @extra1:		extra 64-bit data for CQE32
+ * @extra2:		extra 64-bit data for CQE32
  *
  */
 TRACE_EVENT(io_uring_complete,
=20
-	TP_PROTO(void *ctx, void *req, u64 user_data, int res, unsigned cflags)=
,
+	TP_PROTO(void *ctx, void *req, u64 user_data, int res, unsigned cflags,
+		 u64 extra1, u64 extra2),
=20
-	TP_ARGS(ctx, req, user_data, res, cflags),
+	TP_ARGS(ctx, req, user_data, res, cflags, extra1, extra2),
=20
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
@@ -332,6 +335,8 @@ TRACE_EVENT(io_uring_complete,
 		__field(  u64,		user_data	)
 		__field(  int,		res		)
 		__field(  unsigned,	cflags		)
+		__field(  u64,		extra1		)
+		__field(  u64,		extra2		)
 	),
=20
 	TP_fast_assign(
@@ -340,12 +345,17 @@ TRACE_EVENT(io_uring_complete,
 		__entry->user_data	=3D user_data;
 		__entry->res		=3D res;
 		__entry->cflags		=3D cflags;
+		__entry->extra1		=3D extra1;
+		__entry->extra2		=3D extra2;
 	),
=20
-	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x",
+	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x "
+		  "extra1 %llu extra2 %llu ",
 		__entry->ctx, __entry->req,
 		__entry->user_data,
-		__entry->res, __entry->cflags)
+		__entry->res, __entry->cflags,
+		(unsigned long long) __entry->extra1,
+		(unsigned long long) __entry->extra2)
 );
=20
 /**
--=20
2.30.2

