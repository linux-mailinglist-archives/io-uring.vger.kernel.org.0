Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6085105B6
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353279AbiDZRrN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349265AbiDZRrM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564581816ED
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:04 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQRGP015407
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=GH1+MXt5i7iBXahEfZX4x8k2bUloCbbTyddNdvbHmvI=;
 b=grY+W0iF8mxETr4nBW/7EQZ4h3g49V0P8ELB/FIMqo4lLE2o4N8swA4V3p9e351v2U1L
 57Os3QgjIncIozKizxCjEjZNgVAcVuXzK4gW4CqIl7fGBfBMnCqe+s9Ti9R0+hYj1QlK
 lIr8PH3rGGfSLce15FM6BjQBNyveD3oCbCE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fp6f9d36h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:04 -0700
Received: from twshared13345.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:44:02 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 95880E2D485F; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 06/18] xfs: add iomap async buffered write support
Date:   Tue, 26 Apr 2022 10:43:23 -0700
Message-ID: <20220426174335.4004987-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: VEHYyqUTuorOnThdUc10I407gIJDZA69
X-Proofpoint-GUID: VEHYyqUTuorOnThdUc10I407gIJDZA69
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the async buffered write support to the iomap layer of XFS. If
a lock cannot be acquired or additional reads need to be performed, the
request will return -EAGAIN in case this is an async buffered write reque=
st.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/xfs/xfs_iomap.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e552ce541ec2..80b6c48e88af 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -881,18 +881,28 @@ xfs_buffered_write_iomap_begin(
 	bool			eof =3D false, cow_eof =3D false, shared =3D false;
 	int			allocfork =3D XFS_DATA_FORK;
 	int			error =3D 0;
+	bool			no_wait =3D (flags & IOMAP_NOWAIT);
=20
 	if (xfs_is_shutdown(mp))
 		return -EIO;
=20
 	/* we can't use delayed allocations when using extent size hints */
-	if (xfs_get_extsz_hint(ip))
+	if (xfs_get_extsz_hint(ip)) {
+		if (no_wait)
+			return -EAGAIN;
+
 		return xfs_direct_write_iomap_begin(inode, offset, count,
 				flags, iomap, srcmap);
+	}
=20
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
=20
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (no_wait) {
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+	}
=20
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
@@ -902,6 +912,11 @@ xfs_buffered_write_iomap_begin(
=20
 	XFS_STATS_INC(mp, xs_blk_mapw);
=20
+	if (no_wait && xfs_need_iread_extents(XFS_IFORK_PTR(ip, XFS_DATA_FORK))=
) {
+		error =3D -EAGAIN;
+		goto out_unlock;
+	}
+
 	error =3D xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
 	if (error)
 		goto out_unlock;
@@ -933,6 +948,10 @@ xfs_buffered_write_iomap_begin(
 	if (xfs_is_cow_inode(ip)) {
 		if (!ip->i_cowfp) {
 			ASSERT(!xfs_is_reflink_inode(ip));
+			if (no_wait) {
+				error =3D -EAGAIN;
+				goto out_unlock;
+			}
 			xfs_ifork_init_cow(ip);
 		}
 		cow_eof =3D !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
@@ -956,6 +975,11 @@ xfs_buffered_write_iomap_begin(
 			goto found_imap;
 		}
=20
+		if (no_wait) {
+			error =3D -EAGAIN;
+			goto out_unlock;
+		}
+
 		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
=20
 		/* Trim the mapping to the nearest shared extent boundary. */
@@ -993,6 +1017,11 @@ xfs_buffered_write_iomap_begin(
 			allocfork =3D XFS_COW_FORK;
 	}
=20
+	if (no_wait) {
+		error =3D -EAGAIN;
+		goto out_unlock;
+	}
+
 	error =3D xfs_qm_dqattach_locked(ip, false);
 	if (error)
 		goto out_unlock;
--=20
2.30.2

