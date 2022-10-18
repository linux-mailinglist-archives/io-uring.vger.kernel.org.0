Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74613603334
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJRTQZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 18 Oct 2022 15:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJRTQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:16:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC8E5A3DD
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:18 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IDnw0E024815
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:17 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k9gcnty5d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:17 -0700
Received: from twshared5252.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:16:14 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 82185227F0534; Tue, 18 Oct 2022 12:16:02 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v2 13/13] io_uring: Make remove_ifq_region a delayed work call
Date:   Tue, 18 Oct 2022 12:16:02 -0700
Message-ID: <20221018191602.2112515-14-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
References: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ezX_kytenqNn_y_5JETmJtMGGDf9pqhB
X-Proofpoint-ORIG-GUID: ezX_kytenqNn_y_5JETmJtMGGDf9pqhB
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

Very much a WIP!

The page backing store should not be removed until all ouststanding
packets are returned.  The packets may be inflight, owned by the
driver or sitting in a socket buffer.

This shows how the cleanup routine should check that there are no
pending packets in flight, before cleaning up the buffers.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 4a551349b600..a1525a0b0245 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -25,6 +25,7 @@ struct ifq_region {
 	u16			id;
 
 	spinlock_t		freelist_lock;
+	struct delayed_work	release_work;
 
 	struct io_zctap_buf	*buf;
 	struct io_zctap_buf	*freelist[];
@@ -199,24 +200,38 @@ static void io_zctap_put_page(struct io_zctap_ifq *ifq, struct page *page)
        io_zctap_put_buf(ifq, &ifr->buf[pgid]);
 }
 
-static void io_remove_ifq_region(struct ifq_region *ifr)
+static void io_remove_ifq_region_work(struct work_struct *work)
 {
-	struct io_mapped_ubuf *imu;
-	struct page *page;
-	int i;
+	struct ifq_region *ifr = container_of(
+		to_delayed_work(work), struct ifq_region, release_work);
+	struct io_zctap_buf *buf;
+	int i, refs;
 
-	imu = ifr->imu;
 	for (i = 0; i < ifr->nr_pages; i++) {
-		page = imu->bvec[i].bv_page;
+		buf = &ifr->buf[i];
+		refs = atomic_read(&buf->refcount) & IO_ZCTAP_KREF_MASK;
+		if (refs) {
+			schedule_delayed_work(&ifr->release_work, HZ);
+			return;
+		}
+	}
 
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
+	for (i = 0; i < ifr->nr_pages; i++) {
+		buf = &ifr->buf[i];
+		set_page_private(buf->page, 0);
+		ClearPagePrivate(buf->page);
 	}
 
 	kvfree(ifr->buf);
 	kvfree(ifr);
 }
 
+static void io_remove_ifq_region(struct ifq_region *ifr)
+{
+	INIT_DELAYED_WORK(&ifr->release_work, io_remove_ifq_region_work);
+	schedule_delayed_work(&ifr->release_work, 0);
+}
+
 static inline struct device *
 netdev2device(struct net_device *dev)
 {
@@ -403,6 +418,8 @@ static struct io_zctap_ifq *io_zctap_ifq_alloc(void)
 	return &priv->ifq;
 }
 
+/* XXX this seems to be called too late - MM is already torn down? */
+/* need to tear down sockets, then io_uring, then MM */
 static void io_zctap_ifq_free(struct io_zctap_ifq *ifq)
 {
 	if (ifq->queue_id != -1)
-- 
2.30.2

