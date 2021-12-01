Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868EA4646E0
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 06:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbhLAFzN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 00:55:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37016 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346825AbhLAFzK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 00:55:10 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B10XTtU017741
        for <io-uring@vger.kernel.org>; Tue, 30 Nov 2021 21:51:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=vdMtFPj5bdAqXLDdqwxX2yp88l324WqmYn/7iuKoU+A=;
 b=iNKA+o/aQzkcWEHEJ5vE5n+jGx8oghVh+gIHOo7Y0FxEXoDCb5Ji+Uc0sXps90sJpRtn
 bMrtLsV2Jey0pVAACs5Jd1afaLnyWEZf9eix5om3GXR166QgPINvMY70tCbYh5JuCan3
 S6VBtO4APW2gdzjbifS4wuM4n1sN6T9tzyQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cnhx4fh1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 Nov 2021 21:51:49 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 21:51:48 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 670DC7227185; Tue, 30 Nov 2021 21:51:46 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 3/5] fs: split off do_getxattr from getxattr
Date:   Tue, 30 Nov 2021 21:51:42 -0800
Message-ID: <20211201055144.3141001-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211201055144.3141001-1-shr@fb.com>
References: <20211201055144.3141001-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: JCmIwYwxIQc5JTxd4OXAk9R1fMppbJ_o
X-Proofpoint-ORIG-GUID: JCmIwYwxIQc5JTxd4OXAk9R1fMppbJ_o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=736 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off do_getxattr function from the getxattr
function. This will allow io_uring to call it from its
io worker.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/internal.h |  6 ++++++
 fs/xattr.c    | 31 ++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 1b88f29905e6..8326bb5932f0 100644
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
+		    ssize_t size);
+
 void *setxattr_setup(struct user_namespace *mnt_userns,
 		     const char __user *name,
 		     struct xattr_ctx *data);
diff --git a/fs/xattr.c b/fs/xattr.c
index 79afea64d7ba..94167a47d7cf 100644
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
+	 const char *kname, void __user *value, ssize_t size)
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
+	ssize_t error;
=20
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
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

