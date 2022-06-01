Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F26F53AFE4
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 00:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiFAVB4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 17:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiFAVBy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 17:01:54 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFA61BF173
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 14:01:52 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251GTTmH015007
        for <io-uring@vger.kernel.org>; Wed, 1 Jun 2022 14:01:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+IYV+ohWMnP9Z2WqVp2E+CnW9cqqI1fK3UacqUP+NEU=;
 b=TNdvL5H9Nnbr5ngz7PfC+qxRx5KoUDRycNbiHAywt2stgsiwkD+CJvAzRkQJig18OBKK
 qZAm40cAczX/wnle++9nk7FIfdVUQKDonMs75YhI66e8QeRkrZGvFdICsZ36p7PLwZ0D
 kKYhyyoqZKqPtXrYDJk0Z01/dwH9VyEofy4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gdt5jqff6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 14:01:52 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 14:01:51 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id B86C6FEB2394; Wed,  1 Jun 2022 14:01:42 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>
Subject: [PATCH v7 01/15] mm: Move starting of background writeback into the main balancing loop
Date:   Wed, 1 Jun 2022 14:01:27 -0700
Message-ID: <20220601210141.3773402-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220601210141.3773402-1-shr@fb.com>
References: <20220601210141.3773402-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 38ZABpBqG0jleG__yDv20SI5M4RPy8bc
X-Proofpoint-ORIG-GUID: 38ZABpBqG0jleG__yDv20SI5M4RPy8bc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_08,2022-06-01_01,2022-02-23_01
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

We start background writeback if we are over background threshold after
exiting the main loop in balance_dirty_pages(). This may result in
basing the decision on already stale values (we may have slept for
significant amount of time) and it is also inconvenient for refactoring
needed for async dirty throttling. Move the check into the main waiting
loop.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 mm/page-writeback.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 55c2776ae699..e59c523aed1a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1627,6 +1627,19 @@ static void balance_dirty_pages(struct bdi_writeba=
ck *wb,
 			}
 		}
=20
+		/*
+		 * In laptop mode, we wait until hitting the higher threshold
+		 * before starting background writeout, and then write out all
+		 * the way down to the lower threshold.  So slow writers cause
+		 * minimal disk activity.
+		 *
+		 * In normal mode, we start background writeout at the lower
+		 * background_thresh, to keep the amount of dirty memory low.
+		 */
+		if (!laptop_mode && nr_reclaimable > gdtc->bg_thresh &&
+		    !writeback_in_progress(wb))
+			wb_start_background_writeback(wb);
+
 		/*
 		 * Throttle it only when the background writeback cannot
 		 * catch-up. This avoids (excessively) small writeouts
@@ -1657,6 +1670,7 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 			break;
 		}
=20
+		/* Start writeback even when in laptop mode */
 		if (unlikely(!writeback_in_progress(wb)))
 			wb_start_background_writeback(wb);
=20
@@ -1823,23 +1837,6 @@ static void balance_dirty_pages(struct bdi_writeba=
ck *wb,
=20
 	if (!dirty_exceeded && wb->dirty_exceeded)
 		wb->dirty_exceeded =3D 0;
-
-	if (writeback_in_progress(wb))
-		return;
-
-	/*
-	 * In laptop mode, we wait until hitting the higher threshold before
-	 * starting background writeout, and then write out all the way down
-	 * to the lower threshold.  So slow writers cause minimal disk activity=
.
-	 *
-	 * In normal mode, we start background writeout at the lower
-	 * background_thresh, to keep the amount of dirty memory low.
-	 */
-	if (laptop_mode)
-		return;
-
-	if (nr_reclaimable > gdtc->bg_thresh)
-		wb_start_background_writeback(wb);
 }
=20
 static DEFINE_PER_CPU(int, bdp_ratelimits);
--=20
2.30.2

