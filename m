Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD8C6172E2
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiKBXkY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiKBXjz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:55 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DF82713
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:32:58 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVqTE014603
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:32:58 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkva13p5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:32:57 -0700
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:32:57 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id ABBED235B6186; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 10/15] io_uring: Allocate a uarg for use by the ifq RX
Date:   Wed, 2 Nov 2022 16:32:39 -0700
Message-ID: <20221102233244.4022405-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
References: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Gy7gooCVhGzW9cLv_NWg2B2RiBOnEWJe
X-Proofpoint-ORIG-GUID: Gy7gooCVhGzW9cLv_NWg2B2RiBOnEWJe
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

Create a static uarg which is attached to zerocopy RX buffers,
and add a callback to handle freeing the skb.

As the skb is marked as zerocopy, it bypasses the default network
skb fragment destructor and calls our version.  This handles our
refcounts, and releasing the ZC buffer back to the freelist.

Add the put_page() implementations, which release the fragments.
This may also be called by drivers during cleanup.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 64 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 8 deletions(-)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 766da3bb2e41..a84204c6eb96 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -30,6 +30,12 @@ struct ifq_region {
 	u16			freelist[];
 };
 
+/* XXX get around not having "struct ubuf_info" defined in io_uring_types.h */
+struct io_zctap_ifq_priv {
+	struct io_zctap_ifq	ifq;
+	struct ubuf_info	uarg;
+};
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
 static void zctap_set_page_info(struct page *page, u64 info)
@@ -52,6 +58,16 @@ static u16 zctap_page_id(const struct page *page)
 	return zctap_page_info(page) & 0xffff;
 }
 
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
 #define IO_ZCTAP_UREF		0x10000
 #define IO_ZCTAP_KREF_MASK	(IO_ZCTAP_UREF - 1)
@@ -70,7 +86,9 @@ static bool io_zctap_put_buf_uref(struct io_zctap_buf *buf)
 	return atomic_sub_and_test(IO_ZCTAP_UREF, &buf->refcount);
 }
 
-/* gets a user-supplied buffer from the fill queue */
+/* gets a user-supplied buffer from the fill queue
+ *   note: may drain N entries, but still have no usable buffers
+ */
 static struct io_zctap_buf *io_zctap_get_buffer(struct io_zctap_ifq *ifq,
 						u16 *buf_pgid)
 {
@@ -181,9 +199,19 @@ void io_zctap_put_buf_refs(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf,
 }
 EXPORT_SYMBOL(io_zctap_put_buf_refs);
 
+/* could be called by the stack as it drops/recycles the skbs */
 bool io_zctap_put_page(struct io_zctap_ifq *ifq, struct page *page)
 {
-	return false;
+	struct ifq_region *ifr;
+	u16 pgid;
+
+	if (!zctap_page_ours(page))
+		return false;
+
+	ifr = ifq->region;			/* only one */
+	pgid = zctap_page_id(page);
+	io_zctap_put_buf(ifq, &ifr->buf[pgid]);
+	return true;
 }
 EXPORT_SYMBOL(io_zctap_put_page);
 
@@ -347,17 +375,35 @@ static int io_close_zctap_ifq(struct io_zctap_ifq *ifq, u16 queue_id)
 	return __io_queue_mgmt(ifq->dev, NULL, queue_id);
 }
 
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
+		if (!io_zctap_put_page(&priv->ifq, page))
+			__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
+	}
+}
+
 static struct io_zctap_ifq *io_zctap_ifq_alloc(struct io_ring_ctx *ctx)
 {
-	struct io_zctap_ifq *ifq;
+	struct io_zctap_ifq_priv *priv;
 
-	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
-	if (!ifq)
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
 		return NULL;
 
-	ifq->ctx = ctx;
-	ifq->queue_id = -1;
-	return ifq;
+	priv->ifq.ctx = ctx;
+	priv->ifq.queue_id = -1;
+	priv->ifq.uarg = &priv->uarg;
+	return &priv->ifq;
 }
 
 static void io_zctap_ifq_free(struct io_zctap_ifq *ifq)
@@ -392,6 +438,8 @@ int io_register_ifq(struct io_ring_ctx *ctx,
 		return -ENOMEM;
 
 	ifq->fill_bgid = req.fill_bgid;
+	ifq->uarg->callback = io_zctap_ifq_callback;
+	ifq->uarg->flags = SKBFL_ALL_ZEROCOPY | SKBFL_FIXED_FRAG;
 
 	err = -ENODEV;
 	ifq->dev = dev_get_by_index(&init_net, req.ifindex);
-- 
2.30.2

