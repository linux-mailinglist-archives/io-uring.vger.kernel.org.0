Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51D247C423
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 17:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhLUQuJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 11:50:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236510AbhLUQuJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 11:50:09 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BLFS1rr011299
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:50:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Y4xClo+bOKLBLadjxOpi5LCV+79V1c88iLat2gQz4Jk=;
 b=B3mvrqpgYA+TU1st8kL/WvP0MUxeS46Hb17miNU4mc1GqtGxbw3GhliJLZdElEG6FG5F
 MuJfEq1BLkdqpxAZmcpgMW5g5vjrfHhYo0Ei2gdELUxbrOB7rH7+rPU+CJsy4xvnToAH
 xpTwRUHZ1pgcryOp/kZP+zSDe7tv0Iavtz8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d35jwn11b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:50:09 -0800
Received: from twshared3205.02.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 08:50:08 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id ABD8885C07D8; Tue, 21 Dec 2021 08:50:01 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <shr@fb.com>
Subject: [PATCH v5 2/5] fs: split off setxattr_setup function from setxattr
Date:   Tue, 21 Dec 2021 08:49:56 -0800
Message-ID: <20211221164959.174480-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211221164959.174480-1-shr@fb.com>
References: <20211221164959.174480-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ZQQ7f_2XGM_bfnVeKmF-OPNFPcdXV5jG
X-Proofpoint-GUID: ZQQ7f_2XGM_bfnVeKmF-OPNFPcdXV5jG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_04,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210083
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits of the setup part of the function
setxattr in its own dedicated function called
setxattr_setup.

This makes it possible to call this function
from io_uring in the pre-processing of an
xattr request.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/internal.h | 16 +++++++++++
 fs/xattr.c    | 74 +++++++++++++++++++++++++++++++++------------------
 2 files changed, 64 insertions(+), 26 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 7979ff8d168c..d13b9f13df09 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -194,3 +194,19 @@ long splice_file_to_pipe(struct file *in,
 			 struct pipe_inode_info *opipe,
 			 loff_t *offset,
 			 size_t len, unsigned int flags);
+
+ /*
+  * fs/xattr.c:
+  */
+struct xattr_ctx {
+	/* Value of attribute */
+	const void __user *value;
+	size_t size;
+	/* Attribute name */
+	char kname[XATTR_NAME_MAX + 1];
+	unsigned int flags;
+};
+
+void *setxattr_setup(struct user_namespace *mnt_userns,
+		     const char __user *name,
+		     struct xattr_ctx *data);
diff --git a/fs/xattr.c b/fs/xattr.c
index 5c8c5175b385..a4b59523bd0e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -25,6 +25,8 @@
=20
 #include <linux/uaccess.h>
=20
+#include "internal.h"
+
 static const char *
 strcmp_prefix(const char *a, const char *a_prefix)
 {
@@ -539,43 +541,63 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
 /*
  * Extended attribute SET operations
  */
-static long
-setxattr(struct user_namespace *mnt_userns, struct dentry *d,
-	 const char __user *name, const void __user *value, size_t size,
-	 int flags)
+
+void *setxattr_setup(struct user_namespace *mnt_userns, const char __use=
r *name,
+		struct xattr_ctx *ctx)
 {
-	int error;
 	void *kvalue =3D NULL;
-	char kname[XATTR_NAME_MAX + 1];
+	int error;
=20
-	if (flags & ~(XATTR_CREATE|XATTR_REPLACE))
-		return -EINVAL;
+	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
+		return ERR_PTR(-EINVAL);
=20
-	error =3D strncpy_from_user(kname, name, sizeof(kname));
-	if (error =3D=3D 0 || error =3D=3D sizeof(kname))
-		error =3D -ERANGE;
+	error =3D strncpy_from_user(ctx->kname, name, sizeof(ctx->kname));
+	if (error =3D=3D 0 || error =3D=3D sizeof(ctx->kname))
+		return  ERR_PTR(-ERANGE);
 	if (error < 0)
-		return error;
+		return ERR_PTR(error);
=20
-	if (size) {
-		if (size > XATTR_SIZE_MAX)
-			return -E2BIG;
-		kvalue =3D kvmalloc(size, GFP_KERNEL);
+	if (ctx->size) {
+		if (ctx->size > XATTR_SIZE_MAX)
+			return ERR_PTR(-E2BIG);
+
+		kvalue =3D kvmalloc(ctx->size, GFP_KERNEL);
 		if (!kvalue)
-			return -ENOMEM;
-		if (copy_from_user(kvalue, value, size)) {
-			error =3D -EFAULT;
-			goto out;
+			return ERR_PTR(-ENOMEM);
+
+		if (copy_from_user(kvalue, ctx->value, ctx->size)) {
+			kvfree(kvalue);
+			return ERR_PTR(-EFAULT);
 		}
-		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) =3D=3D 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) =3D=3D 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, size);
+
+		if ((strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_ACCESS) =3D=3D 0) ||
+		    (strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_DEFAULT) =3D=3D 0))
+			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, ctx->size);
 	}
=20
-	error =3D vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
-out:
-	kvfree(kvalue);
+	return kvalue;
+}
=20
+static long
+setxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	const char __user *name, const void __user *value, size_t size,
+	int flags)
+{
+	struct xattr_ctx ctx =3D {
+		.value    =3D value,
+		.size     =3D size,
+		.flags    =3D flags,
+	};
+	void *kvalue;
+	int error;
+
+	kvalue =3D setxattr_setup(mnt_userns, name, &ctx);
+	if (IS_ERR(kvalue))
+		return PTR_ERR(kvalue);
+
+	error =3D vfs_setxattr(mnt_userns, d, ctx.kname, kvalue, size, flags);
+
+	kvfree(kvalue);
 	return error;
 }
=20
--=20
2.30.2

