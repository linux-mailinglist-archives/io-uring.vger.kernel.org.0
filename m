Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F0C47D877
	for <lists+io-uring@lfdr.de>; Wed, 22 Dec 2021 22:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbhLVVBm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Dec 2021 16:01:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10240 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238152AbhLVVBl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Dec 2021 16:01:41 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BMHwxdJ030132
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 13:01:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=R+gHNHrTjNFVXKBtFBOXRzQyuNrb7FUtOelRI7aqZPo=;
 b=qJ1+1MSKHXJ2Pj4gFk6BsvkwhTOcKx+fj7cgsGfjFMYjlML6Ro43bUFcK6VouKuALi4X
 T7NgxwwAtG8s1QELVDOzY3bhsgXbjk4whfqVZ+oW28+CQ9oVUOD/oAENyv30NZ513Uq/
 1T06Tbb/VfEDw1P2m+lS8WzC46Tos54LEQo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d467yt933-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 13:01:41 -0800
Received: from twshared3115.02.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 13:01:39 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 42D8986EFCDA; Wed, 22 Dec 2021 13:01:30 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <shr@fb.com>
Subject: [PATCH v6 3/5] fs: split off do_getxattr from getxattr
Date:   Wed, 22 Dec 2021 13:01:25 -0800
Message-ID: <20211222210127.958902-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211222210127.958902-1-shr@fb.com>
References: <20211222210127.958902-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: hM-PCUMi-zOWxmqZxtse32h91-71ZSmI
X-Proofpoint-GUID: hM-PCUMi-zOWxmqZxtse32h91-71ZSmI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-22_09,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 impostorscore=0 mlxlogscore=695 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112220111
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
 fs/xattr.c    | 32 ++++++++++++++++++++------------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index e7d5b4a9fb43..ea0433799dbc 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -216,6 +216,12 @@ struct xattr_ctx {
 	unsigned int flags;
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
 		     struct xattr_ctx *ctx);
diff --git a/fs/xattr.c b/fs/xattr.c
index 79afea64d7ba..a675c7f0ea0c 100644
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
@@ -702,10 +695,25 @@ getxattr(struct user_namespace *mnt_userns, struct =
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

