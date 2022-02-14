Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888C74B5957
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 19:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357329AbiBNSHe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 13:07:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357327AbiBNSHc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 13:07:32 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED30865179
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 10:07:24 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21EGJ7HI018317
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 10:07:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=bEtsxO/NXfLlD4LjSdc6Zua/wNrBUsHcyWwnFE48/2c=;
 b=YjDhs1KrDjjg1sn9ctKM3G9seJaZYqGyf8xModkPEMMc3n/DYdv5zbPijZdDztPgfSbo
 H8glw1znFuWTnCtiz9QFo+VLgElC49qrtR9AIwXHPSHYKJbMBhY0SbHputi248X/cGyn
 8ZS7tbnmceSzFijoDW7hwN4lf70t2LP2X9k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7dm2ct5d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 10:07:24 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 10:07:22 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C80B2ABC052B; Mon, 14 Feb 2022 10:04:33 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 1/2] io-uring: add __fill_cqe function
Date:   Mon, 14 Feb 2022 10:04:29 -0800
Message-ID: <20220214180430.70572-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214180430.70572-1-shr@fb.com>
References: <20220214180430.70572-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: FZoG0I_oOotoJ-DFNZUkYp4jkoAIzer2
X-Proofpoint-ORIG-GUID: FZoG0I_oOotoJ-DFNZUkYp4jkoAIzer2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 spamscore=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

This introduces the __fill_cqe function. This is necessary
to correctly issue the io_uring_complete tracepoint.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77b9c7e4793b..b5f207fbe9a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1900,13 +1900,11 @@ static bool io_cqring_event_overflow(struct io_ri=
ng_ctx *ctx, u64 user_data,
 	return true;
 }
=20
-static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
+static inline bool __fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
 				 s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
=20
-	trace_io_uring_complete(ctx, user_data, res, cflags);
-
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
 	 * submission (by quite a lot). Increment the overflow count in
@@ -1922,17 +1920,24 @@ static inline bool __io_fill_cqe(struct io_ring_c=
tx *ctx, u64 user_data,
 	return io_cqring_event_overflow(ctx, user_data, res, cflags);
 }
=20
+static inline bool __io_fill_cqe(struct io_kiocb *req, s32 res, u32 cfla=
gs)
+{
+	trace_io_uring_complete(req->ctx, req->user_data, res, cflags);
+	return __fill_cqe(req->ctx, req->user_data, res, cflags);
+}
+
 static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 =
cflags)
 {
 	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe(req->ctx, req->user_data, res, cflags);
+		__io_fill_cqe(req, res, cflags);
 }
=20
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_d=
ata,
 				     s32 res, u32 cflags)
 {
 	ctx->cq_extra++;
-	return __io_fill_cqe(ctx, user_data, res, cflags);
+	trace_io_uring_complete(ctx, user_data, res, cflags);
+	return __fill_cqe(ctx, user_data, res, cflags);
 }
=20
 static void __io_req_complete_post(struct io_kiocb *req, s32 res,
@@ -1941,7 +1946,7 @@ static void __io_req_complete_post(struct io_kiocb =
*req, s32 res,
 	struct io_ring_ctx *ctx =3D req->ctx;
=20
 	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe(ctx, req->user_data, res, cflags);
+		__io_fill_cqe(req, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -2530,8 +2535,7 @@ static void __io_submit_flush_completions(struct io=
_ring_ctx *ctx)
 						    comp_list);
=20
 			if (!(req->flags & REQ_F_CQE_SKIP))
-				__io_fill_cqe(ctx, req->user_data, req->result,
-					      req->cflags);
+				__io_fill_cqe(req, req->result, req->cflags);
 		}
=20
 		io_commit_cqring(ctx);
@@ -2653,7 +2657,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bo=
ol force_nonspin)
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
=20
-		__io_fill_cqe(ctx, req->user_data, req->result, io_put_kbuf(req));
+		__io_fill_cqe(req, req->result, io_put_kbuf(req));
 		nr_events++;
 	}
=20
--=20
2.30.2

