Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44992576262
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiGONDH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 09:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGONDG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 09:03:06 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230E114D0F
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 06:03:05 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FCSHre001153
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 06:03:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=M+39WHdouEvPKOjrj0YS5BfIa8OWRWVu1qsM8ZZ9vSA=;
 b=h5k+uU0lZq461g8gM6H+nTv88+HWy0TFs5INpotWka4rThe5eBpV6ridisKQkYmzSVce
 46TTH84gDmTnoxPM4p7I4MAX675VDSLg/HDnwnjDzxcQLb20Ft5wYsSjVXyK551b8iPD
 PYsF9k8lweJlfpMa2BrH0eQKObMhG/2HLP0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hb892r57y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 06:03:05 -0700
Received: from twshared33626.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 15 Jul 2022 06:02:56 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E1CDD30AC01E; Fri, 15 Jul 2022 06:02:53 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <sfr@canb.auug.org.au>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next] io_uring: fix types in io_recvmsg_multishot_overflow
Date:   Fri, 15 Jul 2022 06:02:52 -0700
Message-ID: <20220715130252.610639-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: UH6zo4LzqItp4hjlbXPbZMJND_16yMEJ
X-Proofpoint-GUID: UH6zo4LzqItp4hjlbXPbZMJND_16yMEJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_05,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_recvmsg_multishot_overflow had incorrect types on non x64 system.
But also it had an unnecessary INT_MAX check, which could just be done
by changing the type of the accumulator to int (also simplifying the
casts).

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: a8b38c4ce724 ("io_uring: support multishot in recvmsg")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/net.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 616d5f04cc74..6b7d5f33e642 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -327,14 +327,14 @@ int io_send(struct io_kiocb *req, unsigned int issu=
e_flags)
=20
 static bool io_recvmsg_multishot_overflow(struct io_async_msghdr *iomsg)
 {
-	unsigned long hdr;
+	int hdr;
=20
-	if (check_add_overflow(sizeof(struct io_uring_recvmsg_out),
-			       (unsigned long)iomsg->namelen, &hdr))
+	if (iomsg->namelen < 0)
 		return true;
-	if (check_add_overflow(hdr, iomsg->controllen, &hdr))
+	if (check_add_overflow((int)sizeof(struct io_uring_recvmsg_out),
+			       iomsg->namelen, &hdr))
 		return true;
-	if (hdr > INT_MAX)
+	if (check_add_overflow(hdr, (int)iomsg->controllen, &hdr))
 		return true;
=20
 	return false;

base-commit: a8b38c4ce7240d869c820d457bcd51e452149510
--=20
2.30.2

