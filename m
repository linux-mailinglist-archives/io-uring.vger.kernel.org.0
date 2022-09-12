Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B228F5B61B6
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 21:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiILT2S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 15:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiILT2R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 15:28:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0354622A
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:15 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CG6lUR003051
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hjvhu+Qp84kdov74Xj1nrOZz9nTHcHa45YxCt8fKlVM=;
 b=baVMT3r+NT4+eN5IRphhDBdpbkMFS6hj7tN43AHdsvmFdo2i0Y24Av831cjPdX71r4r+
 xTOnZ77FYow+MdGv9AZso1tXi5Zn/s4ptTPXjsPgMobYPYp6c+fx06vHlaxoHaHPcEYU
 3/vMxkN+WpPt/RmwV1MKJHeOOyiqEuUEi54= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jgr9smh8w-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:15 -0700
Received: from twshared6447.05.prn5.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 12:28:13 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 212BB2085238; Mon, 12 Sep 2022 12:27:54 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v3 09/12] btrfs: plumb NOWAIT through the write path
Date:   Mon, 12 Sep 2022 12:27:49 -0700
Message-ID: <20220912192752.3785061-10-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220912192752.3785061-1-shr@fb.com>
References: <20220912192752.3785061-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tLu3xqSOgQ62R55e5D_0PuXq9BuebOgw
X-Proofpoint-GUID: tLu3xqSOgQ62R55e5D_0PuXq9BuebOgw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_13,2022-09-12_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index cb54ba631691..3d038e1257f9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1653,8 +1653,9 @@ static noinline ssize_t btrfs_buffered_write(struct=
 kiocb *iocb,
 	bool force_page_uptodate =3D false;
 	loff_t old_isize =3D i_size_read(inode);
 	unsigned int ilock_flags =3D 0;
+	const bool nowait =3D iocb->ki_flags & IOCB_NOWAIT;
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
 			int can_nocow;
=20
+			if (nowait && (ret =3D=3D -ENOSPC || ret =3D=3D -EAGAIN)) {
+				ret =3D -EAGAIN;
+				break;
+			}
+
 			/*
 			 * If we don't have to COW at the offset, reserve
 			 * metadata only. write_bytes may get smaller than
 			 * requested here.
 			 */
 			can_nocow =3D btrfs_check_nocow_lock(BTRFS_I(inode), pos,
-							   &write_bytes, false);
+							   &write_bytes, nowait);
 			if (can_nocow < 0)
 				ret =3D can_nocow;
 			if (can_nocow > 0)
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

