Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CC3534687
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 00:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344651AbiEYWeu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 18:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345368AbiEYWet (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 18:34:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C43010FEF
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:34:48 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24PGtag0012073
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:34:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HPjnCKp2mP5zUhzFD7orqPqCqeAUncMT3i4YP9mUBko=;
 b=Xeq7UbAJTIf360JtFAeHz5zWRF2O/gjlSpMb/6QAWJ6itPVwmWLEKxk0mwgU1Tpblhv0
 N9Wn5ZMt2RqfVHoIQ3z2TLv6rE7wMW/EoWt+m1NwpJPdtDGS/k/lXVplyCJ3aVvoVJVf
 k/P8cAOLPWXm0+nIta4wqj2A3X5mXRaBf8I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g9qtuafph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:34:47 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub203.TheFacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 25 May 2022 15:34:45 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 25 May 2022 15:34:45 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id F0FF6F9E1B49; Wed, 25 May 2022 15:34:34 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v5 03/16] mm: Add balance_dirty_pages_ratelimited_flags() function
Date:   Wed, 25 May 2022 15:34:19 -0700
Message-ID: <20220525223432.205676-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220525223432.205676-1-shr@fb.com>
References: <20220525223432.205676-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fxXSnP_kQGBq7PngnjF63YB_U6vwC0d8
X-Proofpoint-ORIG-GUID: fxXSnP_kQGBq7PngnjF63YB_U6vwC0d8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_07,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
---
 include/linux/writeback.h |  7 ++++++
 mm/page-writeback.c       | 48 +++++++++++++++++++++++++--------------
 2 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index fec248ab1fec..1bddad86a4f6 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -372,7 +372,14 @@ void global_dirty_limits(unsigned long *pbackground,=
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
index 89dcc7d8395a..3701e813d05f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1545,8 +1545,8 @@ static inline void wb_dirty_limits(struct dirty_thr=
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
@@ -1566,6 +1566,7 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 	struct backing_dev_info *bdi =3D wb->bdi;
 	bool strictlimit =3D bdi->capabilities & BDI_CAP_STRICTLIMIT;
 	unsigned long start_time =3D jiffies;
+	int ret =3D 0;
=20
 	for (;;) {
 		unsigned long now =3D jiffies;
@@ -1794,6 +1795,10 @@ static void balance_dirty_pages(struct bdi_writeba=
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
@@ -1825,6 +1830,7 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 		if (fatal_signal_pending(current))
 			break;
 	}
+	return ret;
 }
=20
 static DEFINE_PER_CPU(int, bdp_ratelimits);
@@ -1845,28 +1851,18 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
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
@@ -1906,9 +1902,27 @@ void balance_dirty_pages_ratelimited(struct addres=
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

