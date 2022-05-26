Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564ED53529D
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 19:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348321AbiEZRjD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 13:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348303AbiEZRjA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 13:39:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C03D994D1
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:00 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QFmfQk025625
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JmNWcJ9S5BuVrDagcKBT8mAi6jQ8Go8fzpG+AeBXTsU=;
 b=mVW/lvkcsWjc8Fz7GtZ235Y8Oa3cFHtz16YyO/+nj3bQs7yDBlRAHeLLL9V/DukUPK1c
 ni6csz00nA5+rg4LuQK6k4szDRGFfvf1yhW8WNeN+JxPYCnJDo2BNVnjicZ738zsq/SU
 gYJd8LaaOD07NfftdMFdaH69Loc8OAVpxO4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gacgx8thp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:00 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub203.TheFacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 26 May 2022 10:38:58 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 26 May 2022 10:38:58 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 67B5AFA621D0; Thu, 26 May 2022 10:38:45 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v6 02/16] mm: Move updates of dirty_exceeded into one place
Date:   Thu, 26 May 2022 10:38:26 -0700
Message-ID: <20220526173840.578265-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220526173840.578265-1-shr@fb.com>
References: <20220526173840.578265-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: jtvxYI4CEQWdyUvuxqZqC9roWrhLGTam
X-Proofpoint-ORIG-GUID: jtvxYI4CEQWdyUvuxqZqC9roWrhLGTam
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_09,2022-05-25_02,2022-02-23_01
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
index 8e5e003f0093..89dcc7d8395a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1720,8 +1720,8 @@ static void balance_dirty_pages(struct bdi_writebac=
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
@@ -1825,9 +1825,6 @@ static void balance_dirty_pages(struct bdi_writebac=
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

