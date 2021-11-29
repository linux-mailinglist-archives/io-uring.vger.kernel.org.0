Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5093F46248C
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 23:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhK2WU3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 17:20:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231921AbhK2WSd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 17:18:33 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATIlAKI028204
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=p4oiGfmog0SYprdOYvPCkGTLk17JWUY0gblWlb4DSu4=;
 b=gut03c/1feTboRGYlf93CoFB9OZ7mnDQzWn97wlcP4mrGcmA2cGXZhYkyYT8smnUG5xb
 QN89n5UKKs8OV8DbfhRno+CjCn2dhowHmlcoTSVWz8OaM1L4JF9QLRJ7axuc9Rv1qblJ
 qgssKWk4220CZPneNg8JHbtcg5aInjvdMYo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cn1as32we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:11 -0800
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 14:15:10 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 00EB77101D21; Mon, 29 Nov 2021 14:15:01 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 2/4] liburing: add helper functions for setxattr and fsetxattr
Date:   Mon, 29 Nov 2021 14:14:56 -0800
Message-ID: <20211129221458.2546542-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129221458.2546542-1-shr@fb.com>
References: <20211129221458.2546542-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 5PAfvcT6UGhPdMwms5reIUAtDkatVeqM
X-Proofpoint-ORIG-GUID: 5PAfvcT6UGhPdMwms5reIUAtDkatVeqM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_11,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 mlxlogscore=741 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Summary:

This adds the helper functions for:
- fsetxattr
- setxattr

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 1c978db..38fcc53 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -673,6 +673,29 @@ static inline void io_uring_prep_linkat(struct io_ur=
ing_sqe *sqe, int olddfd,
 	sqe->hardlink_flags =3D (__u32) flags;
 }
=20
+static inline void io_uring_prep_setxattr(struct io_uring_sqe *sqe,
+					  const char *name,
+					  const char *value,
+					  const char *path,
+					  int flags,
+					  size_t len)
+{
+	io_uring_prep_rw(IORING_OP_SETXATTR, sqe, 0, name, len, (__u64) value);
+	sqe->addr3 =3D (__u64) path;
+	sqe->xattr_flags =3D flags;
+}
+
+static inline void io_uring_prep_fsetxattr(struct io_uring_sqe *sqe,
+					   int         fd,
+					   const char *name,
+					   const char *value,
+					   int         flags,
+					   size_t      len)
+{
+	io_uring_prep_rw(IORING_OP_FSETXATTR, sqe, fd, name, len, (__u64) value=
);
+	sqe->xattr_flags =3D flags;
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist=
 in
  * the SQ ring
--=20
2.30.2

