Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441A55A933C
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbiIAJeC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234157AbiIAJdr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:47 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE26133F2F
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:44 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2819Wnjw003109
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TPzIUCvI+bEJwioztEWjiUFsQfWSFij/MhONrauDgfM=;
 b=UEgQkWf2HsDu1C0KCbXJyeFueJOPHFppWJryFq3zssUXYHwDU2KvyKrbWZEQOEAdUkSo
 VdqDM2yL57xHTveNKvqZaWYXHMrLQ/VM23t6KH6M1tmZyWoSIct9xlK6Gfs/QeOkleHG
 dLTU8n7jFwi40AyyQA8+kq8RML5Q1eSVcNE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jat6s005c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:42 -0700
Received: from twshared8288.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:33 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id CF6085769402; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 09/12] expose CQ ring overflow state
Date:   Thu, 1 Sep 2022 02:33:00 -0700
Message-ID: <20220901093303.1974274-10-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901093303.1974274-1-dylany@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Yty35S0fBUaACgEmQMExvpSs12WX9bTD
X-Proofpoint-ORIG-GUID: Yty35S0fBUaACgEmQMExvpSs12WX9bTD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allow the application to easily view if the CQ ring is in overflow state =
in
case it would like to explicitly flush using io_uring_get_events.

Explicit flushing can be useful for applications that prefer to have
reduced latency on CQs than to process as many as possible.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 3c5097b255de..ca8fbd608901 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1086,6 +1086,15 @@ static inline unsigned io_uring_cq_ready(const str=
uct io_uring *ring)
 	return io_uring_smp_load_acquire(ring->cq.ktail) - *ring->cq.khead;
 }
=20
+/*
+ * Returns true if there are overflow entries waiting to be flushed onto
+ * the CQ ring
+ */
+static inline bool io_uring_cq_has_overflow(const struct io_uring *ring)
+{
+	return IO_URING_READ_ONCE(*ring->sq.kflags) & IORING_SQ_CQ_OVERFLOW;
+}
+
 /*
  * Returns true if the eventfd notification is currently enabled
  */
--=20
2.30.2

