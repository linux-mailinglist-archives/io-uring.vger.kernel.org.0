Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC42650E83D
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiDYS3R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244384AbiDYS3P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:29:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28F1283
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:09 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 23PHPKpd009742
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=djW7aZbgQ0norfLPiEd0Wq7165tpA8ijlfyj3ODVD6c=;
 b=ClLksHma4OWTZOHweq85U+2H3GE7WZ+4GPSIYNk04F7QgbTvsVrCrO88coFqeRK92f/R
 Cucm0VV8p4xANtuDKIw3qKIEIrxMCRD+FaEWvqEFXYuiYq8/+f9m3CBl6183bV2G+un4
 7s0MhR9u33SEYVZrH+JVsAnPB7q6ubIJiqs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fmcy4vb6j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:08 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:26:06 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 4E23BE1F2A63; Mon, 25 Apr 2022 11:25:41 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 08/12] io_uring: overflow processing for CQE32
Date:   Mon, 25 Apr 2022 11:25:26 -0700
Message-ID: <20220425182530.2442911-9-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425182530.2442911-1-shr@fb.com>
References: <20220425182530.2442911-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: x8xy6OY_hB7xkteQys4v4wBq1Eqi7VGn
X-Proofpoint-GUID: x8xy6OY_hB7xkteQys4v4wBq1Eqi7VGn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 fs/io_uring.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 68b61d2b356d..3630671325ea 100644
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
@@ -2017,10 +2017,14 @@ static void io_cqring_ev_posted_iopoll(struct io_=
ring_ctx *ctx)
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool for=
ce)
 {
 	bool all_flushed, posted;
+	size_t cqe_size =3D sizeof(struct io_uring_cqe);
=20
 	if (!force && __io_cqring_events(ctx) =3D=3D ctx->cq_entries)
 		return false;
=20
+	if (ctx->flags & IORING_SETUP_CQE32)
+		cqe_size <<=3D 1;
+
 	posted =3D false;
 	spin_lock(&ctx->completion_lock);
 	while (!list_empty(&ctx->cq_overflow_list)) {
@@ -2032,7 +2036,7 @@ static bool __io_cqring_overflow_flush(struct io_ri=
ng_ctx *ctx, bool force)
 		ocqe =3D list_first_entry(&ctx->cq_overflow_list,
 					struct io_overflow_cqe, list);
 		if (cqe)
-			memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
+			memcpy(cqe, &ocqe->cqe, cqe_size);
 		else
 			io_account_cq_overflow(ctx);
=20
@@ -2121,11 +2125,16 @@ static __cold void io_uring_drop_tctx_refs(struct=
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
+	bool is_cqe32 =3D (ctx->flags & IORING_SETUP_CQE32);
+
+	if (is_cqe32)
+		ocq_size +=3D sizeof(struct io_uring_cqe);
=20
-	ocqe =3D kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
+	ocqe =3D kmalloc(ocq_size, GFP_ATOMIC | __GFP_ACCOUNT);
 	if (!ocqe) {
 		/*
 		 * If we're in ring overflow flush mode, or in task cancel mode,
@@ -2144,6 +2153,10 @@ static bool io_cqring_event_overflow(struct io_rin=
g_ctx *ctx, u64 user_data,
 	ocqe->cqe.user_data =3D user_data;
 	ocqe->cqe.res =3D res;
 	ocqe->cqe.flags =3D cflags;
+	if (is_cqe32) {
+		ocqe->cqe.big_cqe[0] =3D extra1;
+		ocqe->cqe.big_cqe[1] =3D extra2;
+	}
 	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
 	return true;
 }
@@ -2165,7 +2178,7 @@ static inline bool __io_fill_cqe(struct io_ring_ctx=
 *ctx, u64 user_data,
 		WRITE_ONCE(cqe->flags, cflags);
 		return true;
 	}
-	return io_cqring_event_overflow(ctx, user_data, res, cflags);
+	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
 }
=20
 static inline bool __io_fill_cqe_req_filled(struct io_ring_ctx *ctx,
@@ -2187,7 +2200,7 @@ static inline bool __io_fill_cqe_req_filled(struct =
io_ring_ctx *ctx,
 		return true;
 	}
 	return io_cqring_event_overflow(ctx, req->cqe.user_data,
-					req->cqe.res, req->cqe.flags);
+					req->cqe.res, req->cqe.flags, 0, 0);
 }
=20
 static inline bool __io_fill_cqe32_req_filled(struct io_ring_ctx *ctx,
@@ -2213,8 +2226,8 @@ static inline bool __io_fill_cqe32_req_filled(struc=
t io_ring_ctx *ctx,
 		return true;
 	}
=20
-	return io_cqring_event_overflow(ctx, req->cqe.user_data,
-					req->cqe.res, req->cqe.flags);
+	return io_cqring_event_overflow(ctx, req->cqe.user_data, req->cqe.res,
+					req->cqe.flags, extra1, extra2);
 }
=20
 static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 =
cflags)
@@ -2251,7 +2264,7 @@ static inline void __io_fill_cqe32_req(struct io_ki=
ocb *req, s32 res, u32 cflags
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

