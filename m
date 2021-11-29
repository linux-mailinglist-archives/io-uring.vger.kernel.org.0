Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CF046248B
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 23:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhK2WU2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 17:20:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37912 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231862AbhK2WSY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 17:18:24 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATIl9Mt014228
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=GHcdAGWWwT8gy1zBSU0Aw3d1wDwD4o0o2ce2eGEtCEI=;
 b=OV8t+9N1Xa9E3X9vTtGF3OkdS6S2YljIpslLzqxEirUQ+AY1hODT6DEXnJqjps00cF1K
 rTNRzCtkd9KrWmIZiBk33M6nj+hKu+l4IhaOMdqTuLP46/LVmSpIj+/w0/+YZYOEajy8
 JnM02wGUOsihvFT0d27WKif3JFaEWDlwf/Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cmrm1p9au-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:04 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 14:15:03 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 05D8C7101D23; Mon, 29 Nov 2021 14:15:01 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 3/4] liburing: Add helper functions for fgetxattr and getxattr
Date:   Mon, 29 Nov 2021 14:14:57 -0800
Message-ID: <20211129221458.2546542-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129221458.2546542-1-shr@fb.com>
References: <20211129221458.2546542-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 0itCJCKMDx2ZBXBHXJkiU8inpiiYQufJ
X-Proofpoint-ORIG-GUID: 0itCJCKMDx2ZBXBHXJkiU8inpiiYQufJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_11,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 adultscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=724 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Summary:

This adds the helper functions for:
- fgetxattr
- getxattr

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 38fcc53..2e2355f 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -673,6 +673,17 @@ static inline void io_uring_prep_linkat(struct io_ur=
ing_sqe *sqe, int olddfd,
 	sqe->hardlink_flags =3D (__u32) flags;
 }
=20
+static inline void io_uring_prep_getxattr(struct io_uring_sqe *sqe,
+					  const char *name,
+					  const char *value,
+					  const char *path,
+					  size_t len)
+{
+	io_uring_prep_rw(IORING_OP_GETXATTR, sqe, 0, name, len, (__u64) value);
+	sqe->addr3 =3D (__u64) path;
+	sqe->xattr_flags =3D 0;
+}
+
 static inline void io_uring_prep_setxattr(struct io_uring_sqe *sqe,
 					  const char *name,
 					  const char *value,
@@ -685,6 +696,16 @@ static inline void io_uring_prep_setxattr(struct io_=
uring_sqe *sqe,
 	sqe->xattr_flags =3D flags;
 }
=20
+static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
+		                           int         fd,
+					   const char *name,
+					   const char *value,
+					   size_t      len)
+{
+	io_uring_prep_rw(IORING_OP_FGETXATTR, sqe, fd, name, len, (__u64) value=
);
+	sqe->xattr_flags =3D 0;
+}
+
 static inline void io_uring_prep_fsetxattr(struct io_uring_sqe *sqe,
 					   int         fd,
 					   const char *name,
--=20
2.30.2

