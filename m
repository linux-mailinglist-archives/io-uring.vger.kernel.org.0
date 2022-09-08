Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2EF5B10F8
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 02:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiIHA0r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 20:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiIHA0p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 20:26:45 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00A5BB688
        for <io-uring@vger.kernel.org>; Wed,  7 Sep 2022 17:26:41 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287HneP7006000
        for <io-uring@vger.kernel.org>; Wed, 7 Sep 2022 17:26:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=X9bujSKVcNRB1mYolUM9eziGH5m4EumAaZluL1SER74=;
 b=F5ZCXoz7f2WeRSYCxVJMSwAl+2zAWqBnjj1/gOqQKI2w/YWk+mZ20fYYIf7XMBO9OD91
 D10fH5S2Qced8sg7jjhkfjL4ziTp7K8He8eLwAXQCm9MAuolL16lS2f3vOKTaXCZXAvq
 01GaXvp1VY+anLhi2kRpdNWy11QIPHWw3tg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jeamhj36k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 07 Sep 2022 17:26:40 -0700
Received: from twshared6447.05.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 17:26:39 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id BD8C71D2F038; Wed,  7 Sep 2022 17:26:19 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v2 03/12] btrfs: make can_nocow_extent nowait compatible
Date:   Wed, 7 Sep 2022 17:26:07 -0700
Message-ID: <20220908002616.3189675-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908002616.3189675-1-shr@fb.com>
References: <20220908002616.3189675-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fwfOTBaykBfrLq1j8XLtmNiqNSHIXqcD
X-Proofpoint-GUID: fwfOTBaykBfrLq1j8XLtmNiqNSHIXqcD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
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

If we have NOWAIT specified on our IOCB and we're writing into a
PREALLOC or NOCOW extent then we need to be able to tell
can_nocow_extent that we don't want to wait on any locks or metadata IO.
Fix can_nocow_extent to allow for NOWAIT.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/ctree.h       |  5 +++--
 fs/btrfs/extent-tree.c |  5 +++++
 fs/btrfs/file-item.c   |  4 +++-
 fs/btrfs/file.c        |  2 +-
 fs/btrfs/inode.c       | 16 ++++++++++------
 fs/btrfs/relocation.c  |  2 +-
 fs/btrfs/scrub.c       |  4 ++--
 fs/btrfs/tree-log.c    |  6 +++---
 8 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d6d05450198d..536bbc8551fc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3276,7 +3276,8 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handl=
e *trans,
 blk_status_t btrfs_csum_one_bio(struct btrfs_inode *inode, struct bio *b=
io,
 				u64 offset, bool one_ordered);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end=
,
-			     struct list_head *list, int search_commit);
+			     struct list_head *list, int search_commit,
+			     bool nowait);
 void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 				     const struct btrfs_path *path,
 				     struct btrfs_file_extent_item *fi,
@@ -3306,7 +3307,7 @@ struct extent_map *btrfs_get_extent_fiemap(struct b=
trfs_inode *inode,
 					   u64 start, u64 len);
 noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *orig_start, u64 *orig_block_len,
-			      u64 *ram_bytes, bool strict);
+			      u64 *ram_bytes, bool nowait, bool strict);
=20
 void __btrfs_del_delalloc_inode(struct btrfs_root *root,
 				struct btrfs_inode *inode);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6914cd8024ba..583ddae3c270 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2220,6 +2220,11 @@ static noinline int check_delayed_ref(struct btrfs=
_root *root,
 	}
