Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF1543A59
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 19:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiFHR10 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 13:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiFHR0L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 13:26:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C69424A5
        for <io-uring@vger.kernel.org>; Wed,  8 Jun 2022 10:23:53 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258FPbaT016452
        for <io-uring@vger.kernel.org>; Wed, 8 Jun 2022 10:23:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=OxGRfMeRdzuX13wDzkrc1rbWs0f6kgZ2LAt/+Vz+aFQ=;
 b=dxEgnMyge/VCtzxTORn+/gpgUZTwhLwA7WWQ8th82dbU9iUNrXK00LIv1gFhX/TK7jmI
 i2sVenxxHE3pE+OVnUH6cK+eeVTfmEbusSLu9IwPQ93A8VY98ClSEVh8Oap/mszmyuqj
 LkH2ZGiioBmsvHRKndSAk2KrvmX9ECC5EJ8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gj13ctxsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 08 Jun 2022 10:23:53 -0700
Received: from twshared18317.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 8 Jun 2022 10:23:51 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 99099103BFB5A; Wed,  8 Jun 2022 10:17:43 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v8 04/14] iomap: Add flags parameter to iomap_page_create()
Date:   Wed, 8 Jun 2022 10:17:31 -0700
Message-ID: <20220608171741.3875418-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608171741.3875418-1-shr@fb.com>
References: <20220608171741.3875418-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 4UH9eEUW6rDSWQ5v28zf9pp8VfBXLZzZ
X-Proofpoint-ORIG-GUID: 4UH9eEUW6rDSWQ5v28zf9pp8VfBXLZzZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add the kiocb flags parameter to the function iomap_page_create().
Depending on the value of the flags parameter it enables different gfp
flags.

No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d2a9f699e17e..705f80cd2d4e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -44,16 +44,23 @@ static inline struct iomap_page *to_iomap_page(struct=
 folio *folio)
 static struct bio_set iomap_ioend_bioset;
=20
 static struct iomap_page *
-iomap_page_create(struct inode *inode, struct folio *folio)
+iomap_page_create(struct inode *inode, struct folio *folio, unsigned int=
 flags)
 {
 	struct iomap_page *iop =3D to_iomap_page(folio);
 	unsigned int nr_blocks =3D i_blocks_per_folio(inode, folio);
+	gfp_t gfp;
=20
 	if (iop || nr_blocks <=3D 1)
 		return iop;
=20
+	if (flags & IOMAP_NOWAIT)
+		gfp =3D GFP_NOWAIT;
+	else
+		gfp =3D GFP_NOFS | __GFP_NOFAIL;
+
 	iop =3D kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
-			GFP_NOFS | __GFP_NOFAIL);
+		      gfp);
+
 	spin_lock_init(&iop->uptodate_lock);
 	if (folio_test_uptodate(folio))
 		bitmap_fill(iop->uptodate, nr_blocks);
@@ -226,7 +233,7 @@ static int iomap_read_inline_data(const struct iomap_=
iter *iter,
 	if (WARN_ON_ONCE(size > iomap->length))
 		return -EIO;
 	if (offset > 0)
-		iop =3D iomap_page_create(iter->inode, folio);
+		iop =3D iomap_page_create(iter->inode, folio, iter->flags);
 	else
 		iop =3D to_iomap_page(folio);
=20
@@ -264,7 +271,7 @@ static loff_t iomap_readpage_iter(const struct iomap_=
iter *iter,
 		return iomap_read_inline_data(iter, folio);
=20
 	/* zero post-eof blocks as the page may be mapped */
-	iop =3D iomap_page_create(iter->inode, folio);
+	iop =3D iomap_page_create(iter->inode, folio, iter->flags);
 	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen)=
;
 	if (plen =3D=3D 0)
 		goto done;
@@ -547,7 +554,7 @@ static int __iomap_write_begin(const struct iomap_ite=
r *iter, loff_t pos,
 		size_t len, struct folio *folio)
 {
 	const struct iomap *srcmap =3D iomap_iter_srcmap(iter);
-	struct iomap_page *iop =3D iomap_page_create(iter->inode, folio);
+	struct iomap_page *iop;
 	loff_t block_size =3D i_blocksize(iter->inode);
 	loff_t block_start =3D round_down(pos, block_size);
 	loff_t block_end =3D round_up(pos + len, block_size);
@@ -558,6 +565,8 @@ static int __iomap_write_begin(const struct iomap_ite=
r *iter, loff_t pos,
 		return 0;
 	folio_clear_error(folio);
=20
+	iop =3D iomap_page_create(iter->inode, folio, iter->flags);
+
 	do {
 		iomap_adjust_read_range(iter->inode, folio, &block_start,
 				block_end - block_start, &poff, &plen);
@@ -1329,7 +1338,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc=
,
 		struct writeback_control *wbc, struct inode *inode,
 		struct folio *folio, u64 end_pos)
 {
-	struct iomap_page *iop =3D iomap_page_create(inode, folio);
+	struct iomap_page *iop =3D iomap_page_create(inode, folio, 0);
 	struct iomap_ioend *ioend, *next;
 	unsigned len =3D i_blocksize(inode);
 	unsigned nblocks =3D i_blocks_per_folio(inode, folio);
--=20
2.30.2

