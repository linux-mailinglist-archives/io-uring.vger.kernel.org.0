Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E1053469A
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 00:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345259AbiEYWfV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 18:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345537AbiEYWfH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 18:35:07 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3546D101DE
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:35:06 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24PGtaDk009464
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:35:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=j/dY8M7U0980IK7tXqhTnWDktIso9RCIpG7xYensPsA=;
 b=p7bHRri7LXOaLHKaj6Fdm0YE8u2VWdobPaat5hVG7PaL0JCX5V53fNaGhI+3yCohtCF1
 hO05yklFS7Ug4qr840doLbB3kTjWH3T/7xi3FOQh0zPQEUXMt2w/qAC3+YcGZiMZGOFf
 CyiZz5gVlQXDltW/HDi0g2oG6xT7n/5GW4s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g93tx1dr2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:35:05 -0700
Received: from twshared10560.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 25 May 2022 15:35:03 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 4265BF9E1B81; Wed, 25 May 2022 15:34:35 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v5 14/16] xfs: Change function signature of xfs_ilock_iocb()
Date:   Wed, 25 May 2022 15:34:30 -0700
Message-ID: <20220525223432.205676-15-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220525223432.205676-1-shr@fb.com>
References: <20220525223432.205676-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: triHOTbVe_d2ngFLqXtWjOfE6hwzj2e0
X-Proofpoint-GUID: triHOTbVe_d2ngFLqXtWjOfE6hwzj2e0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_06,2022-05-25_02,2022-02-23_01
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

