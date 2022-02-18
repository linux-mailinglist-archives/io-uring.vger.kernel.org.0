Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5924BC0C5
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiBRT6W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238583AbiBRT6W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:22 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346391EAFE
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:04 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IA79xv030766
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BwSx3L7ogY20VkY+MOK+kIbEIgoxq4mLJVLVeNC1mH0=;
 b=DhT+scriyqFJcGhM03Xbq8i26DL15mlZgTQDRA37Z0H/bhX87cHQlq6A12u79+DOq5N0
 pAcBOPJLfGcNCpdE69H/ZEsqsQt2+6r7hNQb6j35Cxcpapuh6yrT7RvV1czIs36FhncP
 HiRKbJJ9NWc3nSOsscBVSS5byYLObsA0Tps= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea9dm3m2h-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:03 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:02 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 8A082AEB65FF; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 01/13] fs: Add flags parameter to __block_write_begin_int
Date:   Fri, 18 Feb 2022 11:57:27 -0800
Message-ID: <20220218195739.585044-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: D7qyajtRbQLOU59klcrXtBlm-bq4Ie6w
X-Proofpoint-ORIG-GUID: D7qyajtRbQLOU59klcrXtBlm-bq4Ie6w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 mlxlogscore=823 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202180122
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

This adds a flags parameter to the __begin_write_begin_int() function.
This allows to pass flags down the stack.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/buffer.c            | 7 ++++---
 fs/internal.h          | 3 ++-
 fs/iomap/buffered-io.c | 4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 8e112b6bd371..6e6a69a12eed 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1970,7 +1970,8 @@ iomap_to_bh(struct inode *inode, sector_t block, st=
ruct buffer_head *bh,
 }
=20
 int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned le=
n,
-		get_block_t *get_block, const struct iomap *iomap)
+			get_block_t *get_block, const struct iomap *iomap,
+			unsigned int flags)
 {
 	unsigned from =3D pos & (PAGE_SIZE - 1);
 	unsigned to =3D from + len;
@@ -2058,7 +2059,7 @@ int __block_write_begin(struct page *page, loff_t p=
os, unsigned len,
 		get_block_t *get_block)
 {
 	return __block_write_begin_int(page_folio(page), pos, len, get_block,
-				       NULL);
+				       NULL, 0);
 }
 EXPORT_SYMBOL(__block_write_begin);
=20
@@ -2118,7 +2119,7 @@ int block_write_begin(struct address_space *mapping=
, loff_t pos, unsigned len,
 	if (!page)
 		return -ENOMEM;
=20
-	status =3D __block_write_begin(page, pos, len, get_block);
+	status =3D __block_write_begin_int(page_folio(page), pos, len, get_bloc=
k, NULL, flags);
 	if (unlikely(status)) {
 		unlock_page(page);
 		put_page(page);
diff --git a/fs/internal.h b/fs/internal.h
index 8590c973c2f4..7432df23f3ce 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -38,7 +38,8 @@ static inline int emergency_thaw_bdev(struct super_bloc=
k *sb)
  * buffer.c
  */
 int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned le=
n,
-		get_block_t *get_block, const struct iomap *iomap);
+			get_block_t *get_block, const struct iomap *iomap,
+			unsigned int flags);
=20
 /*
  * char_dev.c
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6c51a75d0be6..47c519952725 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -646,7 +646,7 @@ static int iomap_write_begin(const struct iomap_iter =
*iter, loff_t pos,
 	if (srcmap->type =3D=3D IOMAP_INLINE)
 		status =3D iomap_write_begin_inline(iter, folio);
 	else if (srcmap->flags & IOMAP_F_BUFFER_HEAD)
-		status =3D __block_write_begin_int(folio, pos, len, NULL, srcmap);
+		status =3D __block_write_begin_int(folio, pos, len, NULL, srcmap, 0);
 	else
 		status =3D __iomap_write_begin(iter, pos, len, folio);
=20
@@ -979,7 +979,7 @@ static loff_t iomap_folio_mkwrite_iter(struct iomap_i=
ter *iter,
=20
 	if (iter->iomap.flags & IOMAP_F_BUFFER_HEAD) {
 		ret =3D __block_write_begin_int(folio, iter->pos, length, NULL,
-					      &iter->iomap);
+					      &iter->iomap, 0);
 		if (ret)
 			return ret;
 		block_commit_write(&folio->page, 0, length);
--=20
2.30.2

