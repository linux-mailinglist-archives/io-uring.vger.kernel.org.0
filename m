Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFB75B61BA
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 21:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiILT2V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 15:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiILT2U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 15:28:20 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C280245F7D
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:18 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CIuZli020563
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Xfmv/q1sJqX2orN/Q6I/sqaH1MCfWUK4TQnNtY5BWDc=;
 b=Km2YyidxKG/uK1G+0axv3B9xehd9q+GKNg9XZeaKqLeJlxnkPGMq2weZwkDxM3Y9cCPO
 dnFLwxfqA+FdHqCTgg/Nf/wr5jRYcnlR/TfQSzS0QvybHHS03tRkotm1DDKTXl2PEh/L
 pq0MjTSUvrTkpiVp4x/XGQaej3UTZ4aj5Ac= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jgrb1mec9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:17 -0700
Received: from twshared13315.14.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 12:28:16 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 266C1208523A; Mon, 12 Sep 2022 12:27:54 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v3 10/12] btrfs: make balance_dirty_pages nowait compatible
Date:   Mon, 12 Sep 2022 12:27:50 -0700
Message-ID: <20220912192752.3785061-11-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220912192752.3785061-1-shr@fb.com>
References: <20220912192752.3785061-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: AWZEvZ4Akbr78DHttzWGW_tJJ84he7Tp
X-Proofpoint-GUID: AWZEvZ4Akbr78DHttzWGW_tJJ84he7Tp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_13,2022-09-12_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This replaces the call to function balance_dirty_pages_ratelimited() in
the function btrfs_buffered_write() with a call to
balance_dirty_pages_ratelimited_flags().

It also moves the function after the again label. This can cause the
function to be called a bit later, but this should have no impact in the
real world.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/file.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3d038e1257f9..4dc6484ff229 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1654,6 +1654,7 @@ static noinline ssize_t btrfs_buffered_write(struct=
 kiocb *iocb,
 	loff_t old_isize =3D i_size_read(inode);
 	unsigned int ilock_flags =3D 0;
 	const bool nowait =3D iocb->ki_flags & IOCB_NOWAIT;
+	unsigned int bdp_flags =3D nowait ? BDP_ASYNC : 0;
=20
 	if (nowait)
 		ilock_flags |=3D BTRFS_ILOCK_TRY;
@@ -1756,6 +1757,10 @@ static noinline ssize_t btrfs_buffered_write(struc=
t kiocb *iocb,
=20
 		release_bytes =3D reserve_bytes;
 again:
+		ret =3D balance_dirty_pages_ratelimited_flags(inode->i_mapping, bdp_fl=
ags);
+		if (ret)
+			break;
+
 		/*
 		 * This is going to setup the pages array with the number of
 		 * pages we want, so we don't really need to worry about the
@@ -1860,8 +1865,6 @@ static noinline ssize_t btrfs_buffered_write(struct=
 kiocb *iocb,
=20
 		cond_resched();
=20
-		balance_dirty_pages_ratelimited(inode->i_mapping);
-
 		pos +=3D copied;
 		num_written +=3D copied;
 	}
--=20
2.30.2

