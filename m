Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5868C6F6FE3
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 18:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjEDQYn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 12:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjEDQYm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 12:24:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FC72736
        for <io-uring@vger.kernel.org>; Thu,  4 May 2023 09:24:39 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344DUQHm004507
        for <io-uring@vger.kernel.org>; Thu, 4 May 2023 09:24:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=AaYuBOaYpT66nE1D2HqpGq7fb6dTESrUtz4Epo1lLdc=;
 b=NLTO6OY+Xpa4/jvCOT9NbpNZoaoWvkUTqnZ5ZJmmsncTqF4GDleh87uzuuqWg2OSb6zr
 KWABcOBArAfU6HESkHPOjhp/NigChDqaYQaKYidL0AuzQqmXO/fX/DNRQpw9rn9HLcln
 W+ZMQl+n9IsOgFm+6nj/+XrVPlzeewGi2a7085DGuhd1KGjAtP/QW7rsBHQf5XS2WuE2
 UVC+hiauIuTlKRQ08uoVQI73OkCO/JV3SuPiBPQ9ApzbJ32LKARdl3JPexL5crFTtFEf
 rvrnm5SVIvV2SftK2zBNkQ9giK74tFgth/tVPqj0l9jRBaHFttmkYKl2eTgNtkPBatQL Ug== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qbvxxyf7u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 04 May 2023 09:24:39 -0700
Received: from twshared52232.38.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 4 May 2023 09:24:37 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 1CF7A17BB4F6A; Thu,  4 May 2023 09:24:28 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>
CC:     Keith Busch <kbusch@kernel.org>
Subject: [PATCH] io_uring: set plug tags for same file
Date:   Thu, 4 May 2023 09:24:27 -0700
Message-ID: <20230504162427.1099469-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NfXCk7kvq4GRcwf1YmuW6G7OCMDGrBNv
X-Proofpoint-GUID: NfXCk7kvq4GRcwf1YmuW6G7OCMDGrBNv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_10,2023-05-04_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

io_uring tries to optimize allocating tags by hinting to the plug how
many it expects to need for a batch instead of allocating each tag
individually. But io_uring submission queueus may have a mix of many
devices for io, so the number of io's counted may be overestimated. This
can lead to allocating too many tags, which adds overhead to finding
that many contiguous tags, freeing up the ones we didn't use, and may
starve out other users that can actually use them.

When starting a new batch of uring commands, count only commands that
match the file descriptor of the first seen for this optimization.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-core.c               | 49 +++++++++++++++-------------------
 include/linux/blkdev.h         |  6 -----
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 24 ++++++++++++++---
 4 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 00c74330fa92c..28f1755f37901 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1039,32 +1039,6 @@ int kblockd_mod_delayed_work_on(int cpu, struct de=
layed_work *dwork,
 }
 EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
=20
-void blk_start_plug_nr_ios(struct blk_plug *plug, unsigned short nr_ios)
-{
-	struct task_struct *tsk =3D current;
-
-	/*
-	 * If this is a nested plug, don't actually assign it.
-	 */
-	if (tsk->plug)
-		return;
-
-	plug->mq_list =3D NULL;
-	plug->cached_rq =3D NULL;
-	plug->nr_ios =3D min_t(unsigned short, nr_ios, BLK_MAX_REQUEST_COUNT);
-	plug->rq_count =3D 0;
-	plug->multiple_queues =3D false;
-	plug->has_elevator =3D false;
-	plug->nowait =3D false;
-	INIT_LIST_HEAD(&plug->cb_list);
-
-	/*
-	 * Store ordering should not be needed here, since a potential
-	 * preempt will imply a full memory barrier
-	 */
-	tsk->plug =3D plug;
-}
-
 /**
  * blk_start_plug - initialize blk_plug and track it inside the task_str=
uct
  * @plug:	The &struct blk_plug that needs to be initialized
@@ -1090,7 +1064,28 @@ void blk_start_plug_nr_ios(struct blk_plug *plug, =
unsigned short nr_ios)
  */
 void blk_start_plug(struct blk_plug *plug)
 {
-	blk_start_plug_nr_ios(plug, 1);
+	struct task_struct *tsk =3D current;
+
+	/*
+	 * If this is a nested plug, don't actually assign it.
+	 */
+	if (tsk->plug)
+		return;
+
+	plug->mq_list =3D NULL;
+	plug->cached_rq =3D NULL;
+	plug->nr_ios =3D 1;
+	plug->rq_count =3D 0;
+	plug->multiple_queues =3D false;
+	plug->has_elevator =3D false;
+	plug->nowait =3D false;
+	INIT_LIST_HEAD(&plug->cb_list);
+
+	/*
+	 * Store ordering should not be needed here, since a potential
+	 * preempt will imply a full memory barrier
+	 */
+	tsk->plug =3D plug;
 }
 EXPORT_SYMBOL(blk_start_plug);
