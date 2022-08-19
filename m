Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BEB599BDA
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 14:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348840AbiHSMUl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 08:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348731AbiHSMUj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 08:20:39 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB689FF227
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:20:38 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27JA7IEq006345
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:20:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=NYkgeWhc4loqejV4OaN5qzP3Q6+Q/djrUZ4arEpsTro=;
 b=CgH3TKtdxXAJ4VIvZMLh/q6bOsOFAZCoxSRCVOPu/IdnFLQ2g4mVMYDZXgZPJ2ZHIahv
 GzK19RM+9/g6ltpLcr0ypKt21QzVthuW8bP87a0res9bpxPh+G9jTW+e8JkSCSLTKLRg
 0OFR2Z7HJBawYnj4QwK9BRai185yyiGRiqI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3j1p0rymvw-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:20:38 -0700
Received: from twshared25684.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 05:20:34 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 300F94CEF04A; Fri, 19 Aug 2022 05:20:25 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next v3 3/7] io_uring: do not run task work at the start of io_uring_enter
Date:   Fri, 19 Aug 2022 05:19:42 -0700
Message-ID: <20220819121946.676065-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220819121946.676065-1-dylany@fb.com>
References: <20220819121946.676065-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: nAQDhCYs6i0Z_MAw0PTO-NEVHY90kYlW
X-Proofpoint-GUID: nAQDhCYs6i0Z_MAw0PTO-NEVHY90kYlW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_06,2022-08-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is not needed, and it is normally better to wait for task work until
after submissions. This will allow greater batching if either work arrive=
s
in the meanwhile, or if the submissions cause task work to be queued up.

For SQPOLL this also no longer runs task work, but this is handled inside
the SQPOLL loop anyway.

For IOPOLL io_iopoll_check will run task work anyway

And otherwise io_cqring_wait will run task work

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 19d5d1ab5793..53696dd90626 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2990,8 +2990,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u=
32, to_submit,
 	struct fd f;
 	long ret;
=20
-	io_run_task_work();
-
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP =
|
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING)))
--=20
2.30.2

