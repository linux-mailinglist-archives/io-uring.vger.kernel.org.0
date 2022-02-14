Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3724B58EF
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357273AbiBNRpA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 12:45:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357203AbiBNRon (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 12:44:43 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0D765489
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:35 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ECHRdX024089
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LHVvoEZfE6JaHZroD1k0ORc9e9YEoF8oOTWuN+537Qc=;
 b=m8IUD7cIb0bY1zrxnNi/Wp7ND5BOIKoqg2fLChxD1KbWdy4R8eKjp03nsRoywYY5ccC9
 aovmYfV1fYvtRyyTvncJ+7FM4WYupFi7gW/JB7NqLu4D5bI3btoKl1EwLDptwkLkwcnP
 XLym/5qbBGRfzYEgTHu0kZK1RUSUSmArQ+0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7py4j44e-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:35 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 09:44:29 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id D2FC8ABBD10B; Mon, 14 Feb 2022 09:44:09 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 12/14] mm: support write throttling for async buffered writes
Date:   Mon, 14 Feb 2022 09:44:01 -0800
Message-ID: <20220214174403.4147994-13-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214174403.4147994-1-shr@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fYDw9ic17pjo4lV1w65WfWJFWPkwlPD_
X-Proofpoint-GUID: fYDw9ic17pjo4lV1w65WfWJFWPkwlPD_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140105
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This change adds support for async write throttling in the function
balance_dirty_pages(). So far if throttling was required, the code
was waiting synchronously as long as the writes were throttled. This
change introduces asynchronous throttling. Instead of waiting in the
function balance_dirty_pages(), the timeout is set in the task_struct
field bdp_pause. Once the timeout has expired, the writes are no
longer throttled.

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
 mm/filemap.c              |  2 +-
 mm/page-writeback.c       | 54 ++++++++++++++++++++++++++++-----------
 3 files changed, 41 insertions(+), 16 deletions(-)

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
diff --git a/mm/filemap.c b/mm/filemap.c
index 19065ad95a4c..aa51ff1a0e8f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3805,7 +3805,7 @@ static ssize_t do_generic_perform_write(struct file=
 *file, struct iov_iter *i,
 		pos +=3D status;
 		written +=3D status;
=20
-		balance_dirty_pages_ratelimited(mapping);
+		balance_dirty_pages_ratelimited_flags(mapping, flags & AOP_FLAGS_NOWAI=
T);
 	} while (iov_iter_count(i));
=20
 	return written ? written : status;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 91d163f8d36b..767d0b997da5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1558,7 +1558,7 @@ static inline void wb_dirty_limits(struct dirty_thr=
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
@@ -1792,6 +1792,14 @@ static void balance_dirty_pages(struct bdi_writeba=
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
@@ -1799,6 +1807,8 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 		current->dirty_paused_when =3D now + pause;
 		current->nr_dirtied =3D 0;
 		current->nr_dirtied_pause =3D nr_dirtied_pause;
+		current->bdp_nr_dirtied_pause =3D -1;
+		current->bdp_pause =3D 0;
=20
 		/*
 		 * This is typically equal to (dirty < thresh) and can also
@@ -1863,19 +1873,7 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
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
@@ -1886,6 +1884,15 @@ void balance_dirty_pages_ratelimited(struct addres=
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
@@ -1924,10 +1931,27 @@ void balance_dirty_pages_ratelimited(struct addre=
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

