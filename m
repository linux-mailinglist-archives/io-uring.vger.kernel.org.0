Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8355F7FA2
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiJGVRe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJGVRc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:17:32 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B228873C1B
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:17:26 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297I5Gan010451
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:17:26 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k27evyp6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:17:25 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:25 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 73DB921DAFDA2; Fri,  7 Oct 2022 14:17:13 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC v1 6/9] io_uring: introduce reference tracking for user pages.
Date:   Fri, 7 Oct 2022 14:17:10 -0700
Message-ID: <20221007211713.170714-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007211713.170714-1-jonathan.lemon@gmail.com>
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 5Z9W4HqVj-qrElROvJnME-I8ZJuly40L
X-Proofpoint-ORIG-GUID: 5Z9W4HqVj-qrElROvJnME-I8ZJuly40L
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

This is currently a WIP.

If only part of a page is used by a skb fragment, and then provided
to the user, the page should not be reused by the kernel until all
sub-page fragments are not in use.

If only full pages are used (and not sub-page fragments), then this
code shouldn't be needed.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 58b4c5417650..9db3421fb9fa 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -183,9 +183,36 @@ struct ifq_region {
 	int			count;
 	int			imu_idx;
 	int			nr_pages;
+	u8			*page_uref;
 	struct page		*page[];
 };
 
+static void io_add_page_uref(struct ifq_region *ifr, u16 pgid)
+{
+	if (WARN_ON(!ifr))
+		return;
+
+	if (WARN_ON(pgid < ifr->imu_idx))
+		return;
+
+	ifr->page_uref[pgid - ifr->imu_idx]++;
+}
+
+static bool io_put_page_last_uref(struct ifq_region *ifr, u64 addr)
+{
+	int idx;
+
+	if (WARN_ON(addr < ifr->start || addr > ifr->end))
+		return false;
+
+	idx = (addr - ifr->start) >> PAGE_SHIFT;
+
+	if (WARN_ON(!ifr->page_uref[idx]))
+		return false;
+
+	return --ifr->page_uref[idx] == 0;
+}
+
 int io_provide_ifq_region_prep(struct io_kiocb *req,
 			       const struct io_uring_sqe *sqe)
 {
@@ -244,6 +271,11 @@ int io_provide_ifq_region(struct io_kiocb *req, unsigned int issue_flags)
 	if (!ifr)
 		return -ENOMEM;
 
+	ifr->page_uref = kvmalloc_array(nr_pages, sizeof(u8), GFP_KERNEL);
+	if (!ifr->page_uref) {
+		kvfree(ifr);
+		return -ENOMEM;
+	}
 
 	ifr->nr_pages = nr_pages;
 	ifr->imu_idx = idx;
@@ -261,6 +293,7 @@ int io_provide_ifq_region(struct io_kiocb *req, unsigned int issue_flags)
 		info = zctap_page_info(r->bgid, idx + i, id);
 		set_page_private(page, info);
 		ifr->page[i] = page;
+		ifr->page_uref[i] = 0;
 	}
 
 	WRITE_ONCE(r->ifq->region,  ifr);
@@ -273,6 +306,7 @@ int io_provide_ifq_region(struct io_kiocb *req, unsigned int issue_flags)
 		set_page_private(page, 0);
 	}
 
+	kvfree(ifr->page_uref);
 	kvfree(ifr);
 
 	return -EEXIST;
-- 
2.30.2

