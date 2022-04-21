Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB98509C10
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387453AbiDUJUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387450AbiDUJT6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:19:58 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483A714084
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:09 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23KL3Pme007320
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DX6ytzEKTL5duvmKH/e/++KuZNvGuRCr7bx9oCW9eMA=;
 b=od7P82sRevfiZJOcn5YV5zeOVrsGoTp6XSZMp1F7jpFZ36U7oc4jqbq/UBEgOQV7gsE/
 qfEzophPeVsnMQxY+zeuAHqk7eLPKY77JMfu7cArYmfWUCGpGTWcczfmSZKvx/SYUpey
 aj8JQZM7/Tbxv3GeVxnYaVpVN5Mq/en49Ec= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fjsrju40q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:08 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub103.TheFacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:17:07 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:17:06 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id EB3EF7CA75FC; Thu, 21 Apr 2022 02:14:01 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 2/6] io_uring: trace cqe overflows
Date:   Thu, 21 Apr 2022 02:13:41 -0700
Message-ID: <20220421091345.2115755-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091345.2115755-1-dylany@fb.com>
References: <20220421091345.2115755-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: VllGvL6ife8jR31HVOYs5QzkEQYO431P
X-Proofpoint-GUID: VllGvL6ife8jR31HVOYs5QzkEQYO431P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Trace cqe overflows in io_uring. Print ocqe before the check, so if it is
NULL it indicates that it has been dropped.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e1d5243bbbc..d654faffa486 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2107,6 +2107,7 @@ static bool io_cqring_event_overflow(struct io_ring=
_ctx *ctx, u64 user_data,
 	struct io_overflow_cqe *ocqe;
=20
 	ocqe =3D kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
+	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
 	if (!ocqe) {
 		/*
 		 * If we're in ring overflow flush mode, or in task cancel mode,
--=20
2.30.2

