Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFE64BC0D1
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238598AbiBRT60 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbiBRT6W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:22 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2599225591
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:05 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IB9kjF008180
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=diiXg5ASU6ZxIrdESQhrsgpZ9XXx9iwjyH5u3VF5/BQ=;
 b=WnzRguBhxbS5tJ6Co3Nwqb0cCfGPezS0rmqxk23iIGWmeHEZKijF6ugtT5PALlvWYCQY
 hn6eL+a8/zjG69qq/BS+Vd1WscxHbHMGPuai3IXf5lekQEXIc8OZGhuPG0rm7WuDZghc
 AQCDoTYK8UoL2Ap9Zlk/h3mf+cWchgmWV44= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e9yf2xd4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:04 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:02 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A32C8AEB6607; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 05/13] fs: split off __create_empty_buffers function
Date:   Fri, 18 Feb 2022 11:57:31 -0800
Message-ID: <20220218195739.585044-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: u-xSz-msjYEtXEIaX5Xg3aQBJBAYs6ik
X-Proofpoint-ORIG-GUID: u-xSz-msjYEtXEIaX5Xg3aQBJBAYs6ik
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_08,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180121
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

This splits off the function __create_empty_buffers() from the function
create_empty_buffers. The __create_empty_buffers has an additional gfp
parameter. This allows the caller to specify the allocation properties.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/buffer.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2858eaf433c8..648e1cba6da3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1554,17 +1554,12 @@ void block_invalidatepage(struct page *page, unsi=
gned int offset,
 EXPORT_SYMBOL(block_invalidatepage);
=20
=20
-/*
- * We attach and possibly dirty the buffers atomically wrt
- * __set_page_dirty_buffers() via private_lock.  try_to_free_buffers
- * is already excluded via the page lock.
- */
-void create_empty_buffers(struct page *page,
-			unsigned long blocksize, unsigned long b_state)
+static void __create_empty_buffers(struct page *page, unsigned long bloc=
ksize,
+				unsigned long b_state, gfp_t gfp)
 {
 	struct buffer_head *bh, *head, *tail;
=20
-	head =3D alloc_page_buffers(page, blocksize, true);
+	head =3D __alloc_page_buffers(page, blocksize, gfp);
 	bh =3D head;
 	do {
 		bh->b_state |=3D b_state;
@@ -1587,6 +1582,17 @@ void create_empty_buffers(struct page *page,
 	attach_page_private(page, head);
 	spin_unlock(&page->mapping->private_lock);
 }
+/*
+ * We attach and possibly dirty the buffers atomically wrt
+ * __set_page_dirty_buffers() via private_lock.  try_to_free_buffers
+ * is already excluded via the page lock.
+ */
+void create_empty_buffers(struct page *page,
+			unsigned long blocksize, unsigned long b_state)
+{
+	return __create_empty_buffers(page, blocksize, b_state,
+				GFP_NOFS | __GFP_ACCOUNT | __GFP_NOFAIL);
+}
 EXPORT_SYMBOL(create_empty_buffers);
=20
 /**
--=20
2.30.2

