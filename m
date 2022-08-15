Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A614592FE4
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiHON1X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241744AbiHON1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:27:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B791F2E5
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:27:15 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27F3GEti005327
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:27:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=elo11oeZTA1gSvwZSKIWM7v1BAL4ib92riEy4sbRovY=;
 b=DtqsC80pbkqM73COuqxddmo2GugwpPZOyI3wwJ7MFHSc7VBO4uNrpEIEEF21sdBpbaxg
 YXzj65OZcJ8d/BXtywbTxs9bVCCW4C4npO81ah+vQBfJvp+yBfEmSqJwvIJO+g4cYWVK
 ZNcAjzLcJ2BZ2kC877Flgtaw5myj0S+0Dx4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hx7mx2n3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:27:14 -0700
Received: from twshared25684.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:27:13 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 640DF49B7311; Mon, 15 Aug 2022 06:09:55 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 09/11] expose CQ ring overflow state
Date:   Mon, 15 Aug 2022 06:09:45 -0700
Message-ID: <20220815130947.1002152-10-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130947.1002152-1-dylany@fb.com>
References: <20220815130947.1002152-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: JKgV_R9NIIB54MB9b9AOqSjxsp6tRrQ-
X-Proofpoint-GUID: JKgV_R9NIIB54MB9b9AOqSjxsp6tRrQ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 6b25c358c63f..47668c3f26a7 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1064,6 +1064,15 @@ static inline unsigned io_uring_cq_ready(const str=
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

