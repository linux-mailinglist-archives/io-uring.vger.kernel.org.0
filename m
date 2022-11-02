Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863036172DB
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiKBXkT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiKBXj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:57 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B5B25C3
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:33:10 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVtKT014829
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:33:10 -0700
Received: from maileast.thefacebook.com ([163.114.130.3])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkva13p79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:33:10 -0700
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:33:09 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id D3C23235B6191; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 15/15] io_uring: Notify the application as the fillq is drained.
Date:   Wed, 2 Nov 2022 16:32:44 -0700
Message-ID: <20221102233244.4022405-16-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
References: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: DemRKpXBe8LgF0X0UUPn_srqc2GlvTx5
X-Proofpoint-ORIG-GUID: DemRKpXBe8LgF0X0UUPn_srqc2GlvTx5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Userspace maintains a free count of space available in the fillq,
and only returns entries based on the available space.  As the
kernel removes these entries, it needs to notify the application
so more buffers can be queued.

Only one outstanding notifier per queue is used, and it provides
the most recent count of entries removed from the queue.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 8515fff20ad5..5fb48f0c0351 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -15,6 +15,7 @@
 #include "zctap.h"
 #include "rsrc.h"
 #include "kbuf.h"
+#include "refs.h"
 
 #define NR_ZCTAP_IFQS	1
 
@@ -26,6 +27,7 @@ struct ifq_region {
 	int			cache_count;
 	int			free_count;
 	int			nr_pages;
+	int			taken;
 	u16			id;
 
 	spinlock_t		freelist_lock;
@@ -44,8 +46,14 @@ struct ifq_region {
 struct io_zctap_ifq_priv {
 	struct io_zctap_ifq	ifq;
 	struct ubuf_info	uarg;
+	struct io_kiocb		req;
 };
 
+static struct io_kiocb *io_zctap_ifq_notifier(struct io_zctap_ifq *ifq)
+{
+	return &((struct io_zctap_ifq_priv *)ifq)->req;
+}
+
 static void io_zctap_ifq_put(struct io_zctap_ifq *ifq);
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
@@ -131,6 +139,17 @@ static void io_zctap_recycle_buf(struct ifq_region *ifr,
 	}
 }
 
+static void io_zctap_fillq_notify(struct io_kiocb *req, bool *locked)
+{
+	int res = *(int *)&req->cmd.data;
+
+	io_post_aux_cqe(req->ctx, 0xface0000, res,
+			IORING_CQE_F_BUFFER|IORING_CQE_F_NOTIF,
+			true);
+
+	io_req_task_complete(req, locked);
+}
+
 /* gets a user-supplied buffer from the fill queue
  *   note: may drain N entries, but still have no usable buffers
  *   XXX add retry limit?
@@ -159,6 +178,7 @@ static struct io_zctap_buf *io_zctap_get_buffer(struct io_zctap_ifq *ifq,
 	if (!addr)
 		return NULL;
 
+	ifr->taken++;
 	pgid = addr & 0xffff;
 //	region_id = (addr >> 16) & 0xffff;
 
@@ -192,6 +212,7 @@ struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
 {
 	struct io_zctap_buf *buf;
 	struct ifq_region *ifr;
+	struct io_kiocb *req;
 	int count;
 	u16 pgid;
 
@@ -214,6 +235,19 @@ struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
 	count = io_zctap_get_buffers(ifq, ifr->cache, REGION_REFILL_COUNT);
 	ifr->cache_count += count;
 
+	req = io_zctap_ifq_notifier(ifq);
+	if (ifr->taken && atomic_read(&req->refs) == 1) {
+		int res;
+
+		res = (ifq->fill_bgid << 16) | ifr->taken;
+		*(int *)&req->cmd.data = res;
+		ifr->taken = 0;
+
+		req_ref_get(req);
+		req->io_task_work.func = io_zctap_fillq_notify;
+		io_req_task_work_add(req);
+	}
+
 	if (ifr->cache_count)
 		goto out;
 
@@ -441,6 +475,7 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 	ifr->id = id;
 	ifr->ifq = ifq;
 	ifr->delay_end = 0;
+	ifr->taken = 0;
 	ifr->cache_count = 0;
 
 	err = io_zctap_map_region(ifr, imu);
@@ -529,6 +564,11 @@ static struct io_zctap_ifq *io_zctap_ifq_alloc(struct io_ring_ctx *ctx)
 	priv->ifq.ctx = ctx;
 	priv->ifq.queue_id = -1;
 	priv->ifq.uarg = &priv->uarg;
+
+	priv->req.ctx = ctx;
+	priv->req.task = current;
+	io_req_set_refcount(&priv->req);
+
 	return &priv->ifq;
 }
 
-- 
2.30.2

