Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06E4613838
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiJaNlu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiJaNlt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDB8101F8
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFZhB018811
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=bSy4dJny2RPucbubAwvu4900axwZa+ZbHsR4KWJN7lc=;
 b=l9JdGew+kllVLwlkaQRDBV/yyf64Bozyzj0LCBdG/byGiLnUxoLbb/nLukJYQHWO0nwf
 tDGDyjPTqlDJEWUUT8xB2kUy42ycGGS5OTSYi3jiWqK4Jh3OlMq+Jr3F4MnZ9KYBo6yb
 SwegQr35SeP28/59kvG+zJve0BRbt8qypX7F90qOp0tMAvtx5/29Tyr2stwYPJgCRP+q
 1vrz8sL8GJXenUrpBuER5vwaOJVQRhoekrI0psYfP8TXJmDSiClJrUxvvYnXN8PsJBeh
 AT8GiO/d3TEx4WB6Jo6dtQsKxf0gFweaYzxvEmM470L4ScPbiWDnnQxx+KJ7jJausLpY Tg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh1vpwwh9-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700
Received: from twshared6758.06.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A3CDE8A19648; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 01/12] io_uring: infrastructure for retargeting rsrc nodes
Date:   Mon, 31 Oct 2022 06:41:15 -0700
Message-ID: <20221031134126.82928-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: UODCCKAtLr0g9UgiNoqgIT5xzuFo9pLK
X-Proofpoint-ORIG-GUID: UODCCKAtLr0g9UgiNoqgIT5xzuFo9pLK
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

rsrc node cleanup can be indefinitely delayed when there are long lived
requests. For example if a file is located in the same rsrc node as a lon=
g
lived socket with multishot poll, then even if unregistering the file it
will not be closed while the poll request is still active.

Introduce a timer when rsrc node is switched, so that periodically we can
retarget these long lived requests to the newest nodes. That will allow
the old nodes to be cleaned up, freeing resources.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 include/linux/io_uring_types.h |  2 +
 io_uring/io_uring.c            |  1 +
 io_uring/opdef.h               |  1 +
 io_uring/rsrc.c                | 92 ++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h                |  1 +
 5 files changed, 97 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index f5b687a787a3..1d4eff4e632c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -327,6 +327,8 @@ struct io_ring_ctx {
 	struct llist_head		rsrc_put_llist;
 	struct list_head		rsrc_ref_list;
 	spinlock_t			rsrc_ref_lock;
+	struct delayed_work		rsrc_retarget_work;
+	bool				rsrc_retarget_scheduled;
=20
 	struct list_head		io_buffers_pages;
=20
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cc16e39b27f..ea2260359c56 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -320,6 +320,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
 	spin_lock_init(&ctx->rsrc_ref_lock);
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
+	INIT_DELAYED_WORK(&ctx->rsrc_retarget_work, io_rsrc_retarget_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 3efe06d25473..1b72b14cb5ab 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -37,6 +37,7 @@ struct io_op_def {
 	int (*prep_async)(struct io_kiocb *);
 	void (*cleanup)(struct io_kiocb *);
 	void (*fail)(struct io_kiocb *);
+	bool (*can_retarget_rsrc)(struct io_kiocb *);
 };
=20
 extern const struct io_op_def io_op_defs[];
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 55d4ab96fb92..106210e0d5d5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -15,6 +15,7 @@
 #include "io_uring.h"
 #include "openclose.h"
 #include "rsrc.h"
+#include "opdef.h"
=20
 struct io_rsrc_update {
 	struct file			*file;
@@ -204,6 +205,95 @@ void io_rsrc_put_work(struct work_struct *work)
 	}
 }
=20
+
+static unsigned int io_rsrc_retarget_req(struct io_ring_ctx *ctx,
+					 struct io_kiocb *req)
+	__must_hold(&ctx->uring_lock)
+{
+	if (!req->rsrc_node ||
+	     req->rsrc_node =3D=3D ctx->rsrc_node)
+		return 0;
+	if (!io_op_defs[req->opcode].can_retarget_rsrc)
+		return 0;
+	if (!(*io_op_defs[req->opcode].can_retarget_rsrc)(req))
+		return 0;
+
+	io_rsrc_put_node(req->rsrc_node, 1);
+	req->rsrc_node =3D ctx->rsrc_node;
+	return 1;
+}
+
+static unsigned int io_rsrc_retarget_table(struct io_ring_ctx *ctx,
+				   struct io_hash_table *table)
+{
+	unsigned int nr_buckets =3D 1U << table->hash_bits;
+	unsigned int refs =3D 0;
+	struct io_kiocb *req;
+	int i;
+
+	for (i =3D 0; i < nr_buckets; i++) {
+		struct io_hash_bucket *hb =3D &table->hbs[i];
+
+		spin_lock(&hb->lock);
+		hlist_for_each_entry(req, &hb->list, hash_node)
+			refs +=3D io_rsrc_retarget_req(ctx, req);
+		spin_unlock(&hb->lock);
+	}
+	return refs;
+}
+
+static void io_rsrc_retarget_schedule(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	percpu_ref_get(&ctx->refs);
+	mod_delayed_work(system_wq, &ctx->rsrc_retarget_work, 60 * HZ);
+	ctx->rsrc_retarget_scheduled =3D true;
+}
+
+static void __io_rsrc_retarget_work(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_rsrc_node *node;
+	unsigned int refs;
+	bool any_waiting;
+
+	if (!ctx->rsrc_node)
+		return;
+
+	spin_lock_irq(&ctx->rsrc_ref_lock);
+	any_waiting =3D false;
+	list_for_each_entry(node, &ctx->rsrc_ref_list, node) {
+		if (!node->done) {
+			any_waiting =3D true;
+			break;
+		}
+	}
+	spin_unlock_irq(&ctx->rsrc_ref_lock);
+
+	if (!any_waiting)
+		return;
+
+	refs =3D io_rsrc_retarget_table(ctx, &ctx->cancel_table);
+	refs +=3D io_rsrc_retarget_table(ctx, &ctx->cancel_table_locked);
+
+	ctx->rsrc_cached_refs -=3D refs;
+	while (unlikely(ctx->rsrc_cached_refs < 0))
+		io_rsrc_refs_refill(ctx);
+}
+
+void io_rsrc_retarget_work(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx;
+
+	ctx =3D container_of(work, struct io_ring_ctx, rsrc_retarget_work.work)=
;
+
+	mutex_lock(&ctx->uring_lock);
+	ctx->rsrc_retarget_scheduled =3D false;
+	__io_rsrc_retarget_work(ctx);
+	mutex_unlock(&ctx->uring_lock);
+	percpu_ref_put(&ctx->refs);
+}
+
 void io_wait_rsrc_data(struct io_rsrc_data *data)
 {
 	if (data && !atomic_dec_and_test(&data->refs))
@@ -285,6 +375,8 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		atomic_inc(&data_to_kill->refs);
 		percpu_ref_kill(&rsrc_node->refs);
 		ctx->rsrc_node =3D NULL;
+		if (!ctx->rsrc_retarget_scheduled)
+			io_rsrc_retarget_schedule(ctx);
 	}
=20
 	if (!ctx->rsrc_node) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 81445a477622..2b94df8fd9e8 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -54,6 +54,7 @@ struct io_mapped_ubuf {
 };
=20
 void io_rsrc_put_work(struct work_struct *work);
+void io_rsrc_retarget_work(struct work_struct *work);
 void io_rsrc_refs_refill(struct io_ring_ctx *ctx);
 void io_wait_rsrc_data(struct io_rsrc_data *data);
 void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);
--=20
2.30.2

