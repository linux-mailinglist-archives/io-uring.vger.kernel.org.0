Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046A2507B74
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344945AbiDSU7d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 16:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357857AbiDSU7c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 16:59:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E505241635
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:48 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23JGdbSU002594
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ulD/KHoDprLRTNxjJUHy1WAlDONDpaTtHukF4zqk2Jc=;
 b=Fuk5yR+LKZjdvT/+31x8GZGd0hhpEXHhyVMAnbdQ6XKQ88boA1OekIxvoTwuUj9k1ED8
 XRH0UMKyTd69ZOBJYu+O19sLmk3d2PWpfYEDpikVtt2rqli1E5JaTDMl+CJjcm0+/DG+
 JC6yK8bW63a0HkN9HuyTRbBxPy5a2Sqz50E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhkk2658q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:48 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:56:47 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 1F8E2DD45FED; Tue, 19 Apr 2022 13:56:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v1 09/11] io_uring: add tracing for additional CQE32 fields
Date:   Tue, 19 Apr 2022 13:56:22 -0700
Message-ID: <20220419205624.1546079-10-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205624.1546079-1-shr@fb.com>
References: <20220419205624.1546079-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 5lRXGoBG9qQS3pNMecayNPhZcRrfnmAR
X-Proofpoint-ORIG-GUID: 5lRXGoBG9qQS3pNMecayNPhZcRrfnmAR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_08,2022-04-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

