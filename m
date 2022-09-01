Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21785AA377
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 00:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiIAW7h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 18:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbiIAW7f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 18:59:35 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469957A752
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 15:59:35 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281MnoKo005336
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 15:59:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=rw0k7DZmYMzQBjK5YB9+d7ZEbsfOy10Ymshr2skiNpE=;
 b=LcWhyHgF4AGV09ky4ce0xq4TuS2z1+c00VB3X9JBdXrDtQZvWvGBuoSlnj9weZ68Wh1E
 hmseKVC6cfMPaJsVVkZWeXEKVvxaBklE9rRMHDU4q3/cE/3NxwWxhR5SyUJckkUZdw2/
 QXoQFIeg4mxFQx8Oto63Sc0qEgK5WHDIQqY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jat6s55s4-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 15:59:34 -0700
Received: from twshared22593.02.prn5.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 15:59:31 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 4D98A19149CD; Thu,  1 Sep 2022 15:59:13 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>
Subject: [PATCH v1 07/10] btrfs: make lock_and_cleanup_extent_if_need nowait compatible
Date:   Thu, 1 Sep 2022 15:58:46 -0700
Message-ID: <20220901225849.42898-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901225849.42898-1-shr@fb.com>
References: <20220901225849.42898-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: kKYC3U1pVnOEiHSE452B14iAtRxVeK1e
X-Proofpoint-ORIG-GUID: kKYC3U1pVnOEiHSE452B14iAtRxVeK1e
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

This adds the nowait parameter to lock_and_cleanup_extent_if_need(). If
the nowait parameter is specified we try to lock the extent in nowait
mode.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/file.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d529f61ac5b9..ef9175efbf99 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1440,7 +1440,7 @@ static noinline int
 lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page *=
*pages,
 				size_t num_pages, loff_t pos,
 				size_t write_bytes,
-				u64 *lockstart, u64 *lockend,
+				u64 *lockstart, u64 *lockend, bool nowait,
 				struct extent_state **cached_state)
 {
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
@@ -1455,8 +1455,20 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode=
 *inode, struct page **pages,
 	if (start_pos < inode->vfs_inode.i_size) {
 		struct btrfs_ordered_extent *ordered;
=20
-		lock_extent_bits(&inode->io_tree, start_pos, last_pos,
+		if (nowait) {
+			if (!try_lock_extent(&inode->io_tree, start_pos, last_pos)) {
+				for (i =3D 0; i < num_pages; i++) {
+					unlock_page(pages[i]);
+					put_page(pages[i]);
+				}
+
+				return -EWOULDBLOCK;
+			}
+		} else {
+			lock_extent_bits(&inode->io_tree, start_pos, last_pos,
 				cached_state);
+		}
+
 		ordered =3D btrfs_lookup_ordered_range(inode, start_pos,
 						     last_pos - start_pos + 1);
 		if (ordered &&
@@ -1755,7 +1767,7 @@ static noinline ssize_t btrfs_buffered_write(struct=
 kiocb *iocb,
 		extents_locked =3D lock_and_cleanup_extent_if_need(
 				BTRFS_I(inode), pages,
 				num_pages, pos, write_bytes, &lockstart,
-				&lockend, &cached_state);
+				&lockend, false, &cached_state);
 		if (extents_locked < 0) {
 			if (extents_locked =3D=3D -EAGAIN)
 				goto again;
--=20
2.30.2

