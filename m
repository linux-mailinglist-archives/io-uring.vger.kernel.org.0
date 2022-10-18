Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CED603329
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJRTQN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 18 Oct 2022 15:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJRTQL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:16:11 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEE058158
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:10 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IFF8CP014549
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:09 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k9ky5gh55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:09 -0700
Received: from twshared9384.24.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:16:08 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 4BF41227F050F; Tue, 18 Oct 2022 12:16:02 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v2 05/13] io_uring: create page freelist for the ifq region
Date:   Tue, 18 Oct 2022 12:15:54 -0700
Message-ID: <20221018191602.2112515-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
References: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: drkKCkEDu5CjumzBGTge4MGWDOF962KP
X-Proofpoint-GUID: drkKCkEDu5CjumzBGTge4MGWDOF962KP
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

Create a freelist where the driver can obtain pages for the packet
backing store.  Use the page's page_private field to record lookup
information.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 61 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 5 deletions(-)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index f8a5702f93f4..af2e871b1b62 100644
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
 	ifr->count = nr_pages;
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

