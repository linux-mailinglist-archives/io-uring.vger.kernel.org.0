Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175EA528AF9
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343917AbiEPQtK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343922AbiEPQtB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:49:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650F53C73C
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:56 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GF657a019213
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=T6Nf5vvbSAgD76rs2Ks0JXOmFetMmsycSIKG8Fv6YWk=;
 b=C4vXe1DOYARU4E6ZwAe57ojhYXfaaT32ISu+1SkIAi2q2CQgsHeXVxYNDoJVrHVwhmYJ
 gEM6sQWDB6eMOmpKdS+g2K0uXxITuWsg4of1/sqhFJsYO59o8GuM8cohXQS7Fr8YPfcP
 hslOIdmb35IXVQfZqmJCGv1blE9eWw5wL3Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a4ntn7e-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:56 -0700
Received: from twshared10276.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:53 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 8986BF146DE9; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 13/16] mm: add balance_dirty_pages_ratelimited_flags() function
Date:   Mon, 16 May 2022 09:47:15 -0700
Message-ID: <20220516164718.2419891-14-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220516164718.2419891-1-shr@fb.com>
References: <20220516164718.2419891-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ZNReFpLVpwvkYxpj2b_B79T75yRl6AIT
X-Proofpoint-ORIG-GUID: ZNReFpLVpwvkYxpj2b_B79T75yRl6AIT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the function balance_dirty_pages_ratelimited_flags(). It adds
the parameter is_async to balance_dirty_pages_ratelimited(). In case
this is an async write, it will call _balance_diirty_pages() to
determine if write throttling needs to be enabled. If write throttling
is enabled, it retuns -EAGAIN, so the write request can be punted to
the io-uring worker.

The new function is changed to return the sleep time, so callers can
observe if the write has been punted.

For non-async writes the current behavior is maintained.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 include/linux/writeback.h |  1 +
 mm/page-writeback.c       | 48 ++++++++++++++++++++++++++-------------
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index fec248ab1fec..d589804bb3be 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -373,6 +373,7 @@ unsigned long wb_calc_thresh(struct bdi_writeback *wb=
, unsigned long thresh);
=20
 void wb_update_bandwidth(struct bdi_writeback *wb);
 void balance_dirty_pages_ratelimited(struct address_space *mapping);
+int  balance_dirty_pages_ratelimited_flags(struct address_space *mapping=
, bool is_async);
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
=20
 typedef int (*writepage_t)(struct page *page, struct writeback_control *=
wbc,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index cbb74c0666c6..78f1326f3f20 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1877,28 +1877,17 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
  */
 DEFINE_PER_CPU(int, dirty_throttle_leaks) =3D 0;
=20
-/**
- * balance_dirty_pages_ratelimited - balance dirty memory state
- * @mapping: address_space which was dirtied
- *
- * Processes which are dirtying memory should call in here once for each=
 page
- * which was newly dirtied.  The function will periodically check the sy=
stem's
- * dirty state and will initiate writeback if needed.
- *
- * Once we're over the dirty memory limit we decrease the ratelimiting
- * by a lot, to prevent individual processes from overshooting the limit
- * by (ratelimit_pages) each.
- */
-void balance_dirty_pages_ratelimited(struct address_space *mapping)
+int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,=
 bool is_async)
 {
 	struct inode *inode =3D mapping->host;
 	struct backing_dev_info *bdi =3D inode_to_bdi(inode);
 	struct bdi_writeback *wb =3D NULL;
 	int ratelimit;
+	int ret =3D 0;
 	int *p;
=20
 	if (!(bdi->capabilities & BDI_CAP_WRITEBACK))
-		return;
+		return ret;
=20
 	if (inode_cgwb_enabled(inode))
 		wb =3D wb_get_create_current(bdi, GFP_KERNEL);
@@ -1937,10 +1926,37 @@ void balance_dirty_pages_ratelimited(struct addre=
ss_space *mapping)
 	}
 	preempt_enable();
=20
-	if (unlikely(current->nr_dirtied >=3D ratelimit))
-		balance_dirty_pages(wb, current->nr_dirtied);
+	if (unlikely(current->nr_dirtied >=3D ratelimit)) {
+		if (is_async) {
+			struct bdp_ctx ctx =3D { BDP_CTX_INIT(ctx, wb) };
+
+			ret =3D _balance_dirty_pages(wb, current->nr_dirtied, &ctx);
+			if (ret)
+				ret =3D -EAGAIN;
+		} else {
+			balance_dirty_pages(wb, current->nr_dirtied);
+		}
+	}
=20
 	wb_put(wb);
+	return ret;
+}
+
+/**
+ * balance_dirty_pages_ratelimited - balance dirty memory state
+ * @mapping: address_space which was dirtied
+ *
+ * Processes which are dirtying memory should call in here once for each=
 page
+ * which was newly dirtied.  The function will periodically check the sy=
stem's
+ * dirty state and will initiate writeback if needed.
+ *
+ * Once we're over the dirty memory limit we decrease the ratelimiting
+ * by a lot, to prevent individual processes from overshooting the limit
+ * by (ratelimit_pages) each.
+ */
+void balance_dirty_pages_ratelimited(struct address_space *mapping)
+{
+	balance_dirty_pages_ratelimited_flags(mapping, false);
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
=20
--=20
2.30.2

