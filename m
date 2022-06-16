Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C1F54EC8A
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 23:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379172AbiFPV2V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 17:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379116AbiFPV2S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 17:28:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC0422502
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 14:28:17 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GKPSwX020230
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 14:28:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=V4TkoQ7WXm0jJu0pyVno6F/WdfdTQwfd01SRs7zvVjU=;
 b=eFMT/WnlE3uD4DSMpityR+D9RsFeVopvkHCY0i1z52oE1pFQg0f182KxO0KAj8NFBX+V
 0VwbBSNGPWdv2cjE4ltuYfaJzc8O857JVoS8yHBcE8zu3iNI9hiHDwyKRopoxtnXfQBf
 AtEWjTuiQALH9xy9HZurHZ8niezDOxxjOg8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gqve427wj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 14:28:16 -0700
Received: from twshared14818.18.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 16 Jun 2022 14:28:15 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9B98D108B7097; Thu, 16 Jun 2022 14:22:23 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>, <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v9 03/14] mm: Add balance_dirty_pages_ratelimited_flags() function
Date:   Thu, 16 Jun 2022 14:22:10 -0700
Message-ID: <20220616212221.2024518-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220616212221.2024518-1-shr@fb.com>
References: <20220616212221.2024518-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Po1PKghZkFM9r41E1Etg7-VIj-jGlnVH
X-Proofpoint-GUID: Po1PKghZkFM9r41E1Etg7-VIj-jGlnVH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_18,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jan Kara <jack@suse.cz>

This adds the helper function balance_dirty_pages_ratelimited_flags().
It adds the parameter flags to balance_dirty_pages_ratelimited().
The flags parameter is passed to balance_dirty_pages(). For async
buffered writes the flag value will be BDP_ASYNC.

If balance_dirty_pages() gets called for async buffered write, we don't
want to wait. Instead we need to indicate to the caller that throttling
is needed so that it can stop writing and offload the rest of the write
to a context that can block.

The new helper function is also used by balance_dirty_pages_ratelimited()=
.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Stefan Roesch <shr@fb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/writeback.h |  7 ++++++
 mm/page-writeback.c       | 51 +++++++++++++++++++++++++++++++--------
 2 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index da21d63f70e2..b8c9610c2313 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -364,7 +364,14 @@ void global_dirty_limits(unsigned long *pbackground,=
 unsigned long *pdirty);
 unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thr=
esh);
=20
 void wb_update_bandwidth(struct bdi_writeback *wb);
+
+/* Invoke balance dirty pages in async mode. */
+#define BDP_ASYNC 0x0001
+
 void balance_dirty_pages_ratelimited(struct address_space *mapping);
+int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
+		unsigned int flags);
+
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
=20
 typedef int (*writepage_t)(struct page *page, struct writeback_control *=
wbc,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 90b1998c16a1..bfca433640fc 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1554,8 +1554,8 @@ static inline void wb_dirty_limits(struct dirty_thr=
ottle_control *dtc)
  * If we're over `background_thresh' then the writeback threads are woke=
n to
  * perform some writeout.
  */
-static void balance_dirty_pages(struct bdi_writeback *wb,
-				unsigned long pages_dirtied)
+static int balance_dirty_pages(struct bdi_writeback *wb,
+			       unsigned long pages_dirtied, unsigned int flags)
 {
 	struct dirty_throttle_control gdtc_stor =3D { GDTC_INIT(wb) };
 	struct dirty_throttle_control mdtc_stor =3D { MDTC_INIT(wb, &gdtc_stor)=
 };
@@ -1575,6 +1575,7 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 	struct backing_dev_info *bdi =3D wb->bdi;
 	bool strictlimit =3D bdi->capabilities & BDI_CAP_STRICTLIMIT;
 	unsigned long start_time =3D jiffies;
+	int ret =3D 0;
=20
 	for (;;) {
 		unsigned long now =3D jiffies;
@@ -1803,6 +1804,10 @@ static void balance_dirty_pages(struct bdi_writeba=
ck *wb,
 					  period,
 					  pause,
 					  start_time);
+		if (flags & BDP_ASYNC) {
+			ret =3D -EAGAIN;
+			break;
+		}
 		__set_current_state(TASK_KILLABLE);
 		wb->dirty_sleep =3D now;
 		io_schedule_timeout(pause);
@@ -1834,6 +1839,7 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 		if (fatal_signal_pending(current))
 			break;
 	}
+	return ret;
 }
=20
 static DEFINE_PER_CPU(int, bdp_ratelimits);
@@ -1855,27 +1861,34 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
 DEFINE_PER_CPU(int, dirty_throttle_leaks) =3D 0;
=20
 /**
- * balance_dirty_pages_ratelimited - balance dirty memory state
- * @mapping: address_space which was dirtied
+ * balance_dirty_pages_ratelimited_flags - Balance dirty memory state.
+ * @mapping: address_space which was dirtied.
+ * @flags: BDP flags.
  *
  * Processes which are dirtying memory should call in here once for each=
 page
  * which was newly dirtied.  The function will periodically check the sy=
stem's
  * dirty state and will initiate writeback if needed.
  *
- * Once we're over the dirty memory limit we decrease the ratelimiting
- * by a lot, to prevent individual processes from overshooting the limit
- * by (ratelimit_pages) each.
+ * See balance_dirty_pages_ratelimited() for details.
+ *
+ * Return: If @flags contains BDP_ASYNC, it may return -EAGAIN to
+ * indicate that memory is out of balance and the caller must wait
+ * for I/O to complete.  Otherwise, it will return 0 to indicate
+ * that either memory was already in balance, or it was able to sleep
+ * until the amount of dirty memory returned to balance.
  */
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
@@ -1915,9 +1928,27 @@ void balance_dirty_pages_ratelimited(struct addres=
s_space *mapping)
 	preempt_enable();
=20
 	if (unlikely(current->nr_dirtied >=3D ratelimit))
-		balance_dirty_pages(wb, current->nr_dirtied);
+		balance_dirty_pages(wb, current->nr_dirtied, flags);
=20
 	wb_put(wb);
+	return ret;
+}
+
+/**
+ * balance_dirty_pages_ratelimited - balance dirty memory state.
+ * @mapping: address_space which was dirtied.
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

