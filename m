Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9655E5AA370
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 00:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiIAW7e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 18:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiIAW7d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 18:59:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F1380E8C
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 15:59:33 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281MooaA031116
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 15:59:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=XVCHQQfWhWgKAKMZPJkW78hrbIW41ozZ96M/ldxVQ+c=;
 b=KnfGKqv7uHvGB11KFCpX830jJ3sANFbKSsaAmgoXCzTsPUhtufoSOCIvuAJTN5Q7wgj7
 X9Z32atEmqtYTU02Xh3BKZVQUdiu2Xk2+FiYH6bsDRQyeFXYzPHuDCKpXczHqD4N2zgP
 yVV4rtFwygZ73dnfTB5aFcZtHOGeBdmoydQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jav4fcjt2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 15:59:32 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub103.TheFacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 15:59:32 -0700
Received: from twshared22593.02.prn5.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 15:59:32 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 5C00119149D3; Thu,  1 Sep 2022 15:59:13 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>
Subject: [PATCH v1 10/10] btrfs: enable nowait async buffered writes
Date:   Thu, 1 Sep 2022 15:58:49 -0700
Message-ID: <20220901225849.42898-11-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901225849.42898-1-shr@fb.com>
References: <20220901225849.42898-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: lk9Sgy4ktzpCrtcJf7E7yCfr1lS8vkrF
X-Proofpoint-ORIG-GUID: lk9Sgy4ktzpCrtcJf7E7yCfr1lS8vkrF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Enable nowait async buffered writes in btrfs_do_write_iter() and
btrfs_file_open().

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b498541228ca..984225a92207 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2107,13 +2107,13 @@ ssize_t btrfs_do_write_iter(struct kiocb *iocb, s=
truct iov_iter *from,
 	if (BTRFS_FS_ERROR(inode->root->fs_info))
 		return -EROFS;
=20
-	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
-		return -EOPNOTSUPP;
-
 	if (sync)
 		atomic_inc(&inode->sync_writers);
=20
 	if (encoded) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EOPNOTSUPP;
+
 		num_written =3D btrfs_encoded_write(iocb, from, encoded);
 		num_sync =3D encoded->len;
 	} else if (iocb->ki_flags & IOCB_DIRECT) {
@@ -3755,7 +3755,7 @@ static int btrfs_file_open(struct inode *inode, str=
uct file *filp)
 {
 	int ret;
=20
-	filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
=20
 	ret =3D fsverity_file_open(inode, filp);
 	if (ret)
--=20
2.30.2

