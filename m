Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02705352C3
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 19:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348342AbiEZRjk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 13:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348369AbiEZRjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 13:39:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2499A9B5
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:30 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QH4w3g023267
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KHrcNgpGoec04+4iaa68lI4ptLIlXN7oy1iPyC/evOA=;
 b=h24Jkrr5OHPP90yQHENm88tV675Zd+bz26TkIqQM6zgWCdzPEmJgaermkuE+zAxxHmoe
 COb8degQhkHXLDUbGJ59/w3i17ssrZA0zPxx93Hx9JVwYTHSbpoCJH+M9cuzJBVAPtxW
 vNT09lLV6AzkVCAQOLNu+Sk2K07/4K0ly2A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93upxw83-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:30 -0700
Received: from twshared14818.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 26 May 2022 10:39:28 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id B80A4FA621EC; Thu, 26 May 2022 10:38:45 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v6 16/16] xfs: Enable async buffered write support
Date:   Thu, 26 May 2022 10:38:40 -0700
Message-ID: <20220526173840.578265-17-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220526173840.578265-1-shr@fb.com>
References: <20220526173840.578265-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dYx_qD3vcX9BavcZmr5pKByr1-ppjT_O
X-Proofpoint-GUID: dYx_qD3vcX9BavcZmr5pKByr1-ppjT_O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_09,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This turns on the async buffered write support for XFS.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e9d615f4c209..2297770364b0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1169,7 +1169,7 @@ xfs_file_open(
 		return -EFBIG;
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
-	file->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	file->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
 	return 0;
 }
=20
--=20
2.30.2

