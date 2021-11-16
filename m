Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77646452A38
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 07:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240458AbhKPGCR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240226AbhKPGBn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:01:43 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB28C061198;
        Mon, 15 Nov 2021 21:42:57 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id y7so16552951plp.0;
        Mon, 15 Nov 2021 21:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e6K5BXrMyolcmdiOfyNeEh73nCV8EI1WCMaNjFKoCaQ=;
        b=EYMkJSXLoa0ztBWSqmFKZVu3vcoZZytjxVtqBnWFCac7xGykPEHAYM70yIZA0Hm/oD
         8XT/5vnFCMyvx442ULlXiofa8GZm0jwAhEie4Ue7TD5gJFGCRncwmZm1fP68P1zUMwpw
         CrAjfL2chkAA0zSkQZaOcnIca21w7x1QOp5EiC6VRgzOlgzNa993212o+Y0ahsrvUh68
         l2xOVy9AIxHn3CT0mbNBY21inSit6EeV7QuJhsQnFgoeyU75XKp5n3GJFVPkmEvh6p6P
         T7wRmzGL2drDpeMCr9k18gT9L211RFQF665orIbkic3ScASxs5Cd72+QNUGr4bGWX0nC
         q3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e6K5BXrMyolcmdiOfyNeEh73nCV8EI1WCMaNjFKoCaQ=;
        b=47RYqeccgJ4uG9sR2mDu0leZ30x0LwaojjQi1iZCvcThdfAQfOEa1XyHzyCQMLDCgG
         tiXPAda3/ng4FAMn4V/Bz/S9e6QGE+44aYFHlwQl5wktYctcNaS2M2t2P7NuAi36TmoM
         wZrSJrk3HCH1IFCDPtv1+ipXEysTMAl8/gsBDpCWbLn9L9vkx8hQTWxx5TPczRHCHe0j
         WVc0H2sQxPnpngpyq9WqXcbP3lxXZw7t8NW24prhwk7gxvanUOkhoVUpoVU54gN79p2a
         iiPSrWbLHDDbuu+qOGBJj3taav/ejHuW+v2Km/t1RtUhXYzd4bGJElfNKKevhEgEWA+h
         yIJQ==
X-Gm-Message-State: AOAM531WWO8C1n4EbzQUtjUfuyJswCwgS66DAgd5Ndh2A42qpr9OjfGw
        7cJvJj2Jj/Ku+FWp0l3kbD2Zx0nPHDE=
X-Google-Smtp-Source: ABdhPJzoT289D9hKmGhb5k4T6hxNisYvJ/8bfdr4mxR+BleXQ0qe1BChDLQP+fZFY2slZcYLnCgZUQ==
X-Received: by 2002:a17:90b:38c7:: with SMTP id nn7mr5551574pjb.105.1637041377236;
        Mon, 15 Nov 2021 21:42:57 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id qe12sm1087344pjb.29.2021.11.15.21.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:42:57 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org
Subject: [PATCH bpf-next v1 6/8] selftests/bpf: Add test for epoll BPF iterator
Date:   Tue, 16 Nov 2021 11:12:35 +0530
Message-Id: <20211116054237.100814-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116054237.100814-1-memxor@gmail.com>
References: <20211116054237.100814-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5777; h=from:subject; bh=DG1ceIlzLy6lY4GMZPn9QTX203OUaeTgUvIDcoyd6f8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhk0S6d2hVzCKfLqmy8AJRA3YMmFlPTEsu6PpJAH4r n+xBa3uJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZNEugAKCRBM4MiGSL8RypSxD/ 9Ed2jtsSmSIhILwYK0H6KRZGs4Qeu5D7rwpmcKKT1CN8CnssYKaJkIuc5dlYLZnKx3AhsNTiHUfsQe RFtRDbWWcLvYKOyZ4K6B8+vrU/XNsblWArw6YdJrwbKZjHiiRfMZAC2ZIxltlLRKVoAjdbLevvO7oH aadSywqpunQiKrNEd+s/16f+Re/NkSlgMu6nBzEyKfiFJh2rltpQxJ91M68Rj7v4VAx2njqsea//7p aeNqmaZSSNl+6QRHvDgbZ09CfV4XnEcdS3ih2dX+gEu6SjU+SzABvM5qN8TZIdinM01mKFJq+PPRzQ zTAss5Vn7xlgzSe3VZIgx78jFl1AaElj+C1eDzb69fWetH7tY/KTl4GBraXDLrWSWpWF7miXB6ys7B xowJynKQ0kUWhODV1/aeuNAYw/4B7mHBLok2QeZAnJcpNZuweW3noARX9A+JsVaF1DYVcjdogkcykH DHwe5d+1+nOp4F9y/9R/rDaMlpV2QQCqUAENmXaWlRd6O3Q80+HOu6WHPlPD7c+LkZ9HJ/S7fHCYsp /aHm4ZYNYV+Fqc3pXqIlJOkPvzAPBEUWuOJwcyHSSfSnGzVdwn1DO1RhBRkOA49JW4gZNxv/NrpRwH BPFAaforx7zO4hZm7u4WS6pWgWUjX7K8QzWEk+1mHDvdVycb8EnMEuetSvcg==
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
index baf11fe2f88d..45e186385f9a 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
 #include <sys/mman.h>
+#include <sys/epoll.h>
 #include <test_progs.h>
 #include <linux/io_uring.h>
 
@@ -30,6 +31,7 @@
 #include "bpf_iter_test_kern5.skel.h"
 #include "bpf_iter_test_kern6.skel.h"
 #include "bpf_iter_io_uring.skel.h"
+#include "bpf_iter_epoll.skel.h"
 
 static int duration;
 
@@ -1461,6 +1463,123 @@ void test_io_uring_file(void)
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
@@ -1525,4 +1644,6 @@ void test_bpf_iter(void)
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
2.33.1

