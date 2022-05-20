Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A0752F336
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352904AbiETShp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352966AbiETShi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:37:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB5019593E
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:36 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24KHSWR1022741
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wRT/wXmzHcgMsrcASISsv+kuIl+EmEXecNfLk2i1H+Q=;
 b=XZrWJQHbaazjv8esO8Kc/bK15skibCixwrQ7jpANZNLfbjUqwyCylvw4FH2ea8UKDX7J
 EhgVadqEQCPBd+S5SxZhF/mWIt8v7uAY48LtwCoSp0HDD1YnQ9zcb3/ltDtRiDzpm7YK
 nAs8YkoYA8YxIRYTEguvgDc6hhuDh9J++eE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g6bja2avx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:36 -0700
Received: from twshared35748.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:34 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 82E0DF5E5B2D; Fri, 20 May 2022 11:37:16 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [RFC PATCH v4 07/17] iomap: Use balance_dirty_pages_ratelimited_flags in iomap_write_iter
Date:   Fri, 20 May 2022 11:36:36 -0700
Message-ID: <20220520183646.2002023-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220520183646.2002023-1-shr@fb.com>
References: <20220520183646.2002023-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: KvSzHVL-qR2RWz5Fb9MTmhOBgwpz73we
X-Proofpoint-ORIG-GUID: KvSzHVL-qR2RWz5Fb9MTmhOBgwpz73we
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_05,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

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
---
 fs/iomap/buffered-io.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 187f4ddd7ba7..020452467ca8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -765,14 +765,22 @@ static loff_t iomap_write_iter(struct iomap_iter *i=
ter, struct iov_iter *i)
 	do {
 		struct folio *folio;
 		struct page *page;
+		struct address_space *mapping =3D iter->inode->i_mapping;
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
+		unsigned int bdp_flags =3D
+			(iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
=20
 		offset =3D offset_in_page(pos);
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
@@ -796,7 +804,7 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 			break;
=20
 		page =3D folio_file_page(folio, pos >> PAGE_SHIFT);
-		if (mapping_writably_mapped(iter->inode->i_mapping))
+		if (mapping_writably_mapped(mapping))
 			flush_dcache_page(page);
=20
 		copied =3D copy_page_from_iter_atomic(page, offset, bytes, i);
@@ -821,8 +829,6 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 		pos +=3D status;
 		written +=3D status;
 		length -=3D status;
-
-		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
 	} while (iov_iter_count(i) && length);
=20
 	return written ? written : status;
--=20
2.30.2

