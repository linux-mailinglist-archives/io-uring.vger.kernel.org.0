Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C0147D870
	for <lists+io-uring@lfdr.de>; Wed, 22 Dec 2021 22:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbhLVVBg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Dec 2021 16:01:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18104 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237536AbhLVVBg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Dec 2021 16:01:36 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BMHx4YS010999
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 13:01:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZmlhQUmi0/AvhoKrC/Xi4w1Gh85p1GREugOsxTzoPKA=;
 b=RuOrsVlBKGxklwgVwLcjR+jChO+ridm5sNx9o+qCDe0EzmZCpcX50p7hf/QbwusN2BzA
 QCimc8y2+ta0ALk6IFXNN5kPnMGVwd9DXx7wQTiz+0DCyXEGONcU5VpoNNIhyclP/Lt5
 mxVauGa7YcWNTmj+lnvrFclultCPNIOZZ6o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d40wrmg6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 13:01:35 -0800
Received: from twshared10481.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 13:01:34 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 3DAE586EFCD8; Wed, 22 Dec 2021 13:01:30 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <shr@fb.com>
Subject: [PATCH v6 2/5] fs: split off setxattr_setup function from setxattr
Date:   Wed, 22 Dec 2021 13:01:24 -0800
Message-ID: <20211222210127.958902-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211222210127.958902-1-shr@fb.com>
References: <20211222210127.958902-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: I9wm8FkVbxQ9NTvapBW78UAbeOgfOFDQ
X-Proofpoint-ORIG-GUID: I9wm8FkVbxQ9NTvapBW78UAbeOgfOFDQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-22_09,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112220111
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
index 432ea3ce76ec..e7d5b4a9fb43 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -202,3 +202,20 @@ struct linux_dirent64;
=20
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent=
,
 		 unsigned int count, loff_t *pos);
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
+	unsigned int flags;
+};
+
+void *setxattr_setup(struct user_namespace *mnt_userns,
+		     const char __user *name,
+		     struct xattr_ctx *ctx);
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

