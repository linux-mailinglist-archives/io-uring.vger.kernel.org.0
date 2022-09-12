Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E3D5B61B5
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 21:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiILT2R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 15:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiILT2Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 15:28:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EC246208
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:14 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 28CFwoBx023356
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=IijL+6ktEQVnC8jsLhUeVptj0sovDNKd9aG2PZkdZJQ=;
 b=TZgv9M9VotzTlHMsObD0ymTkVMFP9+dDptsr0cjMQN+SmCJgt4EkPBUn23rim0o5jM7H
 3iE7cAk/MpS/7pUoz7RRSHTH8pfZt1NGFSTJQDK2qF+BwWP2Mm+LFmZgI/EEPMvTJhCV
 9GRpmLf6aDeV8PO2TFf2TgAV6Ybm41QGWdU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jgp8xvx1w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:13 -0700
Received: from twshared6447.05.prn5.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 12:28:08 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id ED68F208522A; Mon, 12 Sep 2022 12:27:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v3 02/12] btrfs: implement a nowait option for tree searches
Date:   Mon, 12 Sep 2022 12:27:42 -0700
Message-ID: <20220912192752.3785061-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220912192752.3785061-1-shr@fb.com>
References: <20220912192752.3785061-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: A5FWy_AO24a1h-uzgYrUl1bTNsXAAjIz
X-Proofpoint-ORIG-GUID: A5FWy_AO24a1h-uzgYrUl1bTNsXAAjIz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_12,2022-09-12_02,2022-06-22_01
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

From: Josef Bacik <josef@toxicpanda.com>

For NOWAIT IOCB's we'll need a way to tell search to not wait on locks
or anything.  Accomplish this by adding a path->nowait flag that will
use trylocks and skip reading of metadata, returning -EAGAIN in either
of these cases.  For now we only need this for reads, so only the read
side is handled.  Add an ASSERT() to catch anybody trying to use this
for writes so they know they'll have to implement the write side.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/ctree.c   | 39 ++++++++++++++++++++++++++++++++++++---
 fs/btrfs/ctree.h   |  1 +
 fs/btrfs/locking.c | 23 +++++++++++++++++++++++
 fs/btrfs/locking.h |  1 +
 4 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ebfa35fe1c38..71b238364939 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1447,6 +1447,11 @@ read_block_for_search(struct btrfs_root *root, str=
uct btrfs_path *p,
 			return 0;
 		}
=20
+		if (p->nowait) {
+			free_extent_buffer(tmp);
+			return -EAGAIN;
+		}
+
 		if (unlock_up)
 			btrfs_unlock_up_safe(p, level + 1);
=20
@@ -1467,6 +1472,8 @@ read_block_for_search(struct btrfs_root *root, stru=
ct btrfs_path *p,
 			ret =3D -EAGAIN;
=20
 		goto out;
+	} else if (p->nowait) {
+		return -EAGAIN;
 	}
=20
 	if (unlock_up) {
@@ -1634,7 +1641,13 @@ static struct extent_buffer *btrfs_search_slot_get=
_root(struct btrfs_root *root,
 		 * We don't know the level of the root node until we actually
 		 * have it read locked
 		 */
-		b =3D btrfs_read_lock_root_node(root);
+		if (p->nowait) {
+			b =3D btrfs_try_read_lock_root_node(root);
+			if (IS_ERR(b))
+				return b;
+		} else {
+			b =3D btrfs_read_lock_root_node(root);
+		}
 		level =3D btrfs_header_level(b);
 		if (level > write_lock_level)
 			goto out;
@@ -1910,6 +1923,13 @@ int btrfs_search_slot(struct btrfs_trans_handle *t=
rans, struct btrfs_root *root,
 	WARN_ON(p->nodes[0] !=3D NULL);
 	BUG_ON(!cow && ins_len);
=20
+	/*
+	 * For now only allow nowait for read only operations.  There's no
+	 * strict reason why we can't, we just only need it for reads so I'm
+	 * only implementing it for reads right now.
+	 */
+	ASSERT(!p->nowait || !cow);
+
 	if (ins_len < 0) {
 		lowest_unlock =3D 2;
=20
@@ -1936,7 +1956,12 @@ int btrfs_search_slot(struct btrfs_trans_handle *t=
rans, struct btrfs_root *root,
=20
 	if (p->need_commit_sem) {
 		ASSERT(p->search_commit_root);
-		down_read(&fs_info->commit_root_sem);
+		if (p->nowait) {
+			if (!down_read_trylock(&fs_info->commit_root_sem))
+				return -EAGAIN;
+		} else {
+			down_read(&fs_info->commit_root_sem);
+		}
 	}
=20
 again:
@@ -2082,7 +2107,15 @@ int btrfs_search_slot(struct btrfs_trans_handle *t=
rans, struct btrfs_root *root,
 				btrfs_tree_lock(b);
 				p->locks[level] =3D BTRFS_WRITE_LOCK;
 			} else {
-				btrfs_tree_read_lock(b);
+				if (p->nowait) {
+					if (!btrfs_try_tree_read_lock(b)) {
+						free_extent_buffer(b);
+						ret =3D -EAGAIN;
+						goto done;
+					}
+				} else {
+					btrfs_tree_read_lock(b);
+				}
 				p->locks[level] =3D BTRFS_READ_LOCK;
 			}
 			p->nodes[level] =3D b;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index df8c99c99df9..ca59ba6421a9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -443,6 +443,7 @@ struct btrfs_path {
 	 * header (ie. sizeof(struct btrfs_item) is not included).
 	 */
 	unsigned int search_for_extension:1;
+	unsigned int nowait:1;
 };
 #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info)=
 >> 4) - \
 					sizeof(struct btrfs_item))
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 9063072b399b..d6c88922d3e2 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -285,6 +285,29 @@ struct extent_buffer *btrfs_read_lock_root_node(stru=
ct btrfs_root *root)
 	return eb;
 }
=20
+/*
+ * Loop around taking references on and locking the root node of the tre=
e in
+ * nowait mode until we end up with a lock on the root node or returning=
 to
+ * avoid blocking.
+ *
+ * Return: root extent buffer with read lock held or -EWOULDBLOCK.
+ */
+struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *r=
oot)
+{
+	struct extent_buffer *eb;
+
+	while (1) {
+		eb =3D btrfs_root_node(root);
+		if (!btrfs_try_tree_read_lock(eb))
+			return ERR_PTR(-EAGAIN);
+		if (eb =3D=3D root->node)
+			break;
+		btrfs_tree_read_unlock(eb);
+		free_extent_buffer(eb);
+	}
+	return eb;
+}
+
 /*
  * DREW locks
  * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index ab268be09bb5..490c7a79e995 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -94,6 +94,7 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb);
 int btrfs_try_tree_write_lock(struct extent_buffer *eb);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)=
;
+struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *r=
oot);
=20
 #ifdef CONFIG_BTRFS_DEBUG
 static inline void btrfs_assert_tree_write_locked(struct extent_buffer *=
eb)
--=20
2.30.2

