Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098375248BA
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 11:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351886AbiELJSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 05:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351877AbiELJSs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 05:18:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5EC22782C
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 02:18:47 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BMwcRC002014
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 02:18:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=qb8qhPLHzq0EH/CymmI5Fcp6Hy360LSsgnIx1SZs8HQ=;
 b=HPCaz8o+r9oswo/04M1aFkHTd6wmAq2ISf1WB04Qm72U8hqH36+hN8Arg1fPkwHbxJqy
 uuBj2CvBRXHzG5Jzz+AF0MaCnlinmkkAMD3k/dko59j3DuXjKEd7ORr5ExsYFbp5XAOd
 kxCIhaofxpD5zh2DqK2nuzKgnBAIapU4uck= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g0gat5gjh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 02:18:46 -0700
Received: from twshared25848.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 12 May 2022 02:18:44 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id C464D8F0223B; Thu, 12 May 2022 02:18:36 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 1/2] io_uring: fix ordering of args in io_uring_queue_async_work
Date:   Thu, 12 May 2022 02:18:33 -0700
Message-ID: <20220512091834.728610-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220512091834.728610-1-dylany@fb.com>
References: <20220512091834.728610-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: zVWPPzKAq_jhQz30swzR2sKLlIBbAR4v
X-Proofpoint-GUID: zVWPPzKAq_jhQz30swzR2sKLlIBbAR4v
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

Fix arg ordering in TP_ARGS macro, which fixes the output.

Fixes: 502c87d65564c ("io-uring: Make tracepoints consistent.")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/trace/events/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 630982b3c34c..ef186809ce97 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -148,7 +148,7 @@ TRACE_EVENT(io_uring_queue_async_work,
 	TP_PROTO(void *ctx, void * req, unsigned long long user_data, u8 opcode=
,
 		unsigned int flags, struct io_wq_work *work, int rw),
=20
-	TP_ARGS(ctx, req, user_data, flags, opcode, work, rw),
+	TP_ARGS(ctx, req, user_data, opcode, flags, work, rw),
=20
 	TP_STRUCT__entry (
 		__field(  void *,			ctx		)
--=20
2.30.2

