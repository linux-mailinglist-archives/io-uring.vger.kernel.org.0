Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56863754A
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKXJgk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiKXJgi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:38 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577AA12297E
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:37 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANHsDVK024532
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=ypQnsRu7Buxort9bAj70n6tcg67nT7jZNP2MzV/nQ6Y=;
 b=hBe8Rr9MLcPbOyhk5sWaEXtWeKUl4+l8/4duBGh/31+4dk/k0FuD9h4e8wdC9d4uSYVR
 n+soqGwUFaCz6lOt95br0H5azok4W7CbFKgcGRepTG9NijOztgAUx8cULTR6zVOS4tPY
 H+ftY7bpDVXAV+78CJzidTgZvsoslp3qaYBqdwcCKlw+W6kIxe1OxDyc8StaYo3oZsow
 7Yysw3mX5me/EaKjtBK9PE92Z016z7j9BW3UGcEpbCsWYvthEtEbKRF+gXvamh9yZFu8
 8UTuH3e5MWNQjzsCqek/e9MF3rW246onjJqjF3VPDVYN3xLMdE+Tqa45dEw67o3vvAYq Cg== 
Received: from maileast.thefacebook.com ([163.114.130.3])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1cg3s8x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:36 -0800
Received: from twshared8047.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:35 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0019BA173A18; Thu, 24 Nov 2022 01:36:20 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 6/9] io_uring: make io_fill_cqe_aux static
Date:   Thu, 24 Nov 2022 01:35:56 -0800
Message-ID: <20221124093559.3780686-7-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: oTAvkL_OUhYR54syrn1gtWFhAaQqVVIA
X-Proofpoint-GUID: oTAvkL_OUhYR54syrn1gtWFhAaQqVVIA
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

This is only used in io_uring.c

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/io_uring.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4f48e8a919a2..92a7d6deacb6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -770,8 +770,8 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx =
*ctx, bool overflow)
 	return &rings->cqes[off];
 }
=20
-bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
-		     bool allow_overflow)
+static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 =
res, u32 cflags,
+			    bool allow_overflow)
 {
 	struct io_uring_cqe *cqe;
=20
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dd02adf3d0df..46694f40bf72 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -34,8 +34,6 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)=
;
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
 		     bool allow_overflow);
-bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
-		     bool allow_overflow);
 bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 =
res, u32 cflags,
 		bool allow_overflow);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
--=20
2.30.2

