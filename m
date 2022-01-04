Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E8548484F
	for <lists+io-uring@lfdr.de>; Tue,  4 Jan 2022 20:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiADTJo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Jan 2022 14:09:44 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38658 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232029AbiADTJo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Jan 2022 14:09:44 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 204GFn1P016133
        for <io-uring@vger.kernel.org>; Tue, 4 Jan 2022 11:09:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=V+xz4Rd9dju/19he8NNp/jGwK0reRGRbeRTJJJ8yRx8=;
 b=WWKPuA0DQPWpKgD9wVq7Ya4YCVeD2JyNOkbY/TziOvPLssHcqkUf484E1PTGLirUrz89
 ywiuNd0yMuKsLIGX6xcpS6oc2m0VjXpVzQgb+vKWMmSaE6BRTol2zGrXff6boMsHWFAA
 bBqEEpWhPYhC11e1Hx+vmPF84WGiLKDXpbk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dc7pjx1ju-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 04 Jan 2022 11:09:43 -0800
Received: from twshared0654.04.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 11:09:42 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id BC0E58FC8E14; Tue,  4 Jan 2022 11:09:38 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v11 2/4] fs: split off do_getxattr from getxattr
Date:   Tue, 4 Jan 2022 11:09:34 -0800
Message-ID: <20220104190936.3085647-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104190936.3085647-1-shr@fb.com>
References: <20220104190936.3085647-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: DBs5VI__5GDBRmBFC6ZZVHSFmi4Q4rwf
X-Proofpoint-ORIG-GUID: DBs5VI__5GDBRmBFC6ZZVHSFmi4Q4rwf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_09,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 spamscore=0 adultscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxlogscore=703 lowpriorityscore=0 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201040127
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
 fs/internal.h |  7 +++++++
 fs/xattr.c    | 32 ++++++++++++++++++++------------
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 00c98b0cd634..942b2005a2be 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -220,6 +220,13 @@ struct xattr_ctx {
 	unsigned int flags;
 };
=20
+
+ssize_t do_getxattr(struct user_namespace *mnt_userns,
+		    struct dentry *d,
+		    const char *kname,
+		    void __user *value,
+		    size_t size);
+
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry=
,
 		struct xattr_ctx *ctx);
diff --git a/fs/xattr.c b/fs/xattr.c
index dec7ac3e0e89..7f2b805ed56c 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -675,19 +675,12 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __us=
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
@@ -711,10 +704,25 @@ getxattr(struct user_namespace *mnt_userns, struct =
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

