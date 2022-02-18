Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE91A4BC0E3
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239462AbiBRT7E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:59:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239151AbiBRT6s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:48 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B5729820
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:17 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IJk6eZ030224
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ds6aA0r8D5r2Fq6gKB5PCnyOU1VkJi+nNKZbhqDyrxA=;
 b=hNNIwQB8nqPM9vIuH9rKO13Bf8txFeYzGlg4Z6qpjl6rl4W0QnbGG1orYTnDtGpNtUo+
 M/GDknoxNHaWUb3DBUHe6p5m1iR70VKVZm3uzWEWUGAoi0dEt84Yi/HdIaKpa+nP7Xzl
 JUDox+8V9NfwlalGW8cw9QwiUgHEfu2mhJw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea9dm3m4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:17 -0800
Received: from twshared27297.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:16 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A97B7AEB6609; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 06/13] fs: Add gfp_t parameter to create_page_buffers()
Date:   Fri, 18 Feb 2022 11:57:32 -0800
Message-ID: <20220218195739.585044-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: dLpUXTXe9bb3dj09-AKtHCfuOd83rJby
X-Proofpoint-ORIG-GUID: dLpUXTXe9bb3dj09-AKtHCfuOd83rJby
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 mlxlogscore=950 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202180122
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the gfp_t parameter to the create_page_buffers function.
This allows the caller to specify the required parameters.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/buffer.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 648e1cba6da3..ae588ae4b1c1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1682,13 +1682,20 @@ static inline int block_size_bits(unsigned int bl=
ocksize)
 	return ilog2(blocksize);
 }
=20
-static struct buffer_head *create_page_buffers(struct page *page, struct=
 inode *inode, unsigned int b_state)
+static struct buffer_head *create_page_buffers(struct page *page,
+					struct inode *inode,
+					unsigned int b_state,
+					gfp_t flags)
 {
 	BUG_ON(!PageLocked(page));
=20
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
-				     b_state);
+	if (!page_has_buffers(page)) {
+		gfp_t gfp =3D GFP_NOFS | __GFP_ACCOUNT | flags;
+
+		__create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
+				     b_state, gfp);
+	}
+
 	return page_buffers(page);
 }
=20
@@ -1734,7 +1741,7 @@ int __block_write_full_page(struct inode *inode, st=
ruct page *page,
 	int write_flags =3D wbc_to_write_flags(wbc);
=20
 	head =3D create_page_buffers(page, inode,
-					(1 << BH_Dirty)|(1 << BH_Uptodate));
+					(1 << BH_Dirty)|(1 << BH_Uptodate), __GFP_NOFAIL);
=20
 	/*
 	 * Be very careful.  We have no exclusion from __set_page_dirty_buffers
@@ -2000,7 +2007,7 @@ int __block_write_begin_int(struct folio *folio, lo=
ff_t pos, unsigned len,
 	BUG_ON(to > PAGE_SIZE);
 	BUG_ON(from > to);
=20
-	head =3D create_page_buffers(&folio->page, inode, 0);
+	head =3D create_page_buffers(&folio->page, inode, 0, flags);
 	blocksize =3D head->b_size;
 	bbits =3D block_size_bits(blocksize);
=20
@@ -2127,12 +2134,17 @@ int block_write_begin(struct address_space *mappi=
ng, loff_t pos, unsigned len,
 	pgoff_t index =3D pos >> PAGE_SHIFT;
 	struct page *page;
 	int status;
+	gfp_t gfp =3D 0;
+	bool no_wait =3D (flags & AOP_FLAG_NOWAIT);
+
+	if (no_wait)
+		gfp =3D GFP_ATOMIC | __GFP_NOWARN;
=20
 	page =3D grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
=20
-	status =3D __block_write_begin_int(page_folio(page), pos, len, get_bloc=
k, NULL, flags);
+	status =3D __block_write_begin_int(page_folio(page), pos, len, get_bloc=
k, NULL, gfp);
 	if (unlikely(status)) {
 		unlock_page(page);
 		put_page(page);
@@ -2280,7 +2292,7 @@ int block_read_full_page(struct page *page, get_blo=
ck_t *get_block)
 	int nr, i;
 	int fully_mapped =3D 1;
=20
-	head =3D create_page_buffers(page, inode, 0);
+	head =3D create_page_buffers(page, inode, 0, __GFP_NOFAIL);
 	blocksize =3D head->b_size;
 	bbits =3D block_size_bits(blocksize);
=20
--=20
2.30.2

