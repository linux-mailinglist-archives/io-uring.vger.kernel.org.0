Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847F0462414
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 23:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhK2WQV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 17:16:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231131AbhK2WQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 17:16:21 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATIlAoe028212
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:13:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=r8StrTaZD8bttQsZuBxeUQ8HxsyxBTGKeS63+8sOiQ4=;
 b=VdbVEgX29HZlLTY85o5AH0iIma2zlnCH8rCO4CAYV8cKNaqaegATk/exXgCiu9tDWcrz
 AuBAoVZiG3k2iMwr3bZPqFKI5IEI/91wvo64lgfrwvKZuMG/ZpLZsLt2MFnWtu7UXUkK
 mrp0Pf2tVztHW6oib5NGKocNsXE1jbw0GgA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cn1as32g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:13:02 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 14:13:01 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9DB45710160A; Mon, 29 Nov 2021 14:12:59 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 3/5] fs: split off the vfs_getxattr from getxattr
Date:   Mon, 29 Nov 2021 14:12:55 -0800
Message-ID: <20211129221257.2536146-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129221257.2536146-1-shr@fb.com>
References: <20211129221257.2536146-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 22SsrEJ9WR1XiQ8x1-WuyFYBucorJ8LL
X-Proofpoint-ORIG-GUID: 22SsrEJ9WR1XiQ8x1-WuyFYBucorJ8LL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_11,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 mlxlogscore=896 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Summary:

This splits off vfs_getxattr call from the getxattr
function. This will allow io_uring to call it from
its io worker.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/internal.h |  6 ++++++
 fs/xattr.c    | 37 +++++++++++++++++++++++--------------
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index c5c82bfb5ecf..9805415b199c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -208,6 +208,12 @@ struct xattr_ctx {
 	int flags;
 };
=20
+ssize_t do_getxattr(struct user_namespace *mnt_userns,
+		    struct dentry *d,
+		    const char *kname,
+		    void __user *value,
+		    size_t size);
+
 void *setxattr_setup(struct user_namespace *mnt_userns,
 		     const char __user *name,
 		     struct xattr_ctx *data);
diff --git a/fs/xattr.c b/fs/xattr.c
index 13963b914ac5..9e1dba601a03 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -666,19 +666,12 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __us=
er *, name,
 /*
  * Extended attribute GET operations
  */
-static ssize_t
-getxattr(struct user_namespace *mnt_userns, struct dentry *d,
-	 const char __user *name, void __user *value, size_t size)
+ssize_t
+do_getxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	 const char *name, void __user *value, size_t size)
 {
-	ssize_t error;
 	void *kvalue =3D NULL;
-	char kname[XATTR_NAME_MAX + 1];
-
-	error =3D strncpy_from_user(kname, name, sizeof(kname));
-	if (error =3D=3D 0 || error =3D=3D sizeof(kname))
-		error =3D -ERANGE;
-	if (error < 0)
-		return error;
+	size_t error;
=20
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
@@ -688,10 +681,10 @@ getxattr(struct user_namespace *mnt_userns, struct =
dentry *d,
 			return -ENOMEM;
 	}
=20
-	error =3D vfs_getxattr(mnt_userns, d, kname, kvalue, size);
+	error =3D vfs_getxattr(mnt_userns, d, name, kvalue, size);
 	if (error > 0) {
-		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) =3D=3D 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) =3D=3D 0))
+		if ((strcmp(name, XATTR_NAME_POSIX_ACL_ACCESS) =3D=3D 0) ||
+		    (strcmp(name, XATTR_NAME_POSIX_ACL_DEFAULT) =3D=3D 0))
 			posix_acl_fix_xattr_to_user(mnt_userns, kvalue, error);
 		if (size && copy_to_user(value, kvalue, error))
 			error =3D -EFAULT;
@@ -706,6 +699,22 @@ getxattr(struct user_namespace *mnt_userns, struct d=
entry *d,
 	return error;
 }
=20
+static ssize_t
+getxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	 const char __user *name, void __user *value, size_t size)
+{
+	ssize_t error;
+	char kname[XATTR_NAME_MAX + 1];
+
+	error =3D strncpy_from_user(kname, name, sizeof(kname));
+	if (error =3D=3D 0 || error =3D=3D sizeof(kname))
+		error =3D -ERANGE;
+	if (error < 0)
+		return error;
+
+	return do_getxattr(mnt_userns, d, kname, value, size);
+}
+
 static ssize_t path_getxattr(const char __user *pathname,
 			     const char __user *name, void __user *value,
 			     size_t size, unsigned int lookup_flags)
--=20
2.30.2

