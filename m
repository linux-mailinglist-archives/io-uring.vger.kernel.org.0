Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEC85EAC67
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 18:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbiIZQZb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 12:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbiIZQZE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 12:25:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F359815729
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 08:14:23 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 28QD7aqG013837
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 08:14:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=1e9vWCAVJyP0v5XEjApMCq1DhjsimJ8I74uggNCiJHk=;
 b=K3assWhcBQMtDuNWj+iiS026j69UTEua2PUyAd+AueVVsMylaWALCaJtamwK239cawS0
 uz84QLq2aMqbiIzAa5b1ROiLLiWnQzO7GZEg2BZGIoUI4iF4XMVQmVmVtpS3Xkn9CqDH
 1YNwT14Akg4oDAi/Avun0FyM01PulVy3Xcs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jswd7uvnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 08:14:23 -0700
Received: from twshared14494.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 08:14:22 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1930F6AF7F50; Mon, 26 Sep 2022 08:14:18 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 2/2] update documentation to reflect no 5.20 kernel
Date:   Mon, 26 Sep 2022 08:14:12 -0700
Message-ID: <20220926151412.2515493-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220926151412.2515493-1-dylany@fb.com>
References: <20220926151412.2515493-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OmFRMqoSgMp6XWLp97CoSrk_WM-1Vz7B
X-Proofpoint-GUID: OmFRMqoSgMp6XWLp97CoSrk_WM-1Vz7B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The documentation referenced the wrong kernel version.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_prep_recv.3    | 2 +-
 man/io_uring_prep_recvmsg.3 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/io_uring_prep_recv.3 b/man/io_uring_prep_recv.3
index 60a77fc241b5..b3862369affa 100644
--- a/man/io_uring_prep_recv.3
+++ b/man/io_uring_prep_recv.3
@@ -55,7 +55,7 @@ If a posted CQE does not have the
 .B IORING_CQE_F_MORE
 flag set then the multishot receive will be done and the application sho=
uld issue a
 new request.
-Multishot variants are available since kernel 5.20.
+Multishot variants are available since kernel 6.0.
=20
=20
 After calling this function, additional io_uring internal modifier flags
diff --git a/man/io_uring_prep_recvmsg.3 b/man/io_uring_prep_recvmsg.3
index 07096ee4826c..65f324dfef9b 100644
--- a/man/io_uring_prep_recvmsg.3
+++ b/man/io_uring_prep_recvmsg.3
@@ -65,7 +65,7 @@ submitted with the request. See
 .B io_uring_recvmsg_out (3)
 for more information on accessing the data.
=20
-Multishot variants are available since kernel 5.20.
+Multishot variants are available since kernel 6.0.
=20
 After calling this function, additional io_uring internal modifier flags
 may be set in the SQE
--=20
2.30.2

