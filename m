Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292FC4BC0C2
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbiBRT6Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238476AbiBRT6Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:16 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D7931C
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:57:59 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IFr9RB026039
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:57:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zcQrDPv3eW71zY4XW+9wjHujhsnhMRVqCLVW8ftO+VU=;
 b=i4FhaxWqZyH/Ab7xkJHmk7gZe4IyVEm+3PD6IJxkX7L3/NE3PFbCD6b5o6nhTVWWPPcA
 fZ2YGHIHfALt9xRtcn7DyAliPHT8uNMjJ2UVazjCZt7/ZUFdle/ocSdsBwtCVh8U8y8j
 kBNq5fxHoxaLV9rYjet4oFQKYsdAm3W8HtA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea1mp5p21-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:57:58 -0800
Received: from twshared27297.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:57:58 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9C739AEB6605; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 04/13] fs: split off __alloc_page_buffers function
Date:   Fri, 18 Feb 2022 11:57:30 -0800
Message-ID: <20220218195739.585044-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: QGK8nnmb0IQGGQzVkDiCafP3hjES7XMT
X-Proofpoint-ORIG-GUID: QGK8nnmb0IQGGQzVkDiCafP3hjES7XMT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180122
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
index 6e6a69a12eed..2858eaf433c8 100644
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
+static struct buffer_head *__alloc_page_buffers(struct page *page,
+						unsigned long size, gfp_t gfp)
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

