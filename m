Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FFB4E5599
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245209AbiCWPqk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245206AbiCWPqk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:46:40 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9208B4A907
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:10 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22NEjnCg022907
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=AMRkH0dRomNB6m76Dyijqy0/T5Q1W0Jckt/WcWFLbjs=;
 b=UUZXZN6tJCrtimStYMeDs93aRzwCYVBnOPrkXFAEvtafOqmoVq1ZtnCkVLZxP/d4Tgg9
 cxqyzH9i28ZS7NoYfPrnEqJcez4t1ce1ir0uWGOT9qJ9nFFT4VJjiy54FQF3QMGLQ6Fe
 E7nMxrVwgHjdQT/JZM71DkNUdwDPhsuZHrA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f05kerf30-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:09 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 08:45:08 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id D1187CA02521; Wed, 23 Mar 2022 08:44:59 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 1/4] liburing: Update io_uring in liburing
Date:   Wed, 23 Mar 2022 08:44:54 -0700
Message-ID: <20220323154457.3303391-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220323154457.3303391-1-shr@fb.com>
References: <20220323154457.3303391-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: YYjSOxX_HQtt5DmhHS3QXJF8eQUIN8pV
X-Proofpoint-ORIG-GUID: YYjSOxX_HQtt5DmhHS3QXJF8eQUIN8pV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 5c03061..949a351 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -293,7 +293,8 @@ static inline void io_uring_prep_rw(int op, struct io=
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
index 15516b7..57ad631 100644
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
@@ -149,6 +151,10 @@ enum {
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
 	IORING_OP_MSG_RING,
+	IORING_OP_FSETXATTR,
+	IORING_OP_SETXATTR,
+	IORING_OP_FGETXATTR,
+	IORING_OP_GETXATTR,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -395,7 +401,7 @@ struct io_uring_probe {
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

