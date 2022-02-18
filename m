Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548BD4BC0CE
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbiBRT6Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238598AbiBRT6W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:22 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F4D20181
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:04 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IGAsx5023865
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dyQGKcmKLpBFkL0VFOvvJJDt9XqOrzO/TDGIL6U8++0=;
 b=H57y9wVdNGQuv+4ziv9okUhV1TSt/PMqnpZ6avVGOdn0fXztN5aetoOoeoe5Ze/E5Slr
 4/vFXmtFFzHwhoKRZlLmT00tSz9GmoT/6nHyK99/CBjFHMTlTAgSJG7t92MNU68J8DpP
 Bzt7OSo+qvD5mXrCFAzK1meESV3xDsi7tYE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea1mp5p2g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:04 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:02 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 963EBAEB6603; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 03/13] mm: Add support for async buffered writes
Date:   Fri, 18 Feb 2022 11:57:29 -0800
Message-ID: <20220218195739.585044-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: vzfdbqgb41urqk121ASX8IXTsbHhP4jb
X-Proofpoint-ORIG-GUID: vzfdbqgb41urqk121ASX8IXTsbHhP4jb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 suspectscore=0 mlxlogscore=877 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180122
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

This adds support for async buffered writes in the mm layer. When the
AOP_FLAG_NOWAIT flag is set, if the page is not already loaded,
the page gets created without blocking on the allocation.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 mm/filemap.c      |  1 +
 mm/folio-compat.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5bd692a327d0..f4e2036c5029 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -42,6 +42,7 @@
 #include <linux/ramfs.h>
 #include <linux/page_idle.h>
 #include <linux/migrate.h>
+#include <linux/sched/mm.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 749555a232a8..8243eeb883c1 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -133,11 +133,19 @@ struct page *grab_cache_page_write_begin(struct add=
ress_space *mapping,
 					pgoff_t index, unsigned flags)
 {
 	unsigned fgp_flags =3D FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE;
+	gfp_t gfp =3D mapping_gfp_mask(mapping);
=20
 	if (flags & AOP_FLAG_NOFS)
 		fgp_flags |=3D FGP_NOFS;
-	return pagecache_get_page(mapping, index, fgp_flags,
-			mapping_gfp_mask(mapping));
+
+	if (flags & AOP_FLAG_NOWAIT) {
+		fgp_flags |=3D FGP_NOWAIT;
+
+		gfp |=3D GFP_ATOMIC;
+		gfp &=3D ~__GFP_DIRECT_RECLAIM;
+	}
+
+	return pagecache_get_page(mapping, index, fgp_flags, gfp);
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
=20
--=20
2.30.2

