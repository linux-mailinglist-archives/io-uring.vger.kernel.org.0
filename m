Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8F750B66E
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387937AbiDVLvm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 07:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447169AbiDVLvl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 07:51:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8037356414
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:48 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23LNWeEI031015
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9WuIuJmN0dAriI+LOLWlvlSZuUGXP7INqvYC4WD8/IU=;
 b=D7rYVf354q0VeefX/4hUgWfaTqnw3yXQUabch51p4nBQA+wPQjy7Ww7pbVCSLOlGdVB4
 2AbcZ8ns02kKFfDfwfLS1ZB1IUYAmODaY19sAL89mZRjdsJm0yzihDs6eTeju29cfWLt
 9JFGcerBYFCyAPTcBbpB0iosWTFkW0VR6dg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fket43wf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:48 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 04:48:46 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id A91407DC56B9; Fri, 22 Apr 2022 04:48:31 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 6/7] test: add make targets for each test
Date:   Fri, 22 Apr 2022 04:48:14 -0700
Message-ID: <20220422114815.1124921-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220422114815.1124921-1-dylany@fb.com>
References: <20220422114815.1124921-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _uO6tx8IKvS0Aly-WTL05VhF1nDXXnDI
X-Proofpoint-GUID: _uO6tx8IKvS0Aly-WTL05VhF1nDXXnDI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_03,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a make target runtests-parallel which can run tests in parallel.
This is very useful to quickly run all the tests locally with
  $ make -j runtests-parallel

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/Makefile          | 10 +++++++++-
 test/runtests-quiet.sh | 10 ++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)
 create mode 100755 test/runtests-quiet.sh

diff --git a/test/Makefile b/test/Makefile
index cb7e15e..fe35ff9 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -185,6 +185,7 @@ all_targets +=3D sq-full-cpp.t
=20
 test_targets :=3D $(patsubst %.c,%,$(test_srcs))
 test_targets :=3D $(patsubst %.cc,%,$(test_targets))
+run_test_targets :=3D $(patsubst %,%.run_test,$(test_targets))
 test_targets :=3D $(patsubst %,%.t,$(test_targets))
 all_targets +=3D $(test_targets)
=20
@@ -229,4 +230,11 @@ runtests: all
 runtests-loop: all
 	@./runtests-loop.sh $(test_targets)
=20
-.PHONY: all install clean runtests runtests-loop
+%.run_test: %.t
+	@./runtests-quiet.sh $<
+
+runtests-parallel: $(run_test_targets)
+	@echo "All tests passed"
+
+.PHONY: all install clean runtests runtests-loop runtests-parallel
+.PHONY +=3D $(run_test_targets)
diff --git a/test/runtests-quiet.sh b/test/runtests-quiet.sh
new file mode 100755
index 0000000..ba9fe2b
--- /dev/null
+++ b/test/runtests-quiet.sh
@@ -0,0 +1,10 @@
+#!/usr/bin/env bash
+
+TESTS=3D("$@")
+RESULT_FILE=3D$(mktemp)
+./runtests.sh "${TESTS[@]}" 2>&1 > $RESULT_FILE
+RET=3D"$?"
+if [ "${RET}" -ne 0 ]; then
+    cat $RESULT_FILE
+fi
+rm $RESULT_FILE
--=20
2.30.2

