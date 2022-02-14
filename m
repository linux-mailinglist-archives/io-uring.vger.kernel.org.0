Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57824B58EA
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 18:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357230AbiBNRot (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 12:44:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357205AbiBNRol (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 12:44:41 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E09365485
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:34 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ECHRdT024089
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zdWhSChvqhF2fmfEaurlE4EGbKOQKMRzCLYDx/9AfHo=;
 b=qiIC9nO4C8g/b/yIJ0VqOVOTvbSaWfhF415m2rk4uv8/sZsGbM2vtYkwVfMv+ueVWRwV
 KNAdN27ymErA7rrpOutG5SnmnaSrqvbvg1i2F6pFiHTiKZBVZx+GEfxMTTi06OrjNI+o
 Cj8DRAP98GVYmi14RYoWw63XIpnALeDsepE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7py4j44e-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:33 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 09:44:25 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id ADF1DABBD0FF; Mon, 14 Feb 2022 09:44:09 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 06/14] fs: split off __create_empty_buffers function
Date:   Mon, 14 Feb 2022 09:43:55 -0800
Message-ID: <20220214174403.4147994-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214174403.4147994-1-shr@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wYMqypxuIohRwbVbi8q30xpLmd1WHUZM
X-Proofpoint-GUID: wYMqypxuIohRwbVbi8q30xpLmd1WHUZM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

This splits off the function __create_empty_buffers() from the function
create_empty_buffers. The __create_empty_buffers has an additional gfp
parameter. This allows the caller to specify the allocation properties.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/buffer.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a1986f95a39a..948505480b43 100644
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

