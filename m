Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53BC4B58F0
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356631AbiBNRok (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 12:44:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357208AbiBNRod (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 12:44:33 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995C165439
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:25 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ECHW45005573
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=sk+j4IRk3PfnWSQ2NA03xb7dzT85yytAB7SgmygMQh8=;
 b=C9br4Imcr4Dz9XV03g5RrEW09KpRTM6o2Zr61B94ak/fsklep4gEDdvz3Qsrr3t0dy92
 1ipwghG2/NZ9Y8ZmJu1geUHMy7bvZGWIMM3R5Q9D7DH5bGeOqBM7j6ctBJeNdPYaMe1q
 4e8w7J6r9gy3r52RqJYP+EiUqn6oOEXkKLg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7pxr25us-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:24 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 09:44:23 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A818AABBD0FD; Mon, 14 Feb 2022 09:44:09 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 05/14] fs: split off __alloc_page_buffers function
Date:   Mon, 14 Feb 2022 09:43:54 -0800
Message-ID: <20220214174403.4147994-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214174403.4147994-1-shr@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WUVzlBBRFFPqB01bs6vhRUmwzgNN4lsp
X-Proofpoint-GUID: WUVzlBBRFFPqB01bs6vhRUmwzgNN4lsp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 phishscore=0 impostorscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140105
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

This splits off the __alloc_page_buffers() function from the
alloc_page_buffers_function(). In addition it adds a gfp_t parameter, so
the caller can specify the allocation flags.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/buffer.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6e6a69a12eed..a1986f95a39a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -802,26 +802,13 @@ int remove_inode_buffers(struct inode *inode)
 	return ret;
 }
=20
-/*
- * Create the appropriate buffers when given a page for data area and
- * the size of each buffer.. Use the bh->b_this_page linked list to
- * follow the buffers created.  Return NULL if unable to create more
- * buffers.
- *
- * The retry flag is used to differentiate async IO (paging, swapping)
- * which may not fail from ordinary buffer allocations.
- */
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long =
size,
-		bool retry)
+struct buffer_head *__alloc_page_buffers(struct page *page, unsigned lon=
g size,
+		gfp_t gfp)
 {
 	struct buffer_head *bh, *head;
-	gfp_t gfp =3D GFP_NOFS | __GFP_ACCOUNT;
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
=20
-	if (retry)
-		gfp |=3D __GFP_NOFAIL;
-
 	/* The page lock pins the memcg */
 	memcg =3D page_memcg(page);
 	old_memcg =3D set_active_memcg(memcg);
@@ -859,6 +846,26 @@ struct buffer_head *alloc_page_buffers(struct page *=
page, unsigned long size,
=20
 	goto out;
 }
+
+/*
+ * Create the appropriate buffers when given a page for data area and
+ * the size of each buffer.. Use the bh->b_this_page linked list to
+ * follow the buffers created.  Return NULL if unable to create more
+ * buffers.
+ *
+ * The retry flag is used to differentiate async IO (paging, swapping)
+ * which may not fail from ordinary buffer allocations.
+ */
+struct buffer_head *alloc_page_buffers(struct page *page, unsigned long =
size,
+		bool retry)
+{
+	gfp_t gfp =3D GFP_NOFS | __GFP_ACCOUNT;
+
+	if (retry)
+		gfp |=3D __GFP_NOFAIL;
+
+	return __alloc_page_buffers(page, size, gfp);
+}
 EXPORT_SYMBOL_GPL(alloc_page_buffers);
=20
 static inline void
--=20
2.30.2

