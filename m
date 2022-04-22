Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3398B50BC7B
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 18:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbiDVQEv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 12:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358721AbiDVQEu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 12:04:50 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433885BE68
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:57 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23MEltU5000956
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=AWYidNDFejqFnWUUjFRAjxm7UHFpSbU9uj2nVPGPBBo=;
 b=Q0WjboV50j5AJxrzLnW7EGh4EV7wWUbr3/8IAZLRwsUasc4TRl3ITc+/3K4lcam57xI6
 +mz1J98Xhpz5PZvbnSPe4/jrwaMgk5fR6ooKweAvcXhaLHnyrbkJnMi48LXt/DrWdW9A
 bVEk6Q7ua0x1vKO7OwLraJOFyIiVZ6Pgar4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fjnsxf3g4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:56 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 09:01:55 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id CC0117E01545; Fri, 22 Apr 2022 09:01:41 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 6/7] test: add make targets for each test
Date:   Fri, 22 Apr 2022 09:01:31 -0700
Message-ID: <20220422160132.2891927-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220422160132.2891927-1-dylany@fb.com>
References: <20220422160132.2891927-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: WpebdSrmI_I7dTD8lhEvFjzzHFdECu52
X-Proofpoint-ORIG-GUID: WpebdSrmI_I7dTD8lhEvFjzzHFdECu52
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

Add a make target runtests-parallel which can run tests in parallel.
This is very useful to quickly run all the tests locally with
  $ make -j runtests-parallel

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 Makefile               |  2 ++
 test/Makefile          | 10 +++++++++-
 test/runtests-quiet.sh | 11 +++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)
 create mode 100755 test/runtests-quiet.sh

diff --git a/Makefile b/Makefile
index 28c0fd8..d54551e 100644
--- a/Makefile
+++ b/Makefile
@@ -21,6 +21,8 @@ runtests: all
 	@$(MAKE) -C test runtests
 runtests-loop:
 	@$(MAKE) -C test runtests-loop
+runtests-parallel:
+	@$(MAKE) -C test runtests-parallel
=20
 config-host.mak: configure
 	@if [ ! -e "$@" ]; then					\
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
index 0000000..438a00a
--- /dev/null
+++ b/test/runtests-quiet.sh
@@ -0,0 +1,11 @@
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
+exit $RET
--=20
2.30.2

