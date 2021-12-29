Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3582D4816A5
	for <lists+io-uring@lfdr.de>; Wed, 29 Dec 2021 21:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhL2Uci (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 15:32:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44540 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229557AbhL2Uch (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 15:32:37 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BTHDlKN011770
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 12:32:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=g0KFlOUuryi2K2aT57GzAH4trWZbls5urVBgYCcqqcs=;
 b=AcQlTqkQXP054sRD/zL0ZqWcSZqxIvsjQu717KPA1m93rSdTy8q9i3/0ktJWugHm5lh1
 kdQnJ7KU6pVwbvkDe1xkANFhEV1b2zbWvUoYyH1CGLiWqeZ3OmyoAFcsf1wOpU9OQICA
 FbAny4neYxOXqr5daT/P4JKzJb8v0OEvXlc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d80p4h1bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 12:32:37 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 29 Dec 2021 12:32:36 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 6F88C8C20DF2; Wed, 29 Dec 2021 12:30:04 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v10 1/5] fs: split off do_user_path_at_empty from user_path_at_empty()
Date:   Wed, 29 Dec 2021 12:29:58 -0800
Message-ID: <20211229203002.4110839-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211229203002.4110839-1-shr@fb.com>
References: <20211229203002.4110839-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: e6uSxZ48rG3brhHvpJPzBV7kdtEz5X7S
X-Proofpoint-ORIG-GUID: e6uSxZ48rG3brhHvpJPzBV7kdtEz5X7S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_06,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 mlxlogscore=680 spamscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off a do_user_path_at_empty function from the
user_path_at_empty_function. This is required so it can be
called from io_uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h |  6 ++++++
 fs/namei.c    | 10 ++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 432ea3ce76ec..afa60757d5f6 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -202,3 +202,9 @@ struct linux_dirent64;
=20
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent=
,
 		 unsigned int count, loff_t *pos);
+
+ /*
+  * fs/namei.c:
+  */
+extern int do_user_path_at_empty(int dfd, struct filename *filename,
+				unsigned int flags, struct path *path);
diff --git a/fs/namei.c b/fs/namei.c
index 1f9d2187c765..d988e241b32c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2794,12 +2794,18 @@ int path_pts(struct path *path)
 }
 #endif
=20
+int do_user_path_at_empty(int dfd, struct filename *filename, unsigned i=
nt flags,
+		       struct path *path)
+{
+	return filename_lookup(dfd, filename, flags, path, NULL);
+}
+
 int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
-		 struct path *path, int *empty)
+		struct path *path, int *empty)
 {
 	struct filename *filename =3D getname_flags(name, flags, empty);
-	int ret =3D filename_lookup(dfd, filename, flags, path, NULL);
=20
+	int ret =3D do_user_path_at_empty(dfd, filename, flags, path);
 	putname(filename);
 	return ret;
 }
--=20
2.30.2

