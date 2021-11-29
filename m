Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8166A462419
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 23:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhK2WQ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 17:16:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231147AbhK2WQY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 17:16:24 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATIlAHD028209
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:13:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=6BYGb+rUOoqGB/UnZ04lCfqwbkH4+RgVOtLm1IKLgqI=;
 b=Pcz8T8lEaTCR1srgLKvhLW1LZ4e6TsPVSewZq2t0xx6dL2OvjRleUNj6myfgfCjyfo68
 MMa08E/U24Mjpsdt7tQrg5JNywAcmzNN7Vn8C+8HxTimlOGRfuGvVAzbcctjL5cARaZJ
 etSKga2kHGr1W94E+wYOkECq2mFLADmF6CM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cn1as32gg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:13:06 -0800
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 14:13:05 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 906227101606; Mon, 29 Nov 2021 14:12:59 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 1/5] fs: make user_path_at_empty() take a struct filename
Date:   Mon, 29 Nov 2021 14:12:53 -0800
Message-ID: <20211129221257.2536146-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129221257.2536146-1-shr@fb.com>
References: <20211129221257.2536146-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 23mqI8TcYhfA_ACYZzhQnNAodT_4qDDm
X-Proofpoint-ORIG-GUID: 23mqI8TcYhfA_ACYZzhQnNAodT_4qDDm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_11,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 mlxlogscore=732 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Summary:

- Changes the user_path_at_empty function to take a filename
  struct instead of an user character pointer.
- It also includes the necessary changes in stat.c and namei.c
  to call the user_path_at_empty function.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/namei.c            | 5 ++---
 fs/stat.c             | 7 ++++++-
 include/linux/namei.h | 4 ++--
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1f9d2187c765..baf34cde9ecd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2794,10 +2794,9 @@ int path_pts(struct path *path)
 }
 #endif
=20
-int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
-		 struct path *path, int *empty)
+int user_path_at_empty(int dfd, struct filename *filename, unsigned flag=
s,
+		       struct path *path)
 {
-	struct filename *filename =3D getname_flags(name, flags, empty);
 	int ret =3D filename_lookup(dfd, filename, flags, path, NULL);
=20
 	putname(filename);
diff --git a/fs/stat.c b/fs/stat.c
index 28d2020ba1f4..d8752c103062 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -435,12 +435,17 @@ static int do_readlinkat(int dfd, const char __user=
 *pathname,
 	int error;
 	int empty =3D 0;
 	unsigned int lookup_flags =3D LOOKUP_EMPTY;
+	struct filename *filename;
=20
 	if (bufsiz <=3D 0)
 		return -EINVAL;
=20
 retry:
-	error =3D user_path_at_empty(dfd, pathname, lookup_flags, &path, &empty=
);
+	filename =3D getname_flags(pathname, lookup_flags, &empty);
+	if (IS_ERR(filename))
+		return PTR_ERR(filename);
+
+	error =3D user_path_at_empty(dfd, filename, lookup_flags, &path);
 	if (!error) {
 		struct inode *inode =3D d_backing_inode(path.dentry);
=20
diff --git a/include/linux/namei.h b/include/linux/namei.h
index e89329bb3134..dc1ae29478b0 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -49,12 +49,12 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
=20
 extern int path_pts(struct path *path);
=20
-extern int user_path_at_empty(int, const char __user *, unsigned, struct=
 path *, int *empty);
+extern int user_path_at_empty(int, struct filename *, unsigned, struct p=
ath *);
=20
 static inline int user_path_at(int dfd, const char __user *name, unsigne=
d flags,
 		 struct path *path)
 {
-	return user_path_at_empty(dfd, name, flags, path, NULL);
+	return user_path_at_empty(dfd, getname_flags(name, flags, NULL), flags,=
 path);
 }
=20
 extern int kern_path(const char *, unsigned, struct path *);
--=20
2.30.2

