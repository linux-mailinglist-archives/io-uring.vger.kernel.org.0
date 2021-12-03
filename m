Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16593467DEB
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 20:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343599AbhLCTSz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 14:18:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52560 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343663AbhLCTSx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 14:18:53 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3HlUgC013470
        for <io-uring@vger.kernel.org>; Fri, 3 Dec 2021 11:15:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=MSZQFSxPJFwq865NhhlubeB+7yf1sYa/xbh+40S6LQQ=;
 b=h7tbCtA/RAExBQT+QTCWnPvcXzRE5TE423ecYHkh0sqr1//X/SQtlZgPGN+6H1wLgi37
 52jlkPHycI9u1zJSMMA0/1XzxyPQ5vb5lSHcXhtUSAN2FyZRdFN/bJfI2b2L0GOVicdj
 SZNAqhyLEPbcg74lWmO7+HrtTVAj/+seckA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cqck4d6d7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 03 Dec 2021 11:15:29 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 11:15:28 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 3D6BD767FE9E; Fri,  3 Dec 2021 11:15:26 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v3 1/5] fs: split off do_user_path_at_empty from user_path_at_empty()
Date:   Fri, 3 Dec 2021 11:15:12 -0800
Message-ID: <20211203191516.1327214-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211203191516.1327214-1-shr@fb.com>
References: <20211203191516.1327214-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: zqxA45wq16SlCBQALOiv2cJ0btKR-GkL
X-Proofpoint-GUID: zqxA45wq16SlCBQALOiv2cJ0btKR-GkL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=1
 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 mlxlogscore=586 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off a do_user_path_at_empty function from the
user_path_at_empty_function. This is required so it can be
called from io_uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/namei.c            | 10 ++++++++--
 include/linux/namei.h |  2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

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
diff --git a/include/linux/namei.h b/include/linux/namei.h
index e89329bb3134..8f3ef38c057b 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -49,6 +49,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
=20
 extern int path_pts(struct path *path);
=20
+extern int do_user_path_at_empty(int dfd, struct filename *filename,
+				unsigned int flags, struct path *path);
 extern int user_path_at_empty(int, const char __user *, unsigned, struct=
 path *, int *empty);
=20
 static inline int user_path_at(int dfd, const char __user *name, unsigne=
d flags,
--=20
2.30.2

