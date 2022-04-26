Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D72D5105A3
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiDZRq7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238343AbiDZRq6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:46:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20CA1816E7
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:49 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQeK3017060
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5kC+EaG8kC1NKMRTCYxqHhGLne8jSvz8PgxcvPIUop4=;
 b=iyirba4hRWIPkhSOLF7SjU7PUizOK0Hd/MOc4d5C4ZWbYlqqd8bOrW6URG7DpEa6Q9DT
 O85UVe0gM1yWHgnzNBwZtCJvzgSL0nIS/8xkcKAOKdo7lpg/T/kznI5jhGAL3xIHhXW0
 6+a+OQp4XOtRGET0UR6/oP01yhTXbc68Y1c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fp6a8d4jv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:49 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:43:48 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 815E2E2D4859; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 03/18] iomap: add iomap_page_create_gfp to allocate iomap_pages
Date:   Tue, 26 Apr 2022 10:43:20 -0700
Message-ID: <20220426174335.4004987-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Jn6GHEVFyJ_acD2zVXmF3xSpuj61hoaw
X-Proofpoint-ORIG-GUID: Jn6GHEVFyJ_acD2zVXmF3xSpuj61hoaw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

