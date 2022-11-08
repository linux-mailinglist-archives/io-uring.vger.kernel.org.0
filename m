Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72716208C7
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 06:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiKHFFq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 8 Nov 2022 00:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiKHFFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 00:05:41 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9CF17AB9
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 21:05:39 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7LKmUo022482
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 21:05:38 -0800
Received: from maileast.thefacebook.com ([163.114.130.3])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kq6kk4yf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 21:05:38 -0800
Received: from twshared2001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 21:05:37 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id F335A23B26011; Mon,  7 Nov 2022 21:05:21 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [PATCH v1 05/15] io_uring: mark pages in ifq region with zctap information.
Date:   Mon, 7 Nov 2022 21:05:11 -0800
Message-ID: <20221108050521.3198458-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Ct5t0uyShckbSY0wYhvTP4p0n6ROSynx
X-Proofpoint-GUID: Ct5t0uyShckbSY0wYhvTP4p0n6ROSynx
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

The network stack passes up pages, which must be mapped to
zctap device buffers in order to get the reference count and
other items.  Mark the page as private, and use the page_private
field to record the lookup and ownership information.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 61 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 5 deletions(-)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 0705f5056d07..7426feee1e04 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -27,18 +27,68 @@ struct ifq_region {
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
+static void zctap_set_page_info(struct page *page, u64 info)
+{
+	set_page_private(page, info);
+}
+
+static u64 zctap_mk_page_info(u16 region_id, u16 pgid)
+{
+	return (u64)0xface << 48 | (u64)region_id << 16 | (u64)pgid;
+}
+
 static void io_remove_ifq_region(struct ifq_region *ifr)
 {
+	struct io_mapped_ubuf *imu;
+	struct page *page;
+	int i;
+
+	imu = ifr->imu;
+	for (i = 0; i < ifr->nr_pages; i++) {
+		page = imu->bvec[i].bv_page;
+
+		ClearPagePrivate(page);
+		set_page_private(page, 0);
+	}
+
 	kvfree(ifr);
 }
 
+static int io_zctap_map_region(struct ifq_region *ifr)
+{
+	struct io_mapped_ubuf *imu;
+	struct page *page;
+	u64 info;
+	int i;
+
+	imu = ifr->imu;
+	for (i = 0; i < ifr->nr_pages; i++) {
+		page = imu->bvec[i].bv_page;
+		if (PagePrivate(page))
+			goto out;
+		SetPagePrivate(page);
+		info = zctap_mk_page_info(ifr->id, i);
+		zctap_set_page_info(page, info);
+		ifr->freelist[i] = page;
+	}
+	return 0;
+
+out:
+	while (i--) {
+		page = imu->bvec[i].bv_page;
+		ClearPagePrivate(page);
+		set_page_private(page, 0);
+	}
+	return -EEXIST;
+}
+
 int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 {
 	struct io_ring_ctx *ctx = ifq->ctx;
 	struct io_mapped_ubuf *imu;
 	struct ifq_region *ifr;
-	int i, nr_pages;
-	struct page *page;
+	int nr_pages;
+	int err;
 
 	/* XXX for now, only allow one region per ifq. */
 	if (ifq->region)
@@ -63,9 +113,10 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 	ifr->free_count = nr_pages;
 	ifr->id = id;
 
-	for (i = 0; i < nr_pages; i++) {
-		page = imu->bvec[i].bv_page;
-		ifr->freelist[i] = page;
+	err = io_zctap_map_region(ifr);
+	if (err) {
+		kvfree(ifr);
+		return err;
 	}
 
 	ifq->region = ifr;
-- 
2.30.2

