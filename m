Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAF852F31E
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350635AbiETShd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352892AbiETShb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:37:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8509195935
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:29 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24KHSQ57022413
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4+pNNcv/s7lwCe+89++WipKGwJWYuAjDxvNindOohPA=;
 b=JU9hG2Y4vcXbFkMMX7XUkpXndS7kbihL0F0ALOTtvizu6TxLA3oue1fzEP9D9zNhKsXg
 ybCIYG/Aeen2zEayM/MUVt/8hsUi1PHi6aiZBcCQEobZR1ZwJBJXLgBpG3hDha05hbro
 9g7pcxDqu6T3amNZx/YKJRQHIhHSTgSS1hM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g6bja2aus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:28 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub101.TheFacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:27 -0700
Received: from twshared6696.05.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:27 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 71B86F5E5B27; Fri, 20 May 2022 11:37:16 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [RFC PATCH v4 04/17] mm: Add balance_dirty_pages_ratelimited_flags() function
Date:   Fri, 20 May 2022 11:36:33 -0700
Message-ID: <20220520183646.2002023-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220520183646.2002023-1-shr@fb.com>
References: <20220520183646.2002023-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ISo3UsNHN8aCirx9CG3O4s4XUWUfDYXL
X-Proofpoint-ORIG-GUID: ISo3UsNHN8aCirx9CG3O4s4XUWUfDYXL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_05,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
It adds the parameter flags to balance_dirty_pages_ratelimited().
The flags parameter is passed to balance_dirty_pages(). For async
buffered writes the flag value will be BDP_ASYNC.

The new helper function is also used by balance_dirty_pages_ratelimited()=
.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 include/linux/writeback.h |  3 +++
 mm/page-writeback.c       | 38 +++++++++++++++++++++++---------------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a9114c5090e9..1bddad86a4f6 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -377,6 +377,9 @@ void wb_update_bandwidth(struct bdi_writeback *wb);
 #define BDP_ASYNC 0x0001
=20
 void balance_dirty_pages_ratelimited(struct address_space *mapping);
+int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
+		unsigned int flags);
+
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
=20
 typedef int (*writepage_t)(struct page *page, struct writeback_control *=
wbc,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7a320fd2ad33..3701e813d05f 100644
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
+int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
+					unsigned int flags)
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
@@ -1912,9 +1902,27 @@ void balance_dirty_pages_ratelimited(struct addres=
s_space *mapping)
 	preempt_enable();
=20
 	if (unlikely(current->nr_dirtied >=3D ratelimit))
-		balance_dirty_pages(wb, current->nr_dirtied, 0);
+		balance_dirty_pages(wb, current->nr_dirtied, flags);
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
+	balance_dirty_pages_ratelimited_flags(mapping, 0);
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
=20
--=20
2.30.2

