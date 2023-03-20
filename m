Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457DA6C21E6
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 20:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCTTuL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 15:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCTTtx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 15:49:53 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8566359D8
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 12:49:33 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KH7ieH021820
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 12:49:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=U0/3J+HHMZBBK0FiD+ndgXJ6yE8VA1tpXmsViN6pA/o=;
 b=cqx2uwIo8UwuxepKougBvKv7EZcl/fEOj1+ZaOyiLz+Y7LyNUz7J/ipTSR/KZ3Vv2qwH
 qeKRZ3/NCT6O+43vZpFQE1YsUUcfwTas3XOFNXVDyO9/JZFQSFBCyBSb5mjMCU+xAKsx
 +fNsj54h0nXTQ20WdgAb/Cuo9M8f1Y/rVolJdOn4EpA5+65pmoYEAxHGEazG7n1yqLw1
 RkadA41aKPRkt1YAc83ClZTkKCiDTD6iiWmAv1USqnBnyjb66nnLabMmpiVaJDHu2bgp
 nQo0oZVVtpbvce/K2HZGV/3ACM63XPjMp2xCfxJVqWDgFmrHd+3jZ8rD/6Yx5UELOeHA yQ== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3peq8hb3gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 12:49:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqJMCsMCkypSubMA69SDfi+N5F5s3ueyJZxt86bmPuOkkhTMXYJUJ15thUC1wegcYw381q0RHrC2/pplbhZ+DSc6Mkht9VFN674n6JgH/REVKVDEuutuy0QJt0e09T3TDJk4Yi5lxYErm8PonSlD3nB3TdmsjFAuXrYLYvEq3RqOmSGJmKiI1qHQe9VglyqYQHYGIYDOjKIyX6MSrLpdjGns5tMug/LN6VjoBW/iDs1UdmZizHtUrRHb9yu2Ogz8PWsjgma1SIhZzuFKUR5E+V4UJzgYJyqxbNqZvS+XxGRtkSQhBGwuLN75mkpqbxsHicyWVuLFiXfRTCGmM3FLFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0/3J+HHMZBBK0FiD+ndgXJ6yE8VA1tpXmsViN6pA/o=;
 b=drX4PrPKWb3flyS1nIlYuByIdFHZtZj49Z9Jl0QzyItET/4ALqumSrF2+Yu0ipMA+xUA/lBiUJ711LKt1EVyOiVLzQ6SWiCdJdCNlNAJv6UoSUYnqP1tjXbZMviw7/VUeEPcH4h1x7H0wTCI0aS9WxpmXYKrJC4t1csMJ1P2zFRiyRDPvYqfyC0sZn6Aa8tU3fFBWwX9/w4tGRMn0XByKkREdd8HwaDNWUGNGhQLcxKI3oNTOmuGxL+/NqcTpVOdCMKXGXJfAU6VdjDSXft/TfW8o6hb2T0YQaCy8orfI8teKB+F4XqC0yHcin5fLmtZcmCxjzmeHnnnA8+eTBVU2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 66.220.155.178) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=meta.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject header.from=meta.com;
 dkim=none (message not signed); arc=none
Received: from BN9PR03CA0254.namprd03.prod.outlook.com (2603:10b6:408:ff::19)
 by SA1PR15MB4579.namprd15.prod.outlook.com (2603:10b6:806:19b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:49:26 +0000
Received: from BN8NAM12FT095.eop-nam12.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::dc) by BN9PR03CA0254.outlook.office365.com
 (2603:10b6:408:ff::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Mon, 20 Mar 2023 19:49:30 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 66.220.155.178)
 smtp.mailfrom=meta.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=meta.com;
Received-SPF: Fail (protection.outlook.com: domain of meta.com does not
 designate 66.220.155.178 as permitted sender)
 receiver=protection.outlook.com; client-ip=66.220.155.178;
 helo=66-220-155-178.mail-mxout.facebook.com;
