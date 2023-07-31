Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38AD76A214
	for <lists+io-uring@lfdr.de>; Mon, 31 Jul 2023 22:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjGaUju (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 16:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjGaUjt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 16:39:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E20E75
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 13:39:44 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VHWgnB009044
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 13:39:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=0ZnlWyrwd7iATPqd/g0Cn32zm8aOrkPyd6/Aa72Ze+Q=;
 b=imGJYq/iSlRcHb7+HzC6hy9aRAIlqW2OUn1cLGJO9wRxkabKZbyFuA4o707jVEEhx5/L
 0Gintazknl4ttSWO31KK8dsNYgSh3Y20/sMlCNxLXvVW2qPd8DUiCeorEPdkUGaQSBMz
 oxPVyJ1TIYLir5+oXfg6QVYfxPW7HJi+r9HWEJDfsDXN9yO5lM5ehKRqV9XE4iPNaV5Y
 0lULIT0cI/Dh6LTiZ2uaHhq2mdrSCEoDk8qHlc2OpkHoeurCqZZ9VV7SdojoJX7EPnPP
 wP/EwnJkuhrW1a9gKE2qEKVyAbcjdOU3+QXa5VanDMHlB1PJlT0YNv3U1z64ltTNp3KS nw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3s4xtmu32v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 13:39:43 -0700
Received: from twshared3345.02.ash8.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 13:39:40 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 94EE01C6CD51A; Mon, 31 Jul 2023 13:39:33 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC:     Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3] io_uring: set plug tags for same file
Date:   Mon, 31 Jul 2023 13:39:32 -0700
Message-ID: <20230731203932.2083468-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 0HtWong3Ln0gmKfRurprDIP5yh0Db-e2
X-Proofpoint-ORIG-GUID: 0HtWong3Ln0gmKfRurprDIP5yh0Db-e2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_15,2023-07-31_02,2023-05-22_02
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
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
match the file descriptor of the first seen for this optimization. This
avoids have to call the unlikely "blk_mq_free_plug_rqs()" at the end of
a submission when multiple devices are used in a batch.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
v2->v3

  The previous attempted to split the setup and submit further, but was
  requested to go back to this simpler version.=20

 block/blk-core.c               | 49 +++++++++++++++-------------------
 block/blk-mq.c                 |  6 +++--
 include/linux/blkdev.h         |  6 -----
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 37 ++++++++++++++++++-------
 5 files changed, 54 insertions(+), 45 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 99d8b9812b18f..b8f8aa1376e60 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1043,32 +1043,6 @@ int kblockd_mod_delayed_work_on(int cpu, struct de=
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
@@ -1094,7 +1068,28 @@ void blk_start_plug_nr_ios(struct blk_plug *plug, =
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
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d50b1d62a3d92..fc75fb9ef34ed 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -523,7 +523,8 @@ static struct request *blk_mq_rq_cache_fill(struct re=
quest_queue *q,
 		.q		=3D q,
 		.flags		=3D flags,
 		.cmd_flags	=3D opf,
-		.nr_tags	=3D plug->nr_ios,
+		.nr_tags	=3D min_t(unsigned int, plug->nr_ios,
+					BLK_MAX_REQUEST_COUNT),
 		.cached_rq	=3D &plug->cached_rq,
 	};
 	struct request *rq;
@@ -2859,7 +2860,8 @@ static struct request *blk_mq_get_new_requests(stru=
ct request_queue *q,
 	rq_qos_throttle(q, bio);
=20
 	if (plug) {
-		data.nr_tags =3D plug->nr_ios;
+		data.nr_tags =3D min_t(unsigned int, plug->nr_ios,
+				     BLK_MAX_REQUEST_COUNT);
 		plug->nr_ios =3D 1;
 		data.cached_rq =3D &plug->cached_rq;
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ed44a997f629f..a2a022957cd96 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -984,7 +984,6 @@ struct blk_plug_cb {
 extern struct blk_plug_cb *blk_check_plugged(blk_plug_cb_fn unplug,
 					     void *data, int size);
 extern void blk_start_plug(struct blk_plug *);
-extern void blk_start_plug_nr_ios(struct blk_plug *, unsigned short);
 extern void blk_finish_plug(struct blk_plug *);
=20
 void __blk_flush_plug(struct blk_plug *plug, bool from_schedule);
@@ -1000,11 +999,6 @@ long nr_blockdev_pages(void);
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
index f04ce513fadba..109d4530bccbf 100644
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
index 135da2fd0edab..36f45d234fe49 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2195,18 +2195,25 @@ static int io_init_req(struct io_ring_ctx *ctx, s=
truct io_kiocb *req,
 		return -EINVAL;
=20
 	if (def->needs_file) {
-		struct io_submit_state *state =3D &ctx->submit_state;
-
 		req->cqe.fd =3D READ_ONCE(sqe->fd);
=20
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
 		 * target is potentially a read/write to block based storage.
 		 */
-		if (state->need_plug && def->plug) {
-			state->plug_started =3D true;
-			state->need_plug =3D false;
-			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
+	        if (def->plug) {
+			struct io_submit_state *state =3D &ctx->submit_state;
+
+			if (state->need_plug) {
+			        state->plug_started =3D true;
+			        state->need_plug =3D false;
+			        state->fd =3D req->cqe.fd;
+			        blk_start_plug(&state->plug);
+			} else if (state->plug_started &&
+			           state->fd =3D=3D req->cqe.fd &&
+			           !state->link.head) {
+			        state->plug.nr_ios++;
+			}
 		}
 	}
=20
@@ -2267,7 +2274,8 @@ static __cold int io_submit_fail_init(const struct =
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
@@ -2315,7 +2323,7 @@ static inline int io_submit_sqe(struct io_ring_ctx =
*ctx, struct io_kiocb *req,
 		return 0;
 	}
=20
-	io_queue_sqe(req);
+	wq_list_add_tail(&req->comp_list, req_list);
 	return 0;
 }
=20
@@ -2400,6 +2408,8 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
 	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries =3D io_sqring_entries(ctx);
+	struct io_wq_work_list req_list;
+	struct io_kiocb *req;
 	unsigned int left;
 	int ret;
=20
@@ -2410,9 +2420,9 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
 	io_get_task_refs(left);
 	io_submit_state_start(&ctx->submit_state, left);
=20
+	INIT_WQ_LIST(&req_list);
 	do {
 		const struct io_uring_sqe *sqe;
-		struct io_kiocb *req;
=20
 		if (unlikely(!io_alloc_req(ctx, &req)))
 			break;
@@ -2425,13 +2435,20 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsig=
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
+		req =3D container_of(req_list.first, struct io_kiocb, comp_list);
+		req_list.first =3D req->comp_list.next;
+		req->comp_list.next =3D NULL;
+		io_queue_sqe(req);
+	}
+
 	if (unlikely(left)) {
 		ret -=3D left;
 		/* try again if it submitted nothing and can't allocate a req */
--=20
2.34.1

