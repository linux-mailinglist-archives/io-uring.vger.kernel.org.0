Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E804645FCF6
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 06:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348671AbhK0GBH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 01:01:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16634 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241709AbhK0F7G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 00:59:06 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1AR3pMP7001363
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 21:55:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/u31pn93VuoRNh18SkC9coZW1dmaq15iiIMXz3oSgm0=;
 b=bGhCohzzLOor5q5ODjJzO46kXOi7d5wuu0DuHI8HA9EzjAAuZlydGncct4Lt0B3u0BTM
 luH3wIo6vY2X4hlfX2My9Q5MDdA9dUwAWwFseETaSpEjE6RBeKf3vYp9z5EPH+vkOlUy
 43EJxoMPe7v6lN5APD5jkB3caF1DC57O/MY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3ckcc48frt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 21:55:52 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 21:55:51 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 4D8DA6F661A4; Fri, 26 Nov 2021 21:55:41 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v4 1/3] fs: add parameter use_fpos to iterate_dir function
Date:   Fri, 26 Nov 2021 21:55:32 -0800
Message-ID: <20211127055535.2976876-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211127055535.2976876-1-shr@fb.com>
References: <20211127055535.2976876-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: bGjMCMsifgFUl8p1xAswUYi3Vzd2__J8
X-Proofpoint-ORIG-GUID: bGjMCMsifgFUl8p1xAswUYi3Vzd2__J8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-27_02,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=988
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111270031
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

