Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95754507B6D
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357860AbiDSU7k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 16:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357857AbiDSU7j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 16:59:39 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E0A41608
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:55 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23JGdo0K021282
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5F92pawz3h/oEqVycRjp0db+7XvXLwsFL8r1nmzw2JE=;
 b=hQfpIx0/atHPxf3+6XD2QCNG9QjH6atoVYYLzVyEEAtJHomAvVlqJbZp7vaLBXM0Lpr3
 n2vf5K93JxclO/HNom+opH/O9zqQ4laJEJhyeIuY34Kbc2UCLPgk6YG9TV/x2ysaZ6sQ
 yz7Hpsm59bxVd3vzjaEpxNBPQgbZrY+NvgU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhn52wrmd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:54 -0700
Received: from twshared37304.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:56:46 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 070E5DD45FE5; Tue, 19 Apr 2022 13:56:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v1 05/11] io_uring: add CQE32 completion processing
Date:   Tue, 19 Apr 2022 13:56:18 -0700
Message-ID: <20220419205624.1546079-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205624.1546079-1-shr@fb.com>
References: <20220419205624.1546079-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: UIBFoJ7TvjkgYcmChSkOnE-hLmmO-mam
X-Proofpoint-ORIG-GUID: UIBFoJ7TvjkgYcmChSkOnE-hLmmO-mam
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

This adds the completion processing for the large CQE's and makes sure
that the extra1 and extra2 fields are passed through.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 55 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index abbd2efbe255..c93a9353c88d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2247,18 +2247,15 @@ static noinline bool io_fill_cqe_aux(struct io_ri=
ng_ctx *ctx, u64 user_data,
 	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
=20
-static void __io_req_complete_post(struct io_kiocb *req, s32 res,
-				   u32 cflags)
+static void __io_req_complete_put(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx =3D req->ctx;
-
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(req, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
 	 */
 	if (req_ref_put_and_test(req)) {
+		struct io_ring_ctx *ctx =3D req->ctx;
+
 		if (req->flags & IO_REQ_LINK_FLAGS) {
 			if (req->flags & IO_DISARM_MASK)
 				io_disarm_next(req);
@@ -2281,8 +2278,23 @@ static void __io_req_complete_post(struct io_kiocb=
 *req, s32 res,
 	}
 }
=20
-static void io_req_complete_post(struct io_kiocb *req, s32 res,
-				 u32 cflags)
+static void __io_req_complete_post(struct io_kiocb *req, s32 res,
+				   u32 cflags)
+{
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe_req(req, res, cflags);
+	__io_req_complete_put(req);
+}
+
+static void __io_req_complete_post32(struct io_kiocb *req, s32 res,
+				   u32 cflags, u64 extra1, u64 extra2)
+{
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe32_req(req, res, cflags, extra1, extra2);
+	__io_req_complete_put(req);
+}
+
+static void io_req_complete_post(struct io_kiocb *req, s32 res, u32 cfla=
gs)
 {
 	struct io_ring_ctx *ctx =3D req->ctx;
=20
@@ -2293,6 +2305,18 @@ static void io_req_complete_post(struct io_kiocb *=
req, s32 res,
 	io_cqring_ev_posted(ctx);
 }
=20
+static void io_req_complete_post32(struct io_kiocb *req, s32 res,
+				   u32 cflags, u64 extra1, u64 extra2)
+{
+	struct io_ring_ctx *ctx =3D req->ctx;
+
+	spin_lock(&ctx->completion_lock);
+	__io_req_complete_post32(req, res, cflags, extra1, extra2);
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+}
+
 static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
 					 u32 cflags)
 {
@@ -2310,6 +2334,21 @@ static inline void __io_req_complete(struct io_kio=
cb *req, unsigned issue_flags,
 		io_req_complete_post(req, res, cflags);
 }
=20
+static inline void __io_req_complete32(struct io_kiocb *req,
+				       unsigned int issue_flags, s32 res,
+				       u32 cflags, u64 extra1, u64 extra2)
+{
+	if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
+		req->cqe.res =3D res;
+		req->cqe.flags =3D cflags;
+		req->extra1 =3D extra1;
+		req->extra2 =3D extra2;
+		req->flags |=3D REQ_F_COMPLETE_INLINE;
+	} else {
+		io_req_complete_post32(req, res, cflags, extra1, extra2);
+	}
+}
+
 static inline void io_req_complete(struct io_kiocb *req, s32 res)
 {
 	__io_req_complete(req, 0, res, 0);
--=20
2.30.2