=20
 	if (!mutex_trylock(&head->mutex)) {
+		if (path->nowait) {
+			spin_unlock(&delayed_refs->lock);
+			return -EAGAIN;
+		}
+
 		refcount_inc(&head->refs);
 		spin_unlock(&delayed_refs->lock);
=20
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index c828f971a346..fcc6ce861409 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -503,7 +503,8 @@ blk_status_t btrfs_lookup_bio_sums(struct inode *inod=
e, struct bio *bio, u8 *dst
 }
=20
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end=
,
-			     struct list_head *list, int search_commit)
+			     struct list_head *list, int search_commit,
+			     bool nowait)
 {
 	struct btrfs_fs_info *fs_info =3D root->fs_info;
 	struct btrfs_key key;
@@ -525,6 +526,7 @@ int btrfs_lookup_csums_range(struct btrfs_root *root,=
 u64 start, u64 end,
 	if (!path)
 		return -ENOMEM;
=20
+	path->nowait =3D nowait;
 	if (search_commit) {
 		path->skip_locking =3D 1;
 		path->reada =3D READA_FORWARD;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5a3f6e0d9688..f4aa198f0f87 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1502,7 +1502,7 @@ int btrfs_check_nocow_lock(struct btrfs_inode *inod=
e, loff_t pos,
=20
 	btrfs_lock_and_flush_ordered_range(inode, lockstart, lockend, NULL);
 	ret =3D can_nocow_extent(&inode->vfs_inode, lockstart, &num_bytes,
-			NULL, NULL, NULL, false);
+			NULL, NULL, NULL, false, false);
 	if (ret <=3D 0) {
 		ret =3D 0;
 		btrfs_drew_write_unlock(&root->snapshot_lock);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ad250892028d..8ad3bea26652 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1667,7 +1667,7 @@ static noinline int run_delalloc_zoned(struct btrfs=
_inode *inode,
 }
=20
 static noinline int csum_exist_in_range(struct btrfs_fs_info *fs_info,
-					u64 bytenr, u64 num_bytes)
+					u64 bytenr, u64 num_bytes, bool nowait)
 {
 	struct btrfs_root *csum_root =3D btrfs_csum_root(fs_info, bytenr);
 	struct btrfs_ordered_sum *sums;
@@ -1675,7 +1675,8 @@ static noinline int csum_exist_in_range(struct btrf=
s_fs_info *fs_info,
 	LIST_HEAD(list);
=20
 	ret =3D btrfs_lookup_csums_range(csum_root, bytenr,
-				       bytenr + num_bytes - 1, &list, 0);
+				       bytenr + num_bytes - 1, &list, 0,
+				       nowait);
 	if (ret =3D=3D 0 && list_empty(&list))
 		return 0;
=20
@@ -1801,6 +1802,7 @@ static int can_nocow_file_extent(struct btrfs_path =
*path,
 	u8 extent_type;
 	int can_nocow =3D 0;
 	int ret =3D 0;
+	bool nowait =3D path->nowait;
=20
 	fi =3D btrfs_item_ptr(leaf, path->slots[0], struct btrfs_file_extent_it=
em);
 	extent_type =3D btrfs_file_extent_type(leaf, fi);
@@ -1877,7 +1879,8 @@ static int can_nocow_file_extent(struct btrfs_path =
*path,
 	 * Force COW if csums exist in the range. This ensures that csums for a
 	 * given extent are either valid or do not exist.
 	 */
-	ret =3D csum_exist_in_range(root->fs_info, args->disk_bytenr, args->num=
_bytes);
+	ret =3D csum_exist_in_range(root->fs_info, args->disk_bytenr, args->num=
_bytes,
+				  nowait);
 	WARN_ON_ONCE(ret > 0 && is_freespace_inode);
 	if (ret !=3D 0)
 		goto out;
@@ -7293,7 +7296,7 @@ static bool btrfs_extent_readonly(struct btrfs_fs_i=
nfo *fs_info, u64 bytenr)
  */
 noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *orig_start, u64 *orig_block_len,
-			      u64 *ram_bytes, bool strict)
+			      u64 *ram_bytes, bool nowait, bool strict)
 {
 	struct btrfs_fs_info *fs_info =3D btrfs_sb(inode->i_sb);
 	struct can_nocow_file_extent_args nocow_args =3D { 0 };
@@ -7309,6 +7312,7 @@ noinline int can_nocow_extent(struct inode *inode, =
u64 offset, u64 *len,
 	path =3D btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->nowait =3D nowait;
=20
 	ret =3D btrfs_lookup_file_extent(NULL, root, path,
 			btrfs_ino(BTRFS_I(inode)), offset, 0);
@@ -7578,7 +7582,7 @@ static int btrfs_get_blocks_direct_write(struct ext=
ent_map **map,
 		block_start =3D em->block_start + (start - em->start);
=20
 		if (can_nocow_extent(inode, start, &len, &orig_start,
-				     &orig_block_len, &ram_bytes, false) =3D=3D 1) {
+				     &orig_block_len, &ram_bytes, false, false) =3D=3D 1) {
 			bg =3D btrfs_inc_nocow_writers(fs_info, block_start);
 			if (bg)
 				can_nocow =3D true;
@@ -11243,7 +11247,7 @@ static int btrfs_swap_activate(struct swap_info_s=
truct *sis, struct file *file,
 		free_extent_map(em);
 		em =3D NULL;
=20
-		ret =3D can_nocow_extent(inode, start, &len, NULL, NULL, NULL, true);
+		ret =3D can_nocow_extent(inode, start, &len, NULL, NULL, NULL, false, =
true);
 		if (ret < 0) {
 			goto out;
 		} else if (ret) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 45c02aba2492..dfc3f6c04b13 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4339,7 +4339,7 @@ int btrfs_reloc_clone_csums(struct btrfs_inode *ino=
de, u64 file_pos, u64 len)
 	disk_bytenr =3D file_pos + inode->index_cnt;
 	csum_root =3D btrfs_csum_root(fs_info, disk_bytenr);
 	ret =3D btrfs_lookup_csums_range(csum_root, disk_bytenr,
-				       disk_bytenr + len - 1, &list, 0);
+				       disk_bytenr + len - 1, &list, 0, false);
 	if (ret)
 		goto out;
=20
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 3afe5fa50a63..1cb3eed8b917 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3077,7 +3077,7 @@ static int scrub_raid56_data_stripe_for_parity(stru=
ct scrub_ctx *sctx,
=20
 		ret =3D btrfs_lookup_csums_range(csum_root, extent_start,
 					       extent_start + extent_size - 1,
-					       &sctx->csum_list, 1);
+					       &sctx->csum_list, 1, false);
 		if (ret) {
 			scrub_parity_mark_sectors_error(sparity, extent_start,
 							extent_size);
@@ -3303,7 +3303,7 @@ static int scrub_simple_mirror(struct scrub_ctx *sc=
tx,
 		if (extent_flags & BTRFS_EXTENT_FLAG_DATA) {
 			ret =3D btrfs_lookup_csums_range(csum_root, cur_logical,
 					cur_logical + scrub_len - 1,
-					&sctx->csum_list, 1);
+					&sctx->csum_list, 1, false);
 			if (ret)
 				break;
 		}
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9205c4a5ca81..8af30dab2a17 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -801,7 +801,7 @@ static noinline int replay_one_extent(struct btrfs_tr=
ans_handle *trans,
=20
 			ret =3D btrfs_lookup_csums_range(root->log_root,
 						csum_start, csum_end - 1,
-						&ordered_sums, 0);
+						&ordered_sums, 0, false);
 			if (ret)
 				goto out;
 			/*
@@ -4513,7 +4513,7 @@ static noinline int copy_items(struct btrfs_trans_h=
andle *trans,
 		disk_bytenr +=3D extent_offset;
 		ret =3D btrfs_lookup_csums_range(csum_root, disk_bytenr,
 					       disk_bytenr + extent_num_bytes - 1,
-					       &ordered_sums, 0);
+					       &ordered_sums, 0, false);
 		if (ret)
 			goto out;
=20
@@ -4709,7 +4709,7 @@ static int log_extent_csums(struct btrfs_trans_hand=
le *trans,
 	ret =3D btrfs_lookup_csums_range(csum_root,
 				       em->block_start + csum_offset,
 				       em->block_start + csum_offset +
-				       csum_len - 1, &ordered_sums, 0);
+				       csum_len - 1, &ordered_sums, 0, false);
 	if (ret)
 		return ret;
=20
--=20
2.30.2

