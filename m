Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9265105B3
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353140AbiDZRrM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351089AbiDZRrJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A9E1816A7
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:00 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQQ5v025142
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DMxeTOpqCEe+Tvocr/V6khKpI6cObsPyGo88EBQxCYQ=;
 b=hvlnd3V4HxFmkkcQbSVhcchro7WsRr2JGxiXSvC12JY3o1rd7//BSGTbNGUQTF6Zg/46
 mvgoZRKQ0zk3SUCQIolBP97y6khT+veGVL/lj45fYc8frK319E8kwfUa4lXUmXQvtkNM
 yKU470QMOHMfx/Tgj8JYARRMcMVXzBA1C0Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fpbk8bt8a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:00 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:43:59 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 87F30E2D485B; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 04/18] iomap: use iomap_page_create_gfp() in __iomap_write_begin
Date:   Tue, 26 Apr 2022 10:43:21 -0700
Message-ID: <20220426174335.4004987-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2cr9dVMdj6anOKJA6KUF7dO5hNmLX-Jz
X-Proofpoint-GUID: 2cr9dVMdj6anOKJA6KUF7dO5hNmLX-Jz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

