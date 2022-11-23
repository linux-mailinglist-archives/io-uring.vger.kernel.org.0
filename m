Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A9E635B08
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237674AbiKWLHq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbiKWLHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:07:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE03B7A
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:55 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2ANB5YK9007011
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=AdN0224fAZ77xd7LmyPfs1YCRBOz2SV+0/LexFe/noo=;
 b=SPEXEkeNZWZpriCIKj5FSneorTsbTodm8J4l1D5vJUQIBC83FHRvU0T2oCZv31jHAENk
 2rInh9PDeWsYXpJkL1x6+8THUOsaVvEV75KVAnIw6Wx/+v0c+m5y5olHgf/IUKk9iZN2
 QMFAARUzGocQUohFWymoklvWjwiIGtWtN9HJ/kUSMTP3wjIlidEtw20x/qFmBgsTn3bS
 BCMqQ0j0J8dON+8tyE3P3opOsG3DdMDLjXN99aq9eamZMM2fdrXAV0UpFMZAv0AwaLhH
 oZRH/c7EUNaijbMNvri1D7nrbOWzHJQxZ5toUwlJtWfgIfUc33saadx17ajA6ijrKW9E 1w== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3m1c7ra43e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:54 -0800
Received: from twshared0705.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:53 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 8E91FA0804D6; Wed, 23 Nov 2022 03:06:27 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 08/13] io_uring: allow defer completion for aux posted cqes
Date:   Wed, 23 Nov 2022 03:06:09 -0800
Message-ID: <20221123110614.3297343-9-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 77YBq-kpC80KKXjCzYKsd0BC_bXuTTZh
X-Proofpoint-ORIG-GUID: 77YBq-kpC80KKXjCzYKsd0BC_bXuTTZh
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
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
index 43db84fe001d..39f80d68d31c 100644
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
@@ -1348,6 +1364,9 @@ static void __io_submit_flush_completions(struct io_r=
ing_ctx *ctx)
 	struct io_submit_state *state =3D &ctx->submit_state;
=20
 	io_cq_lock(ctx);
+	/* post must come first to preserve CQE ordering */
+	if (state->cqes_count)
+		__io_flush_post_cqes(ctx);
 	wq_list_for_each(node, prev, &state->compl_reqs) {
 		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
 					    comp_list);
@@ -1357,8 +1376,10 @@ static void __io_submit_flush_completions(struct io_=
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

