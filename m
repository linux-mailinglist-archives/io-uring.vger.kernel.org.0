Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1832B63754B
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiKXJgm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiKXJgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:41 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FB011E72A
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:40 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANNUF14005926
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=xdIQVOTGgm/gk39ZeUZ9hdqKda+zof3w1vIvgJkVPm4=;
 b=HWdueoh8mM1O+2YRKophKISAr5RKoOtA80KZNi1p1JgSVuIQwe0bsQIG9k4/o0PMLlvT
 qDCUmf3Smgj173G57tMRFK7CfShwtBonREVitok3drFIiFmxSGYsKGcTeyHX449fL77N
 os9O0CC2mgg1yCZrAKNWSN82ayMmcf2MkYFsIXih6X1hVS6qRKwjxYriB8evy4cgU+2f
 rfe4iT/dbbkzif3jrzD+aLP2tiZ0HoolD3Aswye4Q5iAZGAAGRwKsp+U17bEZda51et+
 YfqqSFJmNskjfKhqTkAy3OXLuQlLCFKe8VRgxM1wgqLl49oTzAr0NNoNvtJALha8c5nQ Mw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1w88tr5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:39 -0800
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub203.TheFacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:39 -0800
Received: from twshared7043.05.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:38 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 2603DA173A1F; Thu, 24 Nov 2022 01:36:21 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 9/9] io_uring: allow multishot polled reqs to defer completion
Date:   Thu, 24 Nov 2022 01:35:59 -0800
Message-ID: <20221124093559.3780686-10-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: KZMBmWDFU1LPRUYwCbpuvyy6EU8KmNG9
X-Proofpoint-GUID: KZMBmWDFU1LPRUYwCbpuvyy6EU8KmNG9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Until now there was no reason for multishot polled requests to defer
completions as there was no functional difference. However now this will
actually defer the completions, for a performance win.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f0e5ae7740cf..164904e7da25 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1805,7 +1805,8 @@ int io_poll_issue(struct io_kiocb *req, bool *locke=
d)
 	io_tw_lock(req->ctx, locked);
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -EFAULT;
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT);
+	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT|
+				 IO_URING_F_COMPLETE_DEFER);
 }
=20
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
--=20
2.30.2

