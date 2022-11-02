Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319216172E0
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiKBXkX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiKBXjz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:55 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A742AD4
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:32:58 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVqTF014603
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:32:58 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkva13p5k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:32:58 -0700
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:32:57 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id A3DD6235B6184; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 09/15] skbuff: Introduce SKBFL_FIXED_FRAG and skb_fixed()
Date:   Wed, 2 Nov 2022 16:32:38 -0700
Message-ID: <20221102233244.4022405-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
References: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: x0Qu9nkIjVmc7hDPnyKrmJc6mRp-F3oC
X-Proofpoint-ORIG-GUID: x0Qu9nkIjVmc7hDPnyKrmJc6mRp-F3oC
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

When a skb marked as zerocopy goes up the network stack, during
RX, it calls skb_orphan_frags_rx.  This is designed to catch TX
zerocopy data being redirected back up the stack, not new zerocopy
fragments coming up from the driver.

Currently, since the skb is marked as zerocopy, skb_copy_ubufs()
is called, defeating the point of zerocopy-RX.

Have the driver mark the fragments as fixed, so they are not copied.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 59c9fd55699d..5d57e2c37529 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -516,6 +516,9 @@ enum {
 	 * use frags only up until ubuf_info is released
 	 */
 	SKBFL_MANAGED_FRAG_REFS = BIT(4),
+
+	/* don't move or copy the fragment */
+	SKBFL_FIXED_FRAG = BIT(5),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
@@ -1653,6 +1656,11 @@ static inline bool skb_zcopy_managed(const struct sk_buff *skb)
 	return skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAG_REFS;
 }
 
+static inline bool skb_fixed(const struct sk_buff *skb)
+{
+	return skb_shinfo(skb)->flags & SKBFL_FIXED_FRAG;
+}
+
 static inline bool skb_pure_zcopy_same(const struct sk_buff *skb1,
 				       const struct sk_buff *skb2)
 {
@@ -3089,7 +3097,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
 /* Frags must be orphaned, even if refcounted, if skb might loop to rx path */
 static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
 {
-	if (likely(!skb_zcopy(skb)))
+	if (likely(!skb_zcopy(skb) || skb_fixed(skb)))
 		return 0;
 	return skb_copy_ubufs(skb, gfp_mask);
 }
-- 
2.30.2

