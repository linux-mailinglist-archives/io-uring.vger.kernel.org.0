Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FFF4597F9
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 23:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhKVW5a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 17:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhKVW5X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 17:57:23 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ACCC061574;
        Mon, 22 Nov 2021 14:54:15 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id u80so5831877pfc.9;
        Mon, 22 Nov 2021 14:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y8fd/OzoWO0A4euNuWolWcSQ1k5QoF6gHKtM1v6KFXI=;
        b=OUvvhWYC+ge2LI8AESR+JF0HyeuaXNSYPw3VE702Rpjq7xHm9eA53xo6wYNPpYL4Jf
         70RnxeEVLRht9cFuNAjr7daUWeYYeh184lM/2KGoiJuZrErgUObCCPN75VahtufHj8Hc
         tV/3Lcg6U2l9YSQHt+Umi12+VwdJFcHoYCVO3sm/vHlTqXObUXcaxqgOtre3v3LD7HOv
         mO5RtwNCAvueRjEASZsPKr7bWJEVIguTXHSsslkKGslrmOLz5le1CR2jFjzbZ4N7i7x0
         L3M5nwaO4AIWcm1IxfPWeXmHflwwTB96ExgEb2MzIFh/Q3xG2dir7Rns2PlFSKxwLT21
         hbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y8fd/OzoWO0A4euNuWolWcSQ1k5QoF6gHKtM1v6KFXI=;
        b=Ru0Uf5vBA06+8BHkOy30K2a3y0awZ8vGtwmPHXOUZuoQ5Ynmw3DqcCCUhuXnhMBz2J
         dKUjIm+PFh+mxcTXqxpl/ypEd5vSbmG4Ujk/y3yANG6FNY59CT+OaTLZX+GQlLFNogXs
         V1CX/U7QcZRCczoPhcoO6EkIJyyHKfLcoYIXCspsYB8ZMNfzVFIcDzUnXfQ9bh1dU7bv
         IDPlZtqTNedWi2uN7oUmM66PZAm11bFRNwQ3ssSOkNuqR/6FP/Kj4EdFDWfXHsE57pZd
         uoFXyl96aWbH6b5k8GOMug35MkBRiz86qgBsBdhgRdIrWy9kCYWtAr5dkU6ekoABXb8N
         nSCA==
X-Gm-Message-State: AOAM530RTzhLQ2+XqUenf1LblDt5gKNi1hPb56J53JTlpM1gK8Qz6R09
        jOMvw3QaVQf3eXzP+JrJjWUWMfABv3Y=
X-Google-Smtp-Source: ABdhPJwubNKRzEqF3TgEEJ5euzH8JJvmO4ZBg3zenrtJQXfjnbidaCTg2Dtf02bm4l4nqBKhNwY5xQ==
X-Received: by 2002:a62:7541:0:b0:4a3:8a3b:6136 with SMTP id q62-20020a627541000000b004a38a3b6136mr806380pfc.78.1637621655252;
        Mon, 22 Nov 2021 14:54:15 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id c9sm7044106pgq.58.2021.11.22.14.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:54:15 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org
