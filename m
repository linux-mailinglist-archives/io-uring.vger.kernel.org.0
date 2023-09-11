Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BB179C04D
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242348AbjIKWKY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbjIKKev (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 06:34:51 -0400
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8FE120;
        Mon, 11 Sep 2023 03:34:47 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-9a64619d8fbso538062766b.0;
        Mon, 11 Sep 2023 03:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694428485; x=1695033285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f1vGDg0uCtdiqjKqDiwFtuGhRJ18xP0o/QuRB7i2CeI=;
        b=RRs/t1JazOZS4/jgQq2jQjDx4LDbMPqL1zI0BTFaJrcDkRUzIWjG1x6ZdZOEogKVRd
         jz/pAJuHMynH8MaGc2HKOUf8yP4oGvsSWiqqtmkSHp2zPDYGqqu0cHCwCMtOsHiB/Wyk
         tTmMNavKDvlvs2QuFUBOfz0Bq9oMmErIXpNZpLM/DP0Dr9EPG8T8JTPU1RRkqcyT6r/n
         jHk+gaIsQQKUxr5HdIw3a471GbByqqPdwkFBpof0ni0qQ+XsqxEbypx24OalDWySdHuP
         K3looho0TZRJalPHYkdOgL23cnRwaUlAO7x4bwdya2jsXY6poa7+MfaUQHgFA1o+reau
         3u9w==
X-Gm-Message-State: AOJu0YxS8OLJQusa3UXHwbDSByLHE7l6FHYcbQ78Hh3SZXDdL/tJy4HV
        A2D6Cqg8tok1ejrPnbCLzH4=
X-Google-Smtp-Source: AGHT+IHmWj5YVmmZsKaZvOCXIKXs0u+o/kNMeqe3Amwqnpk8GDcWPj4dCCdlfGnRy9cLjYIk7DkVTg==
X-Received: by 2002:a17:907:b18:b0:99c:e38d:e484 with SMTP id h24-20020a1709070b1800b0099ce38de484mr6984550ejl.6.1694428485510;
        Mon, 11 Sep 2023 03:34:45 -0700 (PDT)
Received: from localhost (fwdproxy-cln-013.fbsv.net. [2a03:2880:31ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id v14-20020a17090690ce00b0099c53c44083sm5131989ejw.79.2023.09.11.03.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 03:34:45 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        martin.lau@linux.dev, krisman@suse.de,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        pabeni@redhat.com, Wang Yufen <wangyufen@huawei.com>,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v5 8/8] selftests/bpf/sockopt: Add io_uring support
Date:   Mon, 11 Sep 2023 03:34:07 -0700
Message-Id: <20230911103407.1393149-9-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230911103407.1393149-1-leitao@debian.org>
References: <20230911103407.1393149-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Expand the BPF sockopt test to use also check for io_uring
{g,s}etsockopt commands operations.

Create infrastructure to run io_uring tests using the mini_liburing
helpers, so, the {g,s}etsockopt operation could either be called from
system calls, or, via io_uring.

Add a 'use_io_uring' parameter to run_test(), to specify if the test
should be run using io_uring if the parameter is set, or via the regular
system calls if false.

Call *all* tests twice, using the regular io_uring path, and the new
io_uring path.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 .../selftests/bpf/prog_tests/sockopt.c        | 95 +++++++++++++++++--
 1 file changed, 89 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt.c b/tools/testing/selftests/bpf/prog_tests/sockopt.c
index 9e6a5e3ed4de..40fb4c315ad9 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
+#include <io_uring/mini_liburing.h>
 #include "cgroup_helpers.h"
 
 static char bpf_log_buf[4096];
@@ -940,7 +941,85 @@ static int load_prog(const struct bpf_insn *insns,
 	return fd;
 }
 
-static int run_test(int cgroup_fd, struct sockopt_test *test)
+/* Core function that handles io_uring ring initialization,
+ * sending SQE with sockopt command and waiting for the CQE.
+ */
+static int uring_sockopt(int op, int fd, int level, int optname,
+			 const void *optval, socklen_t *optlen)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int err;
+
+	err = io_uring_queue_init(1, &ring, 0);
+	if (!ASSERT_OK(err, "Initialize io_uring ring"))
+		return err;
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!ASSERT_NEQ(sqe, NULL, "Get an SQE")) {
+		err = -1;
+		goto fail;
+	}
+
+	if (op == SOCKET_URING_OP_GETSOCKOPT)
+		io_uring_prep_cmd_get(sqe, op, fd, level, optname, optval,
+				      optlen);
+	else
+		io_uring_prep_cmd(sqe, op, fd, level, optname, optval,
+				  *optlen);
+
+	err = io_uring_submit(&ring);
+	if (!ASSERT_EQ(err, 1, "Submit SQE"))
+		goto fail;
+
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (!ASSERT_OK(err, "Wait for CQE"))
+		goto fail;
+
+	err = cqe->res;
+
+fail:
+	io_uring_queue_exit(&ring);
+
+	return err;
+}
+
+static int uring_setsockopt(int fd, int level, int optname, const void *optval,
+			    socklen_t *optlen)
+{
+	return uring_sockopt(SOCKET_URING_OP_SETSOCKOPT, fd, level, optname,
+			     optval, optlen);
+}
+
+static int uring_getsockopt(int fd, int level, int optname, void *optval,
+			    socklen_t *optlen)
+{
+	return uring_sockopt(SOCKET_URING_OP_GETSOCKOPT, fd, level, optname,
+			     optval, optlen);
+}
+
+/* Execute the setsocktopt operation */
+static int call_setsockopt(bool use_io_uring, int fd, int level, int optname,
+			   const void *optval, socklen_t optlen)
+{
+	if (use_io_uring)
+		return uring_setsockopt(fd, level, optname, optval, &optlen);
+
+	return setsockopt(fd, level, optname, optval, optlen);
+}
+
+/* Execute the getsocktopt operation */
+static int call_getsockopt(bool use_io_uring, int fd, int level, int optname,
+			   void *optval, socklen_t *optlen)
+{
+	if (use_io_uring)
+		return uring_getsockopt(fd, level, optname, optval, optlen);
+
+	return getsockopt(fd, level, optname, optval, optlen);
+}
+
+static int run_test(int cgroup_fd, struct sockopt_test *test, bool use_io_uring)
 {
 	int sock_fd, err, prog_fd;
 	void *optval = NULL;
@@ -980,8 +1059,9 @@ static int run_test(int cgroup_fd, struct sockopt_test *test)
 			test->set_optlen = num_pages * sysconf(_SC_PAGESIZE) + remainder;
 		}
 
