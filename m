Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC7B5F7FA4
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiJGVRe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiJGVRc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:17:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13600925BA
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:17:27 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297I5iKs027912
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:17:26 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k2hshchc7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:17:26 -0700
Received: from twshared0933.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:24 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 6C2D321DAFDA0; Fri,  7 Oct 2022 14:17:13 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC v1 5/9] io_uring: Add io_uring zctap iov structure and helpers
Date:   Fri, 7 Oct 2022 14:17:09 -0700
Message-ID: <20221007211713.170714-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007211713.170714-1-jonathan.lemon@gmail.com>
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 60zRx7nguJYLQkbz-gzDzyCNdoQy3qEU
X-Proofpoint-GUID: 60zRx7nguJYLQkbz-gzDzyCNdoQy3qEU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
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

With networking zero-copy receive, the incoming data is placed
directly into user-supplied buffers.  Instead of returning the
buffer address, return the buffer group id and buffer id, and
let the application figure out the base address.

Add helpers for storing and retrieving the encoding, which is
stored in the page_private field.  This will be used in the
zerocopy RX routine, when handling pages from skb fragments.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/linux/io_uring.h | 10 +++++++++
 io_uring/zctap.c              | 39 ++++++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3b392f8270dc..145d55280919 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -664,6 +664,16 @@ struct io_uring_ifq_req {
 	__u16	__pad[3];
 };
 
+struct io_uring_zctap_iov {
+	__u32	off;
+	__u32	len;
+	__u16	bgid;
+	__u16	bid;
+	__u16	ifq_id;
+	__u16	resv;
+};
+
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 728f7c938b7b..58b4c5417650 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -19,6 +19,26 @@ static DEFINE_XARRAY_ALLOC1(io_zctap_ifq_xa);
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
+static u64 zctap_page_info(u16 region_id, u16 pgid, u16 ifq_id)
+{
+	return (u64)region_id << 32 | (u64)pgid << 16 | ifq_id;
+}
+
+static u16 zctap_page_region_id(const struct page *page)
+{
+	return (page_private(page) >> 32) & 0xffff;
+}
+
+static u16 zctap_page_id(const struct page *page)
+{
+	return (page_private(page) >> 16) & 0xffff;
+}
+
+static u16 zctap_page_ifq_id(const struct page *page)
+{
+	return page_private(page) & 0xffff;
+}
+
 static int __io_queue_mgmt(struct net_device *dev, struct io_zctap_ifq *ifq,
 			   u16 *queue_id)
 {
@@ -213,8 +233,9 @@ int io_provide_ifq_region(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ifq_region *r = io_kiocb_to_cmd(req, struct io_ifq_region);
 	struct ifq_region *ifr;
-	int i, idx, nr_pages;
+	int i, id, idx, nr_pages;
 	struct page *page;
+	u64 info;
 
 	nr_pages = r->len >> PAGE_SHIFT;
 	idx = (r->addr - req->imu->ubuf) >> PAGE_SHIFT;
@@ -231,12 +252,28 @@ int io_provide_ifq_region(struct io_kiocb *req, unsigned int issue_flags)
 	ifr->start = r->addr;
 	ifr->end = r->addr + r->len;
 
+	id = r->ifq->id;
 	for (i = 0; i < nr_pages; i++, idx++) {
 		page = req->imu->bvec[idx].bv_page;
+		if (PagePrivate(page))
+			goto out;
+		SetPagePrivate(page);
+		info = zctap_page_info(r->bgid, idx + i, id);
+		set_page_private(page, info);
 		ifr->page[i] = page;
 	}
 
 	WRITE_ONCE(r->ifq->region,  ifr);
 
 	return 0;
+out:
+	while (i--) {
+		page = req->imu->bvec[idx + i].bv_page;
+		ClearPagePrivate(page);
+		set_page_private(page, 0);
+	}
+
+	kvfree(ifr);
+
+	return -EEXIST;
 }
-- 
2.30.2

