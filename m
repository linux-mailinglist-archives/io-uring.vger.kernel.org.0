Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AC0621A56
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 18:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiKHRWW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 12:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbiKHRWI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 12:22:08 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA19457B5C
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 09:22:06 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8HDVf8022520
        for <io-uring@vger.kernel.org>; Tue, 8 Nov 2022 09:22:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=ZLur+SOjFsgPpSvyvi8oHGzPWVeuaWNPpHdNwXuIaBI=;
 b=ASWXJjBgL05P5jm7nnFRTRiZptRkUxbrlIEm1WHmh7Xj92eud6Le/FY0+D+CZ00uhDaa
 q3EDAqQYHfJjmvrdW69pwiHqRNlFgtxXyFdWXn7tXirFTeVCMh3SkTRcoEc0iLVJhlwM
 A6wpDtaMpLvrmilXfd+ThAou2aNfcH6eylhFtzR9nfH5xoTU5sCAxSYKSroMV146RcAL
 PE80gRYsJSi3gD1mZZJvmwIiWUktM4jVEdnHGIrKoL3vfOIFDo2cI8v4NQ806oPF362e
 Uxg034+oZ8JWzDq7hIHFeJ68csYso7h/cbg8SSMionSKVBSYOOIrURFt7zTaLOgNHFm5 og== 
Received: from maileast.thefacebook.com ([163.114.130.3])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kq6kkaa8c-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 08 Nov 2022 09:22:05 -0800
Received: from twshared14438.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 09:22:05 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 4714791F7AA2; Tue,  8 Nov 2022 09:21:54 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing] Alphabetise the test list
Date:   Tue, 8 Nov 2022 09:21:37 -0800
Message-ID: <20221108172137.2528931-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: hM_qxAZE7LU7jTJsJDEodbAJKTSi1ziT
X-Proofpoint-GUID: hM_qxAZE7LU7jTJsJDEodbAJKTSi1ziT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Alphabetical order is commanded by the comment at the top of the list, an=
d
also would have helped notice that skip-cqe.c is repeated.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 test/Makefile | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/test/Makefile b/test/Makefile
index 8263e9f9a0b7..8ad99641abe1 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -122,8 +122,8 @@ test_srcs :=3D \
 	poll-cancel-ton.c \
 	poll-link.c \
 	poll-many.c \
-	poll-mshot-update.c \
 	poll-mshot-overflow.c \
+	poll-mshot-update.c \
 	poll-ring.c \
 	poll-v-poll.c \
 	pollfree.c \
@@ -144,10 +144,12 @@ test_srcs :=3D \
 	sendmsg_fs_cve.c \
 	send_recv.c \
 	send_recvmsg.c \
+	send-zerocopy.c \
 	shared-wq.c \
 	short-read.c \
 	shutdown.c \
 	sigfd-deadlock.c \
+	single-issuer.c \
 	skip-cqe.c \
 	socket.c \
 	socket-rw.c \
@@ -168,8 +170,8 @@ test_srcs :=3D \
 	submit-and-wait.c \
 	submit-link-fail.c \
 	submit-reuse.c \
-	sync-cancel.c \
 	symlink.c \
+	sync-cancel.c \
 	teardowns.c \
 	thread-exit.c \
 	timeout.c \
@@ -179,9 +181,6 @@ test_srcs :=3D \
 	unlink.c \
 	wakeup-hang.c \
 	xattr.c \
-	skip-cqe.c \
-	single-issuer.c \
-	send-zerocopy.c \
 	# EOL
=20
 all_targets :=3D

base-commit: 754bc068ec482c5338a07dd74b7d3892729bb847
--=20
2.30.2

