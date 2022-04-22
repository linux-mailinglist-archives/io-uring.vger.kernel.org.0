Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2570A50BC76
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358721AbiDVQEw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 12:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358809AbiDVQEu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 12:04:50 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A8E5BE70
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:57 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23MFRrgD001341
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=61DgPiGwxtBLKnIeSfHJk3Nr9/xzhaRwE1gmUZyX6NU=;
 b=Iu4Nr4otrtemv+qvuTgauNLWpAHY9k8jNRt7yk2B76hCL1QPY2xO6V85/OQGh/jDrVjm
 ajqoeQLuQtBEQPNKhXVU2rAlaXtPv/+lm3YyxUaDp3lNmuV7ZZsrQjOFgrSfgdPlmfNq
 O8lAQdM9DcetcJ0/IJN1LduypQxoYoLxzeU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fkd7rx3ut-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:56 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 09:01:55 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 8A3867E01540; Fri, 22 Apr 2022 09:01:41 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 5/7] test: mkdir -p output folder
Date:   Fri, 22 Apr 2022 09:01:30 -0700
Message-ID: <20220422160132.2891927-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220422160132.2891927-1-dylany@fb.com>
References: <20220422160132.2891927-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: WBI69jrrTgiXhRo51kw6XaFsHQIfAjR4
X-Proofpoint-ORIG-GUID: WBI69jrrTgiXhRo51kw6XaFsHQIfAjR4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_04,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case multiple mkdir are running at once, do not log an error if it
exists due to a race condition.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/runtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/runtests.sh b/test/runtests.sh
index 122e482..6d8f7af 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -139,7 +139,7 @@ run_test()
 # Run all specified tests
 for tst in "${TESTS[@]}"; do
 	if [ ! -d output ]; then
-		mkdir output
+		mkdir -p output
 	fi
 	if [ -z "${TEST_MAP[$tst]}" ]; then
 		run_test "$tst"
--=20
2.30.2

