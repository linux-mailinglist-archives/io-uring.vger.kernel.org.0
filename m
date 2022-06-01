Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFF653B035
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 00:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiFAVBt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 17:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiFAVBt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 17:01:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790161BF168
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 14:01:48 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251K52TX028648
        for <io-uring@vger.kernel.org>; Wed, 1 Jun 2022 14:01:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kEVeF1raHjzqCCTZ1PYGpmk3OQwPxUvEougAHhggs/M=;
 b=MIQLVDM65hkWiJ0lj6EVBtpJJYyYIf98ZkTWo1bMxOEy0y4v9tHTqrLZMDRFnnGQdBNi
 kxmJQW35KHX88Mf2FMrS70P0sgPJ7aRlnDnVRolIVskefxOf5xtsWa7upTHJNv+N6tCy
 scjCwY3fbHsQKcFPW1kcApydM3OYFm2c2J4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gdt5jqfeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 14:01:48 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub102.TheFacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 14:01:47 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 14:01:46 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id BB990FEB2396; Wed,  1 Jun 2022 14:01:42 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>
Subject: [PATCH v7 02/15] mm: Move updates of dirty_exceeded into one place
Date:   Wed, 1 Jun 2022 14:01:28 -0700
Message-ID: <20220601210141.3773402-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220601210141.3773402-1-shr@fb.com>
References: <20220601210141.3773402-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: O92XqE8C_euGDD2U9kEgvPrJB4feOCFW
X-Proofpoint-ORIG-GUID: O92XqE8C_euGDD2U9kEgvPrJB4feOCFW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_08,2022-06-01_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

