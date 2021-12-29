Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC52B48171B
	for <lists+io-uring@lfdr.de>; Wed, 29 Dec 2021 22:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhL2VsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 16:48:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36852 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231322AbhL2VsF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 16:48:05 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BTHDlRu011770
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 13:48:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=F+GlZ2cSO0Ie3lufY8YGswNQaVXi8N9gOyAXbRX6hsk=;
 b=iE7+fBS9ezfY5ssz2OdIoVVrQAZeCPnyc9Xb19uzETFMETqsSawYJANO8xjsZuIQAivN
 YnczLfqGiHxnIzYEbfGD52nCAWJy4cXy3qObJXTbxTn8C/Gz7A5KreIyly78eEw8IZ/D
 oeamrNLbqgFNJgv5c049w/nlsrRDfuDwI5A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d80p4hb4q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 13:48:04 -0800
Received: from twshared3115.02.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 29 Dec 2021 13:48:02 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 263498C2C91A; Wed, 29 Dec 2021 13:47:53 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1] liburing: add xattr and getdents documentation
Date:   Wed, 29 Dec 2021 13:47:48 -0800
Message-ID: <20211229214748.290407-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 9lWioeJlelHk6vLvEpYEn7uU55rHKbQm
X-Proofpoint-ORIG-GUID: 9lWioeJlelHk6vLvEpYEn7uU55rHKbQm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_07,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 mlxlogscore=975 spamscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the getdents and xattr API documentation to the
io_uring_enter man page.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 man/io_uring_enter.2 | 106 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 89 insertions(+), 17 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 589f3ef..9b1d0f9 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -176,7 +176,7 @@ struct io_uring_sqe {
     __u16   ioprio;         /* ioprio for the request */
     __s32   fd;             /* file descriptor to do IO on */
     union {
-        __u64   off;            /* offset into file */
+        __u64   off;        /* offset into file */
         __u64   addr2;
     };
     union {
@@ -201,26 +201,23 @@ struct io_uring_sqe {
         __u32    rename_flags;
         __u32    unlink_flags;
         __u32    hardlink_flags;
+        __u32    xattr_flags;
     };
-    __u64    user_data;     /* data to be passed back at completion time=
 */
+    __u64 user_data; /* data to be passed back at completion time */
     union {
-    struct {
         /* index into fixed buffers, if used */
-            union {
-                /* index into fixed buffers, if used */
-                __u16    buf_index;
-                /* for grouped buffer selection */
-                __u16    buf_group;
-            }
-        /* personality to use, if used */
-        __u16    personality;
-        union {
-            __s32    splice_fd_in;
-            __u32    file_index;
-	};
-    };
-    __u64    __pad2[3];
+        __u16    buf_index;
+        /* for grouped buffer selection */
+        __u16    buf_group;
+    } __attribute__((packed))
+    /* personality to use, if used */
+    __u16    personality;
+    union {
+        __s32    splice_fd_in;
+        __u32    file_index;
     };
+    __u64    addr3;
+    __u64    __pad2[1];
 };
 .EE
 .in
@@ -1024,6 +1021,81 @@ being passed in to
 .BR linkat(2).
 Available since 5.15.
=20
+.TP
+.B IORING_OP_GETDENTS
+Issue the equivalent of a
+.BR getdents64(2)
+system call.
+.I fd
+should be set to the dirfd,
+.I addr
+should point to linux_dirent64 structure
+.I len
+should be set to the size of the above structure
+.I off
+should be set to the directory offset.
+Available since 5.17.
+
+.TP
+.B IORING_OP_GETXATTR
+Issue the equivalent of a
+.BR getxattr(2)
+system call.
+.I addr
+should point to the attribute name,
+.I len
+should be set to the length of the attribute value,
+.I off
+should point to the attribute value,
+.I addr3
+should point to the path name.
+Available since 5.17.
+
+.TP
+.B IORING_OP_FGETXATTR
+Issue the equivalent of a
+.BR fgetxattr(2)
+system call.
+.I fd
+should be set to the file descriptor of the file,
+.I addr
+should point to the attribute name,
+.I len
+should be set to the length of the attribute value,
+.I off
+should point to the attribute value.
+Available since 5.17.
+
+.TP
+.B IORING_OP_SETXATTR
+Issue the equivalent of a
+.BR setxattr(2)
+system call.
+.I addr
+should point to the attribute name,
+.I len
+should be set to the length of the attribute value,
+.I off
+should point to the attribute value,
+.I addr3
+should point to the path name.
+Available since 5.17.
+
+.TP
+.B IORING_OP_FSETXATTR
+Issue the equivalent of a
+.BR fsetxattr(2)
+system call.
+.I fd
+should be set to the file descriptor of the file,
+.I addr
+should point to the attribute name,
+.I len
+should be set to the length of the attribute value,
+.I off
+should point to the attribute value.
+Available since 5.17.
+
 .PP
 The
 .I flags

base-commit: 18d71076f6c97e1b25aa0e3b0e12a913ec4717fa
--=20
2.30.2

