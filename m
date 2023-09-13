Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2586779ECE0
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 17:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjIMP2v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 11:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjIMP2n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 11:28:43 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9A61BD6;
        Wed, 13 Sep 2023 08:28:39 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-99c3c8adb27so888272466b.1;
        Wed, 13 Sep 2023 08:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694618918; x=1695223718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f1vGDg0uCtdiqjKqDiwFtuGhRJ18xP0o/QuRB7i2CeI=;
        b=A11Q5a1VP/fcQ9TgOWN78oPoZg6kkmtsNi8QeNGpOkGuscvR8HqQ6es6BHcDKvKp2x
         lBr2okhW4SWaRc0xECzgePXGbkx53DUIerGucgd5ltRQdrnaZX1FW5qZwaDU3IgLEZ/5
         tW3urGbcup0SaCqGrLa6idF3tGoqyRzxZ9eQoOCgzMuTThsnaf4rjR/FRMUDHAk1lj8/
         qBHkYYbd95m76Pxyzal2pZKIzPqb0j/1E+u52NBGs9hULg8ElXMQwFfwZjuI0l0dcSLH
         FCMmdZpbvxuKPQboKGIqYdMMG2s5K7THQNlvjIVVXjnPxQaQPmGaxU+/xjplB5XwD3ZA
         noLw==
X-Gm-Message-State: AOJu0YzCcGjpJd6aYMOGT5rgjkO0gH3gY+w4pBLs4Blmejm/B1PVWTYG
        iJKu5vdGCKZLxTCDtLkvzlo=
X-Google-Smtp-Source: AGHT+IHmrrgmP8mf+1WIardtNbDBakZ+xUtLB1E1+f4WfhRclf5HQB29Q5O+QutRs462a3Yp0wPRsw==
X-Received: by 2002:a17:906:3151:b0:9a1:c495:66bb with SMTP id e17-20020a170906315100b009a1c49566bbmr2361258eje.60.1694618918240;
        Wed, 13 Sep 2023 08:28:38 -0700 (PDT)
Received: from localhost (fwdproxy-cln-009.fbsv.net. [2a03:2880:31ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id rn3-20020a170906d92300b0099cc3c7ace2sm8709378ejb.140.2023.09.13.08.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 08:28:37 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de,
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
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
        Wang Yufen <wangyufen@huawei.com>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v6 8/8] selftests/bpf/sockopt: Add io_uring support
Date:   Wed, 13 Sep 2023 08:27:44 -0700
Message-Id: <20230913152744.2333228-9-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230913152744.2333228-1-leitao@debian.org>
References: <20230913152744.2333228-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

