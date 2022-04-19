Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0662507B6A
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357858AbiDSU7f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 16:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357857AbiDSU7e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 16:59:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4304132B
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:50 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23JGdvHE020072
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=apGns2hv2Kojna43sNpICvdsJ0mw7txl6GqDyuzbyqg=;
 b=Rl/zt96JLpLExDL92qySiRE4bHpNtbWPPwC0A6IzeXLJKZ6nGr1muu9IatpHXzLbpmEP
 CWJWfyVU653fhAiOc0kazlS5vwUG4PsDJ9fdsuMxfDfLSw2nrM1p2TQtDl4oioxuRF9Y
 CCEhw+ANxUN95/t0ougFI62TG2nG/Q+wf3M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ffsfwawtr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:47 -0700
Received: from twshared16483.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:56:45 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id E7804DD45FDF; Tue, 19 Apr 2022 13:56:35 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v1 02/11] io_uring: wire up inline completion path for CQE32
Date:   Tue, 19 Apr 2022 13:56:15 -0700
Message-ID: <20220419205624.1546079-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205624.1546079-1-shr@fb.com>
References: <20220419205624.1546079-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: v13YCnZXJjOsGwG7yaU_euXREfvrvaBk
X-Proofpoint-GUID: v13YCnZXJjOsGwG7yaU_euXREfvrvaBk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_07,2022-04-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than always use the slower locked path, wire up use of the
deferred completion path that normal CQEs can take. This reuses the
hash list node for the storage we need to hold the two 64-bit values
that must be passed back.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4c32cf987ef3..bf2b02518332 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -964,7 +964,13 @@ struct io_kiocb {
 	atomic_t			poll_refs;
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
-	struct hlist_node		hash_node;
+	union {
+		struct hlist_node	hash_node;
+		struct {
+			u64		extra1;
+			u64		extra2;
+		};
+	};
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
--=20
2.30.2

