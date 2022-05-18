Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0CB52C7A5
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiERXh1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiERXh0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:37:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0EF5DE74
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:24 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6DAs013732
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=uMreEmlHFQs4cRQDPSVDEcfGskyeRmQunpQrHflgGXo=;
 b=iYcBMOyFLuURxDuGeLOefXRBk8whxBhvRgkMKIVzhTvR2aIuPuOr2g+gN04wQj25y2Dt
 AzCirHN5PNGT7w7yoMyl3AbRmWumnFWLyb764q8bjcLfd5x5xShOJDmjnMHfvxGCWVF5
 2wCQ65fuXvW1QYiutCHg76MQK3Flam/T9oU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4d823xh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:24 -0700
Received: from twshared10276.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 18 May 2022 16:37:23 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id B9B54F3ED859; Wed, 18 May 2022 16:37:12 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v3 04/18] iomap: Add async buffered write support
Date:   Wed, 18 May 2022 16:36:55 -0700
Message-ID: <20220518233709.1937634-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518233709.1937634-1-shr@fb.com>
References: <20220518233709.1937634-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: htQehZB0UY8WZYhxgjmqhUOhnxZfeu77
X-Proofpoint-ORIG-GUID: htQehZB0UY8WZYhxgjmqhUOhnxZfeu77
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds async buffered write support to iomap. The support is focused
on the changes necessary to support XFS with iomap.

Support for other filesystems might require additional changes.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6b06fd358958..b029e2b10e07 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -580,12 +580,18 @@ static int __iomap_write_begin(const struct iomap_i=
ter *iter, loff_t pos,
 	size_t from =3D offset_in_folio(folio, pos), to =3D from + len;
 	size_t poff, plen;
 	gfp_t  gfp =3D GFP_NOFS | __GFP_NOFAIL;
+	bool no_wait =3D (iter->flags & IOMAP_NOWAIT);
+
+	if (no_wait)
+		gfp =3D GFP_NOWAIT;
=20
 	if (folio_test_uptodate(folio))
 		return 0;
 	folio_clear_error(folio);
=20
 	iop =3D iomap_page_create_gfp(iter->inode, folio, nr_blocks, gfp);
+	if (no_wait && !iop)
+		return -EAGAIN;
=20
 	do {
 		iomap_adjust_read_range(iter->inode, folio, &block_start,
@@ -602,6 +608,8 @@ static int __iomap_write_begin(const struct iomap_ite=
r *iter, loff_t pos,
 			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
 				return -EIO;
 			folio_zero_segments(folio, poff, from, to, poff + plen);
+		} else if (no_wait) {
+			return -EAGAIN;
 		} else {
 			int status =3D iomap_read_folio_sync(block_start, folio,
 					poff, plen, srcmap);
@@ -632,6 +640,9 @@ static int iomap_write_begin(const struct iomap_iter =
*iter, loff_t pos,
 	unsigned fgp =3D FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE | FGP_NO=
FS;
 	int status =3D 0;
=20
+	if (iter->flags & IOMAP_NOWAIT)
+		fgp |=3D FGP_NOWAIT;
+
 	BUG_ON(pos + len > iter->iomap.offset + iter->iomap.length);
 	if (srcmap !=3D &iter->iomap)
 		BUG_ON(pos + len > srcmap->offset + srcmap->length);
@@ -789,6 +800,10 @@ static loff_t iomap_write_iter(struct iomap_iter *it=
er, struct iov_iter *i)
 		 * Otherwise there's a nasty deadlock on copying from the
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
+		 *
+		 * For async buffered writes the assumption is that the user
+		 * page has already been faulted in. This can be optimized by
+		 * faulting the user page in the prepare phase of io-uring.
 		 */
 		if (unlikely(fault_in_iov_iter_readable(i, bytes) =3D=3D bytes)) {
 			status =3D -EFAULT;
@@ -844,6 +859,9 @@ iomap_file_buffered_write(struct kiocb *iocb, struct =
iov_iter *i,
 	};
 	int ret;
=20
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		iter.flags |=3D IOMAP_NOWAIT;
+
 	while ((ret =3D iomap_iter(&iter, ops)) > 0)
 		iter.processed =3D iomap_write_iter(&iter, i);
 	if (iter.pos =3D=3D iocb->ki_pos)
--=20
2.30.2

