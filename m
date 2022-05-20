Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF7152F354
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352966AbiETSin (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352988AbiETSiW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:38:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CE7195EA3
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:56 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSNMJ018068
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mezo8o29O3Ay9l7JyNHPANH1KNPPbed3umcUOpvhL7Q=;
 b=jH6HMQZ/qh58RCGqJedbNF1U/zDw6BY2FM3fujn8koRXkX/4BD4Fn3ToH1F1UFcaHQRF
 w473sTF5VYVvUYFU3PecohX1PjdO3MCUBSz8wtrn2sICyS8dWlQAHd+cAMIFyF9MAOoZ
 rDltJoufciTpHlpxS8OqdenNLjIlR3T1Zxw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5xexdw0y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:56 -0700
Received: from twshared8307.18.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:55 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C6F93F5E5B43; Fri, 20 May 2022 11:37:16 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [RFC PATCH v4 17/17] xfs: Enable async buffered write support
Date:   Fri, 20 May 2022 11:36:46 -0700
Message-ID: <20220520183646.2002023-18-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220520183646.2002023-1-shr@fb.com>
References: <20220520183646.2002023-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IMsA-a6sRHJjD3Nglg8ufUHCxHamNziZ
X-Proofpoint-GUID: IMsA-a6sRHJjD3Nglg8ufUHCxHamNziZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index ad3175b7d366..af4fdc852da5 100644
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

