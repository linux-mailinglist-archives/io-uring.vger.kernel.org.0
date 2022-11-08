Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702E56208C1
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 06:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiKHFFg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 8 Nov 2022 00:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiKHFFe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 00:05:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4002AE44
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 21:05:33 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80Utv8007222
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 21:05:33 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kqcmqse5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 21:05:33 -0800
Received: from twshared5476.02.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 21:05:32 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 0CB6C23B26015; Mon,  7 Nov 2022 21:05:22 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [PATCH v1 07/15] io_uring: Allocate zctap device buffers and dma map them.
Date:   Mon, 7 Nov 2022 21:05:13 -0800
Message-ID: <20221108050521.3198458-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: an758WKV419bhmqoSaFd1I5IpsJtwp3C
X-Proofpoint-ORIG-GUID: an758WKV419bhmqoSaFd1I5IpsJtwp3C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
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

The goal is to register a memory region with the device, and
later specify the desired packet buffer size.  The code currently
assumes a page size.

Create the desired number of zctap buffers and DMA map them
to the target device, recording the dma address for later use.

Hold a page reference while the page is dma mapped.

Change the freelist from an array of page pointers to an index
into the device buffer list.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 78 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 63 insertions(+), 15 deletions(-)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 69a04de87f8f..fe4bb3781636 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -18,11 +18,14 @@
 #define NR_ZCTAP_IFQS	1
 
 struct ifq_region {
+	struct io_zctap_ifq	*ifq;		/* only for delayed_work */
 	struct io_mapped_ubuf	*imu;
 	int			free_count;
 	int			nr_pages;
 	u16			id;
-	struct page		*freelist[];
+
+	struct io_zctap_buf	*buf;
+	u16			freelist[];
 };
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
@@ -60,49 +63,85 @@ bool io_zctap_put_page(struct io_zctap_ifq *ifq, struct page *page)
 }
 EXPORT_SYMBOL(io_zctap_put_page);
 
+static inline struct device *
+netdev2device(struct net_device *dev)
+{
+	return dev->dev.parent;			/* from SET_NETDEV_DEV() */
+}
+
 static void io_remove_ifq_region(struct ifq_region *ifr)
 {
-	struct io_mapped_ubuf *imu;
-	struct page *page;
+	struct device *device = netdev2device(ifr->ifq->dev);
+	struct io_zctap_buf *buf;
 	int i;
 
-	imu = ifr->imu;
 	for (i = 0; i < ifr->nr_pages; i++) {
-		page = imu->bvec[i].bv_page;
-
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
+		buf = &ifr->buf[i];
+		set_page_private(buf->page, 0);
+		ClearPagePrivate(buf->page);
+		dma_unmap_page_attrs(device, buf->dma, PAGE_SIZE,
+				     DMA_BIDIRECTIONAL,
+				     DMA_ATTR_SKIP_CPU_SYNC);
+		put_page(buf->page);
 	}
 
+	kvfree(ifr->buf);
 	kvfree(ifr);
 }
 
-static int io_zctap_map_region(struct ifq_region *ifr)
+static int io_zctap_map_region(struct ifq_region *ifr, struct device *device)
 {
 	struct io_mapped_ubuf *imu;
+	struct io_zctap_buf *buf;
 	struct page *page;
+	dma_addr_t addr;
+	int i, err;
 	u64 info;
-	int i;
 
 	imu = ifr->imu;
 	for (i = 0; i < ifr->nr_pages; i++) {
 		page = imu->bvec[i].bv_page;
-		if (PagePrivate(page))
+
+		if (PagePrivate(page)) {
+			err = -EEXIST;
 			goto out;
+		}
+
 		SetPagePrivate(page);
 		info = zctap_mk_page_info(ifr->id, i);
 		zctap_set_page_info(page, info);
-		ifr->freelist[i] = page;
+
+		buf = &ifr->buf[i];
+		addr = dma_map_page_attrs(device, page, 0, PAGE_SIZE,
+					  DMA_BIDIRECTIONAL,
+					  DMA_ATTR_SKIP_CPU_SYNC);
+		if (dma_mapping_error(device, addr)) {
+			set_page_private(page, 0);
+			ClearPagePrivate(page);
+			err = -ENOMEM;
+			goto out;
+		}
+		buf->dma = addr;
+		buf->page = page;
+		atomic_set(&buf->refcount, 0);
+		get_page(page);
+
+		ifr->freelist[i] = i;
 	}
 	return 0;
 
 out:
 	while (i--) {
 		page = imu->bvec[i].bv_page;
-		ClearPagePrivate(page);
 		set_page_private(page, 0);
+		ClearPagePrivate(page);
+		buf = &ifr->buf[i];
+		dma_unmap_page_attrs(device, buf->dma, PAGE_SIZE,
+				     DMA_BIDIRECTIONAL,
+				     DMA_ATTR_SKIP_CPU_SYNC);
+		put_page(page);
 	}
-	return -EEXIST;
+	return err;
 }
 
 int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
@@ -131,13 +170,22 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 	if (!ifr)
 		return -ENOMEM;
 
+	ifr->buf = kvmalloc_array(nr_pages, sizeof(*ifr->buf), GFP_KERNEL);
+	if (!ifr->buf) {
+		kvfree(ifr);
+		return -ENOMEM;
+	}
+
 	ifr->nr_pages = nr_pages;
 	ifr->imu = imu;
 	ifr->free_count = nr_pages;
 	ifr->id = id;
 
-	err = io_zctap_map_region(ifr);
+	ifr->ifq = ifq;		/* XXX */
+
+	err = io_zctap_map_region(ifr, netdev2device(ifq->dev));
 	if (err) {
+		kvfree(ifr->buf);
 		kvfree(ifr);
 		return err;
 	}
-- 
2.30.2