Received: from 66-220-155-178.mail-mxout.facebook.com (66.220.155.178) by
 BN8NAM12FT095.mail.protection.outlook.com (10.13.183.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.2 via Frontend Transport; Mon, 20 Mar 2023 19:49:30 +0000
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 5B8A714006928; Mon, 20 Mar 2023 12:49:27 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2] blk-mq: remove hybrid polling
Date:   Mon, 20 Mar 2023 12:49:26 -0700
Message-Id: <20230320194926.3353144-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM12FT095:EE_|SA1PR15MB4579:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: d06c9a6f-d4f9-435e-235b-08db297c3889
X-ETR:  Bypass spam filtering
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H6m4WxcvfnC8nzO09fP/Y+DWHLhfWJO/uKiDnODTsInfo3QmyC+rR248z6GsMnNLX7uzItXjtinATv915LWCOa7DEl1QEe7eMViw6h5W/9cJSfgJ6UuAi/EnzQ4tUm+X0mOSr6NOYb85WQ3PbZc0s/43Qcu6ESpxxjvzrg1ZVot8INHxdj5ABFwt4Jx7MHlHn+NKE9BNnTbL9czaGpIDl0LlslfF6hxWcCTSampYcr7EIhqM14GprVKEGoka0yLgBJvRw3G+GdE7eqb74oc6dQYijpZs0QTPDShLKFk1poZF8nQmi6ONEdEWSRYRSfq77R9DKxSOS6CIvNgFf3AOtsdtJE0CKQpMlfGJJv3OMftFoGn/wqR0iDppjdufyGQf9DtAr+LqQ9bFoeDkE068qvVcE+GC74FddPIlW5RGqC3XkQVSeNIaWjkoE0bvc/EZgk7FV99O1IEVYKlKqgzjuCb/pH7nqr1xcaJnvlwBPunlxUtXY/NNgm7+kQvSIqtkPwhR9cffEkftfh5jm665SmNzvxoihzDzaCj0qHkPIW8qIOEx88ydb5UwPKEXyweH/Zpx1xFFHmCR3D/itudsT0+5O5dHkodDZzrZjzMIntxwNaxyM3wSC+gK6XlUdobfyxSgOGTVCyeBZy9zM3WXFUzc4hR8T3X108KAH5tA5yIAhwPc6JnT4JNZOqn7iU/51Afd2hCDcJKJOG137ikk2A==
X-Forefront-Antispam-Report: CIP:66.220.155.178;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:66-220-155-178.mail-mxout.facebook.com;PTR:66-220-155-178.mail-mxout.facebook.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(2616005)(6266002)(47076005)(186003)(4326008)(83380400001)(478600001)(336012)(54906003)(316002)(42186006)(70206006)(1076003)(26005)(8676002)(41300700001)(36860700001)(30864003)(5660300002)(7636003)(40460700003)(82740400003)(7596003)(2906002)(356005)(82310400005)(86362001)(36756003)(40480700001)(8936002);DIR:OUT;SFP:1102;
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 19:49:30.3783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d06c9a6f-d4f9-435e-235b-08db297c3889
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=8ae927fe-1255-47a7-a2af-5f3a069daaa2;Ip=[66.220.155.178];Helo=[66-220-155-178.mail-mxout.facebook.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-BN8NAM12FT095.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4579
X-Proofpoint-GUID: iZZkPWW8reD3gwh8tqyjAUM3B9lmgakJ
X-Proofpoint-ORIG-GUID: iZZkPWW8reD3gwh8tqyjAUM3B9lmgakJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_16,2023-03-20_02,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

io_uring provides the only way user space can poll completions, and that
always sets BLK_POLL_NOSLEEP. This effectively makes hybrid polling dead
code, so remove it and everything supporting it.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
v1->v2:

  Make the queue_io_poll_delay_store() a no-op so that anyone using
  it won't see errors.

  Updated Documentation with the new description for the io_poll_delay
  queue attribute.

 Documentation/ABI/stable/sysfs-block |  15 +-
 block/blk-core.c                     |   6 -
 block/blk-mq-debugfs.c               |  26 ----
 block/blk-mq.c                       | 205 +--------------------------
 block/blk-stat.c                     |  18 ---
 block/blk-sysfs.c                    |  25 +---
 include/linux/blk-mq.h               |   2 -
 include/linux/blkdev.h               |  12 --
 io_uring/rw.c                        |   2 +-
 9 files changed, 12 insertions(+), 299 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/sta=
ble/sysfs-block
index 282de3680367d..c57e5b7cb5326 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -336,18 +336,11 @@ What:		/sys/block/<disk>/queue/io_poll_delay
 Date:		November 2016
 Contact:	linux-block@vger.kernel.org
 Description:
-		[RW] If polling is enabled, this controls what kind of polling
-		will be performed. It defaults to -1, which is classic polling.
+		[RW] This was used to control what kind of polling will be
+		performed.  It is now fixed to -1, which is classic polling.
 		In this mode, the CPU will repeatedly ask for completions
-		without giving up any time.  If set to 0, a hybrid polling mode
-		is used, where the kernel will attempt to make an educated guess
-		at when the IO will complete. Based on this guess, the kernel
-		will put the process issuing IO to sleep for an amount of time,
-		before entering a classic poll loop. This mode might be a little
-		slower than pure classic polling, but it will be more efficient.
-		If set to a value larger than 0, the kernel will put the process
-		issuing IO to sleep for this amount of microseconds before
-		entering classic polling.
+		without giving up any time.
+		<deprecated>
=20
=20
 What:		/sys/block/<disk>/queue/io_timeout
diff --git a/block/blk-core.c b/block/blk-core.c
index 9e5e0277a4d95..269765d16cfd9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -263,13 +263,7 @@ static void blk_free_queue_rcu(struct rcu_head *rcu_=
head)
=20
 static void blk_free_queue(struct request_queue *q)
 {
-	if (q->poll_stat)
-		blk_stat_remove_callback(q, q->poll_cb);
-	blk_stat_free_callback(q->poll_cb);
-
 	blk_free_queue_stats(q->stats);
-	kfree(q->poll_stat);
-
 	if (queue_is_mq(q))
 		blk_mq_release(q);
=20
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index b01818f8e216e..212a7f301e730 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -15,33 +15,8 @@
 #include "blk-mq-tag.h"
 #include "blk-rq-qos.h"
=20
-static void print_stat(struct seq_file *m, struct blk_rq_stat *stat)
-{
-	if (stat->nr_samples) {
-		seq_printf(m, "samples=3D%d, mean=3D%llu, min=3D%llu, max=3D%llu",
-			   stat->nr_samples, stat->mean, stat->min, stat->max);
-	} else {
-		seq_puts(m, "samples=3D0");
-	}
-}
-
 static int queue_poll_stat_show(void *data, struct seq_file *m)
 {
-	struct request_queue *q =3D data;
-	int bucket;
-
-	if (!q->poll_stat)
-		return 0;
-
-	for (bucket =3D 0; bucket < (BLK_MQ_POLL_STATS_BKTS / 2); bucket++) {
-		seq_printf(m, "read  (%d Bytes): ", 1 << (9 + bucket));
-		print_stat(m, &q->poll_stat[2 * bucket]);
-		seq_puts(m, "\n");
-
-		seq_printf(m, "write (%d Bytes): ",  1 << (9 + bucket));
-		print_stat(m, &q->poll_stat[2 * bucket + 1]);
-		seq_puts(m, "\n");
-	}
 	return 0;
 }
=20
@@ -282,7 +257,6 @@ static const char *const rqf_name[] =3D {
 	RQF_NAME(STATS),
 	RQF_NAME(SPECIAL_PAYLOAD),
 	RQF_NAME(ZONE_WRITE_LOCKED),
-	RQF_NAME(MQ_POLL_SLEPT),
 	RQF_NAME(TIMED_OUT),
 	RQF_NAME(ELV),
 	RQF_NAME(RESV),
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a875b1cdff9b5..4e30459df8151 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -46,51 +46,15 @@
=20
 static DEFINE_PER_CPU(struct llist_head, blk_cpu_done);
=20
-static void blk_mq_poll_stats_start(struct request_queue *q);
-static void blk_mq_poll_stats_fn(struct blk_stat_callback *cb);
-
-static int blk_mq_poll_stats_bkt(const struct request *rq)
-{
-	int ddir, sectors, bucket;
-
-	ddir =3D rq_data_dir(rq);
-	sectors =3D blk_rq_stats_sectors(rq);
-
-	bucket =3D ddir + 2 * ilog2(sectors);
-
-	if (bucket < 0)
-		return -1;
-	else if (bucket >=3D BLK_MQ_POLL_STATS_BKTS)
-		return ddir + BLK_MQ_POLL_STATS_BKTS - 2;
-
-	return bucket;
-}
-
-#define BLK_QC_T_SHIFT		16
-#define BLK_QC_T_INTERNAL	(1U << 31)
-
 static inline struct blk_mq_hw_ctx *blk_qc_to_hctx(struct request_queue =
*q,
 		blk_qc_t qc)
 {
-	return xa_load(&q->hctx_table,
-			(qc & ~BLK_QC_T_INTERNAL) >> BLK_QC_T_SHIFT);
-}
-
-static inline struct request *blk_qc_to_rq(struct blk_mq_hw_ctx *hctx,
-		blk_qc_t qc)
-{
-	unsigned int tag =3D qc & ((1U << BLK_QC_T_SHIFT) - 1);
-
-	if (qc & BLK_QC_T_INTERNAL)
-		return blk_mq_tag_to_rq(hctx->sched_tags, tag);
-	return blk_mq_tag_to_rq(hctx->tags, tag);
+	return xa_load(&q->hctx_table, qc);
 }
=20
 static inline blk_qc_t blk_rq_to_qc(struct request *rq)
 {
-	return (rq->mq_hctx->queue_num << BLK_QC_T_SHIFT) |
-		(rq->tag !=3D -1 ?
-		 rq->tag : (rq->internal_tag | BLK_QC_T_INTERNAL));
+	return rq->mq_hctx->queue_num;
 }
=20
 /*
@@ -1038,10 +1002,8 @@ static inline void blk_account_io_start(struct req=
uest *req)
=20
 static inline void __blk_mq_end_request_acct(struct request *rq, u64 now=
)
 {
-	if (rq->rq_flags & RQF_STATS) {
-		blk_mq_poll_stats_start(rq->q);
+	if (rq->rq_flags & RQF_STATS)
 		blk_stat_add(rq, now);
-	}
=20
 	blk_mq_sched_completed_request(rq, now);
 	blk_account_io_done(rq, now);
@@ -4222,14 +4184,8 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_=
set *set,
 	/* mark the queue as mq asap */
 	q->mq_ops =3D set->ops;
=20
-	q->poll_cb =3D blk_stat_alloc_callback(blk_mq_poll_stats_fn,
-					     blk_mq_poll_stats_bkt,
-					     BLK_MQ_POLL_STATS_BKTS, q);
-	if (!q->poll_cb)
-		goto err_exit;
-
 	if (blk_mq_alloc_ctxs(q))
-		goto err_poll;
+		goto err_exit;
=20
 	/* init q->mq_kobj and sw queues' kobjects */
 	blk_mq_sysfs_init(q);
@@ -4257,11 +4213,6 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_=
set *set,
=20
 	q->nr_requests =3D set->queue_depth;
=20
-	/*
-	 * Default to classic polling
-	 */
-	q->poll_nsec =3D BLK_MQ_POLL_CLASSIC;
-
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
@@ -4269,9 +4220,6 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_s=
et *set,
=20
 err_hctxs:
 	blk_mq_release(q);
-err_poll:
-	blk_stat_free_callback(q->poll_cb);
-	q->poll_cb =3D NULL;
 err_exit:
 	q->mq_ops =3D NULL;
 	return -ENOMEM;
@@ -4768,138 +4716,8 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag=
_set *set, int nr_hw_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_update_nr_hw_queues);
=20
-/* Enable polling stats and return whether they were already enabled. */
-static bool blk_poll_stats_enable(struct request_queue *q)
-{
-	if (q->poll_stat)
-		return true;
-
-	return blk_stats_alloc_enable(q);
-}
-
-static void blk_mq_poll_stats_start(struct request_queue *q)
-{
-	/*
-	 * We don't arm the callback if polling stats are not enabled or the
-	 * callback is already active.
-	 */
-	if (!q->poll_stat || blk_stat_is_active(q->poll_cb))
-		return;
-
-	blk_stat_activate_msecs(q->poll_cb, 100);
-}
-
-static void blk_mq_poll_stats_fn(struct blk_stat_callback *cb)
-{
-	struct request_queue *q =3D cb->data;
-	int bucket;
-
-	for (bucket =3D 0; bucket < BLK_MQ_POLL_STATS_BKTS; bucket++) {
-		if (cb->stat[bucket].nr_samples)
-			q->poll_stat[bucket] =3D cb->stat[bucket];
-	}
-}
-
-static unsigned long blk_mq_poll_nsecs(struct request_queue *q,
-				       struct request *rq)
-{
-	unsigned long ret =3D 0;
-	int bucket;
-
-	/*
-	 * If stats collection isn't on, don't sleep but turn it on for
-	 * future users
-	 */
-	if (!blk_poll_stats_enable(q))
-		return 0;
-
-	/*
-	 * As an optimistic guess, use half of the mean service time
-	 * for this type of request. We can (and should) make this smarter.
-	 * For instance, if the completion latencies are tight, we can
-	 * get closer than just half the mean. This is especially
-	 * important on devices where the completion latencies are longer
-	 * than ~10 usec. We do use the stats for the relevant IO size
-	 * if available which does lead to better estimates.
-	 */
-	bucket =3D blk_mq_poll_stats_bkt(rq);
-	if (bucket < 0)
-		return ret;
-
-	if (q->poll_stat[bucket].nr_samples)
-		ret =3D (q->poll_stat[bucket].mean + 1) / 2;
-
-	return ret;
-}
-
-static bool blk_mq_poll_hybrid(struct request_queue *q, blk_qc_t qc)
-{
-	struct blk_mq_hw_ctx *hctx =3D blk_qc_to_hctx(q, qc);
-	struct request *rq =3D blk_qc_to_rq(hctx, qc);
-	struct hrtimer_sleeper hs;
-	enum hrtimer_mode mode;
-	unsigned int nsecs;
-	ktime_t kt;
-
-	/*
-	 * If a request has completed on queue that uses an I/O scheduler, we
-	 * won't get back a request from blk_qc_to_rq.
-	 */
-	if (!rq || (rq->rq_flags & RQF_MQ_POLL_SLEPT))
-		return false;
-
-	/*
-	 * If we get here, hybrid polling is enabled. Hence poll_nsec can be:
-	 *
-	 *  0:	use half of prev avg
-	 * >0:	use this specific value
-	 */
-	if (q->poll_nsec > 0)
-		nsecs =3D q->poll_nsec;
-	else
-		nsecs =3D blk_mq_poll_nsecs(q, rq);
-
-	if (!nsecs)
-		return false;
-
-	rq->rq_flags |=3D RQF_MQ_POLL_SLEPT;
-
-	/*
-	 * This will be replaced with the stats tracking code, using
-	 * 'avg_completion_time / 2' as the pre-sleep target.
-	 */
-	kt =3D nsecs;
-
-	mode =3D HRTIMER_MODE_REL;
-	hrtimer_init_sleeper_on_stack(&hs, CLOCK_MONOTONIC, mode);
-	hrtimer_set_expires(&hs.timer, kt);
-
-	do {
-		if (blk_mq_rq_state(rq) =3D=3D MQ_RQ_COMPLETE)
-			break;
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		hrtimer_sleeper_start_expires(&hs, mode);
-		if (hs.task)
-			io_schedule();
-		hrtimer_cancel(&hs.timer);
-		mode =3D HRTIMER_MODE_ABS;
-	} while (hs.task && !signal_pending(current));
-
-	__set_current_state(TASK_RUNNING);
-	destroy_hrtimer_on_stack(&hs.timer);
-
-	/*
-	 * If we sleep, have the caller restart the poll loop to reset the
-	 * state.  Like for the other success return cases, the caller is
-	 * responsible for checking if the IO completed.  If the IO isn't
-	 * complete, we'll get called again and will go straight to the busy
-	 * poll loop.
-	 */
-	return true;
-}
-
-static int blk_mq_poll_classic(struct request_queue *q, blk_qc_t cookie,
-			       struct io_comp_batch *iob, unsigned int flags)
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, struct io_comp=
_batch *iob,
+		unsigned int flags)
 {
 	struct blk_mq_hw_ctx *hctx =3D blk_qc_to_hctx(q, cookie);
 	long state =3D get_current_state();
@@ -4926,17 +4744,6 @@ static int blk_mq_poll_classic(struct request_queu=
e *q, blk_qc_t cookie,
 	return 0;
 }
=20
-int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, struct io_comp=
_batch *iob,
-		unsigned int flags)
-{
-	if (!(flags & BLK_POLL_NOSLEEP) &&
-	    q->poll_nsec !=3D BLK_MQ_POLL_CLASSIC) {
-		if (blk_mq_poll_hybrid(q, cookie))
-			return 1;
-	}
-	return blk_mq_poll_classic(q, cookie, iob, flags);
-}
-
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
 	return rq->mq_ctx->cpu;
diff --git a/block/blk-stat.c b/block/blk-stat.c
index c6ca16abf911e..74a1a8c32d86f 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -231,21 +231,3 @@ void blk_free_queue_stats(struct blk_queue_stats *st=
ats)
=20
 	kfree(stats);
 }
