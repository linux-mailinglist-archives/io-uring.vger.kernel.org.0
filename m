Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C754507B70
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357859AbiDSU7c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 16:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344945AbiDSU7b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 16:59:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5544A41608
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:48 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23JGduSa011486
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0dsqbiIYUpYGsz6SX+Aevv0g3blMuu1d1Q7h+Udsm+w=;
 b=bSVh1rdkQ17FHzqaOsCJ2Aq2J9UU9UwtS0B4vZlGGd0oVr86t2s0v90WGc/3uVmRPaih
 xKeRYxc2yMmUGu7e2nNeg1NR4utPLOV/rC3OhW3WeyRA5+Fhr3c2g3D8iylGKLceSHYg
 geDVQ1USI7/50y574iUJ/v80naj4LJTlJPc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhjh1pdea-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:47 -0700
Received: from twshared16483.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:56:46 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 1993ADD45FEB; Tue, 19 Apr 2022 13:56:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v1 08/11] io_uring: overflow processing for CQE32
Date:   Tue, 19 Apr 2022 13:56:21 -0700
Message-ID: <20220419205624.1546079-9-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205624.1546079-1-shr@fb.com>
References: <20220419205624.1546079-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: -_4x96oWjVrPm22quJR4aMO-xHMPbrut
X-Proofpoint-ORIG-GUID: -_4x96oWjVrPm22quJR4aMO-xHMPbrut
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

This adds the overflow processing for large CQE's.

This adds two parameters to the io_cqring_event_overflow function and
uses these fields to initialize the large CQE fields.

Allocate enough space for large CQE's in the overflow structue. If no
large CQE's are used, the size of the allocation is unchanged.

The cqe field can have a different size depending if its a large
CQE or not. To be able to allocate different sizes, the two fields
in the structure are re-ordered.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ff6229b6df16..50efced63ec9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -220,8 +220,8 @@ struct io_mapped_ubuf {
 struct io_ring_ctx;
=20
 struct io_overflow_cqe {
-	struct io_uring_cqe cqe;
 	struct list_head list;
+	struct io_uring_cqe cqe;
 };
=20
 struct io_fixed_file {
@@ -2016,13 +2016,17 @@ static bool __io_cqring_overflow_flush(struct io_=
ring_ctx *ctx, bool force)
 	while (!list_empty(&ctx->cq_overflow_list)) {
 		struct io_uring_cqe *cqe =3D io_get_cqe(ctx);
 		struct io_overflow_cqe *ocqe;
+		size_t cqe_size =3D sizeof(struct io_uring_cqe);
+
+		if (ctx->flags & IORING_SETUP_CQE32)
+			cqe_size <<=3D 1;
=20
 		if (!cqe && !force)
 			break;
 		ocqe =3D list_first_entry(&ctx->cq_overflow_list,
 					struct io_overflow_cqe, list);
 		if (cqe)
-			memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
+			memcpy(cqe, &ocqe->cqe, cqe_size);
 		else
 			io_account_cq_overflow(ctx);
=20
@@ -2111,11 +2115,15 @@ static __cold void io_uring_drop_tctx_refs(struct=
 task_struct *task)
 }
=20
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_d=
ata,
-				     s32 res, u32 cflags)
+				     s32 res, u32 cflags, u64 extra1, u64 extra2)
 {
 	struct io_overflow_cqe *ocqe;
+	size_t ocq_size =3D sizeof(struct io_overflow_cqe);
=20
-	ocqe =3D kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
+	if (ctx->flags & IORING_SETUP_CQE32)
+		ocq_size +=3D sizeof(struct io_uring_cqe);
+
+	ocqe =3D kmalloc(ocq_size, GFP_ATOMIC | __GFP_ACCOUNT);
 	if (!ocqe) {
 		/*
 		 * If we're in ring overflow flush mode, or in task cancel mode,
@@ -2134,6 +2142,10 @@ static bool io_cqring_event_overflow(struct io_rin=
g_ctx *ctx, u64 user_data,
 	ocqe->cqe.user_data =3D user_data;
 	ocqe->cqe.res =3D res;
 	ocqe->cqe.flags =3D cflags;
+	if (ctx->flags & IORING_SETUP_CQE32) {
+		ocqe->cqe.b[0].extra1 =3D extra1;
+		ocqe->cqe.b[0].extra2 =3D extra2;
+	}
 	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
 	return true;
 }
@@ -2155,7 +2167,7 @@ static inline bool __io_fill_cqe(struct io_ring_ctx=
 *ctx, u64 user_data,
 		WRITE_ONCE(cqe->flags, cflags);
 		return true;
 	}
-	return io_cqring_event_overflow(ctx, user_data, res, cflags);
+	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
 }
=20
 static inline bool __io_fill_cqe_req_filled(struct io_ring_ctx *ctx,
@@ -2177,7 +2189,7 @@ static inline bool __io_fill_cqe_req_filled(struct =
io_ring_ctx *ctx,
 		return true;
 	}
 	return io_cqring_event_overflow(ctx, req->cqe.user_data,
-					req->cqe.res, req->cqe.flags);
+					req->cqe.res, req->cqe.flags, 0, 0);
 }
=20
 static inline bool __io_fill_cqe32_req_filled(struct io_ring_ctx *ctx,
@@ -2241,7 +2253,7 @@ static void __io_fill_cqe32_req(struct io_kiocb *re=
q, s32 res, u32 cflags,
 		return;
 	}
=20
-	io_cqring_event_overflow(ctx, req->cqe.user_data, res, cflags);
+	io_cqring_event_overflow(ctx, req->cqe.user_data, res, cflags, extra1, =
extra2);
 }
=20
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_d=
ata,
--=20
2.30.2

