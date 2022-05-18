Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3748152C7D6
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiERXie (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiERXiI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:38:08 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A51D02AB
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:52 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6IgC013714
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fNgFPteUPRSul4YL74K0HyPjAeD4pJsVpM/yBNzJ9mk=;
 b=jt+h995YXw8439ZAsanKmo0IQots139EyYPv+T82ddhOJ2QmthafY+Xb4dZ9gfzTEvHh
 UhA8i/PVaEJPKO6Pyf9RYOuD4ZFA+HIclSRW0asm2iVRxwrqPNcSfAJlHXm80uIEe188
 gX/mPFsUykf83G+FtTgd2ShLjkWOOwNp7vo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4dea3tmw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:52 -0700
Received: from twshared35748.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 18 May 2022 16:37:51 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 137DBF3ED86F; Wed, 18 May 2022 16:37:13 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v3 15/18] mm: Add balance_dirty_pages_ratelimited_async() function
Date:   Wed, 18 May 2022 16:37:06 -0700
Message-ID: <20220518233709.1937634-16-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518233709.1937634-1-shr@fb.com>
References: <20220518233709.1937634-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: iHfoUU1o6_mErrc4Uu-qMT_SUBBLaG8I
X-Proofpoint-GUID: iHfoUU1o6_mErrc4Uu-qMT_SUBBLaG8I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the helper function balance_dirty_pages_ratelimited_flags().
It adds the parameter no_wait to balance_dirty_pages_ratelimited().
For async buffered writes no_wait will be true.
A new function called balance_dirty_pages_ratelimited_async() is
introduced that calls balance_dirty_pages_ratelimited_flags with no_wait
set to true.
If write throttling is enabled, it retuns -EAGAIN, so the write request
can be punted to the io-uring worker.

For non-async writes the current behavior is maintained.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 include/linux/writeback.h |  1 +
 mm/page-writeback.c       | 60 +++++++++++++++++++++++++++++----------
 2 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index fec248ab1fec..15eb0242d3ef 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -373,6 +373,7 @@ unsigned long wb_calc_thresh(struct bdi_writeback *wb=
, unsigned long thresh);
=20
 void wb_update_bandwidth(struct bdi_writeback *wb);
 void balance_dirty_pages_ratelimited(struct address_space *mapping);
+int  balance_dirty_pages_ratelimited_async(struct address_space *mapping=
);
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
=20
 typedef int (*writepage_t)(struct page *page, struct writeback_control *=
wbc,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index fc3b79acd90b..d6a67fc07c55 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1851,28 +1851,18 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
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
+static int balance_dirty_pages_ratelimited_flags(struct address_space *m=
apping,
+						bool no_wait)
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
@@ -1912,12 +1902,52 @@ void balance_dirty_pages_ratelimited(struct addre=
ss_space *mapping)
 	preempt_enable();
=20
 	if (unlikely(current->nr_dirtied >=3D ratelimit))
-		balance_dirty_pages(wb, current->nr_dirtied, false);
+		balance_dirty_pages(wb, current->nr_dirtied, no_wait);
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
+/**
+ * balance_dirty_pages_ratelimited_async - balance dirty memory state
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
+ *
+ * This is the async version of the API. It only checks if it is require=
d to
+ * balance dirty pages. In case it needs to balance dirty pages, it retu=
rns
+ * -EAGAIN.
+ */
+int  balance_dirty_pages_ratelimited_async(struct address_space *mapping=
)
+{
+	return balance_dirty_pages_ratelimited_flags(mapping, true);
+}
+EXPORT_SYMBOL(balance_dirty_pages_ratelimited_async);
+
 /**
  * wb_over_bg_thresh - does @wb need to be written back?
  * @wb: bdi_writeback of interest
--=20
2.30.2

