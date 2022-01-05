Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C31D485B82
	for <lists+io-uring@lfdr.de>; Wed,  5 Jan 2022 23:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244837AbiAEWSu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jan 2022 17:18:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41882 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244824AbiAEWSn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jan 2022 17:18:43 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 205LB1TE032729
        for <io-uring@vger.kernel.org>; Wed, 5 Jan 2022 14:18:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Svj1mw3IRXvQ6oB4AxcXH21f4t9iI+4z2OazkMdWW/o=;
 b=kbtqB/qi5mcCH1WpXzGieMoomW5AbQsgk7ao+BvpjI+qp86ACOimfdgPpXZJmFDvNJUv
 0jRMrAVBPgyspL2nDZ0/SdajxZe/IJrRhfuJscshQKDbHRLl1KArfsxUABu+ltq9UrjY
 n8ugS0oV5zY4IJnlRl+MCwXbGoZO0FoZj4Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dd2d4nsce-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 05 Jan 2022 14:18:42 -0800
Received: from twshared0654.04.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 14:18:40 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 6702E90D2DAA; Wed,  5 Jan 2022 14:18:32 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v12 2/4] fs: split off do_getxattr from getxattr
Date:   Wed, 5 Jan 2022 14:18:28 -0800
Message-ID: <20220105221830.2668297-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220105221830.2668297-1-shr@fb.com>
References: <20220105221830.2668297-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: opIbbx5GtPmVZ4BUQpRlKq9dZ4Vb-roD
X-Proofpoint-GUID: opIbbx5GtPmVZ4BUQpRlKq9dZ4Vb-roD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_07,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=947 impostorscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050141
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off do_getxattr function from the getxattr
function. This will allow io_uring to call it from its
io worker.

Signed-off-by: Stefan Roesch <shr@fb.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h |  5 +++++
 fs/xattr.c    | 59 +++++++++++++++++++++++++++++++++------------------
 2 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 3aec2ef9fada..c69abc68158d 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -215,6 +215,11 @@ struct xattr_ctx {
 	unsigned int flags;
 };
=20
+
+ssize_t do_getxattr(struct user_namespace *mnt_userns,
+		    struct dentry *d,
+		    struct xattr_ctx *ctx);
+
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry=
,
 		struct xattr_ctx *ctx);
diff --git a/fs/xattr.c b/fs/xattr.c
index 717b3904c2e5..0b9f296a7071 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -675,43 +675,60 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __us=
er *, name,
 /*
  * Extended attribute GET operations
  */
-static ssize_t
-getxattr(struct user_namespace *mnt_userns, struct dentry *d,
-	 const char __user *name, void __user *value, size_t size)
+ssize_t
+do_getxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	struct xattr_ctx *ctx)
 {
 	ssize_t error;
-	void *kvalue =3D NULL;
-	char kname[XATTR_NAME_MAX + 1];
+	char *kname =3D ctx->kname->name;
=20
-	error =3D strncpy_from_user(kname, name, sizeof(kname));
-	if (error =3D=3D 0 || error =3D=3D sizeof(kname))
-		error =3D -ERANGE;
-	if (error < 0)
-		return error;
-
-	if (size) {
-		if (size > XATTR_SIZE_MAX)
-			size =3D XATTR_SIZE_MAX;
-		kvalue =3D kvzalloc(size, GFP_KERNEL);
-		if (!kvalue)
+	if (ctx->size) {
+		if (ctx->size > XATTR_SIZE_MAX)
+			ctx->size =3D XATTR_SIZE_MAX;
+		ctx->kvalue =3D kvzalloc(ctx->size, GFP_KERNEL);
+		if (!ctx->kvalue)
 			return -ENOMEM;
 	}
=20
-	error =3D vfs_getxattr(mnt_userns, d, kname, kvalue, size);
+	error =3D vfs_getxattr(mnt_userns, d, kname, ctx->kvalue, ctx->size);
 	if (error > 0) {
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) =3D=3D 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) =3D=3D 0))
-			posix_acl_fix_xattr_to_user(mnt_userns, kvalue, error);
-		if (size && copy_to_user(value, kvalue, error))
+			posix_acl_fix_xattr_to_user(mnt_userns, ctx->kvalue, error);
+		if (ctx->size && copy_to_user(ctx->value, ctx->kvalue, error))
 			error =3D -EFAULT;
-	} else if (error =3D=3D -ERANGE && size >=3D XATTR_SIZE_MAX) {
+	} else if (error =3D=3D -ERANGE && ctx->size >=3D XATTR_SIZE_MAX) {
 		/* The file system tried to returned a value bigger
 		   than XATTR_SIZE_MAX bytes. Not possible. */
 		error =3D -E2BIG;
 	}
=20
-	kvfree(kvalue);
+	return error;
+}
+
+static ssize_t
+getxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	 const char __user *name, void __user *value, size_t size)
+{
+	ssize_t error;
+	struct xattr_name kname;
+	struct xattr_ctx ctx =3D {
+		.value    =3D value,
+		.kvalue   =3D NULL,
+		.size     =3D size,
+		.kname    =3D &kname,
+		.flags    =3D 0,
+	};
+
+	error =3D strncpy_from_user(kname.name, name, sizeof(kname.name));
+	if (error =3D=3D 0 || error =3D=3D sizeof(kname.name))
+		error =3D -ERANGE;
+	if (error < 0)
+		return error;
=20
+	error =3D  do_getxattr(mnt_userns, d, &ctx);
+
+	kvfree(ctx.kvalue);
 	return error;
 }
=20
--=20
2.30.2

