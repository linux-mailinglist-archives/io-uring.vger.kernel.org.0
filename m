Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB6D58AA5F
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 13:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240579AbiHELzd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 07:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240504AbiHELz0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 07:55:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223ECDF9B
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 04:55:23 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 275A41PW012676
        for <io-uring@vger.kernel.org>; Fri, 5 Aug 2022 04:55:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=dzm6lFTYPM8VXyoRvfuf+LKZFL9the2YikdgW3RO2N0=;
 b=L6wv9Y3OBuxC6dwdRqK1np8Wf/tTrzXzGq913O9CA1FwaA3maRktKvDAqnI2P+PJLDeV
 sc2o81Trm9BMvwCPFh7Zetv8bqh12uDgpV8zqCmZEJ8rEDCuBBl5v3GCty7iS1FWRVH4
 loRzwgHnb3itfogbxSfE2LgWkIzabIVNUTw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hs14g8eea-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 05 Aug 2022 04:55:23 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 04:55:01 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 4DCDE418592C; Fri,  5 Aug 2022 04:54:53 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] io_uring: fix io_recvmsg_prep_multishot casts
Date:   Fri, 5 Aug 2022 04:54:50 -0700
Message-ID: <20220805115450.3921352-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: G8bQa22q-Ln8sameEbQ4FGeGN3vIBe54
X-Proofpoint-GUID: G8bQa22q-Ln8sameEbQ4FGeGN3vIBe54
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_05,2022-08-05_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix casts missing the __user parts. This seemed to only cause errors on
the alpha build, but it was definitely an oversight.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---

Hi,

I tried to reproduce this issue to be sure this fixes it, but I could not=
 get the
warnings out of the gcc I have locally.
That being said it seems like a fairly clear fix.

 io_uring/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 32fc3da04e41..fa7a28b6bad5 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -575,12 +575,12 @@ static int io_recvmsg_prep_multishot(struct io_asyn=
c_msghdr *kmsg,
 	if (kmsg->controllen) {
 		unsigned long control =3D ubuf + hdr - kmsg->controllen;
=20
-		kmsg->msg.msg_control_user =3D (void *) control;
+		kmsg->msg.msg_control_user =3D (void __user *) control;
 		kmsg->msg.msg_controllen =3D kmsg->controllen;
 	}
=20
 	sr->buf =3D *buf; /* stash for later copy */
-	*buf =3D (void *) (ubuf + hdr);
+	*buf =3D (void __user *) (ubuf + hdr);
 	kmsg->payloadlen =3D *len =3D *len - hdr;
 	return 0;
 }

base-commit: b2a88c212e652e94f1e4b635910972ac57ba4e97
--=20
2.30.2

