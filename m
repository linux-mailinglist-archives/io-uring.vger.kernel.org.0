Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585484B58D7
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 18:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357201AbiBNRoa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 12:44:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357189AbiBNRo3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 12:44:29 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959C965481
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:21 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21EHiKfX026958
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TpLM1ylp8BkAtDLY4Cd3m5Nmn6K/IDr/a4obTwyIV9A=;
 b=qzsEjVOq93gYQwti+IpWN0r+BsO/fvrj0gStOAMfxm0DwRSUkqRaHEivKjuhGLa+cK0L
 udPl1LE1ExpULb/UkeCxmpl3gZlg7zL/s7Fs2Rtjk4ciySKQQpwL6VNQTe3Rbv+sewKe
 CcUEyvagMjFaan0VF53J25RkzY91YpbaWbE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7hpcbju6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:21 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 09:44:20 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A1E7CABBD0FB; Mon, 14 Feb 2022 09:44:09 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 04/14] mm: Add support for async buffered writes
Date:   Mon, 14 Feb 2022 09:43:53 -0800
Message-ID: <20220214174403.4147994-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214174403.4147994-1-shr@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: jZ5fLALkIHodJ38l6qfx3xL78D7-zm7k
X-Proofpoint-ORIG-GUID: jZ5fLALkIHodJ38l6qfx3xL78D7-zm7k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 phishscore=0
 clxscore=1015 suspectscore=0 adultscore=0 mlxlogscore=812
 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202140105
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
AOP_FLAGS_BUF_WASYNC flag is set, if the page is not already loaded,
the page gets created without blocking on the allocation.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 mm/filemap.c      | 5 +++++
 mm/folio-compat.c | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 0ff4278c3961..19065ad95a4c 100644
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
@@ -1986,6 +1987,10 @@ struct folio *__filemap_get_folio(struct address_s=
pace *mapping, pgoff_t index,
 			gfp |=3D __GFP_WRITE;
 		if (fgp_flags & FGP_NOFS)
 			gfp &=3D ~__GFP_FS;
+		if (fgp_flags & FGP_NOWAIT) {
+			gfp |=3D GFP_ATOMIC;
+			gfp &=3D ~__GFP_DIRECT_RECLAIM;
+		}
=20
 		folio =3D filemap_alloc_folio(gfp, 0);
 		if (!folio)
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 749555a232a8..a1d05509b29f 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -136,6 +136,10 @@ struct page *grab_cache_page_write_begin(struct addr=
ess_space *mapping,
=20
 	if (flags & AOP_FLAG_NOFS)
 		fgp_flags |=3D FGP_NOFS;
+
+	if (flags & AOP_FLAGS_NOWAIT)
+		fgp_flags |=3D FGP_NOWAIT;
+
 	return pagecache_get_page(mapping, index, fgp_flags,
 			mapping_gfp_mask(mapping));
 }
--=20
2.30.2

