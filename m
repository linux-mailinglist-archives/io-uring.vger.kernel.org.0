Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074EA631E5C
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKUKaH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKUKaG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:30:06 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F991DF3B
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:30:05 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKNt8Kr008867
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:30:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=gCcaYV5ZDcJMmdmNHT3t2urXtrSvZCQor+dsB0KT/HA=;
 b=U6mnar8pSrS2MM8nRc1prMf7qNXSMYaa84qiyXcXqBU2U+C8xsjzueo4im8RIPJnmXTX
 67skiZott2VUhJVyuDaaRHmIu689BAPHfqwjRyUjae1EVFnp7StpA/3VoY81vO3XGdPG
 LSD1zobqPABon34vg01d/H1jQ1/XypF9H1zJ8dG1KGi9OvFr3kCpjyRMEXBHfnJKq64G
 v5JFLsvZf3Un+203wjRwhuzbsx6npQbaJtfxW1zITV1pS1nlCLhXB1C66LwvYGaHDV+Y
 z5OLpPbOBOEOwShOo7Bi/K6rppURoItWF8rxiC3Yo3z1PimXBvE+cOppEsSwHGqdpJbF LA== 
Received: from maileast.thefacebook.com ([163.114.130.8])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kxwqtuevr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:30:04 -0800
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:30:03 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 923B09E66F80; Mon, 21 Nov 2022 02:03:56 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 07/10] io_uring: make io_req_complete_post static
Date:   Mon, 21 Nov 2022 02:03:50 -0800
Message-ID: <20221121100353.371865-8-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121100353.371865-1-dylany@meta.com>
References: <20221121100353.371865-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vKkyg9990ejS3bAi6a24vDBDEJol1CRu
X-Proofpoint-GUID: vKkyg9990ejS3bAi6a24vDBDEJol1CRu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is only called from two functions in io_uring.c so remove the header
export.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2177b3ef094a..715ded749110 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -849,7 +849,7 @@ static void __io_req_complete_put(struct io_kiocb *re=
q)
 	}
 }
=20
-void io_req_complete_post(struct io_kiocb *req)
+static void io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx =3D req->ctx;
=20
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 1daf236513cc..bfe1b5488c25 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -31,7 +31,6 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *=
locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
-void io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
 bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
--=20
2.30.2

