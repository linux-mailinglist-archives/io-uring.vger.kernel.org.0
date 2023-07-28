Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142C87676EB
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 22:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjG1UUO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 16:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjG1UUM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 16:20:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075CE46A0
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 13:19:46 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36SK148e005583
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 13:19:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=IvrblMJCemFaRJq0nFN/OA8NPGjjsNq02SzUiRrfWdo=;
 b=aI5s+PKMuW5zPnyumeVh62RVi5/qlCVUr011SVek8NB7AMAh5Z5VHwZLLDAUCAFpO3CC
 02m/BRnV8LEDJXWibJin8vkhiVwf866F6dotB3xmHir9nmxlZHZKDDsre3BFo0yR2WhT
 rze6h4biwDm4epWzlI2qTPv2V3IULTLMrp85l0G2dQV/8DBXWL/AeiiSL1mKEqUa/c7X
 lEqkHma4p8+bYQ1xkrx2NO45hsK6tGpv+1yHTmoa/Rg3I4QiG97U80j6he2HLnK4RWTv
 HxDQgTJTDSRJUOeYkBUVj1JkhfFbCoSQh6tt43WMORm5ZKsSOBVoY86W1hY3F9kAMJT2 rQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3s3v48n11j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 13:19:14 -0700
Received: from twshared19625.39.frc1.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 28 Jul 2023 13:19:11 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 584B31C47B5E8; Fri, 28 Jul 2023 13:16:20 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC:     Keith Busch <kbusch@kernel.org>
Subject: [PATCH 3/3] io_uring: set plug tags for same file
Date:   Fri, 28 Jul 2023 13:14:49 -0700
Message-ID: <20230728201449.3350962-3-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230728201449.3350962-1-kbusch@meta.com>
References: <20230728201449.3350962-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 6KnQd3D0gScbynAOVBX2CgLgeQ55FLWX
X-Proofpoint-ORIG-GUID: 6KnQd3D0gScbynAOVBX2CgLgeQ55FLWX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
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
match the file descriptor of the first seen for this optimization. This
avoids have to call the unlikely "blk_mq_free_plug_rqs()" at the end of
a submission when multiple devices are used in a batch.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-core.c               | 49 +++++++++++++++-------------------
 block/blk-mq.c                 |  6 +++--
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 19 ++++++++-----
 4 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 90de50082146a..72523a983c419 100644
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
index f14b8669ac69f..1e18ccd7d1376 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -524,7 +524,8 @@ static struct request *blk_mq_rq_cache_fill(struct re=
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
@@ -2867,7 +2868,8 @@ static struct request *blk_mq_get_new_requests(stru=
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
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 598553877fc25..6d922e7749989 100644
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
index 5434aef0a8ef7..379e41b53efde 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2209,18 +2209,25 @@ static int io_init_req(struct io_ring_ctx *ctx, s=
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
+		if (def->plug) {
+			struct io_submit_state *state =3D &ctx->submit_state;
+
+			if (state->need_plug) {
+				state->plug_started =3D true;
+				state->need_plug =3D false;
+				state->fd =3D req->cqe.fd;
+				blk_start_plug(&state->plug);
+			} else if (state->plug_started &&
+				   state->fd =3D=3D req->cqe.fd &&
+				   !state->link.head) {
+				state->plug.nr_ios++;
+			}
 		}
 	}
=20
--=20
2.34.1

