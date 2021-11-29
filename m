Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6651246248A
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 23:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhK2WU2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 17:20:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51444 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232705AbhK2WSY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 17:18:24 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1ATIlDcs032301
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7aBG1MWU2m4SmV/x5D1sdf96FtG9F5fDElWoFZaQk/A=;
 b=NgbYt5J+NCIj/0ZPC507lqcWkeZJHjNcK16BeJb+ppR6LW2WPiRiUhJcBrDzYureGRdY
 Zg/1GM1fZy0eAqvIPyELpd4Qaq3se2yJ1c7u+fIqq33GdKQOGXIuHwV0omVO2f5GOrOD
 0SA5IECBOjPuC4B5TKcF+TCHvvEFZiHuyCs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3cmna672m6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:05 -0800
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 14:15:05 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id F04C67101D1F; Mon, 29 Nov 2021 14:15:00 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 1/4] liburing: Update io_uring in liburing
Date:   Mon, 29 Nov 2021 14:14:55 -0800
Message-ID: <20211129221458.2546542-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129221458.2546542-1-shr@fb.com>
References: <20211129221458.2546542-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: yd0OhCvx90XGlNFsELsPOP3gNZrWe14l
X-Proofpoint-ORIG-GUID: yd0OhCvx90XGlNFsELsPOP3gNZrWe14l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_11,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=823
 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015 phishscore=0
 mlxscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111290105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Summary:

Update liburing with the kernel changes in io_uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing.h          |  3 ++-
 src/include/liburing/io_uring.h | 10 ++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 169e098..1c978db 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -258,7 +258,8 @@ static inline void io_uring_prep_rw(int op, struct io=
_uring_sqe *sqe, int fd,
 	sqe->buf_index =3D 0;
 	sqe->personality =3D 0;
 	sqe->file_index =3D 0;
-	sqe->__pad2[0] =3D sqe->__pad2[1] =3D 0;
+	sqe->addr3 =3D 0;
+	sqe->__pad2[0] =3D 0;
 }
=20
 /**
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index a7d193d..e5bb6ce 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -49,6 +49,7 @@ struct io_uring_sqe {
 		__u32		rename_flags;
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
+		__u32		xattr_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -64,7 +65,8 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	__pad2[2];
+	__u64	addr3;
+	__u64	__pad2[1];
 };
=20
 enum {
@@ -147,6 +149,10 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_FGETXATTR,
+	IORING_OP_FSETXATTR,
+	IORING_OP_GETXATTR,
+	IORING_OP_SETXATTR,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -386,7 +392,7 @@ struct io_uring_probe {
 	__u8 ops_len;	/* length of ops[] array below */
 	__u16 resv;
 	__u32 resv2[3];
-	struct io_uring_probe_op ops[];
+	struct io_uring_probe_op ops[0];
 };
=20
 struct io_uring_restriction {
--=20
2.30.2

