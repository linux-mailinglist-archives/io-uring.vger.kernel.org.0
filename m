Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340DD61F3EB
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 14:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiKGNEQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 08:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbiKGNEO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 08:04:14 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152B21C906
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 05:04:12 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75wJJH029653
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 05:04:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=6BMeufojqvo+7Q7A5+h0+mZ9Xnge4egjhgveabMAng4=;
 b=VLJVPvj8Be0oeO/lM/G2tXz+jWzmJqPv5XfL8YZ/zC7dRLjogvUiFlA6UJOr3TMnV5fp
 6sEBmb6TojPG6i395YR+7Y2Ribpgciud4sTHo/PusF+NGUbkiPlwu1vGo+OxRfYgc8Tm
 Fh2sz5vPtxfNyOc8mZqC+cdFumnS9SfKAcGY9yd+LgeYyBBrVIoJeCYBqhD1ubONDqB4
 7b6tF2L4kOf7my1juCjdPlXdMPT6n6oD0MdWdPImM8ANMpPjpy6X+emJOq5VdIjfZ+6+
 jqwGjGq8Kdxt18HUiArE0lhj4SZiwMyChaHfapwEY1exw5mQ51jeTtNEF1FFQxrj8uT5 iQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knmxsp28u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 05:04:11 -0800
Received: from twshared5287.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 05:04:10 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 6E4EB90D8037; Mon,  7 Nov 2022 05:04:05 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing] Do not always expect multishot recv to stop posting events
Date:   Mon, 7 Nov 2022 05:04:04 -0800
Message-ID: <20221107130404.360691-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7AaGzQSzYdUmrHr0wQEWB31s8xicbd51
X-Proofpoint-GUID: 7AaGzQSzYdUmrHr0wQEWB31s8xicbd51
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_06,2022-11-07_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Later kernels can have a fix that does not stop multishot from posting
events, and would just continue in overflow mode.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 test/recv-multishot.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/test/recv-multishot.c b/test/recv-multishot.c
index 2cfe6898de4c..ed26a5f78759 100644
--- a/test/recv-multishot.c
+++ b/test/recv-multishot.c
@@ -264,11 +264,19 @@ static int test(struct args *args)
=20
 		bool const is_last =3D i =3D=3D recv_cqes - 1;
=20
+		/*
+		 * Older kernels could terminate multishot early due to overflow,
+		 * but later ones will not. So discriminate based on the MORE flag.
+		 */
+		bool const early_last =3D args->early_error =3D=3D ERROR_EARLY_OVERFLO=
W &&
+					!args->wait_each &&
+					i =3D=3D N_CQE_OVERFLOW &&
+					!(cqe->flags & IORING_CQE_F_MORE);
+
 		bool const should_be_last =3D
 			(cqe->res <=3D 0) ||
 			(args->stream && is_last) ||
-			(args->early_error =3D=3D ERROR_EARLY_OVERFLOW &&
-			 !args->wait_each && i =3D=3D N_CQE_OVERFLOW);
+			early_last;
 		int *this_recv;
 		int orig_payload_size =3D cqe->res;
=20

base-commit: 754bc068ec482c5338a07dd74b7d3892729bb847
--=20
2.30.2

