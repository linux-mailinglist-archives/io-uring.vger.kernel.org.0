Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE115B61B8
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 21:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiILT2V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 15:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiILT2T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 15:28:19 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF3546220
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:16 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CIEppd022502
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8RVRQ6/cQX6qNy5uU4Kh4lX2fZOOQ9gq7/Aw+KIXpjA=;
 b=XRbmhapx5q387X5gok3qOUaceqcy5ZmlZXPOIt2VKkhfje2A0uCU0CcR5RvK/BG/vmQU
 4zTzi3giUVTCrJhzHRmHCWoYOL5r/4ihGoIlfFLax+bGgG/eOgznzsy1Dctv1M/ndNH4
 AGwcQocHNG1CKh8Y54jvmyhLycJuLQEazyk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jgsw4ccjw-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:16 -0700
Received: from twshared15978.04.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 12:28:12 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 162392085234; Mon, 12 Sep 2022 12:27:54 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v3 07/12] btrfs: make prepare_pages nowait compatible
Date:   Mon, 12 Sep 2022 12:27:47 -0700
Message-ID: <20220912192752.3785061-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220912192752.3785061-1-shr@fb.com>
References: <20220912192752.3785061-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OB2AqnbZWOnQvV0IVJ9OoyVex1fLiMN7
X-Proofpoint-GUID: OB2AqnbZWOnQvV0IVJ9OoyVex1fLiMN7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_12,2022-09-12_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add nowait parameter to the prepare_pages function. In case nowait is
specified for an async buffered write request, do a nowait allocation or
return -EAGAIN.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/file.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f18efd9f2bc3..d4362ee7e09e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1339,26 +1339,54 @@ static int prepare_uptodate_page(struct inode *in=
ode,
 	return 0;
 }
=20
+static int get_prepare_fgp_flags(bool nowait)
+{
+	int fgp_flags =3D FGP_LOCK | FGP_ACCESSED | FGP_CREAT;
+
+	if (nowait)
+		fgp_flags |=3D FGP_NOWAIT;
+
+	return fgp_flags;
+}
+
+static gfp_t get_prepare_gfp_flags(struct inode *inode, bool nowait)
+{
+	gfp_t gfp;
+
+	gfp =3D btrfs_alloc_write_mask(inode->i_mapping);
+	if (nowait) {
+		gfp &=3D ~__GFP_DIRECT_RECLAIM;
+		gfp |=3D GFP_NOWAIT;
+	}
+
+	return gfp;
+}
+
 /*
  * this just gets pages into the page cache and locks them down.
  */
 static noinline int prepare_pages(struct inode *inode, struct page **pag=
es,
 				  size_t num_pages, loff_t pos,
-				  size_t write_bytes, bool force_uptodate)
+				  size_t write_bytes, bool force_uptodate,
+				  bool nowait)
 {
 	int i;
 	unsigned long index =3D pos >> PAGE_SHIFT;
-	gfp_t mask =3D btrfs_alloc_write_mask(inode->i_mapping);
+	gfp_t mask =3D get_prepare_gfp_flags(inode, nowait);
+	int fgp_flags =3D get_prepare_fgp_flags(nowait);
 	int err =3D 0;
 	int faili;
=20
 	for (i =3D 0; i < num_pages; i++) {
 again:
-		pages[i] =3D find_or_create_page(inode->i_mapping, index + i,
-					       mask | __GFP_WRITE);
+		pages[i] =3D pagecache_get_page(inode->i_mapping, index + i,
+					fgp_flags, mask | __GFP_WRITE);
 		if (!pages[i]) {
 			faili =3D i - 1;
-			err =3D -ENOMEM;
+			if (nowait)
+				err =3D -EAGAIN;
+			else
+				err =3D -ENOMEM;
 			goto fail;
 		}
=20
@@ -1376,7 +1404,7 @@ static noinline int prepare_pages(struct inode *ino=
de, struct page **pages,
 						    pos + write_bytes, false);
 		if (err) {
 			put_page(pages[i]);
-			if (err =3D=3D -EAGAIN) {
+			if (!nowait && err =3D=3D -EAGAIN) {
 				err =3D 0;
 				goto again;
 			}
@@ -1716,7 +1744,7 @@ static noinline ssize_t btrfs_buffered_write(struct=
 kiocb *iocb,
 		 */
 		ret =3D prepare_pages(inode, pages, num_pages,
 				    pos, write_bytes,
-				    force_page_uptodate);
+				    force_page_uptodate, false);
 		if (ret) {
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
 						       reserve_bytes);
--=20
2.30.2

