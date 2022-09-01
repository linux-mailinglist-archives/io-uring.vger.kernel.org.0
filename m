Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD115AA36D
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 00:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiIAW72 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 18:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbiIAW70 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 18:59:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108AB7F137
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 15:59:26 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281MrXJs028883
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 15:59:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KiNh9NWl/t+gaUifKEHYXP9JSrLUJuO5m9kBYkX6Hvc=;
 b=Fd+VNUeXGFqJxIT6HoPx0n11JsG/Z14sBpBF7Yhun5NOC+ljacL0bM9CKqUUM8v8pN+z
 b/W7MzNJqryr7RyoeNJAA/kKp9Bww8lsCuj4e9yVabj+57TDXZaU7jbhsQAY8zQUeiqL
 AbYmaxHFe2qc0kbxmK0utsLvDCm6G1DQVpI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jaf2n09su-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 15:59:25 -0700
Received: from twshared20183.05.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 15:59:23 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 48D1A19149CB; Thu,  1 Sep 2022 15:59:13 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>
Subject: [PATCH v1 06/10] btrfs: make prepare_pages nowait compatible
Date:   Thu, 1 Sep 2022 15:58:45 -0700
Message-ID: <20220901225849.42898-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901225849.42898-1-shr@fb.com>
References: <20220901225849.42898-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: BsUgVO9VcQb10cHGm5RUvcc8BjZdYPxn
X-Proofpoint-ORIG-GUID: BsUgVO9VcQb10cHGm5RUvcc8BjZdYPxn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 fs/btrfs/file.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index da6742a3c715..d529f61ac5b9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1339,26 +1339,55 @@ static int prepare_uptodate_page(struct inode *in=
ode,
 	return 0;
 }
=20
+static int get_prepare_fgp_flags(bool nowait)
+{
+	int fgp_flags;
+
+	fgp_flags =3D FGP_LOCK|FGP_ACCESSED|FGP_CREAT;
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
@@ -1376,7 +1405,7 @@ static noinline int prepare_pages(struct inode *ino=
de, struct page **pages,
 						    pos + write_bytes, false);
 		if (err) {
 			put_page(pages[i]);
-			if (err =3D=3D -EAGAIN) {
+			if (!nowait && err =3D=3D -EAGAIN) {
 				err =3D 0;
 				goto again;
 			}
@@ -1716,7 +1745,7 @@ static noinline ssize_t btrfs_buffered_write(struct=
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

