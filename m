Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532A85346B8
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 00:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239827AbiEYWhH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 18:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345518AbiEYWfE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 18:35:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7B3FD14
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:35:03 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24PGtcqQ009591
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:35:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xrXV6DDKAu8edht2TcHb7XC2Tqf/DAsX1r3VS5rTvoo=;
 b=nq/FnwgdSIxm3G9FiuG3qyoerWRrW88Z7auP/XV0XDH6CQ1Q4on+mEQUjeHlNPFYE33n
 YfyLfvGQIFSss8nr2vgfVMvzQY7nXodO3hkRAAC4zhf7eKnoQ8UKQHpX4W6rG+Y6X+1K
 iOURdEUMw7fswKxKwPRAHTS577uxgBnQAEY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g93tx1dqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:35:02 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 25 May 2022 15:35:01 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 4A19FF9E1B83; Wed, 25 May 2022 15:34:35 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v5 15/16] xfs: Add async buffered write support
Date:   Wed, 25 May 2022 15:34:31 -0700
Message-ID: <20220525223432.205676-16-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220525223432.205676-1-shr@fb.com>
References: <20220525223432.205676-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: VoaTxnZyAU9sgahQMQmjh-_L8rYU-mNm
X-Proofpoint-GUID: VoaTxnZyAU9sgahQMQmjh-_L8rYU-mNm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_06,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the async buffered write support to XFS. For async buffered
write requests, the request will return -EAGAIN if the ilock cannot be
obtained immediately.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/xfs/xfs_file.c  | 9 ++++-----
 fs/xfs/xfs_iomap.c | 5 ++++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 50dea07f5e56..e9d615f4c209 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -409,7 +409,7 @@ xfs_file_write_checks(
 		spin_unlock(&ip->i_flags_lock);
=20
 out:
-	return file_modified(file);
+	return kiocb_modified(iocb);
 }
=20
 static int
@@ -701,12 +701,11 @@ xfs_file_buffered_write(
 	bool			cleared_space =3D false;
 	int			iolock;
=20
-	if (iocb->ki_flags & IOCB_NOWAIT)
-		return -EOPNOTSUPP;
-
 write_retry:
 	iolock =3D XFS_IOLOCK_EXCL;
-	xfs_ilock(ip, iolock);
+	ret =3D xfs_ilock_iocb(ip, iocb->ki_flags, iolock);
+	if (ret)
+		return ret;
=20
 	ret =3D xfs_file_write_checks(iocb, from, &iolock);
 	if (ret)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3aa60e53a181..af8c50140f0f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -881,6 +881,7 @@ xfs_buffered_write_iomap_begin(
 	bool			eof =3D false, cow_eof =3D false, shared =3D false;
 	int			allocfork =3D XFS_DATA_FORK;
 	int			error =3D 0;
+	unsigned int		lockmode =3D XFS_ILOCK_EXCL;
=20
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -892,7 +893,9 @@ xfs_buffered_write_iomap_begin(
=20
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
=20
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error =3D xfs_ilock_for_iomap(ip, flags, &lockmode);
+	if (error)
+		return error;
=20
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
--=20
2.30.2

