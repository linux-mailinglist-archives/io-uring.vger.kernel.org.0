Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF50E50E836
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244379AbiDYS26 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240345AbiDYS24 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:28:56 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606D11CFF4
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:51 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 23PHP73h022098
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/N/gNxRBe/NikFr05Gsxl6dhm/hRfDmfZb/uVTIY1qo=;
 b=QzVz9gKydavHWhFK6YAF1Wptd+D3KC5YP22PIgJNT83LNZ5ObyT9kdaq5OjC+RdiFzNS
 Gx109TZ5Hu8NktMf+XkSjWRvvuX/n9tfo+pHNsjjjLw+udAL4xwhbRvhkkFWVy6evuCz
 z6d5IpNWDUUfsCBPIAZjsObu9K4syJnQDGE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fmd4rma81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:51 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:25:49 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 2FEFEE1F2A5B; Mon, 25 Apr 2022 11:25:41 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v3 04/12] io_uring: add CQE32 setup processing
Date:   Mon, 25 Apr 2022 11:25:22 -0700
Message-ID: <20220425182530.2442911-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425182530.2442911-1-shr@fb.com>
References: <20220425182530.2442911-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wfS_TOSWvGm94cT-2LyBJW3TLUX0ib-f
X-Proofpoint-GUID: wfS_TOSWvGm94cT-2LyBJW3TLUX0ib-f
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

This adds two new function to setup and fill the CQE32 result structure.

Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9712483d3a17..8cb51676d38d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2175,12 +2175,70 @@ static inline bool __io_fill_cqe_req_filled(struc=
t io_ring_ctx *ctx,
 					req->cqe.res, req->cqe.flags);
 }
=20
+static inline bool __io_fill_cqe32_req_filled(struct io_ring_ctx *ctx,
+					      struct io_kiocb *req)
+{
+	struct io_uring_cqe *cqe;
+	u64 extra1 =3D req->extra1;
+	u64 extra2 =3D req->extra2;
+
+	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
+				req->cqe.res, req->cqe.flags);
+
+	/*
+	 * If we can't get a cq entry, userspace overflowed the
+	 * submission (by quite a lot). Increment the overflow count in
+	 * the ring.
+	 */
+	cqe =3D io_get_cqe(ctx);
+	if (likely(cqe)) {
+		memcpy(cqe, &req->cqe, sizeof(struct io_uring_cqe));
+		cqe->big_cqe[0] =3D extra1;
+		cqe->big_cqe[1] =3D extra2;
+		return true;
+	}
+
+	return io_cqring_event_overflow(ctx, req->cqe.user_data,
+					req->cqe.res, req->cqe.flags);
+}
+
 static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 =
cflags)
 {
 	trace_io_uring_complete(req->ctx, req, req->cqe.user_data, res, cflags)=
;
 	return __io_fill_cqe(req->ctx, req->cqe.user_data, res, cflags);
 }
=20
+static inline void __io_fill_cqe32_req(struct io_kiocb *req, s32 res, u3=
2 cflags,
+				u64 extra1, u64 extra2)
+{
+	struct io_ring_ctx *ctx =3D req->ctx;
+	struct io_uring_cqe *cqe;
+
+	if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_CQE32)))
+		return;
+	if (req->flags & REQ_F_CQE_SKIP)
+		return;
+
+	trace_io_uring_complete(ctx, req, req->cqe.user_data, res, cflags);
+
+	/*
+	 * If we can't get a cq entry, userspace overflowed the
+	 * submission (by quite a lot). Increment the overflow count in
+	 * the ring.
+	 */
+	cqe =3D io_get_cqe(ctx);
+	if (likely(cqe)) {
+		WRITE_ONCE(cqe->user_data, req->cqe.user_data);
+		WRITE_ONCE(cqe->res, res);
+		WRITE_ONCE(cqe->flags, cflags);
+		WRITE_ONCE(cqe->big_cqe[0], extra1);
+		WRITE_ONCE(cqe->big_cqe[1], extra2);
+		return;
+	}
+
+	io_cqring_event_overflow(ctx, req->cqe.user_data, res, cflags);
+}
+
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_d=
ata,
 				     s32 res, u32 cflags)
 {
--=20
2.30.2

