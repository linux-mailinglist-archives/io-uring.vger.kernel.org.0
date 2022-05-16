Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61F4528AE0
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343845AbiEPQsr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiEPQsi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:48:38 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70B73C71E
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:36 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GGHCD9006198
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5kC+EaG8kC1NKMRTCYxqHhGLne8jSvz8PgxcvPIUop4=;
 b=NNrDPrekHFh8/hRBV4DG1HSO6+lYTlDlJTwP4RIGFFPSb1ymrGdMORfZamumZy2sTlyB
 Yebt9pO66VbOEaR5lEromYd34UgkpVJ7NcGAJnVFGAFXzDX6KFB7NbYjiafECG9a7a91
 jiti1tPvMGPOwBXZSO2pqAiTo5Ta+HZikME= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a8u2m99-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:35 -0700
Received: from twshared6696.05.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:34 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 423C4F146DD3; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 02/16] iomap: add iomap_page_create_gfp to allocate iomap_pages
Date:   Mon, 16 May 2022 09:47:04 -0700
Message-ID: <20220516164718.2419891-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220516164718.2419891-1-shr@fb.com>
References: <20220516164718.2419891-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gzr4CFm_5aDHtnqQYhbwpoAmcG6DR1m8
X-Proofpoint-GUID: gzr4CFm_5aDHtnqQYhbwpoAmcG6DR1m8
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

Add the function iomap_page_create_gfp() to be able to specify gfp flags
and to pass in the number of blocks per folio in the function
iomap_page_create_gfp().

No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8ce8720093b9..85aa32f50db0 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -43,17 +43,27 @@ static inline struct iomap_page *to_iomap_page(struct=
 folio *folio)
=20
 static struct bio_set iomap_ioend_bioset;
=20
+/**
+ * iomap_page_create_gfp : Create and initialize iomap_page for folio.
+ * @inode     : Pointer to inode
+ * @folio     : Pointer to folio
+ * @nr_blocks : Number of blocks in the folio
+ * @gfp       : gfp allocation flags
+ *
+ * This function returns a newly allocated iomap for the folio with the =
settings
+ * specified in the gfp parameter.
+ *
+ **/
 static struct iomap_page *
-iomap_page_create(struct inode *inode, struct folio *folio)
+iomap_page_create_gfp(struct inode *inode, struct folio *folio,
+		unsigned int nr_blocks, gfp_t gfp)
 {
-	struct iomap_page *iop =3D to_iomap_page(folio);
-	unsigned int nr_blocks =3D i_blocks_per_folio(inode, folio);
+	struct iomap_page *iop;
=20
-	if (iop || nr_blocks <=3D 1)
+	iop =3D kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)), g=
fp);
+	if (!iop)
 		return iop;
=20
-	iop =3D kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
-			GFP_NOFS | __GFP_NOFAIL);
 	spin_lock_init(&iop->uptodate_lock);
 	if (folio_test_uptodate(folio))
 		bitmap_fill(iop->uptodate, nr_blocks);
@@ -61,6 +71,18 @@ iomap_page_create(struct inode *inode, struct folio *f=
olio)
 	return iop;
 }
=20
+static struct iomap_page *
+iomap_page_create(struct inode *inode, struct folio *folio)
+{
+	struct iomap_page *iop =3D to_iomap_page(folio);
+	unsigned int nr_blocks =3D i_blocks_per_folio(inode, folio);
+
+	if (iop || nr_blocks <=3D 1)
+		return iop;
+
+	return iomap_page_create_gfp(inode, folio, nr_blocks, GFP_NOFS | __GFP_=
NOFAIL);
+}
+
 static void iomap_page_release(struct folio *folio)
 {
 	struct iomap_page *iop =3D folio_detach_private(folio);
--=20
2.30.2

