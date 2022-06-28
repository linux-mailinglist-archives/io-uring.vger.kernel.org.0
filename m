Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CEA55E6BE
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347730AbiF1PDK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347712AbiF1PDC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:03:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9323833E9F
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:03:01 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SAE75B013218
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:03:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=yNGWca9EZYptSu02EU61qEdS1WccUVHJPmvgfuLJvJI=;
 b=PT5C3RKF+bqqbTqcVYEy+XGiQto7YKGGtENqdyg9k/8eyAl4PcD5o1GLCI3d0bcHEiGn
 2S4V14Zj70GmXEVnnKDXoePpJF1hxiaC41MDdzd+urLPeHgpg9mdocvLyPYhFJ2SKQtY
 RmiV/ABNzw4ABTJ42O156r6IXbKSk8MzWYI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gyxx31y98-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:03:01 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:02:55 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id DAC6E244BBD1; Tue, 28 Jun 2022 08:02:37 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 3/8] io_uring: allow iov_len = 0 for recvmsg and buffer select
Date:   Tue, 28 Jun 2022 08:02:23 -0700
Message-ID: <20220628150228.1379645-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628150228.1379645-1-dylany@fb.com>
References: <20220628150228.1379645-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: lyYIeo1IPJduEjJ32lTdzwqBWSxttULD
X-Proofpoint-ORIG-GUID: lyYIeo1IPJduEjJ32lTdzwqBWSxttULD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When using BUFFER_SELECT there is no technical requirement that the user
actually provides iov, and this removes one copy_from_user call.

So allow iov_len to be 0.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/net.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 19a805c3814c..5e84f7ab92a3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -300,12 +300,18 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *r=
eq,
 		return ret;
=20
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		if (iov_len > 1)
+		if (iov_len =3D=3D 0) {
+			sr->len =3D iomsg->fast_iov[0].iov_len =3D 0;
+			iomsg->fast_iov[0].iov_base =3D NULL;
+			iomsg->free_iov =3D NULL;
+		} else if (iov_len > 1) {
 			return -EINVAL;
-		if (copy_from_user(iomsg->fast_iov, uiov, sizeof(*uiov)))
-			return -EFAULT;
-		sr->len =3D iomsg->fast_iov[0].iov_len;
-		iomsg->free_iov =3D NULL;
+		} else {
+			if (copy_from_user(iomsg->fast_iov, uiov, sizeof(*uiov)))
+				return -EFAULT;
+			sr->len =3D iomsg->fast_iov[0].iov_len;
+			iomsg->free_iov =3D NULL;
+		}
 	} else {
 		iomsg->free_iov =3D iomsg->fast_iov;
 		ret =3D __import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
--=20
2.30.2

