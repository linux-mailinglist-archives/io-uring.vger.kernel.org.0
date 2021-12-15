Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7137B476583
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhLOWRL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:17:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62148 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229472AbhLOWRK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:17:10 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BFLifsC019424
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:17:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Z5VahS9bOc3VgzotDd35DTx1hPeW6TIZvp/vEn7hWGA=;
 b=Tgn1ZgpHeT4Z45n1zu1n9Fq0ew2iminTLAVLtJnj9lIRwe13XP5CbT4ODhs2Ap/rRVjT
 LqzLtlQqsnqG4A+X+ODf82Jrg15zViK1TisbvsxrvTm27t2Gmw21wdfc7wAKGfkG9zjZ
 /cYASasG/t4xqkE9BkZ5Slo0RtcpVEBfsHo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3cym3qjkuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:17:09 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 14:17:08 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 6C5C981B01A1; Wed, 15 Dec 2021 14:17:05 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>
Subject: [PATCH v4 3/5] fs: split off do_getxattr from getxattr
Date:   Wed, 15 Dec 2021 14:17:00 -0800
Message-ID: <20211215221702.3695098-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215221702.3695098-1-shr@fb.com>
References: <20211215221702.3695098-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: Y-NAlEgwuviO9oRQewoXmHF0dMjLOyhk
X-Proofpoint-ORIG-GUID: Y-NAlEgwuviO9oRQewoXmHF0dMjLOyhk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_13,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 adultscore=0 mlxlogscore=681 impostorscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150123
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
index 1b88f29905e6..5edaee02b50d 100644
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
index 79afea64d7ba..c333fcdac241 100644
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
+	 const char *kname, void __user *value, size_t size)
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

