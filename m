Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D545248B8
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 11:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351862AbiELJSr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 05:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351769AbiELJSp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 05:18:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18CF205F2C
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 02:18:44 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24BMwUJI000516
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 02:18:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dvk0mYlhAFZXbgLChpK9+Tor61QIoW8Jly4TzUrF7pc=;
 b=CwTJJnJBGlki2/HhLIjGZtdrbZgR8U6TKP3TucflriAJIRB2y8d6t7XiojsrAMdQeKQE
 BII8Hg4SH2f5MebT02jxROQ0wus8GGqC5IBJ3XdCPhBQ4O2fkmjVjPWNlt+TTK0pG4n0
 N7CUpBBocEZ9YuLpyUrMTxLrNfewTgivc2I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g04kss8jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 02:18:44 -0700
Received: from twshared10276.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 12 May 2022 02:18:43 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 4BE508F02251; Thu, 12 May 2022 02:18:38 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 2/2] io_uring: only wake when the correct events are set
Date:   Thu, 12 May 2022 02:18:34 -0700
Message-ID: <20220512091834.728610-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220512091834.728610-1-dylany@fb.com>
References: <20220512091834.728610-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 94m1PWgAp2bTi21ond8AwGhp-K70rz26
X-Proofpoint-GUID: 94m1PWgAp2bTi21ond8AwGhp-K70rz26
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The check for waking up a request compares the poll_t bits, however this
will always contain some common flags so this always wakes up.

For files with single wait queues such as sockets this can cause the
request to be sent to the async worker unnecesarily. Further if it is
non-blocking will complete the request with EAGAIN which is not desired.

Here exclude these common events, making sure to not exclude POLLERR whic=
h
might be important.

Fixes: d7718a9d25a6 ("io_uring: use poll driven retry for files that supp=
ort it")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44c57dca358d..44661a1f695a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6782,6 +6782,7 @@ static void io_poll_cancel_req(struct io_kiocb *req=
)
=20
 #define wqe_to_req(wait)	((void *)((unsigned long) (wait)->private & ~1)=
)
 #define wqe_is_double(wait)	((unsigned long) (wait)->private & 1)
+#define IO_ASYNC_POLL_COMMON	(EPOLLONESHOT | POLLPRI)
=20
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, in=
t sync,
 			void *key)
@@ -6816,7 +6817,7 @@ static int io_poll_wake(struct wait_queue_entry *wa=
it, unsigned mode, int sync,
 	}
=20
 	/* for instances that support it check for an event match first */
-	if (mask && !(mask & poll->events))
+	if (mask && !(mask & (poll->events & ~IO_ASYNC_POLL_COMMON)))
 		return 0;
=20
 	if (io_poll_get_ownership(req)) {
@@ -6973,7 +6974,7 @@ static int io_arm_poll_handler(struct io_kiocb *req=
, unsigned issue_flags)
 	struct io_ring_ctx *ctx =3D req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask =3D EPOLLONESHOT | POLLERR | POLLPRI;
+	__poll_t mask =3D IO_ASYNC_POLL_COMMON | POLLERR;
 	int ret;
=20
 	if (!def->pollin && !def->pollout)
--=20
2.30.2

