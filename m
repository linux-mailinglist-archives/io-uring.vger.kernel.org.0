Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D488C5352AC
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 19:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348358AbiEZRj0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 13:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348317AbiEZRjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 13:39:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A631994FC
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:09 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QFmMf5023116
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ntJvO4MQhogPOoilzqoG3I60GXy7qXbkAEj7dOQp0G0=;
 b=Uo9rwFWxx74vwoGm589BbGSUgPnbumsx7jaoN3fiqMte3Cj9NVoR1EHVHdrUDEXyAvFs
 tO3WpjrKDcAfsVDJwmwp1JJefwI28o1TmP67Kz7CCoIh2W6WOx1KDO74CrAi+aIm2k58
 52Tp0+iv/qKdMNjXzNqZr1CczUoJKIAw+vI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93upxw5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:08 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 26 May 2022 10:39:07 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 7AE70FA621D6; Thu, 26 May 2022 10:38:45 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v6 05/16] iomap: Add async buffered write support
Date:   Thu, 26 May 2022 10:38:29 -0700
Message-ID: <20220526173840.578265-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220526173840.578265-1-shr@fb.com>
References: <20220526173840.578265-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: lgHKZE1CFTvMqeVzWkdUMc7c_sV_bC4n
X-Proofpoint-GUID: lgHKZE1CFTvMqeVzWkdUMc7c_sV_bC4n
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

This adds async buffered write support to iomap.

This replaces the call to balance_dirty_pages_ratelimited() with the
call to balance_dirty_pages_ratelimited_flags. This allows to specify if
the write request is async or not.

In addition this also moves the above function call to the beginning of
the function. If the function call is at the end of the function and the
decision is made to throttle writes, then there is no request that
io-uring can wait on. By moving it to the beginning of the function, the
write request is not issued, but returns -EAGAIN instead. io-uring will
punt the request and process it in the io-worker.

By moving the function call to the beginning of the function, the write
throttling will happen one page later.

Signed-off-by: Stefan Roesch <shr@fb.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/iomap/buffered-io.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d6ddc54e190e..2281667646d2 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -559,6 +559,7 @@ static int __iomap_write_begin(const struct iomap_ite=
r *iter, loff_t pos,
 	loff_t block_size =3D i_blocksize(iter->inode);
 	loff_t block_start =3D round_down(pos, block_size);
 	loff_t block_end =3D round_up(pos + len, block_size);
+	unsigned int nr_blocks =3D i_blocks_per_folio(iter->inode, folio);
 	size_t from =3D offset_in_folio(folio, pos), to =3D from + len;
 	size_t poff, plen;
=20
@@ -567,6 +568,8 @@ static int __iomap_write_begin(const struct iomap_ite=
r *iter, loff_t pos,
 	folio_clear_error(folio);
=20
 	iop =3D iomap_page_create(iter->inode, folio, iter->flags);
+	if ((iter->flags & IOMAP_NOWAIT) && !iop && nr_blocks > 1)
+		return -EAGAIN;
=20
 	do {
 		iomap_adjust_read_range(iter->inode, folio, &block_start,
@@ -584,7 +587,12 @@ static int __iomap_write_begin(const struct iomap_it=
er *iter, loff_t pos,
 				return -EIO;
 			folio_zero_segments(folio, poff, from, to, poff + plen);
 		} else {
-			int status =3D iomap_read_folio_sync(block_start, folio,
+			int status;
+
+			if (iter->flags & IOMAP_NOWAIT)
+				return -EAGAIN;
+
+			status =3D iomap_read_folio_sync(block_start, folio,
 					poff, plen, srcmap);
 			if (status)
 				return status;
@@ -613,6 +621,9 @@ static int iomap_write_begin(const struct iomap_iter =
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
@@ -750,6 +761,8 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 	loff_t pos =3D iter->pos;
 	ssize_t written =3D 0;
 	long status =3D 0;
+	struct address_space *mapping =3D iter->inode->i_mapping;
+	unsigned int bdp_flags =3D (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0=
;
=20
 	do {
 		struct folio *folio;
@@ -762,6 +775,11 @@ static loff_t iomap_write_iter(struct iomap_iter *it=
er, struct iov_iter *i)
 		bytes =3D min_t(unsigned long, PAGE_SIZE - offset,
 						iov_iter_count(i));
 again:
+		status =3D balance_dirty_pages_ratelimited_flags(mapping,
+							       bdp_flags);
+		if (unlikely(status))
+			break;
+
 		if (bytes > length)
 			bytes =3D length;
=20
@@ -770,6 +788,10 @@ static loff_t iomap_write_iter(struct iomap_iter *it=
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
@@ -781,7 +803,7 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 			break;
=20
 		page =3D folio_file_page(folio, pos >> PAGE_SHIFT);
-		if (mapping_writably_mapped(iter->inode->i_mapping))
+		if (mapping_writably_mapped(mapping))
 			flush_dcache_page(page);
=20
 		copied =3D copy_page_from_iter_atomic(page, offset, bytes, i);
@@ -806,8 +828,6 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 		pos +=3D status;
 		written +=3D status;
 		length -=3D status;
-
-		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
 	} while (iov_iter_count(i) && length);
=20
 	return written ? written : status;
@@ -825,6 +845,9 @@ iomap_file_buffered_write(struct kiocb *iocb, struct =
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

