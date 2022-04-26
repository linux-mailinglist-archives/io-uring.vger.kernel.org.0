Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFF65105D6
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353611AbiDZRsA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353594AbiDZRr1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAF6184F03
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:17 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQehX017057
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=eSG9Z0a1y3Afz1OmaNZG5NBgo+gWDaZRFRRK2gkwdyE=;
 b=lPWxX3SdreI4PVki1fGluCL3UDdN+RKvTEPpDF2rYBDO9OzSxCQXjDiP4cPg+nlcqraw
 KX/bEJSleYI4wIweOiP99LxP6TRCtOq4o2CoHl9ZqTDQh13HiQ67hrcJ48AL1qIYn3VS
 vZIpytqEk+s3D35NdEcpl2S+gVWiXqS7xnI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fp6a8d4pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:17 -0700
Received: from twshared29473.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:44:16 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id D036BE2D4871; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 15/18] mm: support write throttling for async buffered writes
Date:   Tue, 26 Apr 2022 10:43:32 -0700
Message-ID: <20220426174335.4004987-16-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 4zARgrQnKf7Qspv2M_f6O5XyA-9Zg1TM
X-Proofpoint-ORIG-GUID: 4zARgrQnKf7Qspv2M_f6O5XyA-9Zg1TM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This change adds support for async write throttling in the function
balance_dirty_pages(). So far if throttling was required, the code was
waiting synchronously as long as the writes were throttled. This change
introduces asynchronous throttling. Instead of waiting in the function
balance_dirty_pages(), the timeout is set in the task_struct field
bdp_pause. Once the timeout has expired, the writes are no longer
throttled.

- Add a new parameter to the balance_dirty_pages() function
  - This allows the caller to pass in the nowait flag
  - When the nowait flag is specified, the code does not wait in
    balance_dirty_pages(), but instead stores the wait expiration in the
    new task_struct field bdp_pause.

- The function balance_dirty_pages_ratelimited() resets the new values
  in the task_struct, once the timeout has expired

This change is required to support write throttling for the async
buffered writes. While the writes are throttled, io_uring still can make
progress with processing other requests.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 include/linux/writeback.h |  1 +
 mm/page-writeback.c       | 54 ++++++++++++++++++++++++++++-----------
 2 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index fec248ab1fec..48176a8047db 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -373,6 +373,7 @@ unsigned long wb_calc_thresh(struct bdi_writeback *wb=
, unsigned long thresh);
=20
 void wb_update_bandwidth(struct bdi_writeback *wb);
 void balance_dirty_pages_ratelimited(struct address_space *mapping);
+void  balance_dirty_pages_ratelimited_flags(struct address_space *mappin=
g, bool is_async);
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
=20
 typedef int (*writepage_t)(struct page *page, struct writeback_control *=
wbc,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7e2da284e427..a62aa8a4c2f2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1546,7 +1546,7 @@ static inline void wb_dirty_limits(struct dirty_thr=
ottle_control *dtc)
  * perform some writeout.
  */
 static void balance_dirty_pages(struct bdi_writeback *wb,
-				unsigned long pages_dirtied)
+				unsigned long pages_dirtied, bool is_async)
 {
 	struct dirty_throttle_control gdtc_stor =3D { GDTC_INIT(wb) };
 	struct dirty_throttle_control mdtc_stor =3D { MDTC_INIT(wb, &gdtc_stor)=
 };
@@ -1780,6 +1780,14 @@ static void balance_dirty_pages(struct bdi_writeba=
ck *wb,
 					  period,
 					  pause,
 					  start_time);
+		if (is_async) {
+			if (current->bdp_nr_dirtied_pause =3D=3D -1) {
+				current->bdp_pause =3D now + pause;
+				current->bdp_nr_dirtied_pause =3D nr_dirtied_pause;
+			}
+			break;
+		}
+
 		__set_current_state(TASK_KILLABLE);
 		wb->dirty_sleep =3D now;
 		io_schedule_timeout(pause);
@@ -1787,6 +1795,8 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 		current->dirty_paused_when =3D now + pause;
 		current->nr_dirtied =3D 0;
 		current->nr_dirtied_pause =3D nr_dirtied_pause;
+		current->bdp_nr_dirtied_pause =3D -1;
+		current->bdp_pause =3D 0;
=20
 		/*
 		 * This is typically equal to (dirty < thresh) and can also
@@ -1851,19 +1861,7 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
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
+void balance_dirty_pages_ratelimited_flags(struct address_space *mapping=
, bool is_async)
 {
 	struct inode *inode =3D mapping->host;
 	struct backing_dev_info *bdi =3D inode_to_bdi(inode);
@@ -1874,6 +1872,15 @@ void balance_dirty_pages_ratelimited(struct addres=
s_space *mapping)
 	if (!(bdi->capabilities & BDI_CAP_WRITEBACK))
 		return;
=20
+	if (current->bdp_nr_dirtied_pause !=3D -1 && time_after(jiffies, curren=
t->bdp_pause)) {
+		current->dirty_paused_when =3D current->bdp_pause;
+		current->nr_dirtied =3D 0;
+		current->nr_dirtied_pause =3D current->bdp_nr_dirtied_pause;
+
+		current->bdp_nr_dirtied_pause =3D -1;
+		current->bdp_pause =3D 0;
+	}
+
 	if (inode_cgwb_enabled(inode))
 		wb =3D wb_get_create_current(bdi, GFP_KERNEL);
 	if (!wb)
@@ -1912,10 +1919,27 @@ void balance_dirty_pages_ratelimited(struct addre=
ss_space *mapping)
 	preempt_enable();
=20
 	if (unlikely(current->nr_dirtied >=3D ratelimit))
-		balance_dirty_pages(wb, current->nr_dirtied);
+		balance_dirty_pages(wb, current->nr_dirtied, is_async);
=20
 	wb_put(wb);
 }
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
+}
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
=20
 /**
--=20
2.30.2

