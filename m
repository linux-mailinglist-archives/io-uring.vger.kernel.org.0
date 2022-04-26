Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661A95106B7
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiDZSZG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243582AbiDZSZE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:25:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ACF35872
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:55 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQTe0024657
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Ij7KivMVcbUXweCbvOqlDJEF27GxUbMkVp4K41s4aW0=;
 b=CsMef4CmTrEQyTIisOI18/KV4d67Rohbfk2dgzbc012Jo5yIZS9C3HuL3SRYpr0oR7Pg
 LwX6xYQ4+D25UaogxzOThqLACUPW33GujrJbLu0iIaGCdIIPBQhoLns2Y7v3s/XMOl7q
 Rxon33Boiz3eWnZGN8GJkViWx2IGTSIIti4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fn1ge0d8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:55 -0700
Received: from twshared39027.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 11:21:54 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 5C4A9E2E5696; Tue, 26 Apr 2022 11:21:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v4 05/12] io_uring: add CQE32 completion processing
Date:   Tue, 26 Apr 2022 11:21:27 -0700
Message-ID: <20220426182134.136504-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426182134.136504-1-shr@fb.com>
References: <20220426182134.136504-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 61FoJk7fCICZANFaShv0qb9XqZ8XW5_T
X-Proofpoint-GUID: 61FoJk7fCICZANFaShv0qb9XqZ8XW5_T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c | 53 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8cb51676d38d..f300130fd9f0 100644
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
@@ -2310,6 +2334,19 @@ static inline void __io_req_complete(struct io_kio=
cb *req, unsigned issue_flags,
 		io_req_complete_post(req, res, cflags);
 }
=20
+static inline void __io_req_complete32(struct io_kiocb *req,
+				       unsigned int issue_flags, s32 res,
+				       u32 cflags, u64 extra1, u64 extra2)
+{
+	if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
+		io_req_complete_state(req, res, cflags);
+		req->extra1 =3D extra1;
+		req->extra2 =3D extra2;
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

