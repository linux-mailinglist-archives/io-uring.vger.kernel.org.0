Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FF2638794
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 11:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiKYKee (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 05:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiKYKed (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 05:34:33 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D12931238
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:32 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP4oTSV016731
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=P7yTMIOnFcIis1FwEoARvVLBdtf6/yttrHIQzWbzZHE=;
 b=OvemSbvbcwCe4mRZVvTHjqrVMDi90FJ9LBWdJCcnGN9b0IUc8KHX+Q9nz00VrilRp6Fo
 C9uOf5PDWhhm3TxxSncOwodNGDpnVMgNLQpt5XPWw6voL+Bmb1wiwi9pd0IPgD3kFnuu
 mCQ0AczDGc30W2eE9jMY8jnaj6Yv2lFVq3axddoksT4G+22axZKUwA99TfeJjGIlX4J0
 Y7XYjtb5Q+qCWmuhxOVzmOy8paxltaZGtNtnNNmHFbrR71mUeWN93aYt/swOd7q30nDZ
 jzFzwvjxf0G016Srma8ZlTJlSDkwgu1EGqDvUae4Yar9lQ14U5HEO3jBq+JCMYo5z03s Uw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1w891x05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:31 -0800
Received: from twshared8047.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 02:34:30 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E5461A283EC8; Fri, 25 Nov 2022 02:34:20 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 1/3] io_uring: remove io_req_complete_post_tw
Date:   Fri, 25 Nov 2022 02:34:10 -0800
Message-ID: <20221125103412.1425305-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221125103412.1425305-1-dylany@meta.com>
References: <20221125103412.1425305-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: okJ3g0DNibugIMVvzprJLgQKHgSPXLq3
X-Proofpoint-GUID: okJ3g0DNibugIMVvzprJLgQKHgSPXLq3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's only used in one place. Inline it.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 164904e7da25..38589cf380d1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1521,7 +1521,7 @@ void io_req_task_complete(struct io_kiocb *req, boo=
l *locked)
 	if (*locked)
 		io_req_complete_defer(req);
 	else
-		io_req_complete_post_tw(req, locked);
+		io_req_complete_post(req, IO_URING_F_UNLOCKED);
 }
=20
 /*
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dcb8e3468f1d..76659d2fc90c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -37,13 +37,6 @@ bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u=
64 user_data, s32 res, u32
 		bool allow_overflow);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
=20
-static inline void io_req_complete_post_tw(struct io_kiocb *req, bool *l=
ocked)
-{
-	unsigned flags =3D *locked ? 0 : IO_URING_F_UNLOCKED;
-
-	io_req_complete_post(req, flags);
-}
-
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *n=
pages);
=20
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
--=20
2.30.2

