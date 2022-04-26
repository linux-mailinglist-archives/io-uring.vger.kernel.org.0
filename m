Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89B650F4B8
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 10:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiDZIkC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 04:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345299AbiDZIhs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 04:37:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653AD91546
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:29:29 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q1Ng0H030666
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:29:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=l96gmu+vo1yy5VZGmDq+B6Ej86jYsxcEUNWIu3jlvEU=;
 b=WznR+FL3RIxFI6WymYaIxionNmdoBGkxIL51PAwyJOVrkl8ePLPGAoH8J00rc2CzhmRv
 tQejjFAm9f86zc2aMJ8nb/ZypVesAYk8u5MxuKOF1oaX6f/TrXdI4T1PVZfbdu7Fvx/2
 m1JFummjOmr4nq/gcJgd/zolWYXvY2elpIg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fp6a31q0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:29:29 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 01:29:28 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id AFF4C81D5943; Tue, 26 Apr 2022 01:29:14 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v3 1/4] io_uring: add type to op enum
Date:   Tue, 26 Apr 2022 01:29:04 -0700
Message-ID: <20220426082907.3600028-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426082907.3600028-1-dylany@fb.com>
References: <20220426082907.3600028-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: roH4uTupiAbeWNXjZoWe3v1SKboxVE8B
X-Proofpoint-ORIG-GUID: roH4uTupiAbeWNXjZoWe3v1SKboxVE8B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
index 5fb52bf32435..49d1f3994f8d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -105,7 +105,7 @@ enum {
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

