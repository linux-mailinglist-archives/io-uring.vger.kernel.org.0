Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2F74E558D
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbiCWPqC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242398AbiCWPp7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:45:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7A33B028
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:29 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22N6WTbj000755
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=vOKmr/vrRfDGrDjMmzLYwzgJ+RL6bljKkS+ekZ0ooOk=;
 b=gbyKGICLJWHzXprGxN/3wk90qcvpa/vPYFtT1iXIvMoRTQazFaR4n6tcBEi52jv9nou7
 LXHY/XgonnKIwwY1JSdx0dUPmZ/nhakNNQg7DacZQaRvjXzpR7OcjTjfuM/mHAZ1/xqI
 C3DXOVOQ4gcWur64uwG/DYCsA59RJLwGz/E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ey6ddmtxh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:29 -0700
Received: from twshared37304.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 08:44:27 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 7BC89CA024C5; Wed, 23 Mar 2022 08:44:22 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v13 1/4] fs: split off setxattr_copy and do_setxattr function from setxattr
Date:   Wed, 23 Mar 2022 08:44:17 -0700
Message-ID: <20220323154420.3301504-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220323154420.3301504-1-shr@fb.com>
References: <20220323154420.3301504-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: HSy0r24TG-wwnN5tBnOaV93_sagSOxh3
X-Proofpoint-ORIG-GUID: HSy0r24TG-wwnN5tBnOaV93_sagSOxh3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits of the setup part of the function
setxattr in its own dedicated function called
setxattr_copy. In addition it also exposes a
new function called do_setxattr for making the
setxattr call.

This makes it possible to call these two functions
from io_uring in the processing of an xattr request.

Signed-off-by: Stefan Roesch <shr@fb.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h | 24 +++++++++++++++
 fs/xattr.c    | 82 ++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 82 insertions(+), 24 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 56c0477f4215..96bbab6b58ba 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -196,3 +196,27 @@ long splice_file_to_pipe(struct file *in,
 			 struct pipe_inode_info *opipe,
 			 loff_t *offset,
 			 size_t len, unsigned int flags);
+
+/*
+ * fs/xattr.c:
+ */
+struct xattr_name {
+	char name[XATTR_NAME_MAX + 1];
+};
+
+struct xattr_ctx {
+	/* Value of attribute */
+	union {
+		const void __user *cvalue;
+		void __user *value;
+	};
+	void *kvalue;
+	size_t size;
+	/* Attribute name */
+	struct xattr_name *kname;
+	unsigned int flags;
+};
+
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
+int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry=
,
+		struct xattr_ctx *ctx);
diff --git a/fs/xattr.c b/fs/xattr.c
index 5c8c5175b385..717b3904c2e5 100644
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
@@ -539,43 +541,75 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
 /*
  * Extended attribute SET operations
  */
-static long
-setxattr(struct user_namespace *mnt_userns, struct dentry *d,
-	 const char __user *name, const void __user *value, size_t size,
-	 int flags)
+
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
 {
 	int error;
-	void *kvalue =3D NULL;
-	char kname[XATTR_NAME_MAX + 1];
=20
-	if (flags & ~(XATTR_CREATE|XATTR_REPLACE))
+	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
 		return -EINVAL;
=20
-	error =3D strncpy_from_user(kname, name, sizeof(kname));
-	if (error =3D=3D 0 || error =3D=3D sizeof(kname))
-		error =3D -ERANGE;
+	error =3D strncpy_from_user(ctx->kname->name, name,
+				sizeof(ctx->kname->name));
+	if (error =3D=3D 0 || error =3D=3D sizeof(ctx->kname->name))
+		return  -ERANGE;
 	if (error < 0)
 		return error;
=20
-	if (size) {
-		if (size > XATTR_SIZE_MAX)
+	error =3D 0;
+	if (ctx->size) {
+		if (ctx->size > XATTR_SIZE_MAX)
 			return -E2BIG;
-		kvalue =3D kvmalloc(size, GFP_KERNEL);
-		if (!kvalue)
-			return -ENOMEM;
-		if (copy_from_user(kvalue, value, size)) {
-			error =3D -EFAULT;
-			goto out;
+
+		ctx->kvalue =3D vmemdup_user(ctx->cvalue, ctx->size);
+		if (IS_ERR(ctx->kvalue)) {
+			error =3D PTR_ERR(ctx->kvalue);
+			ctx->kvalue =3D NULL;
 		}
-		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) =3D=3D 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) =3D=3D 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, size);
 	}
=20
-	error =3D vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
-out:
-	kvfree(kvalue);
+	return error;
+}
+
+static void setxattr_convert(struct user_namespace *mnt_userns,
+			struct xattr_ctx *ctx)
+{
+	if (ctx->size &&
+		((strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_ACCESS) =3D=3D 0) ||
+		(strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_DEFAULT) =3D=3D 0)))
+		posix_acl_fix_xattr_from_user(mnt_userns, ctx->kvalue, ctx->size);
+}
+
+int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry=
,
+		struct xattr_ctx *ctx)
+{
+	setxattr_convert(mnt_userns, ctx);
+	return vfs_setxattr(mnt_userns, dentry, ctx->kname->name,
+			ctx->kvalue, ctx->size, ctx->flags);
+}
+
+static long
+setxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	const char __user *name, const void __user *value, size_t size,
+	int flags)
+{
+	struct xattr_name kname;
+	struct xattr_ctx ctx =3D {
+		.cvalue   =3D value,
+		.kvalue   =3D NULL,
+		.size     =3D size,
+		.kname    =3D &kname,
+		.flags    =3D flags,
+	};
+	int error;
+
+	error =3D setxattr_copy(name, &ctx);
+	if (error)
+		return error;
+
+	error =3D do_setxattr(mnt_userns, d, &ctx);
=20
+	kvfree(ctx.kvalue);
 	return error;
 }
=20
--=20
2.30.2

