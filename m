Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7ED752F32D
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352932AbiETShk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352917AbiETShe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:37:34 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76E0195BC6
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:32 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHT3WH021459
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UmuWfsTck1J0e+hUP+BRgFN3i31rkvMhPWWM66De5po=;
 b=Fxg1hdn/CqtmxweUdGOsNRiU7DFAaXTzRjI1M4RAEd2Vp57hnS4ri7TqqNAcFy0lbWgj
 fRo923G5w2r1JngxnY2VTxxpE25dPWty/ZMDajHlOrwx9t58fc0tqmMc84juGE5fyaLI
 ck9eRifFCIZSGjB9GhHkkWEm6hLfCw+Ka6k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5rgj8vge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:31 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:30 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 77671F5E5B29; Fri, 20 May 2022 11:37:16 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [RFC PATCH v4 05/17] iomap: Add gfp parameter to iomap_page_create()
Date:   Fri, 20 May 2022 11:36:34 -0700
Message-ID: <20220520183646.2002023-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220520183646.2002023-1-shr@fb.com>
References: <20220520183646.2002023-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: NE9fkcV9t4cXnE3NS3gj2etDF1sm6OL3
X-Proofpoint-ORIG-GUID: NE9fkcV9t4cXnE3NS3gj2etDF1sm6OL3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
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

Add the gfp flags parameter to the function iomap_page_create() to be
able to specify gfp flags.

No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8ce8720093b9..27e67bfc64f5 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -44,7 +44,7 @@ static inline struct iomap_page *to_iomap_page(struct f=
olio *folio)
 static struct bio_set iomap_ioend_bioset;
=20
 static struct iomap_page *
-iomap_page_create(struct inode *inode, struct folio *folio)
+iomap_page_create(struct inode *inode, struct folio *folio, gfp_t gfp)
 {
 	struct iomap_page *iop =3D to_iomap_page(folio);
 	unsigned int nr_blocks =3D i_blocks_per_folio(inode, folio);
@@ -52,8 +52,8 @@ iomap_page_create(struct inode *inode, struct folio *fo=
lio)
 	if (iop || nr_blocks <=3D 1)
 		return iop;
=20
-	iop =3D kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
-			GFP_NOFS | __GFP_NOFAIL);
+	iop =3D kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)), g=
fp);
+
 	spin_lock_init(&iop->uptodate_lock);
 	if (folio_test_uptodate(folio))
 		bitmap_fill(iop->uptodate, nr_blocks);
@@ -226,7 +226,8 @@ static int iomap_read_inline_data(const struct iomap_=
iter *iter,
 	if (WARN_ON_ONCE(size > iomap->length))
 		return -EIO;
 	if (offset > 0)
-		iop =3D iomap_page_create(iter->inode, folio);
+		iop =3D iomap_page_create(iter->inode, folio,
+					GFP_NOFS | __GFP_NOFAIL);
 	else
 		iop =3D to_iomap_page(folio);
=20
@@ -264,7 +265,7 @@ static loff_t iomap_readpage_iter(const struct iomap_=
iter *iter,
 		return iomap_read_inline_data(iter, folio);
=20
 	/* zero post-eof blocks as the page may be mapped */
-	iop =3D iomap_page_create(iter->inode, folio);
+	iop =3D iomap_page_create(iter->inode, folio, GFP_NOFS | __GFP_NOFAIL);
 	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen)=
;
 	if (plen =3D=3D 0)
 		goto done;
@@ -550,17 +551,20 @@ static int __iomap_write_begin(const struct iomap_i=
ter *iter, loff_t pos,
 		size_t len, struct folio *folio)
 {
 	const struct iomap *srcmap =3D iomap_iter_srcmap(iter);
-	struct iomap_page *iop =3D iomap_page_create(iter->inode, folio);
+	struct iomap_page *iop =3D to_iomap_page(folio);
 	loff_t block_size =3D i_blocksize(iter->inode);
 	loff_t block_start =3D round_down(pos, block_size);
 	loff_t block_end =3D round_up(pos + len, block_size);
 	size_t from =3D offset_in_folio(folio, pos), to =3D from + len;
 	size_t poff, plen;
+	gfp_t  gfp =3D GFP_NOFS | __GFP_NOFAIL;
=20
 	if (folio_test_uptodate(folio))
 		return 0;
 	folio_clear_error(folio);
=20
+	iop =3D iomap_page_create(iter->inode, folio, gfp);
+
 	do {
 		iomap_adjust_read_range(iter->inode, folio, &block_start,
 				block_end - block_start, &poff, &plen);
@@ -1332,7 +1336,8 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc=
,
 		struct writeback_control *wbc, struct inode *inode,
 		struct folio *folio, u64 end_pos)
 {
-	struct iomap_page *iop =3D iomap_page_create(inode, folio);
+	struct iomap_page *iop =3D iomap_page_create(inode, folio,
+						GFP_NOFS | __GFP_NOFAIL);
 	struct iomap_ioend *ioend, *next;
 	unsigned len =3D i_blocksize(inode);
 	unsigned nblocks =3D i_blocks_per_folio(inode, folio);
--=20
2.30.2

