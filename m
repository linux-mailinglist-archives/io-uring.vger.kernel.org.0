Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127E856162D
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbiF3JVH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiF3JVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:21:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CA839B9D
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:20:57 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0LdkC009999
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:20:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZxZLzix8Bi9Yk7IFNr2jDz73SkvYYif0j2TCkCI4q4A=;
 b=Cj8ubWHSadxNTZKSuAaNNz7y9u2RFXQ+MprisCWPvW9Rl5KM4ui1fKEGretJNuLKcCpf
 ketJgz/AHp0ahcZjsCkLwmOprXz9ctG2TLxMTbw5zlIo2KDLjFsNvJeDCZ8CTLqwGMZa
 85YZDIccQglg5hBhBp3yVv6auOXYY6bohZ8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0tdsd1hu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:20:57 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:20:55 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id BCAC0259A051; Thu, 30 Jun 2022 02:14:23 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 liburing 3/7] add io_uring_prep_(recv|recvmsg)_multishot
Date:   Thu, 30 Jun 2022 02:14:18 -0700
Message-ID: <20220630091422.1463570-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091422.1463570-1-dylany@fb.com>
References: <20220630091422.1463570-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6FCWZ-n9FMBjmGu48LknjY9vvUYh6FP9
X-Proofpoint-GUID: 6FCWZ-n9FMBjmGu48LknjY9vvUYh6FP9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a nice API for multishot recv and recvmsg.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index bb2fb87..d6db6e4 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -416,6 +416,14 @@ static inline void io_uring_prep_recvmsg(struct io_u=
ring_sqe *sqe, int fd,
 	sqe->msg_flags =3D flags;
 }
=20
+static inline void io_uring_prep_recvmsg_multishot(struct io_uring_sqe *=
sqe,
+						   int fd, struct msghdr *msg,
+						   unsigned flags)
+{
+	io_uring_prep_recvmsg(sqe, fd, msg, flags);
+	sqe->addr2 |=3D IORING_RECV_MULTISHOT;
+}
+
 static inline void io_uring_prep_sendmsg(struct io_uring_sqe *sqe, int f=
d,
 					 const struct msghdr *msg,
 					 unsigned flags)
@@ -674,6 +682,14 @@ static inline void io_uring_prep_recv(struct io_urin=
g_sqe *sqe, int sockfd,
 	sqe->msg_flags =3D (__u32) flags;
 }
=20
+static inline void io_uring_prep_recv_multishot(struct io_uring_sqe *sqe=
,
+						int sockfd, void *buf,
+						size_t len, int flags)
+{
+	io_uring_prep_recv(sqe, sockfd, buf, len, flags);
+	sqe->addr2 |=3D IORING_RECV_MULTISHOT;
+}
+
 static inline void io_uring_prep_openat2(struct io_uring_sqe *sqe, int d=
fd,
 					const char *path, struct open_how *how)
 {
--=20
2.30.2

