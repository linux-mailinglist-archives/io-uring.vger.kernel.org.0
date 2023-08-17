Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4364F77F9E6
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 16:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352453AbjHQO5E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Aug 2023 10:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352488AbjHQO4r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Aug 2023 10:56:47 -0400
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5743A35AA;
        Thu, 17 Aug 2023 07:56:31 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5255da974c4so6380970a12.3;
        Thu, 17 Aug 2023 07:56:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692284190; x=1692888990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ke4IWzmqO1N+bGCPCfqmfSAH5jeG6iX85TTRlsQcMDs=;
        b=I5LxGv+5Y4qlBcuPQRMVz+pQ/yxKydRfY2Ou/ZGP/OWlOfdCcMb6j5aea2RzkmlWZT
         7SeWnIhAYr5+3MKzoAlLrXcomiN9FNmlW++dKmt1XqEJFI1r980W9m7t9KCFlhP9jfcL
         SbordW4ll0zPKfk9om+Bdc0S4n0OV+GrxTg9dF9OZ8s2OzhizviBeyXbvVndCwVgeFcx
         aJ2ORoknB/domvDdCwN/Q20DzYpX/KnD87JurqSq/TkhFzXjciJQxoBs15GJe39hnhY1
         4hLYccZb6VnKbJdCjCmeStMCM2J6nEWmYq5NQMGuw10feDuCghZmjlp1k6SIq0CdNhSd
         lkRA==
X-Gm-Message-State: AOJu0Yx/xFHqf169G+po0Cl0UymHxQYrpw5RPWWd9yOqK9D+ZtYYXxuO
        y/E4LCMCbJei8rkjhA4Ze8Q=
X-Google-Smtp-Source: AGHT+IGG++fNvmWQJgN7uptZFJRzrGCuJT2vPHS0WF5JyTy6uNOX81AEB0/UY7tK5PTgf6IM32MEpw==
X-Received: by 2002:a17:907:98e4:b0:994:542c:8718 with SMTP id ke4-20020a17090798e400b00994542c8718mr4187880ejc.76.1692284189770;
        Thu, 17 Aug 2023 07:56:29 -0700 (PDT)
