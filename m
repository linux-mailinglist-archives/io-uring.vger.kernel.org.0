Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F3D603335
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJRTQ0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 18 Oct 2022 15:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJRTQZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:16:25 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A665E640
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:21 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 29IDsZZD004394
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:20 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3k9abe6w87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:20 -0700
Received: from twshared1458.22.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:16:18 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 4AB34227F050E; Tue, 18 Oct 2022 12:16:02 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v2 04/13] io_uring: create a zctap region for a mapped buffer
Date:   Tue, 18 Oct 2022 12:15:53 -0700
Message-ID: <20221018191602.2112515-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
References: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: sUZC-eX96q-M6OZryAyrxoE1tKOTH2-_
X-Proofpoint-ORIG-GUID: sUZC-eX96q-M6OZryAyrxoE1tKOTH2-_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This function takes all of a memory region that was previously
registered with io_uring, and assigns it as the backing store for
the specified ifq, binding the pages to a specific device.

The entire region is registered instead of providing individual
bufferrs, as this allows the hardware to select the optimal buffer
size for incoming packets.

The region is registered as part of the register_ifq opcode,
instead of separately, since the ifq ring requires memory when
it is created.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++-
 io_uring/zctap.h |  2 ++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index f4a45b683ca0..f8a5702f93f4 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -6,16 +6,73 @@
 #include <linux/mm.h>
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
 #include "zctap.h"
+#include "rsrc.h"
+#include "kbuf.h"
 
 #define NR_ZCTAP_IFQS	1
 
+struct ifq_region {
+	struct io_mapped_ubuf	*imu;
+	int			count;
+	int			nr_pages;
+	u16			id;
+	struct page		*freelist[];
+};
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
+static void io_remove_ifq_region(struct ifq_region *ifr)
+{
+	kvfree(ifr);
+}
+
+int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
+{
+	struct io_ring_ctx *ctx = ifq->ctx;
+	struct io_mapped_ubuf *imu;
+	struct ifq_region *ifr;
+	int i, nr_pages;
+	struct page *page;
+
+	/* XXX for now, only allow one region per ifq. */
+	if (ifq->region)
+		return -EFAULT;
+
+	if (unlikely(id >= ctx->nr_user_bufs))
+		return -EFAULT;
+	id = array_index_nospec(id, ctx->nr_user_bufs);
+	imu = ctx->user_bufs[id];
+
+	/* XXX check region is page aligned */
+	if (imu->ubuf & ~PAGE_MASK || imu->ubuf_end & ~PAGE_MASK)
+		return -EFAULT;
+
+	nr_pages = imu->nr_bvecs;
+	ifr = kvmalloc(struct_size(ifr, freelist, nr_pages), GFP_KERNEL);
+	if (!ifr)
+		return -ENOMEM;
+
+	ifr->nr_pages = nr_pages;
+	ifr->imu = imu;
+	ifr->count = nr_pages;
+	ifr->id = id;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = imu->bvec[i].bv_page;
+		ifr->freelist[i] = page;
+	}
+
+	ifq->region = ifr;
+
+	return 0;
+}
+
 static int __io_queue_mgmt(struct net_device *dev, struct io_zctap_ifq *ifq,
 			   u16 queue_id)
 {
@@ -59,6 +116,8 @@ static void io_zctap_ifq_free(struct io_zctap_ifq *ifq)
 {
 	if (ifq->queue_id != -1)
 		io_close_zctap_ifq(ifq, ifq->queue_id);
+	if (ifq->region)
+		io_remove_ifq_region(ifq->region);
 	if (ifq->dev)
 		dev_put(ifq->dev);
 	kfree(ifq);
@@ -92,7 +151,9 @@ int io_register_ifq(struct io_ring_ctx *ctx,
 	if (!ifq->dev)
 		goto out;
 
-	/* region attachment TBD */
+	err = io_provide_ifq_region(ifq, req.region_id);
+	if (err)
+		goto out;
 
 	err = io_open_zctap_ifq(ifq, req.queue_id);
 	if (err)
diff --git a/io_uring/zctap.h b/io_uring/zctap.h
index bbe4a509408b..bb44f8e972e8 100644
--- a/io_uring/zctap.h
+++ b/io_uring/zctap.h
@@ -6,4 +6,6 @@ int io_register_ifq(struct io_ring_ctx *ctx,
 		    struct io_uring_ifq_req __user *arg);
 void io_unregister_zctap_all(struct io_ring_ctx *ctx);
 
+int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id);
+
 #endif
-- 
2.30.2

