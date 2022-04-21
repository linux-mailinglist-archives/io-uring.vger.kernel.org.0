Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F9B509BE9
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387524AbiDUJVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387511AbiDUJUv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:20:51 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0482611F
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:02 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23L7a8Dp008741
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=bJuM65BpJc63NMFO9/NkHf3pcltJlPS/DFBpKaOaQPk=;
 b=lldiBU3PAH0YDZFW6BV/8sBLbXKVgyuc09Zrbtl5fFGImHZmPvMjWaNqp0g3KqH11ADx
 MABcQ0/OTZhJaa8Vjgh3IxymUE/LJvujESgWdK0vR/fR1kh4gvkgj1O3qBTiup5AqoLJ
 J6BalZHxlbWkeB8zaU73UEZJwDFQ0sHfGGI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fj9p20w40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:02 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:18:01 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id DC9A87CA771C; Thu, 21 Apr 2022 02:14:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 2/5] update io_uring_enter.2 docs for IORING_FEAT_NODROP
Date:   Thu, 21 Apr 2022 02:14:24 -0700
Message-ID: <20220421091427.2118151-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091427.2118151-1-dylany@fb.com>
References: <20220421091427.2118151-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dWksx70JQy3sq0dI7Ptskcsw_Ehkgoha
X-Proofpoint-GUID: dWksx70JQy3sq0dI7Ptskcsw_Ehkgoha
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The EBUSY docs are out of date, so update them for the IORING_FEAT_NODROP
feature flag

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_enter.2 | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 22dbbd5..3112355 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1327,7 +1327,18 @@ is a valid file descriptor, but the io_uring ring =
is not in the right state
 for details on how to enable the ring.
 .TP
 .B EBUSY
-The application is attempting to overcommit the number of requests it ca=
n have
+If the
+.B IORING_FEAT_NODROP
+feature flag is set, then
+.B EBUSY
+will be returned if there were overflow entries,
+.B IORING_ENTER_GETEVENTS
+flag is set and not all of the overflow entries were able to be flushed =
to
+the CQ ring.
+
+Without=20
+.B IORING_FEAT_NODROP
+the application is attempting to overcommit the number of requests it ca=
n have
 pending. The application should wait for some completions and try again.=
 May
 occur if the application tries to queue more requests than we have room =
for in
 the CQ ring, or if the application attempts to wait for more events with=
out
--=20
2.30.2

