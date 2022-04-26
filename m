Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7439E5105D5
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352183AbiDZRr7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353127AbiDZRr1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:27 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D1A1848F0
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:16 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQeic023483
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RopJ1/yVPh7QFsawIR1F6iuVDzeYTCRggUy5rLIAKgY=;
 b=omPl0bzBVI+ZPYnmo+wi4GSK5EePGGbWRjL7voKA753VVrN3soY3m6W5J6kcWtVVuM3P
 NwULcmgP5A3RGV327AQYRXUbZ+iIyY4oHUbSWmiKENlT9hagPEV23SFXGfmhlkhJf4rR
 HSgxHI1wmnovXLs4fP3niUY2ZIz7Ba3NP3g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fp9qhv8qd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:16 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:44:15 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id E12D7E2D4877; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 18/18] xfs: enable async buffered write support
Date:   Tue, 26 Apr 2022 10:43:35 -0700
Message-ID: <20220426174335.4004987-19-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: yTWpQtU63XNsXp9zfrUTm8slTtcTnDRm
X-Proofpoint-GUID: yTWpQtU63XNsXp9zfrUTm8slTtcTnDRm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 49d54b939502..7544dffaf032 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1210,7 +1210,7 @@ xfs_file_open(
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

