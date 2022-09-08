Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F785B10F5
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 02:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiIHA0q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 20:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiIHA0p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 20:26:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7432AD0215
        for <io-uring@vger.kernel.org>; Wed,  7 Sep 2022 17:26:42 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 287HndTU020483
        for <io-uring@vger.kernel.org>; Wed, 7 Sep 2022 17:26:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=GDEVOcRcGecgVGua2i94I1UxUy/DPQU2dklHpUY7dQ4=;
 b=ZKb6IS7H1ynYTA8n6MnoDXoIPvXwyeeqXc9rFVGMr6vL91H0EFQ6n4IJ/A2avAWlW3WP
 JAIhNb/QUlgqSUX0znHp9RoXaD8skFeKcYUUHIcDHaaEQBxXi5DWAkPDyqWmUrULjLos
 q+rDJe2oy8iaMUKk8tB89x8CRYE4TfylU2o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jee6bgevb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 07 Sep 2022 17:26:41 -0700
Received: from twshared6447.05.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 17:26:39 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id CEF0F1D2F03E; Wed,  7 Sep 2022 17:26:19 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v2 06/12] btrfs: make btrfs_check_nocow_lock nowait compatible
Date:   Wed, 7 Sep 2022 17:26:10 -0700
Message-ID: <20220908002616.3189675-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908002616.3189675-1-shr@fb.com>
References: <20220908002616.3189675-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Url_dqVp3qIcYf3y-Jg1ldgpjyKBRAZy
X-Proofpoint-GUID: Url_dqVp3qIcYf3y-Jg1ldgpjyKBRAZy
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

Now all the helpers that btrfs_check_nocow_lock uses handle nowait, add
a nowait flag to btrfs_check_nocow_lock so it can be used by the write
path.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/ctree.h |  2 +-
 fs/btrfs/file.c  | 33 ++++++++++++++++++++++-----------
 fs/btrfs/inode.c |  2 +-
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 536bbc8551fc..06cb25f2d3bd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3482,7 +3482,7 @@ int btrfs_dirty_pages(struct btrfs_inode *inode, st=
ruct page **pages,
 		      struct extent_state **cached, bool noreserve);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end=
);
 int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
-			   size_t *write_bytes);
+			   size_t *write_bytes, bool nowait);
 void btrfs_check_nocow_unlock(struct btrfs_inode *inode);
=20
 /* tree-defrag.c */
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0f257205c63d..cf19d381ead6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1481,7 +1481,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode =
*inode, struct page **pages,
  * NOTE: Callers need to call btrfs_check_nocow_unlock() if we return > =
0.
  */
 int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
-			   size_t *write_bytes)
+			   size_t *write_bytes, bool nowait)
 {
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
 	struct btrfs_root *root =3D inode->root;
@@ -1500,16 +1500,21 @@ int btrfs_check_nocow_lock(struct btrfs_inode *in=
ode, loff_t pos,
 			   fs_info->sectorsize) - 1;
 	num_bytes =3D lockend - lockstart + 1;
=20
-	btrfs_lock_and_flush_ordered_range(inode, lockstart, lockend, NULL);
+	if (nowait) {
+		if (!btrfs_try_lock_ordered_range(inode, lockstart, lockend)) {
+			btrfs_drew_write_unlock(&root->snapshot_lock);
+			return -EAGAIN;
+		}
+	} else {
+		btrfs_lock_and_flush_ordered_range(inode, lockstart, lockend, NULL);
+	}
 	ret =3D can_nocow_extent(&inode->vfs_inode, lockstart, &num_bytes,
-			NULL, NULL, NULL, false, false);
-	if (ret <=3D 0) {
-		ret =3D 0;
+			NULL, NULL, NULL, nowait, false);
+	if (ret <=3D 0)
 		btrfs_drew_write_unlock(&root->snapshot_lock);
-	} else {
+	else
 		*write_bytes =3D min_t(size_t, *write_bytes ,
 				     num_bytes - pos + lockstart);
-	}
 	unlock_extent(&inode->io_tree, lockstart, lockend);
=20
 	return ret;
@@ -1666,16 +1671,22 @@ static noinline ssize_t btrfs_buffered_write(stru=
ct kiocb *iocb,
 						  &data_reserved, pos,
 						  write_bytes, false);
 		if (ret < 0) {
+			int tmp;
+
 			/*
 			 * If we don't have to COW at the offset, reserve
 			 * metadata only. write_bytes may get smaller than
 			 * requested here.
 			 */
-			if (btrfs_check_nocow_lock(BTRFS_I(inode), pos,
-						   &write_bytes) > 0)
-				only_release_metadata =3D true;
-			else
+			tmp =3D btrfs_check_nocow_lock(BTRFS_I(inode), pos,
+						     &write_bytes, false);
+			if (tmp < 0)
+				ret =3D tmp;
+			if (tmp > 0)
+				ret =3D 0;
+			if (ret)
 				break;
+			only_release_metadata =3D true;
 		}
=20
 		num_pages =3D DIV_ROUND_UP(write_bytes + offset, PAGE_SIZE);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 36e755f73764..5426d4f4ac23 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4884,7 +4884,7 @@ int btrfs_truncate_block(struct btrfs_inode *inode,=
 loff_t from, loff_t len,
 	ret =3D btrfs_check_data_free_space(inode, &data_reserved, block_start,
 					  blocksize, false);
 	if (ret < 0) {
-		if (btrfs_check_nocow_lock(inode, block_start, &write_bytes) > 0) {
+		if (btrfs_check_nocow_lock(inode, block_start, &write_bytes, false) > =
0) {
 			/* For nocow case, no need to reserve data space */
 			only_release_metadata =3D true;
 		} else {
--=20
2.30.2

