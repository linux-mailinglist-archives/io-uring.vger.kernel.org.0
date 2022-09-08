Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A65B10F7
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 02:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiIHA0r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 20:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiIHA0p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 20:26:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3089BD0214
        for <io-uring@vger.kernel.org>; Wed,  7 Sep 2022 17:26:42 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 287HnemN015420
        for <io-uring@vger.kernel.org>; Wed, 7 Sep 2022 17:26:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=FP4BKMFtaBlJsT3YkvMH3UxflWSwQVSL2T5ICVjAeuI=;
 b=hVVGuGhCaWU0MEVjIboUnyHrT8svMtbvkk6d4fqXQfWSaqplgqTuLF7sDy3WV+GB+b/d
 Gl11c0JFxD3pr9uiHF/08miQOTR3ITvyFOr26SEH9X/eH2+hdk3n72TQg4vImBFWm7hu
 llhXrx2bpLc2AYK5XSDjzQJUQmAxiyaSUjU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jevdac9xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 07 Sep 2022 17:26:40 -0700
Received: from twshared6447.05.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 17:26:39 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id C93071D2F03C; Wed,  7 Sep 2022 17:26:19 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v2 05/12] btrfs: add btrfs_try_lock_ordered_range
Date:   Wed, 7 Sep 2022 17:26:09 -0700
Message-ID: <20220908002616.3189675-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908002616.3189675-1-shr@fb.com>
References: <20220908002616.3189675-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: NrX3bzNndXzDfVBDYKbqJm6MS62JKXfh
X-Proofpoint-ORIG-GUID: NrX3bzNndXzDfVBDYKbqJm6MS62JKXfh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
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

For IOCB_NOWAIT we're going to want to use try lock on the extent lock,
and simply bail if there's an ordered extent in the range because the
only choice there is to wait for the ordered extent to complete.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/ordered-data.c | 28 ++++++++++++++++++++++++++++
 fs/btrfs/ordered-data.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 1952ac85222c..3cdfdcedb088 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -1041,6 +1041,34 @@ void btrfs_lock_and_flush_ordered_range(struct btr=
fs_inode *inode, u64 start,
 	}
 }
=20
+/*
+ * btrfs_try_lock_ordered_range - lock the passed range and ensure all p=
ending
+ * ordered extents in it are run to completion in nowait mode.
+ *
+ * @inode:        Inode whose ordered tree is to be searched
+ * @start:        Beginning of range to flush
+ * @end:          Last byte of range to lock
+ *
+ * This function returns 1 if btrfs_lock_ordered_range does not return a=
ny
+ * extents, otherwise 0.
+ */
+int btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u=
64 end)
+{
+	struct btrfs_ordered_extent *ordered;
+
+	if (!try_lock_extent(&inode->io_tree, start, end))
+		return 0;
+
+	ordered =3D btrfs_lookup_ordered_range(inode, start, end - start + 1);
+	if (!ordered)
+		return 1;
+
+	btrfs_put_ordered_extent(ordered);
+	unlock_extent(&inode->io_tree, start, end);
+	return 0;
+}
+
+
 static int clone_ordered_extent(struct btrfs_ordered_extent *ordered, u6=
4 pos,
 				u64 len)
 {
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 87792f85e2c4..ec27ebf0af4b 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -218,6 +218,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *f=
s_info, u64 nr,
 void btrfs_lock_and_flush_ordered_range(struct btrfs_inode *inode, u64 s=
tart,
 					u64 end,
 					struct extent_state **cached_state);
+int btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u=
64 end);
 int btrfs_split_ordered_extent(struct btrfs_ordered_extent *ordered, u64=
 pre,
 			       u64 post);
 int __init ordered_data_init(void);
--=20
2.30.2

