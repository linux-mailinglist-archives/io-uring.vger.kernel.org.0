Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAEE635B02
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbiKWLHr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237748AbiKWLHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:07:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6285F9F
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:55 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB4GCA001713
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=bLNGZhlpyHKXbaemEZ2JEZ10+s6g9IYZV+VGqpv0h5Y=;
 b=muB/CnN0rNhdfWlIvkMyM1Oam9JhaMK65D+2gksTJBeIib+KRelqvoytO1CViKEShR66
 Zer+F6trRETd94J5ieUAhkVlqjDtlktqjMPVB2o0Ud/YnYcfE63x99vgM9LnV2cIeTv8
 3XAk6PBPp2GUYSxNEruJiFOuYpHfsm5iiVlP2lceceXGcosYV/C58F5s/giCCLzndrn8
 OC3tyJ432bz9MWcdnvzcg8TZUqdZQALme3Gj/3wcELLn5OhJm0Q7RysNtr8ySF/5HOe6
 JnL7LBWA4MBz/f62upIt3PyzM/wtZK4wHdLIZkvMch73IEQsoZAFUXb2D9Y5Bku8CJ/w AQ== 
Received: from maileast.thefacebook.com ([163.114.130.3])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m0javkw9g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:54 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:52 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id BF395A0804DB; Wed, 23 Nov 2022 03:06:27 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 10/13] io_uring: make io_fill_cqe_aux static
Date:   Wed, 23 Nov 2022 03:06:11 -0800
Message-ID: <20221123110614.3297343-11-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: loFo_cCB6iNEiqg6-DHTgco1cwyeV9fh
X-Proofpoint-GUID: loFo_cCB6iNEiqg6-DHTgco1cwyeV9fh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
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
index 37b195d85f32..42c7383ead91 100644
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
index e075c4fb70c9..4519d91008de 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -34,8 +34,6 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)=
;
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
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

