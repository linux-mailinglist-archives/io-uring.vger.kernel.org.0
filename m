Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9443F47E887
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 20:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbhLWT5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 14:57:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29280 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229759AbhLWT5Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 14:57:16 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BNIV9Qs007964
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 11:57:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=B5xSUEAcFWJvsBVSRpARlLs35XMF5zJxp7D801NDyS8=;
 b=n3BHqdcICRcG1fwx+rs5Zz1N8jaz/ekhV1wkfmLcXYmcRmUA//C1IGkMYJUa6A5s2o6q
 MzUDAKDdTh4xQC3SpFwZptuTGHCKOBpSZsaXzOM2uRCGiGQdGU+nd63oE5EQkwKoYyZV
 QwG/tpWeTkgqYpjPMOJ7JjuHynkFs7KIM6M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d4fnbwvp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 11:57:15 -0800
Received: from twshared10481.23.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 11:57:14 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C8FC287A074D; Thu, 23 Dec 2021 11:57:08 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v7 3/5] fs: split off do_getxattr from getxattr
Date:   Thu, 23 Dec 2021 11:56:56 -0800
Message-ID: <20211223195658.2805049-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211223195658.2805049-1-shr@fb.com>
References: <20211223195658.2805049-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _kyR8qm3He9_qcAYNVzGHs1RPnvrOuTT
X-Proofpoint-GUID: _kyR8qm3He9_qcAYNVzGHs1RPnvrOuTT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0
 suspectscore=0 adultscore=0 mlxlogscore=696 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230102
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
 fs/internal.h |  6 ++++++
 fs/xattr.c    | 32 ++++++++++++++++++++------------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 28b9f947f26e..d33e7a63a9c0 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -217,6 +217,12 @@ struct xattr_ctx {
 };
=20
=20
+ssize_t do_getxattr(struct user_namespace *mnt_userns,
+		    struct dentry *d,
+		    const char *kname,
+		    void __user *value,
+		    size_t size);
+
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx,
 		void **xattr_val);
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry=
,
diff --git a/fs/xattr.c b/fs/xattr.c
index fbe6c2b7ec47..cd36eeebf0c0 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -684,19 +684,12 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __us=
er *, name,
 /*
  * Extended attribute GET operations
  */
-static ssize_t
-getxattr(struct user_namespace *mnt_userns, struct dentry *d,
-	 const char __user *name, void __user *value, size_t size)
+ssize_t
+do_getxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	const char *kname, void __user *value, size_t size)
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
@@ -720,10 +713,25 @@ getxattr(struct user_namespace *mnt_userns, struct =
dentry *d,
 	}
=20
 	kvfree(kvalue);
-
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

