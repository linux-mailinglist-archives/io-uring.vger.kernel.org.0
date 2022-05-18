Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4240652C7B5
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiERXhl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiERXhe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:37:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF9860060
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:32 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6CEV011494
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xpR2o1MxE5h1TGY+8JuoVPirJk4Gk5FbraTEzaT2FUw=;
 b=NxtOGpNELQR0iKNa6NkY8GykTHgy56E1e+FzzhdFbAorfvsS0/iCA4LhnT1ogMVEqS3W
 zPZDlChdE2JRBrrPAIHL13QINSSFsFiATbc4JFNf2ZU5Wy9YLw7brrkIirUNoNF8/R+e
 nFlNcxB+WpWJrtIBHgIg8Ds1XMg0uZvJwbU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4frtanp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:32 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 18 May 2022 16:37:26 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C06F6F3ED85B; Wed, 18 May 2022 16:37:12 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v3 05/18] xfs: Add iomap async buffered write support
Date:   Wed, 18 May 2022 16:36:56 -0700
Message-ID: <20220518233709.1937634-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518233709.1937634-1-shr@fb.com>
References: <20220518233709.1937634-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: vVpSKSDMpoR6dbMhkKo08AWzQClRSxPA
X-Proofpoint-ORIG-GUID: vVpSKSDMpoR6dbMhkKo08AWzQClRSxPA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the async buffered write support to the iomap layer of XFS. If
a lock cannot be acquired or additional reads need to be performed, the
request will return -EAGAIN in case this is an async buffered write
request.

This patch changes the helper function xfs_ilock_for_iomap such that the
lock mode needs to be passed in.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/xfs/xfs_iomap.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e552ce541ec2..1aea962262ad 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -659,7 +659,7 @@ xfs_ilock_for_iomap(
 	unsigned		flags,
 	unsigned		*lockmode)
 {
-	unsigned		mode =3D XFS_ILOCK_SHARED;
+	unsigned int		mode =3D *lockmode;
 	bool			is_write =3D flags & (IOMAP_WRITE | IOMAP_ZERO);
=20
 	/*
@@ -737,7 +737,7 @@ xfs_direct_write_iomap_begin(
 	int			nimaps =3D 1, error =3D 0;
 	bool			shared =3D false;
 	u16			iomap_flags =3D 0;
-	unsigned		lockmode;
+	unsigned int		lockmode =3D XFS_ILOCK_SHARED;
=20
 	ASSERT(flags & (IOMAP_WRITE | IOMAP_ZERO));
=20
@@ -881,18 +881,22 @@ xfs_buffered_write_iomap_begin(
 	bool			eof =3D false, cow_eof =3D false, shared =3D false;
 	int			allocfork =3D XFS_DATA_FORK;
 	int			error =3D 0;
+	unsigned int		lockmode =3D XFS_ILOCK_EXCL;
=20
 	if (xfs_is_shutdown(mp))
 		return -EIO;
=20
 	/* we can't use delayed allocations when using extent size hints */
-	if (xfs_get_extsz_hint(ip))
+	if (xfs_get_extsz_hint(ip)) {
 		return xfs_direct_write_iomap_begin(inode, offset, count,
 				flags, iomap, srcmap);
+	}
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
@@ -1167,7 +1171,7 @@ xfs_read_iomap_begin(
 	xfs_fileoff_t		end_fsb =3D xfs_iomap_end_fsb(mp, offset, length);
 	int			nimaps =3D 1, error =3D 0;
 	bool			shared =3D false;
-	unsigned		lockmode;
+	unsigned int		lockmode =3D XFS_ILOCK_SHARED;
=20
 	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)));
=20
--=20
2.30.2

