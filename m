Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDAC56C0C2
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 20:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbiGHSS7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 14:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbiGHSSx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 14:18:53 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8425E82396
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 11:18:52 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268HAXR2025070
        for <io-uring@vger.kernel.org>; Fri, 8 Jul 2022 11:18:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KdCc4KrhWrRWer2ak8qf+eJb+HmLvN8qCo6zNNUoH/s=;
 b=PaBj+fHoL5kPN6aqLxjEyyVH6JKD5uuvBFEG8G0Eb64IXVmaGWmveDWDPClMVoYIQ+CU
 6kRdDfeyMRflKiS4vAx8wgLyWZ5bEa9+PNL5wppKbfZfEz/FQcmuQruZMB5/8ioTTfdb
 WgFo4qtLeQS0kph9wvMre0BCKnzwDVTVGow= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h5y1dj772-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 11:18:52 -0700
Received: from twshared14577.08.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 8 Jul 2022 11:18:50 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id AEF432B9EC23; Fri,  8 Jul 2022 11:18:41 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 2/4] io_uring: support 0 length iov in buffer select in compat
Date:   Fri, 8 Jul 2022 11:18:36 -0700
Message-ID: <20220708181838.1495428-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220708181838.1495428-1-dylany@fb.com>
References: <20220708181838.1495428-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: IjgDvSYdn3QhhUGBnWGV6EG6oiYWB4bZ
X-Proofpoint-ORIG-GUID: IjgDvSYdn3QhhUGBnWGV6EG6oiYWB4bZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_15,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Match up work done in "io_uring: allow iov_len =3D 0 for recvmsg and buff=
er
select", but for compat code path.

Fixes: a68caad69ce5 ("io_uring: allow iov_len =3D 0 for recvmsg and buffe=
r select")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/net.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 188edbed1eb7..997c17512694 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -384,16 +384,21 @@ static int __io_compat_recvmsg_copy_hdr(struct io_k=
iocb *req,
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		compat_ssize_t clen;
=20
-		if (len > 1)
-			return -EINVAL;
-		if (!access_ok(uiov, sizeof(*uiov)))
-			return -EFAULT;
-		if (__get_user(clen, &uiov->iov_len))
-			return -EFAULT;
-		if (clen < 0)
+		if (len =3D=3D 0) {
+			sr->len =3D 0;
+			iomsg->free_iov =3D NULL;
+		} else if (len > 1) {
 			return -EINVAL;
-		sr->len =3D clen;
-		iomsg->free_iov =3D NULL;
+		} else {
+			if (!access_ok(uiov, sizeof(*uiov)))
+				return -EFAULT;
+			if (__get_user(clen, &uiov->iov_len))
+				return -EFAULT;
+			if (clen < 0)
+				return -EINVAL;
+			sr->len =3D clen;
+			iomsg->free_iov =3D NULL;
+		}
 	} else {
 		iomsg->free_iov =3D iomsg->fast_iov;
 		ret =3D __import_iovec(READ, (struct iovec __user *)uiov, len,
--=20
2.30.2

