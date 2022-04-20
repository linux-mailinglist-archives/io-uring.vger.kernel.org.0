Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6871D509024
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348276AbiDTTR6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349026AbiDTTR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:17:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DF0AE50
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:10 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23KILUkO020558
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=C3ALyklzyIbY7S44tkM5jyPp+ULBNFImT2bQDYk+Uo4=;
 b=BC5+jiS7JChDodjXsBRCYAo8KpjA/1KhHOvwbSU72jTACQ/QjskpGe9xSRWzDD7j/yfI
 AzW2J8jKmM5cuDDOm/16CdLjUGcgEIO7aFsGdnE7piwnxovuvRCgwrS+pL1eeNDqMOpx
 sfY9bUXJZYRNeSGU85udbsdLhsc6R58KCEY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fhn4j4emh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:09 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:09 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A48B1DE0C410; Wed, 20 Apr 2022 12:14:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 06/12] io_uring: modify io_get_cqe for CQE32
Date:   Wed, 20 Apr 2022 12:14:45 -0700
Message-ID: <20220420191451.2904439-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191451.2904439-1-shr@fb.com>
References: <20220420191451.2904439-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: XUNgB2MjZmE0YCu4t6vB3jX-iwDLzQ95
X-Proofpoint-ORIG-GUID: XUNgB2MjZmE0YCu4t6vB3jX-iwDLzQ95
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
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
---
 fs/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c93a9353c88d..bd352815b9e7 100644
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
@@ -1922,12 +1926,13 @@ static noinline struct io_uring_cqe *__io_get_cqe=
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
-	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
+	if (likely(ctx->cqe_cached < ctx->cqe_sentinel && !(ctx->flags & IORING=
_SETUP_CQE32))) {
 		ctx->cached_cq_tail++;
 		return ctx->cqe_cached++;
 	}
--=20
2.30.2

