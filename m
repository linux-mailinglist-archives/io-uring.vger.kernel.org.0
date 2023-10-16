Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152D17CAAE8
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjJPODF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbjJPOCk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:02:40 -0400
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204E011D;
        Mon, 16 Oct 2023 07:02:15 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-53d9b94731aso8141893a12.1;
        Mon, 16 Oct 2023 07:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464933; x=1698069733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ygDojQGLotNc+hKSW16iP2jFFy8A16V/NuLMLtN4+4=;
        b=KC2cVU1m8Si9d7UT6PbhBe+NFl7JbeJhzsu0K7jM0sfOXmuRfH1HBIgK1LYi/fr+G5
         INC7uEgZi35p+x9v38YltEngFI/APOzFSyz09hI4Vnel1D/igWrlC8BV7AJgTRskwNPl
         7FVY/j8XaQchhWBSf+taTFc4WdzEu2MPHTHaLxtaXWsdeOEx3P7NYGdnL7pqF836Z31/
         u8u7gp0ZLsI2k7SFZAP+b8T/HAXZ7EijPQjEUr9OWez/J3KO+1dCXikF5plyMKVzzJgh
         kiEljif9YAMByjGXXQJdmfZteIyGsRUMq9PwJLdRL5dY/dxCBbHnIAb4pPtfGBk7kz8J
         0Zvw==
X-Gm-Message-State: AOJu0YyX0Tj1Ci6cbACy8B8QIPngD6TDZSCaqbW0bLFaXIWExuJBGO0Q
        cDBrPHYIeiMSd8cVzPDfyP4=
X-Google-Smtp-Source: AGHT+IGrMyp6sQpD3D1xspvVk1aGA875YUeRNnpdlYvQMt6SIfSu6fxlRIZmFkgfG3t8TSTL3iSDMg==
X-Received: by 2002:a05:6402:3985:b0:53d:bc68:633a with SMTP id fk5-20020a056402398500b0053dbc68633amr16373880edb.5.1697464933493;
        Mon, 16 Oct 2023 07:02:13 -0700 (PDT)
Received: from localhost (fwdproxy-cln-010.fbsv.net. [2a03:2880:31ff:a::face:b00c])
        by smtp.gmail.com with ESMTPSA id n30-20020a50935e000000b0053e775e428csm3730388eda.83.2023.10.16.07.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:02:13 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v7 11/11] selftests/bpf/sockopt: Add io_uring support
Date:   Mon, 16 Oct 2023 06:47:49 -0700
Message-Id: <20231016134750.1381153-12-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231016134750.1381153-1-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
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
index 9e6a5e3ed4de..5a4491d4edfe 100644
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
+	if (!ASSERT_OK(err, "io_uring initialization"))
+		return err;
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!ASSERT_NEQ(sqe, NULL, "Get an SQE")) {
+		err = -1;
+		goto fail;
+	}
+
+	io_uring_prep_cmd(sqe, op, fd, level, optname, optval, optlen);
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

