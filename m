Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3812D50F5FF
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 10:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345303AbiDZIls (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 04:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345824AbiDZIje (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 04:39:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF3D7486B
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:31:57 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 23Q1NhWW001849
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:31:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Fr7tFEI87R7I3TlKgd8ZZnv0t+PRO7tv5Y02UGJ/UNI=;
 b=CUQGQWeG45WYFT/fMIijcYLw1xt3jHxqloGVnhZT0VZi3G9w60cUzOLpDDYxsiXWWxIc
 GBFulvwPznI9JZybMajXqAusZdy+uAFFB59r9/ZY6EimlOS7tKNPHaKlMPRcMvtLwMxn
 +j8eVOWUu1ZxUKELSwcADXNmIfB/VxDEGzU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fmd4rrkgc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:31:56 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 01:31:54 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id D5A6D81D594F; Tue, 26 Apr 2022 01:29:15 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v3 3/4] io_uring: rename op -> opcode
Date:   Tue, 26 Apr 2022 01:29:06 -0700
Message-ID: <20220426082907.3600028-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426082907.3600028-1-dylany@fb.com>
References: <20220426082907.3600028-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vwoevv_pPrKvlgwGcUDCFiwfD2Q3mDYa
X-Proofpoint-GUID: vwoevv_pPrKvlgwGcUDCFiwfD2Q3mDYa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

do this for consistency with the other trace messages

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/trace/events/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 05b786f8b0bf..42c7e1a3c6ae 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -530,7 +530,7 @@ TRACE_EVENT(io_uring_req_failed,
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, "
-		  "op %d, flags 0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
+		  "opcode %d, flags 0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
 		  "len=3D%u, rw_flags=3D0x%x, buf_index=3D%d, "
 		  "personality=3D%d, file_index=3D%d, pad=3D0x%llx, addr3=3D%llx, "
 		  "error=3D%d",
--=20
2.30.2

