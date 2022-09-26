Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A665EAA19
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiIZPRm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbiIZPQt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:16:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DB55FEA
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:26 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28PLQvO7016119
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hT+4gTMKePBBA3f8O2UIS1QlPHJ9LqcravhbpAUEnQE=;
 b=jk7+V31/g01oHQ/r3JvRVUhUaxcRLHZA7Bl9hKqDfd1FLMkmNlqO2uZlThMXCOFpC9Nn
 jA5Enqtxi/QSnKi5uJM/zXElDYmyniq5eSSoZ2/bj4kRxJ9avrK5NOXTof07Nk/FqwWt
 6+xYBO6rig+JIZEeaQ9zE2xiLQQeJWAYX/o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jt174jsfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:25 -0700
Received: from twshared14494.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 07:03:24 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 85CB16AEBEF8; Mon, 26 Sep 2022 07:03:17 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 2/3] io_uring: simplify __io_uring_add_tctx_node
Date:   Mon, 26 Sep 2022 07:03:03 -0700
Message-ID: <20220926140304.1973990-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220926140304.1973990-1-dylany@fb.com>
References: <20220926140304.1973990-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: jeIo3RHjljbc5fzlqcRKnw_xagsKDF-a
X-Proofpoint-ORIG-GUID: jeIo3RHjljbc5fzlqcRKnw_xagsKDF-a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove submitter parameter from __io_uring_add_tctx_node.

It was only called from one place, and we can do that logic in that one
place.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c |  2 +-
 io_uring/tctx.c     | 30 ++++++++++++++++++++----------
 io_uring/tctx.h     |  6 ++++--
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3f40defd721d..57315a49b85c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3183,7 +3183,7 @@ static int io_uring_install_fd(struct io_ring_ctx *=
ctx, struct file *file)
 	if (fd < 0)
 		return fd;
=20
-	ret =3D __io_uring_add_tctx_node(ctx, false);
+	ret =3D __io_uring_add_tctx_node(ctx);
 	if (ret) {
 		put_unused_fd(fd);
 		return ret;
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 7f97d97fef0a..dd0205fcdb13 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -105,18 +105,12 @@ static int io_register_submitter(struct io_ring_ctx=
 *ctx)
 	return ret;
 }
=20
-int __io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool submitter)
+int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx =3D current->io_uring;
 	struct io_tctx_node *node;
 	int ret;
=20
-	if ((ctx->flags & IORING_SETUP_SINGLE_ISSUER) && submitter) {
-		ret =3D io_register_submitter(ctx);
-		if (ret)
-			return ret;
-	}
-
 	if (unlikely(!tctx)) {
 		ret =3D io_uring_alloc_task_context(current, ctx);
 		if (unlikely(ret))
@@ -150,8 +144,24 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx=
, bool submitter)
 		list_add(&node->ctx_node, &ctx->tctx_list);
 		mutex_unlock(&ctx->uring_lock);
 	}
-	if (submitter)
-		tctx->last =3D ctx;
+	return 0;
+}
+
+int __io_uring_add_tctx_node_from_submit(struct io_ring_ctx *ctx)
+{
+	int ret;
+
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
+		ret =3D io_register_submitter(ctx);
+		if (ret)
+			return ret;
+	}
+
+	ret =3D __io_uring_add_tctx_node(ctx);
+	if (ret)
+		return ret;
+
+	current->io_uring->last =3D ctx;
 	return 0;
 }
=20
@@ -259,7 +269,7 @@ int io_ringfd_register(struct io_ring_ctx *ctx, void =
__user *__arg,
 		return -EINVAL;
=20
 	mutex_unlock(&ctx->uring_lock);
-	ret =3D __io_uring_add_tctx_node(ctx, false);
+	ret =3D __io_uring_add_tctx_node(ctx);
 	mutex_lock(&ctx->uring_lock);
 	if (ret)
 		return ret;
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index 25974beed4d6..608e96de70a2 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -9,7 +9,8 @@ struct io_tctx_node {
 int io_uring_alloc_task_context(struct task_struct *task,
 				struct io_ring_ctx *ctx);
 void io_uring_del_tctx_node(unsigned long index);
-int __io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool submitter);
+int __io_uring_add_tctx_node(struct io_ring_ctx *ctx);
+int __io_uring_add_tctx_node_from_submit(struct io_ring_ctx *ctx);
 void io_uring_clean_tctx(struct io_uring_task *tctx);
=20
 void io_uring_unreg_ringfd(void);
@@ -27,5 +28,6 @@ static inline int io_uring_add_tctx_node(struct io_ring=
_ctx *ctx)
=20
 	if (likely(tctx && tctx->last =3D=3D ctx))
 		return 0;
-	return __io_uring_add_tctx_node(ctx, true);
+
+	return __io_uring_add_tctx_node_from_submit(ctx);
 }
--=20
2.30.2

