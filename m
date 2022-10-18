Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C09603330
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiJRTQV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 18 Oct 2022 15:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJRTQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:16:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F555E640
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:17 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 29IE0NVH004402
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:15 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3k9abe6w7k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:15 -0700
Received: from twshared9269.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:16:14 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 59CDC227F0515; Tue, 18 Oct 2022 12:16:02 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v2 07/13] io_uring: Allocate the zctap buffers for the device
Date:   Tue, 18 Oct 2022 12:15:56 -0700
Message-ID: <20221018191602.2112515-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
References: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: uBTF1Xbv6cilX-q1CPMV570uIVF_H_2V
X-Proofpoint-ORIG-GUID: uBTF1Xbv6cilX-q1CPMV570uIVF_H_2V
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

The idea is to register a memory region with the device, and
later specify the desired packet buffer size.  The code currently
assumes a page size.

Create the desired number of zctap buffers and DMA map them
to the target device, recording the dma address for later use.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 55 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 46ba0d011250..a924e59513a4 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -22,7 +22,9 @@ struct ifq_region {
 	int			count;
 	int			nr_pages;
 	u16			id;
-	struct page		*freelist[];
+
+	struct io_zctap_buf	*buf;
+	struct io_zctap_buf	*freelist[];
 };
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
@@ -62,35 +64,65 @@ static void io_remove_ifq_region(struct ifq_region *ifr)
 		set_page_private(page, 0);
 	}
 
+	kvfree(ifr->buf);
 	kvfree(ifr);
 }
 
-static int io_zctap_map_region(struct ifq_region *ifr)
+static inline struct device *
+netdev2device(struct net_device *dev)
+{
+	return dev->dev.parent;			/* from SET_NETDEV_DEV() */
+}
+
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
+			err = -ENOMEM;
+			goto out;
+		}
+		buf->dma = addr;
+		buf->page = page;
+		atomic_set(&buf->refcount, 0);
+
+		ifr->freelist[i] = buf;
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
 	}
-	return -EEXIST;
+	return err;
 }
 
 int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
@@ -119,13 +151,20 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
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
 	ifr->count = nr_pages;
 	ifr->id = id;
 
-	err = io_zctap_map_region(ifr);
+	err = io_zctap_map_region(ifr, netdev2device(ifq->dev));
 	if (err) {
+		kvfree(ifr->buf);
 		kvfree(ifr);
 		return err;
 	}
-- 
2.30.2

