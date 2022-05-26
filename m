Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD4E5352C0
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 19:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348343AbiEZRjj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 13:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348348AbiEZRjZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 13:39:25 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C625B9CF41
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:19 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QGA2i7029187
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=j/dY8M7U0980IK7tXqhTnWDktIso9RCIpG7xYensPsA=;
 b=hYZ8Ze4A/CT5HaS/PTL8nf4XjsIpMU+hmG0ipwIqQacEDvUSxqSN5f3/kFCwQS6uQ9SB
 mPtqbyOPchTY4saAJGd2qlr/osfexs6a+CFIOmrfYTpyJRJNmV4chdFLYPdKHp6B3g3D
 Shve816DjdjVFJId54bjXy9tv90jM3HXGwo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g9puarjjt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:19 -0700
Received: from twshared35748.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 26 May 2022 10:39:18 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id ACE45FA621E8; Thu, 26 May 2022 10:38:45 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v6 14/16] xfs: Change function signature of xfs_ilock_iocb()
Date:   Thu, 26 May 2022 10:38:38 -0700
Message-ID: <20220526173840.578265-15-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220526173840.578265-1-shr@fb.com>
References: <20220526173840.578265-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 9MxVhuZUAk79VupLOBAyK72Lguq9qt4X
X-Proofpoint-ORIG-GUID: 9MxVhuZUAk79VupLOBAyK72Lguq9qt4X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_09,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This changes the function signature of the function xfs_ilock_iocb():
- the parameter iocb is replaced with ip, passing in an xfs_inode
- the parameter iocb_flags is added to be able to pass in the iocb flags

This allows to call the function from xfs_file_buffered_writes.
All the callers are changed accordingly.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/xfs/xfs_file.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5bddb1e9e0b3..50dea07f5e56 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -190,14 +190,13 @@ xfs_file_fsync(
 	return error;
 }
=20
-static int
+static inline int
 xfs_ilock_iocb(
-	struct kiocb		*iocb,
+	struct xfs_inode	*ip,
+	int			iocb_flags,
 	unsigned int		lock_mode)
 {
-	struct xfs_inode	*ip =3D XFS_I(file_inode(iocb->ki_filp));
-
-	if (iocb->ki_flags & IOCB_NOWAIT) {
+	if (iocb_flags & IOCB_NOWAIT) {
 		if (!xfs_ilock_nowait(ip, lock_mode))
 			return -EAGAIN;
 	} else {
@@ -222,7 +221,7 @@ xfs_file_dio_read(
=20
 	file_accessed(iocb->ki_filp);
=20
-	ret =3D xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
+	ret =3D xfs_ilock_iocb(ip, iocb->ki_flags, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
 	ret =3D iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, 0);
@@ -244,7 +243,7 @@ xfs_file_dax_read(
 	if (!iov_iter_count(to))
 		return 0; /* skip atime */
=20
-	ret =3D xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
+	ret =3D xfs_ilock_iocb(ip, iocb->ki_flags, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
 	ret =3D dax_iomap_rw(iocb, to, &xfs_read_iomap_ops);
@@ -264,7 +263,7 @@ xfs_file_buffered_read(
=20
 	trace_xfs_file_buffered_read(iocb, to);
=20
-	ret =3D xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
+	ret =3D xfs_ilock_iocb(ip, iocb->ki_flags, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
 	ret =3D generic_file_read_iter(iocb, to);
@@ -343,7 +342,7 @@ xfs_file_write_checks(
 	if (*iolock =3D=3D XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
 		xfs_iunlock(ip, *iolock);
 		*iolock =3D XFS_IOLOCK_EXCL;
-		error =3D xfs_ilock_iocb(iocb, *iolock);
+		error =3D xfs_ilock_iocb(ip, iocb->ki_flags, *iolock);
 		if (error) {
 			*iolock =3D 0;
 			return error;
@@ -516,7 +515,7 @@ xfs_file_dio_write_aligned(
 	int			iolock =3D XFS_IOLOCK_SHARED;
 	ssize_t			ret;
=20
-	ret =3D xfs_ilock_iocb(iocb, iolock);
+	ret =3D xfs_ilock_iocb(ip, iocb->ki_flags, iolock);
 	if (ret)
 		return ret;
 	ret =3D xfs_file_write_checks(iocb, from, &iolock);
@@ -583,7 +582,7 @@ xfs_file_dio_write_unaligned(
 		flags =3D IOMAP_DIO_FORCE_WAIT;
 	}
=20
-	ret =3D xfs_ilock_iocb(iocb, iolock);
+	ret =3D xfs_ilock_iocb(ip, iocb->ki_flags, iolock);
 	if (ret)
 		return ret;
=20
@@ -659,7 +658,7 @@ xfs_file_dax_write(
 	ssize_t			ret, error =3D 0;
 	loff_t			pos;
=20
-	ret =3D xfs_ilock_iocb(iocb, iolock);
+	ret =3D xfs_ilock_iocb(ip, iocb->ki_flags, iolock);
 	if (ret)
 		return ret;
 	ret =3D xfs_file_write_checks(iocb, from, &iolock);
--=20
2.30.2

