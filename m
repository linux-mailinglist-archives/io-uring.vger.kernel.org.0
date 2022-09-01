Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F305A9337
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiIAJdj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiIAJdi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62B4133F1B
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:36 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2812ajMW006574
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/WW2t8S3ZnQd7t9XSqnL/ING4ndt1HubR2MuXYUYAPc=;
 b=FGYIjO0bIPYtG9U7tM4f78Z8Jsc4NbipAyzZNmYtnh/iHNO4Gnugjmm993Gp+vDC24U7
 0ouCFZsFVVGnY2Glp0fnPA/evA9UOg9DXoHDe9EHju9iPKQmVL2a0WHqR0boYbfmjx4o
 2ciTMSK5SSeO159h62WOq7kpgA7fRwYt/lg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jam3v9k1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:35 -0700
Received: from twshared0646.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:35 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E456B5769409; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 12/12] shutdown test: bind to ephemeral port
Date:   Thu, 1 Sep 2022 02:33:03 -0700
Message-ID: <20220901093303.1974274-13-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901093303.1974274-1-dylany@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Nvz39bI1l4VVafX68kt_B4thKvm_2875
X-Proofpoint-ORIG-GUID: Nvz39bI1l4VVafX68kt_B4thKvm_2875
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This test would occasionally fail if the chosen port was in use. Rather
bind to an ephemeral port which will not be in use.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/shutdown.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/test/shutdown.c b/test/shutdown.c
index 14c7407b5492..c584893bdd28 100644
--- a/test/shutdown.c
+++ b/test/shutdown.c
@@ -30,6 +30,7 @@ int main(int argc, char *argv[])
 	int32_t recv_s0;
 	int32_t val =3D 1;
 	struct sockaddr_in addr;
+	socklen_t addrlen;
=20
 	if (argc > 1)
 		return 0;
@@ -44,7 +45,7 @@ int main(int argc, char *argv[])
 	assert(ret !=3D -1);
=20
 	addr.sin_family =3D AF_INET;
-	addr.sin_port =3D htons((rand() % 61440) + 4096);
+	addr.sin_port =3D 0;
 	addr.sin_addr.s_addr =3D inet_addr("127.0.0.1");
=20
 	ret =3D bind(recv_s0, (struct sockaddr*)&addr, sizeof(addr));
@@ -52,6 +53,10 @@ int main(int argc, char *argv[])
 	ret =3D listen(recv_s0, 128);
 	assert(ret !=3D -1);
=20
+	addrlen =3D (socklen_t)sizeof(addr);
+	assert(!getsockname(recv_s0, (struct sockaddr *)&addr,
+			    &addrlen));
+
 	p_fd[1] =3D socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
=20
 	val =3D 1;
--=20
2.30.2

