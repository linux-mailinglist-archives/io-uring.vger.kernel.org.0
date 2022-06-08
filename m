Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C9E543A36
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 19:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiFHRYd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 13:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiFHRYQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 13:24:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653913D1F2
        for <io-uring@vger.kernel.org>; Wed,  8 Jun 2022 10:17:59 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258FPRCZ015553
        for <io-uring@vger.kernel.org>; Wed, 8 Jun 2022 10:17:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kEVeF1raHjzqCCTZ1PYGpmk3OQwPxUvEougAHhggs/M=;
 b=VEVAbSrX/Urzwth+gX50gya5g6tEnC9khLx+U/AjMW5xDcbZwQH3Vy8qpTz0usuL933e
 2H7QwoNTSAq71jCUEpq/SdbIo/ybkLN3ri8nw76NBpJKzc4/CG9Xzi6tjs/MhMVkbLZA
 AUDxvliWDNp/QedrOtn7GO2yDBVH8n/JLHY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gj13ctwfn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 08 Jun 2022 10:17:59 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 8 Jun 2022 10:17:57 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 975C3103BFB58; Wed,  8 Jun 2022 10:17:43 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>
Subject: [PATCH v8 02/14] mm: Move updates of dirty_exceeded into one place
Date:   Wed, 8 Jun 2022 10:17:29 -0700
Message-ID: <20220608171741.3875418-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608171741.3875418-1-shr@fb.com>
References: <20220608171741.3875418-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: qnLF6ehzmD4YEteDOG2znMWZBFfKcKSL
X-Proofpoint-ORIG-GUID: qnLF6ehzmD4YEteDOG2znMWZBFfKcKSL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Transition of wb->dirty_exceeded from 0 to 1 happens before we go to
sleep in balance_dirty_pages() while transition from 1 to 0 happens when
exiting from balance_dirty_pages(), possibly based on old values. This
does not make a lot of sense since wb->dirty_exceeded should simply
reflect whether wb is over dirty limit and so we should ratelimit
entering to balance_dirty_pages() less. Move the two updates together.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 mm/page-writeback.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e59c523aed1a..90b1998c16a1 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1729,8 +1729,8 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 				sdtc =3D mdtc;
 		}
=20
-		if (dirty_exceeded && !wb->dirty_exceeded)
-			wb->dirty_exceeded =3D 1;
+		if (dirty_exceeded !=3D wb->dirty_exceeded)
+			wb->dirty_exceeded =3D dirty_exceeded;
=20
 		if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
 					   BANDWIDTH_INTERVAL))
@@ -1834,9 +1834,6 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 		if (fatal_signal_pending(current))
 			break;
 	}
-
-	if (!dirty_exceeded && wb->dirty_exceeded)
-		wb->dirty_exceeded =3D 0;
 }
=20
 static DEFINE_PER_CPU(int, bdp_ratelimits);
--=20
2.30.2

