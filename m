Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FC247E9B9
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 00:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245247AbhLWXwE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 18:52:04 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64178 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240979AbhLWXwD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 18:52:03 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BNAhaiE024174
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:52:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=STgvX2TE/FLG7fLpXpaJc2rBFNbDgB6WrxQIKn5fdk0=;
 b=HwX4jfSB+GZ+QWHsBq/I8vtMBLO/hbt2VDVWj99DyIlyFlINAC07a4htqsBoROBF/P+E
 PQItzsKeilo7wObPAMfsbAzy9CrSFM8HYEhGzbY0g2GH8Zg2eUK5hqNNAAk6Eo/Ig6yJ
 9lbT5P2w6NhN+AEEEaYhootcvCauMlgWXCA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d4qkumbr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:52:03 -0800
Received: from twshared7572.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 15:52:02 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 7D69687DF611; Thu, 23 Dec 2021 15:51:55 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v8 3/5] fs: split off do_getxattr from getxattr
Date:   Thu, 23 Dec 2021 15:51:21 -0800
Message-ID: <20211223235123.4092764-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211223235123.4092764-1-shr@fb.com>
References: <20211223235123.4092764-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: gxrqjtOqnJyZK979ltUdLRMTl4pHNFna
X-Proofpoint-ORIG-GUID: gxrqjtOqnJyZK979ltUdLRMTl4pHNFna
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=636
 malwarescore=0 mlxscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230122
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
index b07df1623de6..420d0283be12 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -220,6 +220,12 @@ struct xattr_ctx {
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
index dcb4f0ff7e6e..51e305db426f 100644
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
+	struct xattr_name kname;
+
+	error =3D strncpy_from_user(kname.name, name, sizeof(kname.name));
+	if (error =3D=3D 0 || error =3D=3D sizeof(kname.name))
+		error =3D -ERANGE;
+	if (error < 0)
+		return error;
+
+	return do_getxattr(mnt_userns, d, kname.name, value, size);
+}
+
 static ssize_t path_getxattr(const char __user *pathname,
 			     const char __user *name, void __user *value,
 			     size_t size, unsigned int lookup_flags)
--=20
2.30.2

