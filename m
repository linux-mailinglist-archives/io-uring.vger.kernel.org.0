Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB5A72A4EB
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 22:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjFIUpc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 16:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjFIUpc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 16:45:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA76830F8
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 13:45:30 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 359Fks80030945
        for <io-uring@vger.kernel.org>; Fri, 9 Jun 2023 13:45:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=zTgmawKXlZLqbO9qk02nenZbeuA4dRP64zsoMrkzonA=;
 b=TRzXYv/W+UJmPF9hbCQbqHUfI5LvChTzI/4L52aByVtPZ/FVnbHbhF8/069W60BfFi0r
 TPwPRCfSAmhHpuy6Pdp76DnDx7tejgQ2fwFnpsYPqdA+oEca2tGtsg/zD2TUq+Qruqw0
 6bOVc7kOnyN8bl62ur0LiYubTKZLpSlInbYUPrB5AoEyNZq8PxiwOysm243mtiZXHh+T
 SFTgc9zKAMqAtta7PjAcKuvNrhkZIsSKoBo/sPHc3NwlkQh1FAQsSpV1X8qL9jAx9bVP
 7yaUJzt2rwsOri/LLfRPMpksvHvAqbaUBGg4znN731Lyn905Gr2l4f/jAYCQ0ztWNLkU nw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r3us9xk6r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 13:45:30 -0700
Received: from twshared25760.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 13:45:29 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 4523C19D4CC4D; Fri,  9 Jun 2023 13:45:19 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <hch@lst.de>, <axboe@kernel.dk>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 1/2] block: add request polling helper
Date:   Fri, 9 Jun 2023 13:45:16 -0700
Message-ID: <20230609204517.493889-2-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609204517.493889-1-kbusch@meta.com>
References: <20230609204517.493889-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vWr1WFiBFYkn_FQPokmAj11N_aa-CZAt
X-Proofpoint-GUID: vWr1WFiBFYkn_FQPokmAj11N_aa-CZAt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-09_16,2023-06-09_01,2023-05-22_02
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

Provide a direct request polling will for drivers. The interface does
not require a bio, and can skip the overhead associated with polling
those. The biggest gain from skipping the relatively expensive xarray
lookup unnecessary when you already have the request.

With this, the simple rq/qc conversion functions have only one caller
each, so open code this and remove the helpers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-mq.c         | 48 ++++++++++++++++++++++++++++--------------
 include/linux/blk-mq.h |  2 ++
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1749f5890606b..b82b5b3324108 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -49,17 +49,8 @@ static void blk_mq_request_bypass_insert(struct reques=
t *rq,
 		blk_insert_t flags);
 static void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 		struct list_head *list);
-
-static inline struct blk_mq_hw_ctx *blk_qc_to_hctx(struct request_queue =
*q,
-		blk_qc_t qc)
-{
-	return xa_load(&q->hctx_table, qc);
-}
-
-static inline blk_qc_t blk_rq_to_qc(struct request *rq)
-{
-	return rq->mq_hctx->queue_num;
-}
+static int blk_hctx_poll(struct request_queue *q, struct blk_mq_hw_ctx *=
hctx,
+			 struct io_comp_batch *iob, unsigned int flags);
=20
 /*
  * Check if any of the ctx, dispatch list or elevator
@@ -1247,7 +1238,7 @@ void blk_mq_start_request(struct request *rq)
 		q->integrity.profile->prepare_fn(rq);
 #endif
 	if (rq->bio && rq->bio->bi_opf & REQ_POLLED)
-	        WRITE_ONCE(rq->bio->bi_cookie, blk_rq_to_qc(rq));
+	        WRITE_ONCE(rq->bio->bi_cookie, rq->mq_hctx->queue_num);
 }
 EXPORT_SYMBOL(blk_mq_start_request);
=20
@@ -1349,7 +1340,7 @@ EXPORT_SYMBOL_GPL(blk_rq_is_poll);
 static void blk_rq_poll_completion(struct request *rq, struct completion=
 *wait)
 {
 	do {
-		blk_mq_poll(rq->q, blk_rq_to_qc(rq), NULL, 0);
+		blk_hctx_poll(rq->q, rq->mq_hctx, NULL, 0);
 		cond_resched();
 	} while (!completion_done(wait));
 }
@@ -4735,10 +4726,9 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_=
set *set, int nr_hw_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_update_nr_hw_queues);
=20
-int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, struct io_comp=
_batch *iob,
-		unsigned int flags)
+static int blk_hctx_poll(struct request_queue *q, struct blk_mq_hw_ctx *=
hctx,
+			 struct io_comp_batch *iob, unsigned int flags)
 {
-	struct blk_mq_hw_ctx *hctx =3D blk_qc_to_hctx(q, cookie);
 	long state =3D get_current_state();
 	int ret;
=20
@@ -4763,6 +4753,32 @@ int blk_mq_poll(struct request_queue *q, blk_qc_t =
cookie, struct io_comp_batch *
 	return 0;
 }
=20
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie,
+		struct io_comp_batch *iob, unsigned int flags)
+{
+	struct blk_mq_hw_ctx *hctx =3D xa_load(&q->hctx_table, cookie);
+
+	return blk_hctx_poll(q, hctx, iob, flags);
+}
+
+int blk_rq_poll(struct request *rq, struct io_comp_batch *iob,
+		unsigned int poll_flags)
+{
+	struct request_queue *q =3D rq->q;
+	int ret;
+
+	if (!blk_rq_is_poll(rq))
+		return 0;
+	if (!percpu_ref_tryget(&q->q_usage_counter))
+		return 0;
+
+	ret =3D blk_hctx_poll(q, rq->mq_hctx, iob, poll_flags);
+	blk_queue_exit(q);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blk_rq_poll);
+
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
 	return rq->mq_ctx->cpu;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 59b52ec155b1b..9f4d285b52b93 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -715,6 +715,8 @@ int blk_mq_alloc_sq_tag_set(struct blk_mq_tag_set *se=
t,
 void blk_mq_free_tag_set(struct blk_mq_tag_set *set);
=20
 void blk_mq_free_request(struct request *rq);
+int blk_rq_poll(struct request *rq, struct io_comp_batch *iob,
+		unsigned int poll_flags);
=20
 bool blk_mq_queue_inflight(struct request_queue *q);
=20
--=20
2.34.1

