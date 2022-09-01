Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BC55AA376
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 00:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiIAW7g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 18:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiIAW7f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 18:59:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6F87FF86
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 15:59:34 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 281MnZaJ010609
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 15:59:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QD4qlIA8/BoghUXvinBQL0t/sgag+Fk+RaIcuuavKHQ=;
 b=HqkW0uyt60G9RAT2UKvMjZa/t8+8W99l8GRJfUf7HH73YXxOJSLT9O2QTypRUf75TH6Q
 i3Nd1Ba4X9aICNqpv4Fdl9DylTfmmIaDG5YmLxhtT/g/Zmgc4rsIW+FT1h72jlbo6JHz
 7/Mcyaxn56W0avHeqJipIQeCHT87J9PDD/I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jam3vesbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 15:59:33 -0700
Received: from twshared22593.02.prn5.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 15:59:31 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 525AE19149CF; Thu,  1 Sep 2022 15:59:13 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>
Subject: [PATCH v1 08/10] btrfs: btrfs: plumb NOWAIT through the write path
Date:   Thu, 1 Sep 2022 15:58:47 -0700
Message-ID: <20220901225849.42898-9-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901225849.42898-1-shr@fb.com>
References: <20220901225849.42898-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: XYVtf_V76EEaIcq-en84Uttx9DN-ZQ62
X-Proofpoint-ORIG-GUID: XYVtf_V76EEaIcq-en84Uttx9DN-ZQ62
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

We have everywhere setup for nowait, plumb NOWAIT through the write path.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/file.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ef9175efbf99..0789ef9f083b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1653,8 +1653,9 @@ static noinline ssize_t btrfs_buffered_write(struct=
 kiocb *iocb,
 	bool force_page_uptodate =3D false;
 	loff_t old_isize =3D i_size_read(inode);
 	unsigned int ilock_flags =3D 0;
+	bool nowait =3D iocb->ki_flags & IOCB_NOWAIT;
=20
-	if (iocb->ki_flags & IOCB_NOWAIT)
+	if (nowait)
 		ilock_flags |=3D BTRFS_ILOCK_TRY;
=20
 	ret =3D btrfs_inode_lock(inode, ilock_flags);
@@ -1710,17 +1711,22 @@ static noinline ssize_t btrfs_buffered_write(stru=
ct kiocb *iocb,
 		extent_changeset_release(data_reserved);
 		ret =3D btrfs_check_data_free_space(BTRFS_I(inode),
 						  &data_reserved, pos,
-						  write_bytes, false);
+						  write_bytes, nowait);
 		if (ret < 0) {
 			int tmp;
=20
+			if (nowait && (ret =3D=3D -ENOSPC || ret =3D=3D -EWOULDBLOCK)) {
+				ret =3D -EAGAIN;
+				break;
+			}
+
 			/*
 			 * If we don't have to COW at the offset, reserve
 			 * metadata only. write_bytes may get smaller than
 			 * requested here.
 			 */
 			tmp =3D btrfs_check_nocow_lock(BTRFS_I(inode), pos,
-						     &write_bytes, false);
+						     &write_bytes, nowait);
 			if (tmp < 0)
 				ret =3D tmp;
 			if (tmp > 0)
@@ -1737,7 +1743,7 @@ static noinline ssize_t btrfs_buffered_write(struct=
 kiocb *iocb,
 		WARN_ON(reserve_bytes =3D=3D 0);
 		ret =3D btrfs_delalloc_reserve_metadata(BTRFS_I(inode),
 						      reserve_bytes,
-						      reserve_bytes, false);
+						      reserve_bytes, nowait);
 		if (ret) {
 			if (!only_release_metadata)
 				btrfs_free_reserved_data_space(BTRFS_I(inode),
@@ -1767,10 +1773,11 @@ static noinline ssize_t btrfs_buffered_write(stru=
ct kiocb *iocb,
 		extents_locked =3D lock_and_cleanup_extent_if_need(
 				BTRFS_I(inode), pages,
 				num_pages, pos, write_bytes, &lockstart,
-				&lockend, false, &cached_state);
+				&lockend, nowait, &cached_state);
 		if (extents_locked < 0) {
-			if (extents_locked =3D=3D -EAGAIN)
+			if (!nowait && extents_locked =3D=3D -EAGAIN)
 				goto again;
+
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
 						       reserve_bytes);
 			ret =3D extents_locked;
--=20
2.30.2