-		err = setsockopt(sock_fd, test->set_level, test->set_optname,
-				 test->set_optval, test->set_optlen);
+		err = call_setsockopt(use_io_uring, sock_fd, test->set_level,
+				      test->set_optname, test->set_optval,
+				      test->set_optlen);
 		if (err) {
 			if (errno == EPERM && test->error == EPERM_SETSOCKOPT)
 				goto close_sock_fd;
@@ -1008,8 +1088,8 @@ static int run_test(int cgroup_fd, struct sockopt_test *test)
 		socklen_t expected_get_optlen = test->get_optlen_ret ?:
 			test->get_optlen;
 
-		err = getsockopt(sock_fd, test->get_level, test->get_optname,
-				 optval, &optlen);
+		err = call_getsockopt(use_io_uring, sock_fd, test->get_level,
+				      test->get_optname, optval, &optlen);
 		if (err) {
 			if (errno == EOPNOTSUPP && test->error == EOPNOTSUPP_GETSOCKOPT)
 				goto free_optval;
@@ -1063,7 +1143,10 @@ void test_sockopt(void)
 		if (!test__start_subtest(tests[i].descr))
 			continue;
 
-		ASSERT_OK(run_test(cgroup_fd, &tests[i]), tests[i].descr);
+		ASSERT_OK(run_test(cgroup_fd, &tests[i], false),
+			  tests[i].descr);
+		ASSERT_OK(run_test(cgroup_fd, &tests[i], true),
+			  tests[i].descr);
 	}
 
 	close(cgroup_fd);
-- 
2.34.1