=20
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e3242e67a8e3d..1e7cb26e04cb1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -995,7 +995,6 @@ struct blk_plug_cb {
 extern struct blk_plug_cb *blk_check_plugged(blk_plug_cb_fn unplug,
 					     void *data, int size);
 extern void blk_start_plug(struct blk_plug *);
-extern void blk_start_plug_nr_ios(struct blk_plug *, unsigned short);
 extern void blk_finish_plug(struct blk_plug *);
=20
 void __blk_flush_plug(struct blk_plug *plug, bool from_schedule);
@@ -1011,11 +1010,6 @@ long nr_blockdev_pages(void);
 struct blk_plug {
 };
=20
-static inline void blk_start_plug_nr_ios(struct blk_plug *plug,
-					 unsigned short nr_ios)
-{
-}
-
 static inline void blk_start_plug(struct blk_plug *plug)
 {
 }
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 1b2a20a42413a..dd2fe648b6392 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -175,6 +175,7 @@ struct io_submit_state {
 	bool			need_plug;
 	unsigned short		submit_nr;
 	unsigned int		cqes_count;
+	int			fd;
 	struct blk_plug		plug;
 	struct io_uring_cqe	cqes[16];
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bca7a79efda4..ff60342a8f43b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2276,7 +2276,11 @@ static int io_init_req(struct io_ring_ctx *ctx, st=
ruct io_kiocb *req,
 		if (state->need_plug && def->plug) {
 			state->plug_started =3D true;
 			state->need_plug =3D false;
-			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
+			state->fd =3D req->cqe.fd;
+			blk_start_plug(&state->plug);
+		} else if (state->plug_started && req->cqe.fd =3D=3D state->fd &&
+			   !ctx->submit_state.link.head) {
+			state->plug.nr_ios++;
 		}
 	}
=20
@@ -2337,7 +2341,8 @@ static __cold int io_submit_fail_init(const struct =
io_uring_sqe *sqe,
 }
=20
 static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb=
 *req,
-			 const struct io_uring_sqe *sqe)
+			 const struct io_uring_sqe *sqe,
+			 struct io_wq_work_list *req_list)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link =3D &ctx->submit_state.link;
@@ -2385,7 +2390,7 @@ static inline int io_submit_sqe(struct io_ring_ctx =
*ctx, struct io_kiocb *req,
 		return 0;
 	}
=20
-	io_queue_sqe(req);
+	wq_list_add_tail(&req->comp_list, req_list);
 	return 0;
 }
=20
@@ -2470,6 +2475,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
 	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries =3D io_sqring_entries(ctx);
+	struct io_wq_work_list req_list;
 	unsigned int left;
 	int ret;
=20
@@ -2480,6 +2486,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
 	io_get_task_refs(left);
 	io_submit_state_start(&ctx->submit_state, left);
=20
+	INIT_WQ_LIST(&req_list);
 	do {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
@@ -2495,13 +2502,22 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsig=
ned int nr)
 		 * Continue submitting even for sqe failure if the
 		 * ring was setup with IORING_SETUP_SUBMIT_ALL
 		 */
-		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
+		if (unlikely(io_submit_sqe(ctx, req, sqe, &req_list)) &&
 		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
 			left--;
 			break;
 		}
 	} while (--left);
=20
+	while (req_list.first) {
+		struct io_kiocb *req;
+
+		req =3D container_of(req_list.first, struct io_kiocb, comp_list);
+		req_list.first =3D req->comp_list.next;
+
+		io_queue_sqe(req);
+	}
+
 	if (unlikely(left)) {
 		ret -=3D left;
 		/* try again if it submitted nothing and can't allocate a req */
--=20
2.34.1

