Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE9D63754C
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiKXJgm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiKXJgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:41 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EC112294A
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:39 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO7r6NK026397
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=lGhq9H6BOQHa/c7KCccQkOPCfll7ETMh/0j2/9zqCf4=;
 b=AwOxUNVFCz+bP/FRh/NEL8vdW70s2q4prq6EwuCGSUegWtIAtmNhTfuRDh2QP1FJG9TM
 w0XbB7uUN1anEtqqKvegLpTLEX2TeUJoLwizZd+pDoMEUTKdGL0DOf21ZPztlT8aJ6tI
 TvEUZkxhWWzRzQW37nzZOZS1AIeaWru0WWCfB27ZtfNRcd/Wr26FfzxWQfDmk+mfJeq4
 KLngB8RhIeOBhIXIvzCK4fvyvDcjNCm3+cItS0CFpg93bkGYdoMSZ59P0bF1iZUOucK0
 NGyvZw+96Evmbo9g22iwaMYo5UDUY5vNv4JeFSVhFy4Dhwuftg/tU/3FHbrhL7rRGi1Z oA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1cg3s8x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:39 -0800
Received: from twshared7043.05.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:38 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C360BA173A14; Thu, 24 Nov 2022 01:36:20 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 4/9] io_uring: allow defer completion for aux posted cqes
Date:   Thu, 24 Nov 2022 01:35:54 -0800
Message-ID: <20221124093559.3780686-5-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -YVLCDuxVHbCkYTYeHhBj8PMqWd-TCsX
X-Proofpoint-GUID: -YVLCDuxVHbCkYTYeHhBj8PMqWd-TCsX
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Multishot ops cannot use the compl_reqs list as the request must stay in
the poll list, but that means they need to run each completion without
benefiting from batching.

Here introduce batching infrastructure for only small (ie 16 byte)
CQEs. This restriction is ok because there are no use cases posting 32
byte CQEs.

In the ring keep a batch of up to 16 posted results, and flush in the same
way as compl_reqs.

16 was chosen through experimentation on a microbenchmark ([1]), as well
as trying not to increase the size of the ring too much. This increases
the size to 1472 bytes from 1216.

[1]: https://github.com/DylanZA/liburing/commit/9ac66b36bcf4477bfafeff1c5f1=
07896b7ae31cf
Run with $ make -j && ./benchmark/reg.b -s 1 -t 2000 -r 10
Gives results:
baseline	8309 k/s
8		18807 k/s
16		19338 k/s
32		20134 k/s

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 27 ++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f5b687a787a3..accdfecee953 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -174,7 +174,9 @@ struct io_submit_state {
 	bool			plug_started;
 	bool			need_plug;
 	unsigned short		submit_nr;
+	unsigned int		cqes_count;
 	struct blk_plug		plug;
+	struct io_uring_cqe	cqes[16];
 };
=20
 struct io_ev_fd {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cbd271b6188a..53b61b5cde80 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -167,7 +167,8 @@ EXPORT_SYMBOL(io_uring_get_socket);
=20
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
+	    ctx->submit_state.cqes_count)
 		__io_submit_flush_completions(ctx);
 }
=20
@@ -802,6 +803,21 @@ bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user=
_data, s32 res, u32 cflags
 	return false;
 }
=20
+static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_submit_state *state =3D &ctx->submit_state;
+	unsigned int i;
+
+	lockdep_assert_held(&ctx->uring_lock);
+	for (i =3D 0; i < state->cqes_count; i++) {
+		struct io_uring_cqe *cqe =3D &state->cqes[i];
+
+		io_fill_cqe_aux(ctx, cqe->user_data, cqe->res, cqe->flags, true);
+	}
+	state->cqes_count =3D 0;
+}
+
 bool io_post_aux_cqe(struct io_ring_ctx *ctx,
 		     u64 user_data, s32 res, u32 cflags,
 		     bool allow_overflow)
@@ -1325,6 +1341,9 @@ static void __io_submit_flush_completions(struct io_r=
ing_ctx *ctx)
 	struct io_submit_state *state =3D &ctx->submit_state;
=20
 	io_cq_lock(ctx);
+	/* must come first to preserve CQE ordering in failure cases */
+	if (state->cqes_count)
+		__io_flush_post_cqes(ctx);
 	wq_list_for_each(node, prev, &state->compl_reqs) {
 		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
 					    comp_list);
@@ -1334,8 +1353,10 @@ static void __io_submit_flush_completions(struct io_=
ring_ctx *ctx)
 	}
 	io_cq_unlock_post(ctx);
=20
-	io_free_batch_list(ctx, state->compl_reqs.first);
-	INIT_WQ_LIST(&state->compl_reqs);
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
+		io_free_batch_list(ctx, state->compl_reqs.first);
+		INIT_WQ_LIST(&state->compl_reqs);
+	}
 }
=20
 /*
--=20
2.30.2

