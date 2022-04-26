Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127005106B2
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbiDZSYz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiDZSYz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:24:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4850B344F0
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:47 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQR7L024414
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=EPX2HPuoNVQDdRj8v93tGN4tqP8Nao4brJyuoHLBTDw=;
 b=EsgZJcQn65C7PaEyIf42HoeskP/DWn+eJEhvM0F3k45g7acSyCVNe02Tz5Rf0ADUYrUY
 YeKSQFhAEf6vqwqH0qempD8XUGTxcCWASMg4W8SjMo/GHpK19hbyRvTCDPqyLIB4UJ4U
 aHY9r2CUB5P466u4N5ddv8/fX8FR0m0GsTs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fn1ge0d84-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:46 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 11:21:45 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 6270CE2E5698; Tue, 26 Apr 2022 11:21:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v4 06/12] io_uring: modify io_get_cqe for CQE32
Date:   Tue, 26 Apr 2022 11:21:28 -0700
Message-ID: <20220426182134.136504-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426182134.136504-1-shr@fb.com>
References: <20220426182134.136504-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WmCX0Pj4bZB_Tym86iGg3StVHzh0aLKi
X-Proofpoint-GUID: WmCX0Pj4bZB_Tym86iGg3StVHzh0aLKi
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

Modify accesses to the CQE array to take large CQE's into account. The
index needs to be shifted by one for large CQE's.

Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f300130fd9f0..726238dc65dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1909,8 +1909,12 @@ static noinline struct io_uring_cqe *__io_get_cqe(=
struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings =3D ctx->rings;
 	unsigned int off =3D ctx->cached_cq_tail & (ctx->cq_entries - 1);
+	unsigned int shift =3D 0;
 	unsigned int free, queued, len;
=20
+	if (ctx->flags & IORING_SETUP_CQE32)
+		shift =3D 1;
+
 	/* userspace may cheat modifying the tail, be safe and do min */
 	queued =3D min(__io_cqring_events(ctx), ctx->cq_entries);
 	free =3D ctx->cq_entries - queued;
@@ -1922,15 +1926,26 @@ static noinline struct io_uring_cqe *__io_get_cqe=
(struct io_ring_ctx *ctx)
 	ctx->cached_cq_tail++;
 	ctx->cqe_cached =3D &rings->cqes[off];
 	ctx->cqe_sentinel =3D ctx->cqe_cached + len;
-	return ctx->cqe_cached++;
+	ctx->cqe_cached++;
+	return &rings->cqes[off << shift];
 }
=20
 static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 {
 	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
+		struct io_uring_cqe *cqe =3D ctx->cqe_cached;
+
+		if (ctx->flags & IORING_SETUP_CQE32) {
+			unsigned int off =3D ctx->cqe_cached - ctx->rings->cqes;
+
+			cqe +=3D off;
+		}
+
 		ctx->cached_cq_tail++;
-		return ctx->cqe_cached++;
+		ctx->cqe_cached++;
+		return cqe;
 	}
+
 	return __io_get_cqe(ctx);
 }
=20
--=20
2.30.2

