Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0DB50B66B
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 13:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447159AbiDVLvk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 07:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447163AbiDVLvj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 07:51:39 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B5C5641A
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:46 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23M6w0Wt012642
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Qh0NFZZ/PQHv4KCBHZQDn80Dm4UBa7+aTbkpJh1ke3Q=;
 b=DD/vLGq8VkIlprfWu8OvLcaN/kxSCsc9nRIizfv4qZdLLKBrhd14FkclqSQVWbmq26Cw
 dBID2DCGzymDnHOeW1Wvh3BOHuOw7/zpn47gQEPa03o2ad+Dfg7aNp4RDQ9iexy8SPcf
 Vf+cIOlt38CFHN8E2dKT269SLE+8PGliOoc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fjnsxdmsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:46 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 04:48:45 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 9198F7DC56B3; Fri, 22 Apr 2022 04:48:31 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 3/7] test: use unique ports
Date:   Fri, 22 Apr 2022 04:48:11 -0700
Message-ID: <20220422114815.1124921-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220422114815.1124921-1-dylany@fb.com>
References: <20220422114815.1124921-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 2rTmiPBpe5jdLhN5gUXc2kK2nwg2APJv
X-Proofpoint-ORIG-GUID: 2rTmiPBpe5jdLhN5gUXc2kK2nwg2APJv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_03,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for running tests in parallel remove some collisions in
ports. In the future this should probably use ephemeral ports, but for no=
w
there are not too many places to change.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/232c93d07b74.c | 2 +-
 test/recv-msgall.c  | 2 +-
 test/send_recv.c    | 2 +-
 test/send_recvmsg.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/232c93d07b74.c b/test/232c93d07b74.c
index 4153aef..8a7810b 100644
--- a/test/232c93d07b74.c
+++ b/test/232c93d07b74.c
@@ -26,7 +26,7 @@
 #define RECV_BUFF_SIZE 2
 #define SEND_BUFF_SIZE 3
=20
-#define PORT	0x1235
+#define PORT	0x1234
=20
 struct params {
 	int tcp;
diff --git a/test/recv-msgall.c b/test/recv-msgall.c
index 5f202b4..a6f7cfc 100644
--- a/test/recv-msgall.c
+++ b/test/recv-msgall.c
@@ -17,7 +17,7 @@
=20
 #define MAX_MSG	128
=20
-#define PORT	10200
+#define PORT	10201
 #define HOST	"127.0.0.1"
=20
 static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock=
,
diff --git a/test/send_recv.c b/test/send_recv.c
index ad8ea0e..a7b001a 100644
--- a/test/send_recv.c
+++ b/test/send_recv.c
@@ -19,7 +19,7 @@ static char str[] =3D "This is a test of send and recv =
over io_uring!";
=20
 #define MAX_MSG	128
=20
-#define PORT	10200
+#define PORT	10202
 #define HOST	"127.0.0.1"
=20
 static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock=
,
diff --git a/test/send_recvmsg.c b/test/send_recvmsg.c
index 43121f0..f607b5c 100644
--- a/test/send_recvmsg.c
+++ b/test/send_recvmsg.c
@@ -19,7 +19,7 @@ static char str[] =3D "This is a test of sendmsg and re=
cvmsg over io_uring!";
=20
 #define MAX_MSG	128
=20
-#define PORT	10200
+#define PORT	10203
 #define HOST	"127.0.0.1"
=20
 #define BUF_BGID	10
--=20
2.30.2

