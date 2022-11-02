Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA1B6172DC
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiKBXkS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiKBXj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F323B26F7
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:33:03 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVrbW008281
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:33:03 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkrv4wyqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:33:03 -0700
Received: from twshared27579.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:33:02 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 9583A235B617E; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 07/15] io_uring: Allocate zctap device buffers and dma map them.
Date:   Wed, 2 Nov 2022 16:32:36 -0700
Message-ID: <20221102233244.4022405-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
References: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: chgXHM6gK3iTZOMKtL1C2f1OxpP5LfT_
X-Proofpoint-GUID: chgXHM6gK3iTZOMKtL1C2f1OxpP5LfT_
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
index c088655ade22..9f892e9ed8f2 100644
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

