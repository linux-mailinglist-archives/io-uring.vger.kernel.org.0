Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844F2467DE5
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 20:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242605AbhLCTSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 14:18:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234903AbhLCTSw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 14:18:52 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3HlSfX000959
        for <io-uring@vger.kernel.org>; Fri, 3 Dec 2021 11:15:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=2jEi4ZVqpAO9Zpf8xyWub7qM3fHLB8fg32+GBnuz10U=;
 b=b4CbfDbtA3KMePYGlhG43ymcTNyxs8vmkQvQ5n3xfFjoHd3Sv6qlpIe591105C8X8P6d
 UkhM/ltzUSnmYxzmxUBlLm/E+91i8Nv7KB+fuX31MKrZvs/QZjEF5NfPM6GOBReUJaQ+
 MXKUs9urpcoECTxGACxp4WLKhHTKUO0E+pw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cqeku4nx1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 03 Dec 2021 11:15:28 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 11:15:27 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 40D0E767FEA0; Fri,  3 Dec 2021 11:15:26 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v3 2/5] fs: split off setxattr_setup function from setxattr
Date:   Fri, 3 Dec 2021 11:15:13 -0800
Message-ID: <20211203191516.1327214-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211203191516.1327214-1-shr@fb.com>
References: <20211203191516.1327214-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: 9YP6tVvLQ0QFdreEpmOCZcUqfJdEuFji
X-Proofpoint-GUID: 9YP6tVvLQ0QFdreEpmOCZcUqfJdEuFji
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030124
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
 fs/internal.h | 17 ++++++++++++
 fs/xattr.c    | 75 ++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 7979ff8d168c..1b88f29905e6 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -194,3 +194,20 @@ long splice_file_to_pipe(struct file *in,
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
+	char *kname;
+	int kname_sz;
+	int flags;
+};
+
+void *setxattr_setup(struct user_namespace *mnt_userns,
+		     const char __user *name,
+		     struct xattr_ctx *data);
diff --git a/fs/xattr.c b/fs/xattr.c
index 5c8c5175b385..79afea64d7ba 100644
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
@@ -539,43 +541,66 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
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
+	error =3D strncpy_from_user(ctx->kname, name, ctx->kname_sz);
+	if (error =3D=3D 0 || error =3D=3D ctx->kname_sz)
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
+	return kvalue;
+}
+
+static long
+setxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	const char __user *name, const void __user *value, size_t size,
+	int flags)
+{
+	char kname[XATTR_NAME_MAX + 1];
+	struct xattr_ctx ctx =3D {
+		.value    =3D value,
+		.size     =3D size,
+		.kname    =3D kname,
+		.kname_sz =3D sizeof(kname),
+		.flags    =3D flags,
+	};
+	void *kvalue;
+	int error;
+
+	kvalue =3D setxattr_setup(mnt_userns, name, &ctx);
+	if (IS_ERR(kvalue))
+		return PTR_ERR(kvalue);
+
 	error =3D vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
-out:
-	kvfree(kvalue);
=20
+	kvfree(kvalue);
 	return error;
 }
=20
--=20
2.30.2

