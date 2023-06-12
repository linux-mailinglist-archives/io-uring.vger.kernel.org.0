Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A4B72CEEE
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 21:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbjFLTED (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 15:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbjFLTD7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 15:03:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0414AD
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 12:03:57 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35CG99Ab020659
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 12:03:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=AnQZk+f60ziKqHwJmcKaOoi0i87epwPwExTQ/NdgR44=;
 b=PssIqNYazUc8DZkkmexKG9ro8be45fY+Oh3YRmZF3PsTSJMNBisrdwGcKzAtkxDTBcj8
 LxP4RRc9pZi909UfU9XyqFOM+i21s+KBtezDn832A19Jh/j5h6Pd7W4/TRaH/bYuYMGb
 Leg8Lc03hOsgUEmCspTkM86tLVZLx7OKR9iaUfHi9QnMi0Lx/RxD5F2JknesPErBKXxU
 omd0iZ7FFR9iiy34LR0wlf/MmovVQtW4r1VbSAiEigarRbTgxsbPliVODdj7S4oqgb+Q
 N+tb7vNGuBDOTGVFWSRTAmx9aMZSw9V3PFTKdl82Gj2K7H/RMQ8jR/Zoflj5O/IQU4AO sg== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r5xhxmaaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 12:03:57 -0700
Received: from twshared6352.02.ash9.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 12:03:56 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 62CD819FA77A4; Mon, 12 Jun 2023 12:03:44 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <hch@lst.de>, <axboe@kernel.dk>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 1/2] block: add request polling helper
Date:   Mon, 12 Jun 2023 12:03:42 -0700
Message-ID: <20230612190343.2087040-2-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230612190343.2087040-1-kbusch@meta.com>
References: <20230612190343.2087040-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: iksMUP5wDrHNbXSqS_1o6Jcv2iASPjCF
X-Proofpoint-ORIG-GUID: iksMUP5wDrHNbXSqS_1o6Jcv2iASPjCF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-12_14,2023-06-12_02,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

