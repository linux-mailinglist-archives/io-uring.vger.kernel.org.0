Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7F17676CE
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 22:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjG1UPt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 16:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbjG1UPs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 16:15:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D46C423B
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 13:15:46 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36SJUEeB010680
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 13:15:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=HdLTZx3ywuV58VYqToINJa02yzTgr3TXTJwla58Xm/4=;
 b=AeVpb8S/iPtsZsbESzhMlmiY4YHyMmYmUnnCzXTJZpAsMgwkYcpQ6o7cZ10n6LH+6uKX
 JNqe5/IhXJ5/FnpRZKGCHvENGlo0yM3FtWbJfUChf0cXlBtlWKftEzkR3Dp5al1ivS4Y
 Cu7CdrEqGSZItpKoCMjDLK7NdkTC8GeVHN/bS0fiTaANdFkQdRUBCzqbVFJnUggERfqx
 N+dPJsJpGK4yZuwoLlK24wing7buEPukmm/98PILpUHwM+J8/nOcPINYSwYgr0oT/NUC
 7wEKFCnXoTu0Iy6epGDAQ0SuAmDGZK4iJYIctcY7w7nFuKtv4ZRVXcl0+Np6vH6idoj5 wQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3s49g0wxfj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 13:15:46 -0700
Received: from twshared10975.09.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 28 Jul 2023 13:15:44 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id B3C801C47B2B5; Fri, 28 Jul 2023 13:14:50 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC:     Keith Busch <kbusch@kernel.org>
Subject: [PATCH 1/3] io_uring: split req init from submit
Date:   Fri, 28 Jul 2023 13:14:47 -0700
Message-ID: <20230728201449.3350962-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tRTx517z3bdh_Svg9bQC56FITLQpdaU8
X-Proofpoint-GUID: tRTx517z3bdh_Svg9bQC56FITLQpdaU8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Split the req initialization and link handling from the submit. This
simplifies the submit path since everything that can fail is separate
from it, and makes it easier to create batched submissions later.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/io_uring.c | 66 +++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d585171560ce5..818b2d1661c5e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2279,18 +2279,20 @@ static __cold int io_submit_fail_init(const struc=
t io_uring_sqe *sqe,
 	return 0;
 }
=20
-static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb=
 *req,
-			 const struct io_uring_sqe *sqe)
-	__must_hold(&ctx->uring_lock)
+static inline void io_submit_sqe(struct io_kiocb *req)
 {
-	struct io_submit_link *link =3D &ctx->submit_state.link;
-	int ret;
+	trace_io_uring_submit_req(req);
=20
-	ret =3D io_init_req(ctx, req, sqe);
-	if (unlikely(ret))
-		return io_submit_fail_init(sqe, req, ret);
+	if (unlikely(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))
+		io_queue_sqe_fallback(req);
+	else
+		io_queue_sqe(req);
+}
=20
-	trace_io_uring_submit_req(req);
+static int io_setup_link(struct io_submit_link *link, struct io_kiocb **=
orig)
+{
+	struct io_kiocb *req =3D *orig;
+	int ret;
=20
 	/*
 	 * If we already have a head request, queue this one for async
@@ -2300,35 +2302,28 @@ static inline int io_submit_sqe(struct io_ring_ct=
x *ctx, struct io_kiocb *req,
 	 * conditions are true (normal request), then just queue it.
 	 */
 	if (unlikely(link->head)) {
+		*orig =3D NULL;
+
 		ret =3D io_req_prep_async(req);
 		if (unlikely(ret))
-			return io_submit_fail_init(sqe, req, ret);
+			return ret;
=20
 		trace_io_uring_link(req, link->head);
 		link->last->link =3D req;
 		link->last =3D req;
-
 		if (req->flags & IO_REQ_LINK_FLAGS)
 			return 0;
+
 		/* last request of the link, flush it */
-		req =3D link->head;
+		*orig =3D link->head;
 		link->head =3D NULL;
-		if (req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))
-			goto fallback;
-
-	} else if (unlikely(req->flags & (IO_REQ_LINK_FLAGS |
-					  REQ_F_FORCE_ASYNC | REQ_F_FAIL))) {
-		if (req->flags & IO_REQ_LINK_FLAGS) {
-			link->head =3D req;
-			link->last =3D req;
-		} else {
-fallback:
-			io_queue_sqe_fallback(req);
-		}
-		return 0;
+	} else if (unlikely(req->flags & IO_REQ_LINK_FLAGS)) {
+	        link->head =3D req;
+	        link->last =3D req;
+		*orig =3D NULL;
+	        return 0;
 	}
=20
-	io_queue_sqe(req);
 	return 0;
 }
=20
@@ -2412,9 +2407,10 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, co=
nst struct io_uring_sqe **sqe)
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
+	struct io_submit_link *link =3D &ctx->submit_state.link;
 	unsigned int entries =3D io_sqring_entries(ctx);
 	unsigned int left;
-	int ret;
+	int ret, err;
=20
 	if (unlikely(!entries))
 		return 0;
@@ -2434,12 +2430,24 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsig=
ned int nr)
 			break;
 		}
=20
+		err =3D io_init_req(ctx, req, sqe);
+		if (unlikely(err))
+			goto error;
+
+		err =3D io_setup_link(link, &req);
+		if (unlikely(err))
+			goto error;
+
+		if (likely(req))
+			io_submit_sqe(req);
+		continue;
+error:
 		/*
 		 * Continue submitting even for sqe failure if the
 		 * ring was setup with IORING_SETUP_SUBMIT_ALL
 		 */
-		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
-		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
+		err =3D io_submit_fail_init(sqe, req, err);
+		if (err && !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
 			left--;
 			break;
 		}
--=20
2.34.1

