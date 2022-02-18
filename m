Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057614BC0E4
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbiBRT67 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238882AbiBRT6p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:45 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4272927B33
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:14 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IILs8G019472
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=rvfKvYi+EV3QXrTdgmIaOv4PvjI982xuzCImRCkTqmg=;
 b=CT/L+SK3Nys3mc+yBNwAE/76DXF4+UrDxJskGh8UtbBJOrPZ28yu6xRUYiHnHps8b3io
 zxPGJe/atbot6DnKEl2L1QZM5eGMs2wNZ7YHkgnRDJeJFWrQiI7OCcS9GPSuMonw8Tbo
 PxMrCVc3IhYtV/z6IexciU6TaLzNPYhIcCI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea6knvaxw-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:13 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:08 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id D3B57AEB6617; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 13/13] block: enable async buffered writes for block devices.
Date:   Fri, 18 Feb 2022 11:57:39 -0800
Message-ID: <20220218195739.585044-14-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: baojwjXZEcBNZZ9aR8Tl2Af-Qw71tq_S
X-Proofpoint-GUID: baojwjXZEcBNZZ9aR8Tl2Af-Qw71tq_S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_08,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 adultscore=0
 mlxlogscore=823 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

This introduces the flag FMODE_BUF_WASYNC. If devices support async
buffered writes, this flag can be set. It also enables async buffered
writes for block devices.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 block/fops.c       | 5 +----
 fs/read_write.c    | 3 ++-
 include/linux/fs.h | 3 +++
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 4f59e0f5bf30..75b36f8b5e71 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -489,7 +489,7 @@ static int blkdev_open(struct inode *inode, struct fi=
le *filp)
 	 * during an unstable branch.
 	 */
 	filp->f_flags |=3D O_LARGEFILE;
-	filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
=20
 	if (filp->f_flags & O_NDELAY)
 		filp->f_mode |=3D FMODE_NDELAY;
@@ -544,9 +544,6 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
 	if (iocb->ki_pos >=3D size)
 		return -ENOSPC;
=20
-	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) =3D=3D IOCB_NOWAIT)
-		return -EOPNOTSUPP;
-
 	size -=3D iocb->ki_pos;
 	if (iov_iter_count(from) > size) {
 		shorted =3D iov_iter_count(from) - size;
diff --git a/fs/read_write.c b/fs/read_write.c
index 0074afa7ecb3..58233844a9d8 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1641,7 +1641,8 @@ ssize_t generic_write_checks(struct kiocb *iocb, st=
ruct iov_iter *from)
 	if (iocb->ki_flags & IOCB_APPEND)
 		iocb->ki_pos =3D i_size_read(inode);
=20
-	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
+	if ((iocb->ki_flags & IOCB_NOWAIT) &&
+		(!(iocb->ki_flags & IOCB_DIRECT) && !(file->f_mode & FMODE_BUF_WASYNC)=
))
 		return -EINVAL;
=20
 	count =3D iov_iter_count(from);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b7dd5bd701c0..a526de71b932 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -176,6 +176,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t=
 offset,
 /* File supports async buffered reads */
 #define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
=20
+/* File supports async nowait buffered writes */
+#define FMODE_BUF_WASYNC	((__force fmode_t)0x80000000)
+
 /*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
--=20
2.30.2

