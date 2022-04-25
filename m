Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B3550E839
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244396AbiDYS3O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244421AbiDYS3L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:29:11 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD6927B1A
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:04 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHP6Xk005303
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=qjQT4TdGjYQP+fFIUJysux2Jl90fDRSvqrS2tPCEO04=;
 b=GDhEtA7GXgSc2FOdMQgDbfj1EIqUdKPmt08O9c+9BMMVvyNLtSkwcr/GLi/YghbYdcEV
 pPHd43t8PDXhIlvQYTAu9fTsibrI/XCfHM4sSKL4GtrWy3rPsTAgnS5B0xUm/hsB1PyU
 HWnUiGNUabHFT3Akl6SxhCy9EJivLORc3TY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmf9puxy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:03 -0700
Received: from twshared16483.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:26:02 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 3E5E8E1F2A5F; Mon, 25 Apr 2022 11:25:41 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v3 06/12] io_uring: modify io_get_cqe for CQE32
Date:   Mon, 25 Apr 2022 11:25:24 -0700
Message-ID: <20220425182530.2442911-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425182530.2442911-1-shr@fb.com>
References: <20220425182530.2442911-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: AFF7RUE5XY2woM26kGF7hP0o1mQVNVYp
X-Proofpoint-GUID: AFF7RUE5XY2woM26kGF7hP0o1mQVNVYp
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

Modify accesses to the CQE array to take large CQE's into account. The
index needs to be shifted by one for large CQE's.

Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
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

