Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1A5791B89
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 18:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352856AbjIDQ02 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 12:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240655AbjIDQ01 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 12:26:27 -0400
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2EDCC5;
        Mon,  4 Sep 2023 09:25:56 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-99bed101b70so251809466b.3;
        Mon, 04 Sep 2023 09:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693844746; x=1694449546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/injwFwPCEHXUwspfhEaGXaHWVZoMocD4z29NwXIPbw=;
        b=P05PDJzAjiJ1cWWc6lqRJ40L33pvvs7hR6H4OGrK63zBZQdiBcQ1fraI+yi2SKPOyM
         579gMA6+7lcS4aMfQTU5G+LzBezTU+ZdqH44WIf9C8EEG2VTijDxpWKvLi1Px+gk6cmJ
         uBc3lYRCdSajPH+BhaORDJqDL+ap9WNRVSRBZkg0Xk/eaKUrJxQQvbuvj7mojMc8KCgC
         9MjIXa6lHXnvGEkYWXwazgQwkQRhxYb2NXLECmKRMJSjU3MFEa7PDM6jM1czs0CsB4C0
         LvqlcC/oa3sJ7y9G5n8rI5avUlyqns/4On0qehm5wRAW3dxF917buDQaDF+EJVjROf/3
         53ww==
X-Gm-Message-State: AOJu0YwA4pTJrBeZJ7X2u8REc5ZpLRICSZbHFzse1q+i/VyptFfHUqHp
        2a6XnWYTrIVZ1dsNo3nEw88Mq+m5Hf3tyg==
X-Google-Smtp-Source: AGHT+IE0M/etACOA3TJqXPFfT/nGxjhKhbwgCaaa0LEpaA3e4QJIoBD/G/DbeQfgGkp/N8WZFLjhZA==
X-Received: by 2002:a17:906:18c:b0:9a1:cdf1:ba3 with SMTP id 12-20020a170906018c00b009a1cdf10ba3mr9618375ejb.27.1693844745972;
        Mon, 04 Sep 2023 09:25:45 -0700 (PDT)
Received: from localhost (fwdproxy-cln-005.fbsv.net. [2a03:2880:31ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id l11-20020a170906938b00b0098de7d28c34sm6382983ejx.193.2023.09.04.09.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 09:25:45 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de, Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
        Wang Yufen <wangyufen@huawei.com>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v4 10/10] selftests/bpf/sockopt: Add io_uring support
Date:   Mon,  4 Sep 2023 09:25:03 -0700
Message-Id: <20230904162504.1356068-11-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904162504.1356068-1-leitao@debian.org>
References: <20230904162504.1356068-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Expand the sockopt test to use also check for io_uring {g,s}etsockopt
commands operations.

This patch starts by marking each test if they support io_uring support
or not.

Right now, io_uring cmd getsockopt() has a limitation of only
accepting level == SOL_SOCKET, otherwise it returns -EOPNOTSUPP. Since
there aren't any test exercising getsockopt(level == SOL_SOCKET), this
patch changes two tests to use level == SOL_SOCKET, they are
"getsockopt: support smaller ctx->optlen" and "getsockopt: read
ctx->optlen".
There is no limitation for the setsockopt() part.

Later, each test runs using regular {g,s}etsockopt systemcalls, and, if
liburing is supported, execute the same test (again), but calling
liburing {g,s}setsockopt commands.

This patch also changes the level of two tests to use SOL_SOCKET for the
following two tests. This is going to help to exercise the io_uring
subsystem:
 * getsockopt: read ctx->optlen
 * getsockopt: support smaller ctx->optlen

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 .../selftests/bpf/prog_tests/sockopt.c        | 113 +++++++++++++++++-
 1 file changed, 107 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt.c b/tools/testing/selftests/bpf/prog_tests/sockopt.c
index 9e6a5e3ed4de..9b1f7f0b1f7e 100644
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
@@ -251,7 +253,9 @@ static struct sockopt_test {
 		.attach_type = BPF_CGROUP_GETSOCKOPT,
 		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
 
+		.get_level = SOL_SOCKET,
 		.get_optlen = 64,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: deny bigger ctx->optlen",
@@ -276,6 +280,7 @@ static struct sockopt_test {
 		.get_optlen = 64,
 
 		.error = EFAULT_GETSOCKOPT,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: ignore >PAGE_SIZE optlen",
@@ -318,6 +323,7 @@ static struct sockopt_test {
 		.get_optval = {}, /* the changes are ignored */
 		.get_optlen = PAGE_SIZE + 1,
 		.error = EOPNOTSUPP_GETSOCKOPT,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: support smaller ctx->optlen",
@@ -337,8 +343,10 @@ static struct sockopt_test {
 		.attach_type = BPF_CGROUP_GETSOCKOPT,
 		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
 
+		.get_level = SOL_SOCKET,
 		.get_optlen = 64,
 		.get_optlen_ret = 32,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "getsockopt: deny writing to ctx->optval",
@@ -518,6 +526,7 @@ static struct sockopt_test {
 		.set_level = 123,
 
 		.set_optlen = 1,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: allow changing ctx->level",
@@ -572,6 +581,7 @@ static struct sockopt_test {
 		.set_optname = 123,
 
 		.set_optlen = 1,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: allow changing ctx->optname",
@@ -624,6 +634,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 
 		.set_optlen = 64,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: ctx->optlen == -1 is ok",
@@ -640,6 +651,7 @@ static struct sockopt_test {
 		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 
 		.set_optlen = 64,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: deny ctx->optlen < 0 (except -1)",
@@ -658,6 +670,7 @@ static struct sockopt_test {
 		.set_optlen = 4,
 
 		.error = EFAULT_SETSOCKOPT,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: deny ctx->optlen > input optlen",
@@ -675,6 +688,7 @@ static struct sockopt_test {
 		.set_optlen = 64,
 
 		.error = EFAULT_SETSOCKOPT,
+		.io_uring_support = true,
 	},
 	{
 		.descr = "setsockopt: ignore >PAGE_SIZE optlen",
@@ -940,7 +954,89 @@ static int load_prog(const struct bpf_insn *insns,
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
+	if (!ASSERT_OK(err, "Failed to initialize io_uring ring"))
+		return err;
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!ASSERT_NEQ(sqe, NULL, "Failed to get an SQE")) {
+		err = -1;
+		goto fail;
+	}
+
+	io_uring_prep_cmd(sqe, op, fd, level, optname, optval, optlen);
+
+	err = io_uring_submit(&ring);
+	if (!ASSERT_EQ(err, 1, "Failed to submit SQE"))
+		goto fail;
+
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (!ASSERT_OK(err, "Failed to wait for CQE"))
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
@@ -980,8 +1076,9 @@ static int run_test(int cgroup_fd, struct sockopt_test *test)
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
@@ -1008,8 +1105,8 @@ static int run_test(int cgroup_fd, struct sockopt_test *test)
 		socklen_t expected_get_optlen = test->get_optlen_ret ?:
 			test->get_optlen;
 
-		err = getsockopt(sock_fd, test->get_level, test->get_optname,
-				 optval, &optlen);
+		err = call_getsockopt(use_io_uring, sock_fd, test->get_level,
+				      test->get_optname, optval, &optlen);
 		if (err) {
 			if (errno == EOPNOTSUPP && test->error == EOPNOTSUPP_GETSOCKOPT)
 				goto free_optval;
@@ -1063,7 +1160,11 @@ void test_sockopt(void)
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

