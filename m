Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47A560332A
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJRTQO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 18 Oct 2022 15:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJRTQN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:16:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A790580B9
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:12 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IH7WvQ005819
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:12 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k9tpedhgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:11 -0700
Received: from twshared25017.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:16:10 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 6F190227F052D; Tue, 18 Oct 2022 12:16:02 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v2 10/13] io_uring: Allocate a uarg for use by the ifq RX
Date:   Tue, 18 Oct 2022 12:15:59 -0700
Message-ID: <20221018191602.2112515-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
References: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: mOsKDBfi9qmG4nTywYgIprNzz4nDczsv
X-Proofpoint-GUID: mOsKDBfi9qmG4nTywYgIprNzz4nDczsv
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

Create a static uarg which is attached to zerocopy RX buffers,
and add a callback to handle freeing the skb.

As the skb is marked as zerocopy, it bypasses the default network
skb fragment destructor and calls our version.  This handles our
refcounts, and releasing the ZC buffer back to the freelist.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 71 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 5 deletions(-)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index a398270cc43d..b83a62882c27 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -41,6 +41,26 @@ static u64 zctap_mk_page_info(u16 region_id, u16 pgid)
 	return (u64)0xface << 48 | (u64)region_id << 16 | (u64)pgid;
 }
 
+static u64 zctap_page_info(const struct page *page)
+{
+	return page_private(page);
+}
+
+static u16 zctap_page_id(const struct page *page)
+{
+	return zctap_page_info(page) & 0xffff;
+}
+
+static bool zctap_page_magic(const struct page *page)
+{
+	return (zctap_page_info(page) >> 48) == 0xface;
+}
+
+static bool zctap_page_ours(struct page *page)
+{
+	return PagePrivate(page) && zctap_page_magic(page);
+}
+
 /* driver bias cannot be larger than this */
 #define IO_ZCTAP_UREF		0x1000
 #define IO_ZCTAP_KREF_MASK	(IO_ZCTAP_UREF - 1)
@@ -154,6 +174,17 @@ void io_zctap_put_buf(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf)
 }
 EXPORT_SYMBOL(io_zctap_put_buf);
 
+/* could be called by the stack as it drops/recycles the skbs */
+static void io_zctap_put_page(struct io_zctap_ifq *ifq, struct page *page)
+{
+       struct ifq_region *ifr;
+       u16 pgid;
+
+       ifr = ifq->region;		       /* only one */
+       pgid = zctap_page_id(page);
+       io_zctap_put_buf(ifq, &ifr->buf[pgid]);
+}
+
 static void io_remove_ifq_region(struct ifq_region *ifr)
 {
 	struct io_mapped_ubuf *imu;
@@ -306,16 +337,44 @@ static int io_close_zctap_ifq(struct io_zctap_ifq *ifq, u16 queue_id)
 	return __io_queue_mgmt(ifq->dev, NULL, queue_id);
 }
 
+/* XXX get around not having "struct ubuf_info" defined in io_uring_types.h */
+struct io_zctap_ifq_priv {
+	struct io_zctap_ifq	ifq;
+	struct ubuf_info	uarg;
+};
+
+static void io_zctap_ifq_callback(struct sk_buff *skb, struct ubuf_info *uarg,
+				  bool success)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	struct io_zctap_ifq_priv *priv;
+	struct page *page;
+	int i;
+
+	priv = container_of(uarg, struct io_zctap_ifq_priv, uarg);
+
+	for (i = 0; i < shinfo->nr_frags; i++) {
+		page = skb_frag_page(&shinfo->frags[i]);
+		if (zctap_page_ours(page))
+			io_zctap_put_page(&priv->ifq, page);
+#if 0
+		else
+			put_page(page);
+#endif
+	}
+}
+
 static struct io_zctap_ifq *io_zctap_ifq_alloc(void)
 {
-	struct io_zctap_ifq *ifq;
+	struct io_zctap_ifq_priv *priv;
 
-	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
-	if (!ifq)
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
 		return NULL;
 
-	ifq->queue_id = -1;
-	return ifq;
+	priv->ifq.queue_id = -1;
+	priv->ifq.uarg = &priv->uarg;
+	return &priv->ifq;
 }
 
 static void io_zctap_ifq_free(struct io_zctap_ifq *ifq)
@@ -351,6 +410,8 @@ int io_register_ifq(struct io_ring_ctx *ctx,
 
 	ifq->ctx = ctx;
 	ifq->fill_bgid = req.fill_bgid;
+	ifq->uarg->callback = io_zctap_ifq_callback;
+	ifq->uarg->flags = SKBFL_ALL_ZEROCOPY | SKBFL_FIXED_FRAG;
 
 	err = -ENODEV;
 	ifq->dev = dev_get_by_index(&init_net, req.ifindex);
-- 
2.30.2

