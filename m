Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FDE528ADB
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343842AbiEPQso (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343780AbiEPQsh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:48:37 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F9A3C71C
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:36 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GFCt9Q032572
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DMxeTOpqCEe+Tvocr/V6khKpI6cObsPyGo88EBQxCYQ=;
 b=RpoCk+OMgk5qnqxR0wkNFB1Qmw37lZHA94WauSVkEYplpxcApNCtzDksIb9+kjQuH9Ys
 BiMRLp/xXvqL/QTqIrVIhURRfgj4OJPuVVgzCxkUV59DSEpBB+q+P8eMm9+RXYd9vo8E
 VC5Ze8DYVMdN4lTvFmK3NsK0pEe0gZRVNPA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a8u2m9j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:35 -0700
Received: from twshared10276.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:34 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 48B43F146DD5; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 03/16] iomap: use iomap_page_create_gfp() in __iomap_write_begin
Date:   Mon, 16 May 2022 09:47:05 -0700
Message-ID: <20220516164718.2419891-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220516164718.2419891-1-shr@fb.com>
References: <20220516164718.2419891-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: sA9SFWss_LwtsrjrWQJVB1mRHlqdyPLJ
X-Proofpoint-GUID: sA9SFWss_LwtsrjrWQJVB1mRHlqdyPLJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
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

This change uses the new iomap_page_create_gfp() function in the
function __iomap_write_begin().

No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 85aa32f50db0..1ffdc7078e7d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -572,17 +572,22 @@ static int __iomap_write_begin(const struct iomap_i=
ter *iter, loff_t pos,
 		size_t len, struct folio *folio)
 {
 	const struct iomap *srcmap =3D iomap_iter_srcmap(iter);
-	struct iomap_page *iop =3D iomap_page_create(iter->inode, folio);
+	struct iomap_page *iop =3D to_iomap_page(folio);
 	loff_t block_size =3D i_blocksize(iter->inode);
 	loff_t block_start =3D round_down(pos, block_size);
 	loff_t block_end =3D round_up(pos + len, block_size);
+	unsigned int nr_blocks =3D i_blocks_per_folio(iter->inode, folio);
 	size_t from =3D offset_in_folio(folio, pos), to =3D from + len;
 	size_t poff, plen;
+	gfp_t  gfp =3D GFP_NOFS | __GFP_NOFAIL;
=20
 	if (folio_test_uptodate(folio))
 		return 0;
 	folio_clear_error(folio);
=20
+	if (!iop && nr_blocks > 1)
+		iop =3D iomap_page_create_gfp(iter->inode, folio, nr_blocks, gfp);
+
 	do {
 		iomap_adjust_read_range(iter->inode, folio, &block_start,
 				block_end - block_start, &poff, &plen);
--=20
2.30.2

