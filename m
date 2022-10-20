Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59406605F4D
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 13:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiJTLvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 07:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJTLvq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 07:51:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D03B1C6BE7
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 04:51:45 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 29K8KA1O020833
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 04:51:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=u+3OWBUDOoX66R5wv8E+o2AQ8PfvzE/ISOfi6efA3tE=;
 b=IDzHbNvtVhRWzpDz8yV0cFAr0hCnsynE9heTVP5AKNh/NCRZzePRKEaJD55GzfbKIkzj
 ot//CnU6QxeKzaBCp4OE7gja9mw/Kkv8JbHZNuiK33CbrOMdZq71jJWUdXIJlp138c0V
 EJsJx6bFaIf9RLggTCDMt8POWiUZrQe8EQOJtwrQjgAY2ORHQ8NWtza0bDoPTx9jPYC9
 Fp3+kRT3xORy7bs5XS6zznFdgyXvMsx9Nz+7iqRCEtmXgSnMtPGeskCLAmuOfWrM+wWz
 YjNHp55AngcoqFVPwWnyzGyejWkAyD9bp7Z6LhCmGKBVTI1ND6tAcHwNGgmBHW5Q4DI5 hA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3kb2qp9rhk-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 04:51:44 -0700
Received: from twshared0933.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 04:51:43 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id EC2317FF03CB; Thu, 20 Oct 2022 04:51:41 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, Dylan Yudaken <dylany@meta.com>,
        Frank Rehwinkel <frankrehwinkel@gmail.com>
Subject: [PATCH liburing] Document maximum ring size for io_uring_register_buf_ring
Date:   Thu, 20 Oct 2022 04:51:41 -0700
Message-ID: <20221020115141.3723324-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: oS8lZ-D-omJGbGGig6U0Qmd_EYsRbERI
X-Proofpoint-ORIG-GUID: oS8lZ-D-omJGbGGig6U0Qmd_EYsRbERI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The maximum size was not documented, so do that.

Reported-by: Frank Rehwinkel <frankrehwinkel@gmail.com>
Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 man/io_uring_register_buf_ring.3 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_register_buf_ring.3 b/man/io_uring_register_buf=
_ring.3
index f75063fc9f2c..357a3fb39a0c 100644
--- a/man/io_uring_register_buf_ring.3
+++ b/man/io_uring_register_buf_ring.3
@@ -55,7 +55,8 @@ or similar. The size of the ring is the product of
 and the size of
 .IR "struct io_uring_buf" .
 .I ring_entries
-is the desired size of the ring, and must be a power-of-2 in size.
+is the desired size of the ring, and must be a power-of-2 in size. The m=
aximum size=20
+allowed is 2^15 (32768).
 .I bgid
 is the buffer group ID associated with this ring. SQEs that select a buf=
fer
 has a buffer group associated with them in their

base-commit: 13f3fe3af811d8508676dbd1ef552f2b459e1b21
--=20
2.30.2

