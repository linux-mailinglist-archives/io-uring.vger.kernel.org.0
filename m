Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D402561630
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbiF3JVV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiF3JVP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:21:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA604F5AC
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:09 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U4dOAL001285
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/4GLmyjWNgSDAU2q7NAl1jE/TW8cFmkpQXoCGI8PVNA=;
 b=U4GWugo1lGYTf8n1ZJEyHAPbzQwSlqUZgXExyidlKzaDiyt5DyJM+m4F2MqTwIY6S1cP
 2RSP4h3HsVYQi5mb7WFuoNf1yF3fPZDLnv3LQ7Z6AvpymurjSrQFarcYRVaNAT4LUYvc
 v9TVmP2iPFeOLFUZecoeDOPCPNzwMTUGVzM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h150e9545-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:07 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:21:04 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id DEFC52599FE6; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 12/12] io_uring: only trace one of complete or overflow
Date:   Thu, 30 Jun 2022 02:12:31 -0700
Message-ID: <20220630091231.1456789-13-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: uS4fOPLW6Kv_GEIIeS_k9E1GfXzb8kOY
X-Proofpoint-ORIG-GUID: uS4fOPLW6Kv_GEIIeS_k9E1GfXzb8kOY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In overflow we see a duplcate line in the trace, and in some cases 3
lines (if initial io_post_aux_cqe fails).
Instead just trace once for each CQE

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c |  3 ++-
 io_uring/io_uring.h | 10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 523b6ebad15a..caf979cd4327 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -742,7 +742,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx,
 	struct io_uring_cqe *cqe;
=20
 	ctx->cq_extra++;
-	trace_io_uring_complete(ctx, NULL, user_data, res, cflags, 0, 0);
=20
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
@@ -751,6 +750,8 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx,
 	 */
 	cqe =3D io_get_cqe(ctx);
 	if (likely(cqe)) {
+		trace_io_uring_complete(ctx, NULL, user_data, res, cflags, 0, 0);
+
 		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e022d71c177a..868f45d55543 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -101,10 +101,6 @@ static inline bool __io_fill_cqe_req(struct io_ring_=
ctx *ctx,
 {
 	struct io_uring_cqe *cqe;
=20
-	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags,
-				(req->flags & REQ_F_CQE32_INIT) ? req->extra1 : 0,
-				(req->flags & REQ_F_CQE32_INIT) ? req->extra2 : 0);
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
 	 * submission (by quite a lot). Increment the overflow count in
@@ -113,6 +109,12 @@ static inline bool __io_fill_cqe_req(struct io_ring_=
ctx *ctx,
 	cqe =3D io_get_cqe(ctx);
 	if (unlikely(!cqe))
 		return io_req_cqe_overflow(req);
+
+	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
+				req->cqe.res, req->cqe.flags,
+				(req->flags & REQ_F_CQE32_INIT) ? req->extra1 : 0,
+				(req->flags & REQ_F_CQE32_INIT) ? req->extra2 : 0);
+
 	memcpy(cqe, &req->cqe, sizeof(*cqe));
=20
 	if (ctx->flags & IORING_SETUP_CQE32) {
--=20
2.30.2

