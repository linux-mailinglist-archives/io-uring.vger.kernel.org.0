Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E7A561633
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiF3JVY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiF3JVR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:21:17 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9071B3CFCA
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:14 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0La7e008170
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=2nIzbijtoANac14n5z+hDP1FKE7gnAEKn4hYu+nUwCk=;
 b=fX0vLhUPzwCzucH5KJJNd1ShqfBEreANWLxyO/nxefI/brQqXQHAEr66JV4+ukBqlwvB
 HFbdj8RztxmiNdeJGplpTTHuRWXXmtiDCIKJmCUM3JnRFWw6WljBaj79907iqJpC6EQ3
 WwGwq8y2/dPrmSAsSh5GNgeRM2IIj8QhOnI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0qgqxedn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:08 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:21:07 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id D898C2599FE4; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 11/12] io_uring: fix io_uring_cqe_overflow trace format
Date:   Thu, 30 Jun 2022 02:12:30 -0700
Message-ID: <20220630091231.1456789-12-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 7pfp2hicaU7ENmH43gsJZRVK-7vaUvdX
X-Proofpoint-ORIG-GUID: 7pfp2hicaU7ENmH43gsJZRVK-7vaUvdX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make the trace format consistent with io_uring_complete for cflags

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/trace/events/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 918e3a43e4b2..95a8cfaad15a 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -594,7 +594,7 @@ TRACE_EVENT(io_uring_cqe_overflow,
 		__entry->ocqe		=3D ocqe;
 	),
=20
-	TP_printk("ring %p, user_data 0x%llx, res %d, flags %x, "
+	TP_printk("ring %p, user_data 0x%llx, res %d, cflags 0x%x, "
 		  "overflow_cqe %p",
 		  __entry->ctx, __entry->user_data, __entry->res,
 		  __entry->cflags, __entry->ocqe)
--=20
2.30.2

