Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A844450E407
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 17:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbiDYPLE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 11:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiDYPLE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 11:11:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2207668307
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 08:08:00 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 23P76EUl024928
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 08:07:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TDos8lcvwMPUpoVNgDYbiAb9luAiaipjU8+DZffgIe4=;
 b=MSYr7+wv7ZVhcizCNnh5L1wVM5W2pHobtPjRICY/BiTXr/4LlpJ9DRaPd2ao62l3LoyC
 PSDCxVoeYH1mDSxUug9JiAsddiboNQYfO3SHYWZ3QLQ8NiJqNrFrcWSHKKxU5iy0vkww
 1uQMpkhDtQ7CXz9UftoG0PcAuoPtp591B8A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fmd4rjrga-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 08:07:58 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 08:07:56 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 1BE00811B421; Mon, 25 Apr 2022 08:07:54 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 1/4] io_uring: add type to op enum
Date:   Mon, 25 Apr 2022 08:07:37 -0700
Message-ID: <20220425150740.2826784-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425150740.2826784-1-dylany@fb.com>
References: <20220425150740.2826784-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dj7wcQVkhxZV-q0Y9QuUgER_myN7O8IW
X-Proofpoint-GUID: dj7wcQVkhxZV-q0Y9QuUgER_myN7O8IW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_08,2022-04-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is useful to have a type enum for opcodes, to allow the compiler to
assert that every value is used in a switch statement.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/uapi/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 980d82eb196e..a10b216ede3e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -103,7 +103,7 @@ enum {
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
=20
-enum {
+enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
 	IORING_OP_WRITEV,
--=20
2.30.2