-
-bool blk_stats_alloc_enable(struct request_queue *q)
-{
-	struct blk_rq_stat *poll_stat;
-
-	poll_stat =3D kcalloc(BLK_MQ_POLL_STATS_BKTS, sizeof(*poll_stat),
-				GFP_ATOMIC);
-	if (!poll_stat)
-		return false;
-
-	if (cmpxchg(&q->poll_stat, NULL, poll_stat) !=3D NULL) {
-		kfree(poll_stat);
-		return true;
-	}
-
-	blk_stat_add_callback(q, q->poll_cb);
-	return false;
-}
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index f1fce1c7fa44b..1a743b4f29582 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -408,35 +408,12 @@ queue_rq_affinity_store(struct request_queue *q, co=
nst char *page, size_t count)
=20
 static ssize_t queue_poll_delay_show(struct request_queue *q, char *page=
)
 {
-	int val;
-
-	if (q->poll_nsec =3D=3D BLK_MQ_POLL_CLASSIC)
-		val =3D BLK_MQ_POLL_CLASSIC;
-	else
-		val =3D q->poll_nsec / 1000;
-
-	return sprintf(page, "%d\n", val);
+	return sprintf(page, "%d\n", -1);
 }
=20
 static ssize_t queue_poll_delay_store(struct request_queue *q, const cha=
r *page,
 				size_t count)
 {
-	int err, val;
-
-	if (!q->mq_ops || !q->mq_ops->poll)
-		return -EINVAL;
-
-	err =3D kstrtoint(page, 10, &val);
-	if (err < 0)
-		return err;
-
-	if (val =3D=3D BLK_MQ_POLL_CLASSIC)
-		q->poll_nsec =3D BLK_MQ_POLL_CLASSIC;
-	else if (val >=3D 0)
-		q->poll_nsec =3D val * 1000;
-	else
-		return -EINVAL;
-
 	return count;
 }
