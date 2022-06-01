Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D71D53AECF
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 00:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiFAVB5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 17:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiFAVBz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 17:01:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894AC34B9C
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 14:01:54 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251INehb008370
        for <io-uring@vger.kernel.org>; Wed, 1 Jun 2022 14:01:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5yh7bJ43zWawOb4heVTpXC/CGgCWptHJL+luNQUKZk8=;
 b=Hb4u4VI4+HqIbREptSYISF37ee5WH7G2UhrsgYnaVn9M1VbVf/3oPo+9LG/Hg53XsDHf
 OFvif8yn9lOYgJsl+13VXhC8j5A5d474Z+JGYTbn+6uvCMHtVn6oPWbXoT/+ZPle1hcl
 nkXri9gI21BytzWLmgZmB4g6aIUJnXNYuXo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ge5vcm8yc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 14:01:54 -0700
Received: from twshared10560.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 14:01:52 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id D5A49FEB23A1; Wed,  1 Jun 2022 14:01:42 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>
Subject: [PATCH v7 06/15] iomap: Return error code from iomap_write_iter()
Date:   Wed, 1 Jun 2022 14:01:32 -0700
Message-ID: <20220601210141.3773402-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220601210141.3773402-1-shr@fb.com>
References: <20220601210141.3773402-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: -W4vK19ln1_hODJ-bJJL43Hqq16Bfjau
X-Proofpoint-ORIG-GUID: -W4vK19ln1_hODJ-bJJL43Hqq16Bfjau
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_08,2022-06-01_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Change the signature of iomap_write_iter() to return an error code. In
case we cannot allocate a page in iomap_write_begin(), we will not retry
the memory alloction in iomap_write_begin().

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index b06a5c24a4db..e96ab9a3072c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -754,12 +754,13 @@ static size_t iomap_write_end(struct iomap_iter *it=
er, loff_t pos, size_t len,
 	return ret;
 }
=20
-static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter =
*i)
+static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,=
 loff_t *processed)
 {
 	loff_t length =3D iomap_length(iter);
 	loff_t pos =3D iter->pos;
 	ssize_t written =3D 0;
 	long status =3D 0;
+	int error =3D 0;
 	struct address_space *mapping =3D iter->inode->i_mapping;
 	unsigned int bdp_flags =3D (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0=
;
=20
@@ -774,9 +775,9 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 		bytes =3D min_t(unsigned long, PAGE_SIZE - offset,
 						iov_iter_count(i));
 again:
-		status =3D balance_dirty_pages_ratelimited_flags(mapping,
+		error =3D balance_dirty_pages_ratelimited_flags(mapping,
 							       bdp_flags);
-		if (unlikely(status))
+		if (unlikely(error))
 			break;
=20
 		if (bytes > length)
@@ -793,12 +794,12 @@ static loff_t iomap_write_iter(struct iomap_iter *i=
ter, struct iov_iter *i)
 		 * faulting the user page.
 		 */
 		if (unlikely(fault_in_iov_iter_readable(i, bytes) =3D=3D bytes)) {
-			status =3D -EFAULT;
+			error =3D -EFAULT;
 			break;
 		}
=20
-		status =3D iomap_write_begin(iter, pos, bytes, &folio);
-		if (unlikely(status))
+		error =3D iomap_write_begin(iter, pos, bytes, &folio);
+		if (unlikely(error))
 			break;
=20
 		page =3D folio_file_page(folio, pos >> PAGE_SHIFT);
@@ -829,7 +830,8 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 		length -=3D status;
 	} while (iov_iter_count(i) && length);
=20
-	return written ? written : status;
+	*processed =3D written ? written : error;
+	return error;
 }
=20
 ssize_t
@@ -843,12 +845,15 @@ iomap_file_buffered_write(struct kiocb *iocb, struc=
t iov_iter *i,
 		.flags		=3D IOMAP_WRITE,
 	};
 	int ret;
+	int error =3D 0;
=20
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iter.flags |=3D IOMAP_NOWAIT;
=20
-	while ((ret =3D iomap_iter(&iter, ops)) > 0)
-		iter.processed =3D iomap_write_iter(&iter, i);
+	while ((ret =3D iomap_iter(&iter, ops)) > 0) {
+		if (error !=3D -EAGAIN)
+			error =3D iomap_write_iter(&iter, i, &iter.processed);
+	}
 	if (iter.pos =3D=3D iocb->ki_pos)
 		return ret;
 	return iter.pos - iocb->ki_pos;
--=20
2.30.2

