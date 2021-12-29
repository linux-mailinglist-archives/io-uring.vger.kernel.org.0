Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3E64816A7
	for <lists+io-uring@lfdr.de>; Wed, 29 Dec 2021 21:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhL2Ucn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 15:32:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55244 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230131AbhL2Ucl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 15:32:41 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BTHDlvZ014352
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 12:32:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=J2AzANc0raDTMO7WlFVTekzw92CeXv9Qrmf7qu3KJ3o=;
 b=VKXrN1W5pepyvePLgrmcir09rwB4C0Ryp2wu9Nma71Wre1ilT1yZRO8/++1Y5AW/teXB
 EIBfswF0t5rEne4oat66sdU5NqOmKNRc8mGCd/x1c8ciVRmbEs0wi/5YSoelK2zHaUFP
 cPFsBZeZaVvutGy7xZJXLaVwb+wa/KslbeQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d8ghavgua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 12:32:41 -0800
Received: from twshared7750.08.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 29 Dec 2021 12:32:40 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 7A14A8C20DF6; Wed, 29 Dec 2021 12:30:04 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v10 3/5] fs: split off do_getxattr from getxattr
Date:   Wed, 29 Dec 2021 12:30:00 -0800
Message-ID: <20211229203002.4110839-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211229203002.4110839-1-shr@fb.com>
References: <20211229203002.4110839-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: sikHP1eflCH9wQdWzNmAabaDR1lJOpry
X-Proofpoint-ORIG-GUID: sikHP1eflCH9wQdWzNmAabaDR1lJOpry
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_06,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 mlxscore=0 phishscore=0 malwarescore=0 impostorscore=0 spamscore=0
 mlxlogscore=724 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290110
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
index 07487f29feb0..c276ec290489 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -226,6 +226,13 @@ struct xattr_ctx {
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
index 923ba944d20e..3b6d683d07b9 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -677,19 +677,12 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __us=
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
@@ -713,10 +706,25 @@ getxattr(struct user_namespace *mnt_userns, struct =
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