=20
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index dd5ce1137f04a..1dacb2c81fdda 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -57,8 +57,6 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_SPECIAL_PAYLOAD	((__force req_flags_t)(1 << 18))
 /* The per-zone write lock is held for this request */
 #define RQF_ZONE_WRITE_LOCKED	((__force req_flags_t)(1 << 19))
-/* already slept for hybrid poll */
-#define RQF_MQ_POLL_SLEPT	((__force req_flags_t)(1 << 20))
 /* ->timeout has been called, don't expire again */
 #define RQF_TIMED_OUT		((__force req_flags_t)(1 << 21))
 /* queue has elevator attached */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d1aee08f8c181..6ede578dfbc64 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -44,12 +44,6 @@ extern const struct device_type disk_type;
 extern struct device_type part_type;
 extern struct class block_class;
=20
-/* Must be consistent with blk_mq_poll_stats_bkt() */
-#define BLK_MQ_POLL_STATS_BKTS 16
-
-/* Doing classic polling */
-#define BLK_MQ_POLL_CLASSIC -1
-
 /*
  * Maximum number of blkcg policies allowed to be registered concurrentl=
y.
  * Defined here to simplify include dependency.
@@ -468,10 +462,6 @@ struct request_queue {
 #endif
=20
 	unsigned int		rq_timeout;
-	int			poll_nsec;
-
-	struct blk_stat_callback	*poll_cb;
-	struct blk_rq_stat	*poll_stat;
=20
 	struct timer_list	timeout;
 	struct work_struct	timeout_work;
@@ -870,8 +860,6 @@ blk_status_t errno_to_blk_status(int errno);
=20
 /* only poll the hardware once, don't continue until a completion was fo=
und */
 #define BLK_POLL_ONESHOT		(1 << 0)
-/* do not sleep to wait for the expected completion time */
-#define BLK_POLL_NOSLEEP		(1 << 1)
 int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int fl=
ags);
 int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 			unsigned int flags);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4c233910e2009..a099dc0543d95 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1002,7 +1002,7 @@ void io_rw_fail(struct io_kiocb *req)
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
-	unsigned int poll_flags =3D BLK_POLL_NOSLEEP;
+	unsigned int poll_flags =3D 0;
 	DEFINE_IO_COMP_BATCH(iob);
 	int nr_events =3D 0;
=20
--=20
2.34.1

