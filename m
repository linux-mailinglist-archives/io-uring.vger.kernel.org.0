Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E996172DD
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiKBXkU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiKBXj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165DF2707
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:33:11 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NW00h003674
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:33:10 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kk78s6rfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:33:10 -0700
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:33:09 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id C50C6235B618D; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 13/15] io_uring: Make remove_ifq_region a delayed work call
Date:   Wed, 2 Nov 2022 16:32:42 -0700
Message-ID: <20221102233244.4022405-14-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
References: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: P1uWlNRP-wJEiAD8D252IO9xMjamGOr_
X-Proofpoint-GUID: P1uWlNRP-wJEiAD8D252IO9xMjamGOr_
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

The page backing store should not be removed until all ouststanding
packets are returned.  The packets may be inflight, owned by the
driver or sitting in a socket buffer.

The region holds a reference to the ifq, and when the ifq is
closed, a delayed work item is scheduled which checks that all
pages have been returned.  When complete, then the ifq reference
is released so it can be freed.

Currently, the work item will exit and leak pages after a timeout
expires.  This will be addressed.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/zctap.c               | 77 +++++++++++++++++++++++++---------
 2 files changed, 59 insertions(+), 19 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 39f20344d578..7d9895370875 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -583,6 +583,7 @@ struct io_zctap_ifq {
 	struct io_ring_ctx	*ctx;
 	void			*region;
 	struct ubuf_info	*uarg;
+	refcount_t		refcount;
 	u16			queue_id;
 	u16			id;
 	u16			fill_bgid;
diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 32efa7e9199d..9eba916376c6 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -19,13 +19,14 @@
 #define NR_ZCTAP_IFQS	1
 
 struct ifq_region {
-	struct io_zctap_ifq	*ifq;		/* only for delayed_work */
-	struct io_mapped_ubuf	*imu;
+	struct io_zctap_ifq	*ifq;
 	int			free_count;
 	int			nr_pages;
 	u16			id;
 
 	spinlock_t		freelist_lock;
+	struct delayed_work	release_work;
+	unsigned long		delay_end;
 
 	struct io_zctap_buf	*buf;
 	u16			freelist[];
@@ -37,6 +38,8 @@ struct io_zctap_ifq_priv {
 	struct ubuf_info	uarg;
 };
 
+static void io_zctap_ifq_put(struct io_zctap_ifq *ifq);
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
 static void zctap_set_page_info(struct page *page, u64 info)
@@ -235,11 +238,30 @@ netdev2device(struct net_device *dev)
 	return dev->dev.parent;			/* from SET_NETDEV_DEV() */
 }
 
-static void io_remove_ifq_region(struct ifq_region *ifr)
+static void io_remove_ifq_region_work(struct work_struct *work)
 {
+	struct ifq_region *ifr = container_of(
+		to_delayed_work(work), struct ifq_region, release_work);
 	struct device *device = netdev2device(ifr->ifq->dev);
 	struct io_zctap_buf *buf;
-	int i;
+	int i, refs, count;
+
+	count = 0;
+	for (i = 0; i < ifr->nr_pages; i++) {
+		buf = &ifr->buf[i];
+		refs = atomic_read(&buf->refcount) & IO_ZCTAP_KREF_MASK;
+		if (refs) {
+			if (time_before(jiffies, ifr->delay_end)) {
+				schedule_delayed_work(&ifr->release_work, HZ);
+				return;
+			}
+			count++;
+		}
+	}
+
+	if (count)
+		pr_debug("freeing ifr with %d/%d outstanding pages\n",
+			 count, ifr->nr_pages);
 
 	for (i = 0; i < ifr->nr_pages; i++) {
 		buf = &ifr->buf[i];
@@ -251,20 +273,28 @@ static void io_remove_ifq_region(struct ifq_region *ifr)
 		put_page(buf->page);
 	}
 
+	io_zctap_ifq_put(ifr->ifq);
 	kvfree(ifr->buf);
 	kvfree(ifr);
 }
 
-static int io_zctap_map_region(struct ifq_region *ifr, struct device *device)
+static void io_remove_ifq_region(struct ifq_region *ifr)
 {
-	struct io_mapped_ubuf *imu;
+	ifr->delay_end = jiffies + HZ * 10;
+	INIT_DELAYED_WORK(&ifr->release_work, io_remove_ifq_region_work);
+	schedule_delayed_work(&ifr->release_work, 0);
+}
+
+static int io_zctap_map_region(struct ifq_region *ifr,
+			       struct io_mapped_ubuf *imu)
+{
+	struct device *device = netdev2device(ifr->ifq->dev);
 	struct io_zctap_buf *buf;
 	struct page *page;
 	dma_addr_t addr;
 	int i, err;
 	u64 info;
 
-	imu = ifr->imu;
 	for (i = 0; i < ifr->nr_pages; i++) {
 		page = imu->bvec[i].bv_page;
 
@@ -298,10 +328,10 @@ static int io_zctap_map_region(struct ifq_region *ifr, struct device *device)
 
 out:
 	while (i--) {
-		page = imu->bvec[i].bv_page;
+		buf = &ifr->buf[i];
+		page = buf->page;
 		set_page_private(page, 0);
 		ClearPagePrivate(page);
-		buf = &ifr->buf[i];
 		dma_unmap_page_attrs(device, buf->dma, PAGE_SIZE,
 				     DMA_BIDIRECTIONAL,
 				     DMA_ATTR_SKIP_CPU_SYNC);
@@ -344,13 +374,12 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 
 	spin_lock_init(&ifr->freelist_lock);
 	ifr->nr_pages = nr_pages;
-	ifr->imu = imu;
 	ifr->free_count = nr_pages;
 	ifr->id = id;
+	ifr->ifq = ifq;
+	ifr->delay_end = 0;
 
-	ifr->ifq = ifq;		/* XXX */
-
-	err = io_zctap_map_region(ifr, netdev2device(ifq->dev));
+	err = io_zctap_map_region(ifr, imu);
 	if (err) {
 		kvfree(ifr->buf);
 		kvfree(ifr);
@@ -358,6 +387,7 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 	}
 
 	ifq->region = ifr;
+	refcount_inc(&ifq->refcount);
 
 	return 0;
 }
@@ -432,15 +462,23 @@ static struct io_zctap_ifq *io_zctap_ifq_alloc(struct io_ring_ctx *ctx)
 	return &priv->ifq;
 }
 
-static void io_zctap_ifq_free(struct io_zctap_ifq *ifq)
+static void io_zctap_ifq_put(struct io_zctap_ifq *ifq)
+{
+	if (!refcount_dec_and_test(&ifq->refcount))
+		return;
+
+	if (ifq->dev)
+		dev_put(ifq->dev);
+	kfree(ifq);
+}
+
+static void io_zctap_ifq_close(struct io_zctap_ifq *ifq)
 {
 	if (ifq->queue_id != -1)
 		io_close_zctap_ifq(ifq, ifq->queue_id);
 	if (ifq->region)
 		io_remove_ifq_region(ifq->region);
-	if (ifq->dev)
-		dev_put(ifq->dev);
-	kfree(ifq);
+	io_zctap_ifq_put(ifq);
 }
 
 int io_register_ifq(struct io_ring_ctx *ctx,
@@ -466,6 +504,7 @@ int io_register_ifq(struct io_ring_ctx *ctx,
 	ifq->fill_bgid = req.fill_bgid;
 	ifq->uarg->callback = io_zctap_ifq_callback;
 	ifq->uarg->flags = SKBFL_ALL_ZEROCOPY | SKBFL_FIXED_FRAG;
+	refcount_set(&ifq->refcount, 1);
 
 	err = -ENODEV;
 	ifq->dev = dev_get_by_index(&init_net, req.ifindex);
@@ -486,7 +525,7 @@ int io_register_ifq(struct io_ring_ctx *ctx,
 	return 0;
 
 out:
-	io_zctap_ifq_free(ifq);
+	io_zctap_ifq_close(ifq);
 	return err;
 }
 
@@ -499,7 +538,7 @@ int io_unregister_zctap_ifq(struct io_ring_ctx *ctx, unsigned long index)
 		return -EINVAL;
 
 	ctx->zctap_ifq = NULL;
-	io_zctap_ifq_free(ifq);
+	io_zctap_ifq_close(ifq);
 
 	return 0;
 }
-- 
2.30.2

