Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E42845E352
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 00:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346135AbhKYXbN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 18:31:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346760AbhKYX3M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 18:29:12 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AP8OxCk007970
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 15:26:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/u31pn93VuoRNh18SkC9coZW1dmaq15iiIMXz3oSgm0=;
 b=BIta5ag5iCdKizn+MqApg284qarW5ZLJdBxjv2/35xTLGbhvqRmhcZvXkavrtWMc1PS4
 7PB5xfMLVtpGM4p/2j79jnN25ihGEsYizlHEekkn340Clc4sI0rInpM/S98L9U7ZrTM+
 D35cWFWZeLH5HU2ZZppR3NVOxb97ggb8PlA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cj6y0v4xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 15:26:00 -0800
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 25 Nov 2021 15:25:59 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 37D1F6E85F87; Thu, 25 Nov 2021 15:25:56 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v3 1/3] fs: add parameter use_fpos to iterate_dir function
Date:   Thu, 25 Nov 2021 15:25:47 -0800
Message-ID: <20211125232549.3333746-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211125232549.3333746-1-shr@fb.com>
References: <20211125232549.3333746-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: TLnQuCsBNOCgikNYIduBKdZ72s5o-zq9
X-Proofpoint-GUID: TLnQuCsBNOCgikNYIduBKdZ72s5o-zq9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_07,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=987
 mlxscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111250132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the use_fpos parameter to the iterate_dir function.
If use_fpos is true it uses the file position in the file
structure (existing behavior). If use_fpos is false, it uses
the pos in the context structure.

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

