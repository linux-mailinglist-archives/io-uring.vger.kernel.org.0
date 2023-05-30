Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA25F716ADB
	for <lists+io-uring@lfdr.de>; Tue, 30 May 2023 19:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbjE3R0O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 May 2023 13:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjE3RZ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 May 2023 13:25:56 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A22198
        for <io-uring@vger.kernel.org>; Tue, 30 May 2023 10:25:25 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 34UGY2wc022411
        for <io-uring@vger.kernel.org>; Tue, 30 May 2023 10:24:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=bHlDZ98iZ2yfgOB8PPLdZzv6+izKLcs4GDZzU2G+rPE=;
 b=BqTHeYYaLgLknyO8xaTdKS0UwXRvuI2IwkNK2sLTn3jK8N3KW1VD0H5aZsV0mAxIMozc
 S/rJ8/HJI7IzZJxleACqD2zcXXn7oDgIkVfS3paskizdXVE91yesiQfFcbLwAW7h3MoT
 v5hiSJXWVmyKRIzuGpIuVsk0gZhzY/6mY9CE8BgWUVJvC0E4o61kiMpUZ7pBhJyAlfx/
 uGtozZGfD8Me098sjNM4vYbNybvoItrUPf1QhlAaI9PSYJNSSOb6C54VneOAas8cozJQ
 M68m48u17PZoA+oW21PZZICvsn3G6XZxOT6aNKAHX2YUqEiACufyfcs6LrtYyrKMAVZ+ eg== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3qwfhajw9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 May 2023 10:24:04 -0700
Received: from twshared52232.38.frc1.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 10:23:50 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id AB3A3194BF685; Tue, 30 May 2023 10:23:48 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <hch@lst.de>, <axboe@kernel.dk>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 1/2] block: add request polling helper
Date:   Tue, 30 May 2023 10:23:42 -0700
Message-ID: <20230530172343.3250958-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: XGIEio5RH9EimasGHl96d6hMBY2IaoTY
X-Proofpoint-GUID: XGIEio5RH9EimasGHl96d6hMBY2IaoTY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_12,2023-05-30_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

This will be used by drivers that allocate polling requests. It
interface does not require a bio, and can skip the overhead associated
with polling those.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-mq.c         | 29 ++++++++++++++++++++++++++---
 include/linux/blk-mq.h |  2 ++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f6dad0886a2fa..3c12c476e3a5c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4740,10 +4740,9 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_=
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
@@ -4768,6 +4767,30 @@ int blk_mq_poll(struct request_queue *q, blk_qc_t =
cookie, struct io_comp_batch *
 	return 0;
 }
=20
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, struct io_comp=
_batch *iob,
+		unsigned int flags)
+{
+	return blk_hctx_poll(q, blk_qc_to_hctx(q, cookie), iob, flags);
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
index 06caacd77ed66..579818fa1f91d 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -722,6 +722,8 @@ int blk_mq_alloc_sq_tag_set(struct blk_mq_tag_set *se=
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

