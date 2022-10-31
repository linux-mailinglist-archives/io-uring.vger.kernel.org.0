Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE55561383B
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiJaNlx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiJaNlu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:50 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3869101FC
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:49 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFEgX016861
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=TqiMKxYrMMUqwwlhmlCqOkBB81H8vO0REoWfVDEvMWA=;
 b=Kjl2UphPxKZLN05bsex/aEVc8YKGTrAvN7GaMtXr65WWJg8qIq9dNpvvUwV5ji6aJfxW
 n1wIG/u5DAUPw9fnty7OJSfa0fkoJiapgON5hjvkHu2f4ziflbh98nD96S5TStvmSEeF
 dl4wAmAHqbYewd9g1CphDTBrGGMiq8d6BkLsX4zkXLIBPrYAa+Vq9PWmjwOvfLn3A+ul
 ysYzPeBbISrJHqBDLtgu0ZwyBPfZAszYI79WyJfU6wbJZg7t9jZBf9aoExcb3xk6U+zx
 WS5T7R8UeDgVmFt4TgTSJtrZPvfWDcM9gt7NTMRNTUwWoN/dFRNdiygwTfXY1FLG8z9A 0g== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh20vxbnf-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700
Received: from twshared6758.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id B49508A1964C; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 03/12] io_uring: support retargeting rsrc on requests in the io-wq
Date:   Mon, 31 Oct 2022 06:41:17 -0700
Message-ID: <20221031134126.82928-4-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Jb1XR4dv7t-D6mz03ERxvNr3Kx7o78R6
X-Proofpoint-ORIG-GUID: Jb1XR4dv7t-D6mz03ERxvNr3Kx7o78R6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_15,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Requests can be in flight on the io-wq, and can be long lived (for exampl=
e
a double read will get onto the io-wq). So make sure to retarget the rsrc
nodes on those requests.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/rsrc.c | 46 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 106210e0d5d5..8d0d40713a63 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -16,6 +16,7 @@
 #include "openclose.h"
 #include "rsrc.h"
 #include "opdef.h"
+#include "tctx.h"
=20
 struct io_rsrc_update {
 	struct file			*file;
@@ -24,6 +25,11 @@ struct io_rsrc_update {
 	u32				offset;
 };
=20
+struct io_retarget_data {
+	struct io_ring_ctx		*ctx;
+	unsigned int			refs;
+};
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec =
*iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage);
@@ -250,11 +256,42 @@ static void io_rsrc_retarget_schedule(struct io_rin=
g_ctx *ctx)
 	ctx->rsrc_retarget_scheduled =3D true;
 }
=20
+static void io_retarget_rsrc_wq_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req =3D container_of(work, struct io_kiocb, work);
+	struct io_retarget_data *rd =3D data;
+
+	if (req->ctx !=3D rd->ctx)
+		return;
+
+	rd->refs +=3D io_rsrc_retarget_req(rd->ctx, req);
+}
+
+static void io_rsrc_retarget_wq(struct io_retarget_data *data)
+	__must_hold(&data->ctx->uring_lock)
+{
+	struct io_ring_ctx *ctx =3D data->ctx;
+	struct io_tctx_node *node;
+
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx =3D node->task->io_uring;
+
+		if (!tctx->io_wq)
+			continue;
+
+		io_wq_for_each(tctx->io_wq, io_retarget_rsrc_wq_cb, data);
+	}
+}
+
 static void __io_rsrc_retarget_work(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_rsrc_node *node;
-	unsigned int refs;
+	struct io_retarget_data data =3D {
+		.ctx =3D ctx,
+		.refs =3D 0
+	};
+	unsigned int poll_refs;
 	bool any_waiting;
=20
 	if (!ctx->rsrc_node)
@@ -273,10 +310,11 @@ static void __io_rsrc_retarget_work(struct io_ring_=
ctx *ctx)
 	if (!any_waiting)
 		return;
=20
-	refs =3D io_rsrc_retarget_table(ctx, &ctx->cancel_table);
-	refs +=3D io_rsrc_retarget_table(ctx, &ctx->cancel_table_locked);
+	poll_refs =3D io_rsrc_retarget_table(ctx, &ctx->cancel_table);
+	poll_refs +=3D io_rsrc_retarget_table(ctx, &ctx->cancel_table_locked);
+	io_rsrc_retarget_wq(&data);
=20
-	ctx->rsrc_cached_refs -=3D refs;
+	ctx->rsrc_cached_refs -=3D (poll_refs + data.refs);
 	while (unlikely(ctx->rsrc_cached_refs < 0))
 		io_rsrc_refs_refill(ctx);
 }
--=20
2.30.2

