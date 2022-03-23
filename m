Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877DC4E5590
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245182AbiCWPqJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243424AbiCWPqD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:46:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF4A3B3FD
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:33 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22NDenXk017075
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=D/jZId5oa299UGiUhVhwQtmGNBbsRd/InFeSEFlLFnc=;
 b=dcUkgLKcihEbwjiqEkGceT+M/1pDQ3j1EuSvk4Ej4nAhkW0ookzQf2b07CuDjKb0NDa1
 8eMVyWyndunDwNOCzEO7J5dkU/6gkVTmmsK/pyYVy5nDyLv1SoO/9jBGu2F3DsSskhye
 Y1YSBpaP5RoJYor/Z5depgtsQpb3k6/6i8U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eyc9wu3gk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:33 -0700
Received: from twshared10432.40.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 08:44:32 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 83434CA024C7; Wed, 23 Mar 2022 08:44:22 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v13 2/4] fs: split off do_getxattr from getxattr
Date:   Wed, 23 Mar 2022 08:44:18 -0700
Message-ID: <20220323154420.3301504-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220323154420.3301504-1-shr@fb.com>
References: <20220323154420.3301504-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: EabT37Lv5kcEc3WHyT0MMdYfRHs1hpvn
X-Proofpoint-ORIG-GUID: EabT37Lv5kcEc3WHyT0MMdYfRHs1hpvn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 96bbab6b58ba..4a28ae13aaa4 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -217,6 +217,11 @@ struct xattr_ctx {
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

