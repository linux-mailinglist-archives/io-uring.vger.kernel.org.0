Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19C7476510
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 22:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhLOV7a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 16:59:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3560 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230306AbhLOV7a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 16:59:30 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BFLifgC014620
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 13:59:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ksBHQidfEShKnwe7+1AkUOhHNpo3hluOCDtYZipjTtQ=;
 b=W5ihbceAZXOe6y0KsIvmadzeXv11SXG7XHUM/B/9MXOeHhmx+p/jSL02O++zNZgdpfNz
 xEro0hFA2gDN3p6w2I8IQ58EcY4lIXf9wNXM6puDe7Rm4mn5VG5TXs88Cj7ZfM0R+hxw
 9hRF5PnJyEKRkbvjZkdKCVGQT2VW5iLKbCo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3cy84ky7vv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 13:59:30 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 13:59:29 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id D29CF81A403D; Wed, 15 Dec 2021 13:59:26 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>
Subject: [PATCH v6 1/3] fs: split off do_iterate_dir from iterate_dir function
Date:   Wed, 15 Dec 2021 13:59:22 -0800
Message-ID: <20211215215924.3301586-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215215924.3301586-1-shr@fb.com>
References: <20211215215924.3301586-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: HNfBLGMLHpkvJv1kIOBJEPtD8721mqi-
X-Proofpoint-ORIG-GUID: HNfBLGMLHpkvJv1kIOBJEPtD8721mqi-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_13,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 spamscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits of the function do_iterate_dir() from the iterate_dir()
function and adds a new parameter. The new parameter allows the
caller to specify if the position is the file position or the
position stored in the buffer context.

The function iterate_dir is calling the new function do_iterate_dir().

This change is required to support getdents in io_uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/readdir.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 09e8ed7d4161..e9c197edf73a 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -36,8 +36,15 @@
 	unsafe_copy_to_user(dst, src, len, label);		\
 } while (0)
=20
-
-int iterate_dir(struct file *file, struct dir_context *ctx)
+/**
+ * do_iterate_dir - iterate over directory
+ * @file    : pointer to file struct of directory
+ * @ctx     : pointer to directory ctx structure
+ * @use_fpos: true : use file offset
+ *            false: use pos in ctx structure
+ */
+static int do_iterate_dir(struct file *file, struct dir_context *ctx,
+			  bool use_fpos)
 {
 	struct inode *inode =3D file_inode(file);
 	bool shared =3D false;
@@ -60,12 +67,17 @@ int iterate_dir(struct file *file, struct dir_context=
 *ctx)
=20
 	res =3D -ENOENT;
 	if (!IS_DEADDIR(inode)) {
-		ctx->pos =3D file->f_pos;
+		if (use_fpos)
+			ctx->pos =3D file->f_pos;
+
 		if (shared)
 			res =3D file->f_op->iterate_shared(file, ctx);
 		else
 			res =3D file->f_op->iterate(file, ctx);
-		file->f_pos =3D ctx->pos;
+
+		if (use_fpos)
+			file->f_pos =3D ctx->pos;
+
 		fsnotify_access(file);
 		file_accessed(file);
 	}
@@ -76,6 +88,11 @@ int iterate_dir(struct file *file, struct dir_context =
*ctx)
 out:
 	return res;
 }
+
+int iterate_dir(struct file *file, struct dir_context *ctx)
+{
+	return do_iterate_dir(file, ctx, true);
+}
 EXPORT_SYMBOL(iterate_dir);
=20
 /*
--=20
2.30.2