Subject: [PATCH bpf-next v2 07/10] selftests/bpf: Add test for epoll BPF iterator
Date:   Tue, 23 Nov 2021 04:23:49 +0530
Message-Id: <20211122225352.618453-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211122225352.618453-1-memxor@gmail.com>
References: <20211122225352.618453-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5763; h=from:subject; bh=wwA+z5sb920kQ2kHDEdlo3XuyNd/1OGKswevIlyym7c=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhnBrM3EGICESPIZLbqEZWOuWAUbGWRqIllKwYN30n GPnjQEWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZwazAAKCRBM4MiGSL8Rysa5EA C4U+xHvMHjgwmmc8vZFGOapkFm+jL1Ee3OtqWhZGtMgk2xvvVETELDoB+7XAMWrudN3a9cH4ysvx9e +z844r1/osWPivwFzUxpBq+OSMMTrxNR+KQV0BF1as8jV9pgTndCC4StyAeWtrWjqQ3kCEir7ubEtu iyZc40mlaYyBG5nNQ2GRA2UK4yyx/UWZcQf9LPeWTbMbTc1I2E+JLaNUKbmrSsawMTrKQf0s6mpgUS uXDNrjE/3Ns+RZ/VjDn6uZK8nMxJi1aHzQZfjEgrsLDFiJyq4XLATbCgW5IGpPm5jzItVuWIq66smv JLyMo8ohv1On4/4Jg3691S0HQBOgN/URiCovKvLn6G5F425LrGPnZkIb4KrD9gVqfe6t0A+dgo5HmN gyx9binrGOxK9pyHI8Q9UVn9n7n9s1XGY9DCjGzJT2MI7AneGB/SSB/XDEnNXXp7MgZiwE0gWY3Akb evatiShc90ZBygI4emWqqNEzfOlyqP9X/6yBtgTv5orvDNHNlvK2t3jt6s12hKXT3NOXtd6qW4kikg JvwYohUahD6WdJG9eCTiMTCrkvkTw99z5cVja2d2YlfBcrtwSNMU0m94/oS6dR4WRG+npwueV+Mhlu mxO5+cX0RHWjQhw4mfFRIKPfj2n2U2IDD0ZNyEHDtBUEZ9HQW89YIHx66n9w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This tests the epoll iterator, including peeking into the epitem to
inspect the registered file and fd number, and verifying that in
userspace.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 121 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_epoll.c      |  33 +++++
 2 files changed, 154 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_epoll.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index d21121d62458..7fb995deb22d 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2020 Facebook */
 #include <sys/stat.h>
 #include <sys/mman.h>
+#include <sys/epoll.h>
 #include <test_progs.h>
 #include <linux/io_uring.h>
 
@@ -31,6 +32,7 @@
 #include "bpf_iter_test_kern5.skel.h"
 #include "bpf_iter_test_kern6.skel.h"
 #include "bpf_iter_io_uring.skel.h"
+#include "bpf_iter_epoll.skel.h"
 
 static int duration;
 
@@ -1486,6 +1488,123 @@ void test_io_uring_file(void)
 	bpf_iter_io_uring__destroy(skel);
 }
 