Received: from localhost (fwdproxy-cln-012.fbsv.net. [2a03:2880:31ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id sd17-20020a170906ce3100b0099cc3c7ace2sm10327123ejb.140.2023.08.17.07.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 07:56:29 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, krisman@suse.de,
        Wang Yufen <wangyufen@huawei.com>,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v3 9/9] selftests/bpf/sockopt: Add io_uring support
Date:   Thu, 17 Aug 2023 07:55:54 -0700
Message-Id: <20230817145554.892543-10-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230817145554.892543-1-leitao@debian.org>
References: <20230817145554.892543-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Expand the sockopt test to use also check for io_uring {g,s}etsockopt
commands operations.

This patch starts by marking marks each test if they support io_uring
support or not. Right now, io_uring cmd getsockopt() has a limitation of
only accepting level == SOL_SOCKET, otherwise it returns -EOPNOTSUPP.

Later, each test runs using regular {g,s}etsockopt systemcalls, and, if
liburing is supported, execute the same test (again), but calling
liburing {g,s}setsockopt commands.

For that, leverage the mini liburing to do basic io_uring operations.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 tools/testing/selftests/bpf/Makefile          |   1 +
 .../selftests/bpf/prog_tests/sockopt.c        | 129 +++++++++++++++++-
 2 files changed, 124 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 538df8fb8c42..4da04242b848 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -362,6 +362,7 @@ CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 
 $(OUTPUT)/test_l4lb_noinline.o: BPF_CFLAGS += -fno-inline
 $(OUTPUT)/test_xdp_noinline.o: BPF_CFLAGS += -fno-inline
+$(OUTPUT)/test_progs.o: CFLAGS += -I../../../include/
 
 $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 $(OUTPUT)/cgroup_getset_retval_hooks.o: cgroup_getset_retval_hooks.h
diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt.c b/tools/testing/selftests/bpf/prog_tests/sockopt.c
index 9e6a5e3ed4de..4693ad8bfe8f 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
+#include <io_uring/mini_liburing.h>
 #include "cgroup_helpers.h"
 
 static char bpf_log_buf[4096];
@@ -38,6 +39,7 @@ static struct sockopt_test {
 	socklen_t			get_optlen_ret;
 
 	enum sockopt_test_error		error;
+	bool				io_uring_support;
 } tests[] = {
 
 	/* ==================== getsockopt ====================  */
@@ -53,6 +55,7 @@ static struct sockopt_test {
 		.attach_type = BPF_CGROUP_GETSOCKOPT,
 		.expected_attach_type = 0,
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: wrong expected_attach_type",
@@ -65,6 +68,7 @@ static struct sockopt_test {
 		.attach_type = BPF_CGROUP_GETSOCKOPT,
 		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 		.error = DENY_ATTACH,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: bypass bpf hook",
@@ -121,6 +125,7 @@ static struct sockopt_test {
 		.attach_type = BPF_CGROUP_GETSOCKOPT,
 		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: read ctx->level",
@@ -164,6 +169,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
 
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: read ctx->optname",
@@ -225,6 +231,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
 
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: read ctx->optlen",
@@ -252,6 +259,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
 
 		.get_optlen = 64,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: deny bigger ctx->optlen",
@@ -276,6 +284,7 @@ static struct sockopt_test {
 		.get_optlen = 64,
 
 		.error = EFAULT_GETSOCKOPT,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: ignore >PAGE_SIZE optlen",
@@ -318,6 +327,7 @@ static struct sockopt_test {
 		.get_optval = {}, /* the changes are ignored */
 		.get_optlen = PAGE_SIZE + 1,
 		.error = EOPNOTSUPP_GETSOCKOPT,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: support smaller ctx->optlen",
@@ -339,6 +349,7 @@ static struct sockopt_test {
 
 		.get_optlen = 64,
 		.get_optlen_ret = 32,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: deny writing to ctx->optval",
@@ -353,6 +364,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
 
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: deny writing to ctx->optval_end",
@@ -367,6 +379,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
 
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: rewrite value",
@@ -421,6 +434,7 @@ static struct sockopt_test {
 		.attach_type = BPF_CGROUP_SETSOCKOPT,
 		.expected_attach_type = 0,
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: wrong expected_attach_type",
@@ -433,6 +447,7 @@ static struct sockopt_test {
 		.attach_type = BPF_CGROUP_SETSOCKOPT,
 		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
 		.error = DENY_ATTACH,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: bypass bpf hook",
@@ -518,6 +533,7 @@ static struct sockopt_test {
 		.set_level = 123,
 
 		.set_optlen = 1,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: allow changing ctx->level",
@@ -572,6 +588,7 @@ static struct sockopt_test {
 		.set_optname = 123,
 
 		.set_optlen = 1,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: allow changing ctx->optname",
@@ -624,6 +641,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 
 		.set_optlen = 64,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: ctx->optlen == -1 is ok",
@@ -640,6 +658,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 
 		.set_optlen = 64,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: deny ctx->optlen < 0 (except -1)",
@@ -658,6 +677,7 @@ static struct sockopt_test {
 		.set_optlen = 4,
 
 		.error = EFAULT_SETSOCKOPT,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: deny ctx->optlen > input optlen",
@@ -675,6 +695,7 @@ static struct sockopt_test {
 		.set_optlen = 64,
 
 		.error = EFAULT_SETSOCKOPT,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: ignore >PAGE_SIZE optlen",
@@ -775,6 +796,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: deny read ctx->retval",
@@ -791,6 +813,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: deny writing to ctx->optval",
@@ -805,6 +828,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: deny writing to ctx->optval_end",
@@ -819,6 +843,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 
 		.error = DENY_LOAD,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: allow IP_TOS <= 128",
@@ -940,7 +965,94 @@ static int load_prog(const struct bpf_insn *insns,
 	return fd;
 }
 
-static int run_test(int cgroup_fd, struct sockopt_test *test)
+/* Core function that handles io_uring ring initialization,
+ * sending SQE with sockopt command and waiting for the CQE.
+ */
+static int uring_sockopt(int op, int fd, int level, int optname,
+			 const void *optval, socklen_t optlen)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int err;
+
+	err = io_uring_queue_init(1, &ring, 0);
+	if (err) {
+		log_err("Failed to initialize io_uring ring");
+		return err;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		log_err("Failed to get an SQE");
+		return -1;
+	}
+
+	io_uring_prep_cmd(sqe, op, fd, level, optname, optval, optlen);
+
+	err = io_uring_submit(&ring);
+	if (err != 1) {
+		log_err("Failed to submit SQE");
+		return err;
+	}
+
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (err) {
+		log_err("Failed to wait for CQE");
+		return err;
+	}
+
+	err = cqe->res;
+
+	io_uring_queue_exit(&ring);
+
+	return err;
+}
+
+static int uring_setsockopt(int fd, int level, int optname, const void *optval,
+			    socklen_t optlen)
+{
+	return uring_sockopt(SOCKET_URING_OP_SETSOCKOPT, fd, level, optname,
+			     optval, optlen);
+}
+
+static int uring_getsockopt(int fd, int level, int optname, void *optval,
+			    socklen_t *optlen)
+{
+	int ret = uring_sockopt(SOCKET_URING_OP_GETSOCKOPT, fd, level, optname,
+				optval, *optlen);
+	if (ret < 0)
+		return ret;
+
+	/* Populate optlen back to be compatible with systemcall interface,
+	 * and simplify the test.
+	 */
+	*optlen = ret;
+
+	return 0;
+}
+
+/* Execute the setsocktopt operation */
+static int call_setsockopt(bool use_io_uring, int fd, int level, int optname,
+			   const void *optval, socklen_t optlen)
+{
+	if (use_io_uring)
+		return uring_setsockopt(fd, level, optname, optval, optlen);
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
@@ -980,8 +1092,9 @@ static int run_test(int cgroup_fd, struct sockopt_test *test)
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
@@ -1008,8 +1121,8 @@ static int run_test(int cgroup_fd, struct sockopt_test *test)
 		socklen_t expected_get_optlen = test->get_optlen_ret ?:
 			test->get_optlen;
 
-		err = getsockopt(sock_fd, test->get_level, test->get_optname,
-				 optval, &optlen);
+		err = call_getsockopt(use_io_uring, sock_fd, test->get_level,
+				      test->get_optname, optval, &optlen);
 		if (err) {
 			if (errno == EOPNOTSUPP && test->error == EOPNOTSUPP_GETSOCKOPT)
 				goto free_optval;
@@ -1063,7 +1176,11 @@ void test_sockopt(void)
 		if (!test__start_subtest(tests[i].descr))
 			continue;
 
-		ASSERT_OK(run_test(cgroup_fd, &tests[i]), tests[i].descr);
+		ASSERT_OK(run_test(cgroup_fd, &tests[i], false),
+			  tests[i].descr);
+		if (tests[i].io_uring_support)
+			ASSERT_OK(run_test(cgroup_fd, &tests[i], true),
+				  tests[i].descr);
 	}
 
 	close(cgroup_fd);
-- 
2.34.1

