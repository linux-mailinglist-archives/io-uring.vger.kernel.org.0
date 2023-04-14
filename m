Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289A46E2C9A
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 00:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjDNWzo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 18:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDNWzn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 18:55:43 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198D772BE
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 15:55:42 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EMtIqZ010771
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 15:55:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=PWgpLMwEoeKsjWAD+ht5qN5ZNQcpQMzIXg7FG6zhkWY=;
 b=Hod5OUekIHH/ab392PwT4E08t/4eAm1n7R0qfhEkPTHIyyY852rbG6qTt2V8x4w4XF8+
 QcI9ZjeMlEgSuBMYZEmIRdmFG2/UIq4R2AoO6TeDkr8WrHT71cDeJTBSpZs5l2Kkc86y
 N3CPo15s3Tk53dhDrfnLl/rIExenxWVhpuMn8WwKCIa5EfD7rqvppFOTRqzNnhzqoDtM
 WLPgoDHOMdZPRSpS7oMJwgNzRkMyT2Ra7JoLnfxt8eHdkUgcx1bwsQWm9ChIzY8t1e+o
 oUCjfUPxcSaKzTbvNhl0PaqfvLPLto+aoKCJ6CGMCb/jYTooWWDdafI1q9A0UruD/dkR /w== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3pxx65wyt7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 15:55:41 -0700
Received: from twshared35445.38.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 14 Apr 2023 15:55:38 -0700
Received: by devbig023.atn6.facebook.com (Postfix, from userid 197530)
        id 65F128EDA890; Fri, 14 Apr 2023 15:55:33 -0700 (PDT)
From:   David Wei <davidhwei@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, David Wei <davidhwei@meta.com>
Subject: [PATCH v3 2/2] liburing: update man page for multishot timeouts
Date:   Fri, 14 Apr 2023 15:55:06 -0700
Message-ID: <20230414225506.4108955-3-davidhwei@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230414225506.4108955-1-davidhwei@meta.com>
References: <20230414225506.4108955-1-davidhwei@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NUbTDHJANE7AQyepHaqMawDAdDNrZHLm
X-Proofpoint-GUID: NUbTDHJANE7AQyepHaqMawDAdDNrZHLm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_14,2023-04-14_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: David Wei <davidhwei@meta.com>
---
 man/io_uring_prep_timeout.3 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man/io_uring_prep_timeout.3 b/man/io_uring_prep_timeout.3
index bfb8791..f4036e6 100644
--- a/man/io_uring_prep_timeout.3
+++ b/man/io_uring_prep_timeout.3
@@ -51,6 +51,13 @@ Normally a timeout that triggers would return in a
 CQE
 .I res
 value.
+.TP
+.B IORING_TIMEOUT_MULTISHOT
+The request will return multiple timeout completions. The completion fla=
g
+IORING_CQE_F_MORE is set if more timeouts are expected. The value specif=
ied in
+.I count
+is the number of repeats. A value of 0 means the timeout is indefinite a=
nd can
+only be stopped by a removal request.
 .PP
 The timeout completion event will trigger if either the specified timeou=
t
 has occurred, or the specified number of events to wait for have been po=
sted
--=20
2.34.1

