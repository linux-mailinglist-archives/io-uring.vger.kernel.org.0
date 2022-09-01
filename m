Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9025AA364
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 00:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiIAW7Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 18:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiIAW7X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 18:59:23 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A276785BA
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 15:59:22 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281Mndqg024297
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 15:59:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=nn6pNmrfqii0Pxc5tRFGzs2eYju00h6nYRh4yWgopAs=;
 b=lipAF9n17miItZ/keJspriOSSOw4NUnXTlfP6lUMBuH0QWdXvti/EtOXbvlJKZb0WrMY
 rhxrsIWPttJw9u4ge0KT/Ybh1pJB+krj5dF4FNQsUNr4Hwc93gCrwbxfiVzVaxEr/fr8
 MYKTH4rWRjVfq7J8OBsKVjtYtlZlStcMjw4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jaab32msg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 15:59:21 -0700
Received: from twshared16308.14.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 15:59:20 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 3A06419149C5; Thu,  1 Sep 2022 15:59:13 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>
Subject: [PATCH v1 03/10] btrfs: add the ability to use NO_FLUSH for data reservations
Date:   Thu, 1 Sep 2022 15:58:42 -0700
Message-ID: <20220901225849.42898-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901225849.42898-1-shr@fb.com>
References: <20220901225849.42898-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: WTDjPQlurK5sL1lvQNHHn7kxqZ7-r6LJ
X-Proofpoint-ORIG-GUID: WTDjPQlurK5sL1lvQNHHn7kxqZ7-r6LJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

In order to accommodate NOWAIT IOCB's we need to be able to do NO_FLUSH
data reservations, so plumb this through the delalloc reservation
system.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/block-group.c    |  2 +-
 fs/btrfs/delalloc-space.c | 13 ++++++++++---
 fs/btrfs/delalloc-space.h |  3 ++-
 fs/btrfs/file.c           |  2 +-
 fs/btrfs/inode.c          |  4 ++--
 fs/btrfs/space-info.c     |  3 ++-
 6 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index e0375ba9d0fe..9df51245ba93 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2869,7 +2869,7 @@ static int cache_save_setup(struct btrfs_block_grou=
p *block_group,
 	cache_size *=3D fs_info->sectorsize;
=20
 	ret =3D btrfs_check_data_free_space(BTRFS_I(inode), &data_reserved, 0,
-					  cache_size);
+					  cache_size, false);
 	if (ret)
 		goto out_put;
=20
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 1e8f17ff829e..118b2e20b2e1 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -127,9 +127,11 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_ino=
de *inode, u64 bytes)
 }
=20
 int btrfs_check_data_free_space(struct btrfs_inode *inode,
-			struct extent_changeset **reserved, u64 start, u64 len)
+				struct extent_changeset **reserved, u64 start,
+				u64 len, bool noflush)
 {
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
+	enum btrfs_reserve_flush_enum flush =3D BTRFS_RESERVE_FLUSH_DATA;
 	int ret;
=20
 	/* align the range */
@@ -137,7 +139,12 @@ int btrfs_check_data_free_space(struct btrfs_inode *=
inode,
 	      round_down(start, fs_info->sectorsize);
 	start =3D round_down(start, fs_info->sectorsize);
=20
-	ret =3D btrfs_alloc_data_chunk_ondemand(inode, len);
+	if (noflush)
+		flush =3D BTRFS_RESERVE_NO_FLUSH;
+	else if (btrfs_is_free_space_inode(inode))
+		flush =3D BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
+
+	ret =3D btrfs_reserve_data_bytes(fs_info, len, flush);
 	if (ret < 0)
 		return ret;
=20
@@ -454,7 +461,7 @@ int btrfs_delalloc_reserve_space(struct btrfs_inode *=
inode,
 {
 	int ret;
=20
-	ret =3D btrfs_check_data_free_space(inode, reserved, start, len);
+	ret =3D btrfs_check_data_free_space(inode, reserved, start, len, false)=
;
 	if (ret < 0)
 		return ret;
 	ret =3D btrfs_delalloc_reserve_metadata(inode, len, len, false);
diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
index 28bf5c3ef430..e07d46043455 100644
--- a/fs/btrfs/delalloc-space.h
+++ b/fs/btrfs/delalloc-space.h
@@ -7,7 +7,8 @@ struct extent_changeset;
=20
 int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes=
);
 int btrfs_check_data_free_space(struct btrfs_inode *inode,
-			struct extent_changeset **reserved, u64 start, u64 len);
+			struct extent_changeset **reserved, u64 start, u64 len,
+			bool noflush);
 void btrfs_free_reserved_data_space(struct btrfs_inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len);
 void btrfs_delalloc_release_space(struct btrfs_inode *inode,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f4aa198f0f87..0f257205c63d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1664,7 +1664,7 @@ static noinline ssize_t btrfs_buffered_write(struct=
 kiocb *iocb,
 		extent_changeset_release(data_reserved);
 		ret =3D btrfs_check_data_free_space(BTRFS_I(inode),
 						  &data_reserved, pos,
-						  write_bytes);
+						  write_bytes, false);
 		if (ret < 0) {
 			/*
 			 * If we don't have to COW at the offset, reserve
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8ad3bea26652..36e755f73764 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4882,7 +4882,7 @@ int btrfs_truncate_block(struct btrfs_inode *inode,=
 loff_t from, loff_t len,
 	block_end =3D block_start + blocksize - 1;
=20
 	ret =3D btrfs_check_data_free_space(inode, &data_reserved, block_start,
-					  blocksize);
+					  blocksize, false);
 	if (ret < 0) {
 		if (btrfs_check_nocow_lock(inode, block_start, &write_bytes) > 0) {
 			/* For nocow case, no need to reserve data space */
@@ -7767,7 +7767,7 @@ static int btrfs_dio_iomap_begin(struct inode *inod=
e, loff_t start,
 	if (write && !(flags & IOMAP_NOWAIT)) {
 		ret =3D btrfs_check_data_free_space(BTRFS_I(inode),
 						  &dio_data->data_reserved,
-						  start, data_alloc_len);
+						  start, data_alloc_len, false);
 		if (!ret)
 			dio_data->data_space_reserved =3D true;
 		else if (ret && !(BTRFS_I(inode)->flags &
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index d0cbeb7ae81c..0738e1efed79 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1737,7 +1737,8 @@ int btrfs_reserve_data_bytes(struct btrfs_fs_info *=
fs_info, u64 bytes,
 	int ret;
=20
 	ASSERT(flush =3D=3D BTRFS_RESERVE_FLUSH_DATA ||
-	       flush =3D=3D BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE);
+	       flush =3D=3D BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE ||
+	       flush =3D=3D BTRFS_RESERVE_NO_FLUSH);
 	ASSERT(!current->journal_info || flush !=3D BTRFS_RESERVE_FLUSH_DATA);
=20
 	ret =3D __reserve_bytes(fs_info, data_sinfo, bytes, flush);
--=20
2.30.2

