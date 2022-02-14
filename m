Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A9D4B58E0
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 18:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357220AbiBNRoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 12:44:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357204AbiBNRoj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 12:44:39 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC3C65491
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:29 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21ECOxnl014219
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DK6Utv099ANrtOcaZ7fZtH5NvGZGKQSxBl8g8H8/nic=;
 b=lO4JWKs1kVRnRt6nmQ00sdvMxMDt6vsU1frFegMQiLpP2gjP/39Kfx8yrvg+iDUwYW+c
 V3rwV7LfRJSPV2rbtB2LeXcR4PsTKpLT4gTycdM+QX8fA7ejdaiiK/c3B+WU1q+Y4Kmj
 93DZkuvtTlEUsw6AgvGHWloXlCsMkrzNaI8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e7q2ea44k-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:28 -0800
Received: from twshared14630.35.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 09:44:26 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id B44B6ABBD101; Mon, 14 Feb 2022 09:44:09 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 07/14] fs: Add aop_flags parameter to create_page_buffers()
Date:   Mon, 14 Feb 2022 09:43:56 -0800
Message-ID: <20220214174403.4147994-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214174403.4147994-1-shr@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fRo_M8ON4pQTqvinuAPCqtGt7mwNW32f
X-Proofpoint-ORIG-GUID: fRo_M8ON4pQTqvinuAPCqtGt7mwNW32f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=938 phishscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202140105
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the aop_flags parameter to the create_page_buffers function.
When AOP_FLAGS_NOWAIT parameter is set, the atomic allocation flag is
set. The AOP_FLAGS_NOWAIT flag is set, when async buffered writes are
enabled.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/buffer.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 948505480b43..5e3067173580 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1682,13 +1682,27 @@ static inline int block_size_bits(unsigned int bl=
ocksize)
 	return ilog2(blocksize);
 }
=20
-static struct buffer_head *create_page_buffers(struct page *page, struct=
 inode *inode, unsigned int b_state)
+static struct buffer_head *create_page_buffers(struct page *page,
+					struct inode *inode,
+					unsigned int b_state,
+					unsigned int aop_flags)
 {
 	BUG_ON(!PageLocked(page));
=20
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
-				     b_state);
+	if (!page_has_buffers(page)) {
+		gfp_t gfp =3D GFP_NOFS | __GFP_ACCOUNT;
+
+		if (aop_flags & AOP_FLAGS_NOWAIT) {
+			gfp |=3D GFP_ATOMIC | __GFP_NOWARN;
+			gfp &=3D ~__GFP_DIRECT_RECLAIM;
+		} else {
+			gfp |=3D __GFP_NOFAIL;
+		}
+
+		__create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
+				     b_state, gfp);
+	}
+
 	return page_buffers(page);
 }
=20
@@ -1734,7 +1748,7 @@ int __block_write_full_page(struct inode *inode, st=
ruct page *page,
 	int write_flags =3D wbc_to_write_flags(wbc);
=20
 	head =3D create_page_buffers(page, inode,
-					(1 << BH_Dirty)|(1 << BH_Uptodate));
+					(1 << BH_Dirty)|(1 << BH_Uptodate), 0);
=20
 	/*
 	 * Be very careful.  We have no exclusion from __set_page_dirty_buffers
@@ -2000,7 +2014,7 @@ int __block_write_begin_int(struct folio *folio, lo=
ff_t pos, unsigned len,
 	BUG_ON(to > PAGE_SIZE);
 	BUG_ON(from > to);
=20
-	head =3D create_page_buffers(&folio->page, inode, 0);
+	head =3D create_page_buffers(&folio->page, inode, 0, flags);
 	blocksize =3D head->b_size;
 	bbits =3D block_size_bits(blocksize);
=20
@@ -2280,7 +2294,7 @@ int block_read_full_page(struct page *page, get_blo=
ck_t *get_block)
 	int nr, i;
 	int fully_mapped =3D 1;
=20
-	head =3D create_page_buffers(page, inode, 0);
+	head =3D create_page_buffers(page, inode, 0, 0);
 	blocksize =3D head->b_size;
 	bbits =3D block_size_bits(blocksize);
=20
--=20
2.30.2

