Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D031534690
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 00:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344836AbiEYWfU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 18:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344619AbiEYWev (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 18:34:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17E2FD10
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:34:49 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGtdh7009907
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:34:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zeIBIRPPCGXDuSo1H7/8XUmuyxFIlVdisrj7fMF8Y4s=;
 b=nLg4hrXstjAIFJ2E0axlmr0ufRW7VwNFXhqg6CYVpbaTNemiLCczqSlcgUt6/wz3+NXf
 YotKU2rjvhou5KTDw8552veHCm/faiiGrz3CANiqRzfRCp2fDJr9DZSyujmJYlZSJAg9
 qSW4qeXZWf0IdsMrTJes2aZCS1WFxLqC1aw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93tvseh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 15:34:48 -0700
Received: from twshared10276.08.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 25 May 2022 15:34:46 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 03BE1F9E1B4E; Wed, 25 May 2022 15:34:35 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v5 04/16] iomap: Add flags parameter to iomap_page_create()
Date:   Wed, 25 May 2022 15:34:20 -0700
Message-ID: <20220525223432.205676-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220525223432.205676-1-shr@fb.com>
References: <20220525223432.205676-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: aECTbpVfJDsMLEg804hGaZro8QXa45Ee
X-Proofpoint-ORIG-GUID: aECTbpVfJDsMLEg804hGaZro8QXa45Ee
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

Add the kiocb flags parameter to the function iomap_page_create().
Depending on the value of the flags parameter it enables different gfp
flags.

No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8ce8720093b9..8ef77f7287aa 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -44,16 +44,21 @@ static inline struct iomap_page *to_iomap_page(struct=
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
+	gfp_t gfp =3D GFP_NOFS | __GFP_NOFAIL;
=20
 	if (iop || nr_blocks <=3D 1)
 		return iop;
=20
+	if (flags & IOMAP_NOWAIT)
+		gfp =3D GFP_NOWAIT;
+
 	iop =3D kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
-			GFP_NOFS | __GFP_NOFAIL);
+		      gfp);
+
 	spin_lock_init(&iop->uptodate_lock);
 	if (folio_test_uptodate(folio))
 		bitmap_fill(iop->uptodate, nr_blocks);
@@ -226,7 +231,7 @@ static int iomap_read_inline_data(const struct iomap_=
iter *iter,
 	if (WARN_ON_ONCE(size > iomap->length))
 		return -EIO;
 	if (offset > 0)
-		iop =3D iomap_page_create(iter->inode, folio);
+		iop =3D iomap_page_create(iter->inode, folio, 0);
 	else
 		iop =3D to_iomap_page(folio);
=20
@@ -264,7 +269,7 @@ static loff_t iomap_readpage_iter(const struct iomap_=
iter *iter,
 		return iomap_read_inline_data(iter, folio);
=20
 	/* zero post-eof blocks as the page may be mapped */
-	iop =3D iomap_page_create(iter->inode, folio);
+	iop =3D iomap_page_create(iter->inode, folio, 0);
 	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen)=
;
 	if (plen =3D=3D 0)
 		goto done;
@@ -550,7 +555,7 @@ static int __iomap_write_begin(const struct iomap_ite=
r *iter, loff_t pos,
 		size_t len, struct folio *folio)
 {
 	const struct iomap *srcmap =3D iomap_iter_srcmap(iter);
-	struct iomap_page *iop =3D iomap_page_create(iter->inode, folio);
+	struct iomap_page *iop;
 	loff_t block_size =3D i_blocksize(iter->inode);
 	loff_t block_start =3D round_down(pos, block_size);
 	loff_t block_end =3D round_up(pos + len, block_size);
@@ -561,6 +566,8 @@ static int __iomap_write_begin(const struct iomap_ite=
r *iter, loff_t pos,
 		return 0;
 	folio_clear_error(folio);
=20
+	iop =3D iomap_page_create(iter->inode, folio, iter->flags);
+
 	do {
 		iomap_adjust_read_range(iter->inode, folio, &block_start,
 				block_end - block_start, &poff, &plen);
@@ -1332,7 +1339,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc=
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