+void test_epoll(void)
+{
+	const char *fmt = "B\npipe:%d\nsocket:%d\npipe:%d\nsocket:%d\nE\n";
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	char buf[4096] = {}, rbuf[4096] = {};
+	union bpf_iter_link_info linfo;
+	int fds[2], sk[2], epfd, ret;
+	struct bpf_iter_epoll *skel;
+	struct epoll_event ev = {};
+	int iter_fd, set[4];
+	char *s, *t;
+
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	skel = bpf_iter_epoll__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "bpf_iter_epoll__open_and_load"))
+		return;
+
+	epfd = epoll_create1(EPOLL_CLOEXEC);
+	if (!ASSERT_GE(epfd, 0, "epoll_create1"))
+		goto end;
+
+	ret = pipe(fds);
+	if (!ASSERT_OK(ret, "pipe(fds)"))
+		goto end_epfd;
+
+	ret = socketpair(AF_UNIX, SOCK_STREAM, 0, sk);
+	if (!ASSERT_OK(ret, "socketpair"))
+		goto end_pipe;
+
+	ev.events = EPOLLIN;
+
+	ret = epoll_ctl(epfd, EPOLL_CTL_ADD, fds[0], &ev);
+	if (!ASSERT_OK(ret, "epoll_ctl"))
+		goto end_sk;
+
+	ret = epoll_ctl(epfd, EPOLL_CTL_ADD, sk[0], &ev);
+	if (!ASSERT_OK(ret, "epoll_ctl"))
+		goto end_sk;
+
+	ret = epoll_ctl(epfd, EPOLL_CTL_ADD, fds[1], &ev);
+	if (!ASSERT_OK(ret, "epoll_ctl"))
+		goto end_sk;
+
+	ret = epoll_ctl(epfd, EPOLL_CTL_ADD, sk[1], &ev);
+	if (!ASSERT_OK(ret, "epoll_ctl"))
+		goto end_sk;
+
+	linfo.epoll.epoll_fd = epfd;
+	skel->links.dump_epoll = bpf_program__attach_iter(skel->progs.dump_epoll, &opts);
+	if (!ASSERT_OK_PTR(skel->links.dump_epoll, "bpf_program__attach_iter"))
+		goto end_sk;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.dump_epoll));
+	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
+		goto end_sk;
+
+	ret = epoll_ctl(epfd, EPOLL_CTL_ADD, iter_fd, &ev);
+	if (!ASSERT_EQ(ret, -1, "epoll_ctl add for iter_fd"))
+		goto end_iter_fd;
+
+	ret = snprintf(buf, sizeof(buf), fmt, fds[0], sk[0], fds[1], sk[1]);
+	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf), "snprintf"))
+		goto end_iter_fd;
+
+	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
+	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer"))
+		goto end_iter_fd;
+
+	puts("=== Expected Output ===");
+	printf("%s", buf);
+	puts("==== Actual Output ====");
+	printf("%s", rbuf);
+	puts("=======================");
+
+	s = rbuf;
+	while ((s = strtok_r(s, "\n", &t))) {
+		int fd = -1;
+
+		if (s[0] == 'B' || s[0] == 'E')
+			goto next;
+		ASSERT_EQ(sscanf(s, s[0] == 'p' ? "pipe:%d" : "socket:%d", &fd), 1, s);
+		if (fd == fds[0]) {
+			ASSERT_NEQ(set[0], 1, "pipe[0]");
+			set[0] = 1;
+		} else if (fd == fds[1]) {
+			ASSERT_NEQ(set[1], 1, "pipe[1]");
+			set[1] = 1;
+		} else if (fd == sk[0]) {
+			ASSERT_NEQ(set[2], 1, "sk[0]");
+			set[2] = 1;
+		} else if (fd == sk[1]) {
+			ASSERT_NEQ(set[3], 1, "sk[1]");
+			set[3] = 1;
+		} else {
+			ASSERT_TRUE(0, "Incorrect fd in iterator output");
+		}
+next:
+		s = NULL;
+	}
+	for (int i = 0; i < ARRAY_SIZE(set); i++)
+		ASSERT_EQ(set[i], 1, "fd found");
+end_iter_fd:
+	close(iter_fd);
+end_sk:
+	close(sk[1]);
+	close(sk[0]);
+end_pipe:
+	close(fds[1]);
+	close(fds[0]);
+end_epfd:
+	close(epfd);
+end:
+	bpf_iter_epoll__destroy(skel);
+}
+
 void test_bpf_iter(void)
 {
 	if (test__start_subtest("btf_id_or_null"))
@@ -1550,4 +1669,6 @@ void test_bpf_iter(void)
 		test_io_uring_buf();
 	if (test__start_subtest("io_uring_file"))
 		test_io_uring_file();
+	if (test__start_subtest("epoll"))
+		test_epoll();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_epoll.c b/tools/testing/selftests/bpf/progs/bpf_iter_epoll.c
new file mode 100644
index 000000000000..0afc74d154a1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_epoll.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+
+extern void pipefifo_fops __ksym;
+
+SEC("iter/epoll")
+int dump_epoll(struct bpf_iter__epoll *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	struct epitem *epi = ctx->epi;
+	char sstr[] = "socket";
+	char pstr[] = "pipe";
+
+	if (!ctx->meta->seq_num) {
+		BPF_SEQ_PRINTF(seq, "B\n");
+	}
+	if (epi) {
+		struct file *f = epi->ffd.file;
+		char *str;
+
+		if (f->f_op == &pipefifo_fops)
+			str = pstr;
+		else
+			str = sstr;
+		BPF_SEQ_PRINTF(seq, "%s:%d\n", str, epi->ffd.fd);
+	} else {
+		BPF_SEQ_PRINTF(seq, "E\n");
+	}
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.0

