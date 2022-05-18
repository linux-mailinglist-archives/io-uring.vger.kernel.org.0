Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F29D52C7B3
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiERXhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiERXhe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:37:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6265DE7D
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:32 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6El9011573
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=O34zXZfbu8NoYple9DJ1IAcETJnoAkNzVvAkSIEVGtY=;
 b=ojJZ+a0ZQOhMxn0kiS2yUb6+B26dN8juCZOUR9H9tYlByhl/k4vKBSEToffis5giSoRr
 A3dLX8mRyrgRZHummug5xN44xcgdj2s0BB2rntdytgScetDPTgf3iPRTqCWiuqbM7blC
 IfwuI7NoSZ99+TU9LGDRshfQ/ZHXZjXuWR0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4frtanp2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:32 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 18 May 2022 16:37:26 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id B3375F3ED857; Wed, 18 May 2022 16:37:12 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v3 03/18] iomap: Use iomap_page_create_gfp() in __iomap_write_begin
Date:   Wed, 18 May 2022 16:36:54 -0700
Message-ID: <20220518233709.1937634-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518233709.1937634-1-shr@fb.com>
References: <20220518233709.1937634-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: MEiaf79kzIvbaN1yLg7ZY4-sG1_Jv4ye
X-Proofpoint-ORIG-GUID: MEiaf79kzIvbaN1yLg7ZY4-sG1_Jv4ye
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

This change uses the new iomap_page_create_gfp() function in the
function __iomap_write_begin().

No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 85aa32f50db0..6b06fd358958 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -572,17 +572,21 @@ static int __iomap_write_begin(const struct iomap_i=
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
+	iop =3D iomap_page_create_gfp(iter->inode, folio, nr_blocks, gfp);
+
 	do {
 		iomap_adjust_read_range(iter->inode, folio, &block_start,
 				block_end - block_start, &poff, &plen);
--=20
2.30.2

