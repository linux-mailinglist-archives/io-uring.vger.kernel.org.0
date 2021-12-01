Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0954645EB
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 05:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346589AbhLAE1v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 23:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346605AbhLAE1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 23:27:38 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABF0C061759;
        Tue, 30 Nov 2021 20:23:58 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so209569pjb.1;
        Tue, 30 Nov 2021 20:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KFbBr90gefR+1Pl+HlupC3oRKy8nqU/RjzeqFiPeQ3o=;
        b=e+RfFZyT2Z95/cByl+9jVpDoznekanJq8V2Enw878GsMgRfoHFuwCwIWAt1jJTEPZA
         0QWTz/exUlzr6bDyRd/R0xuOT9EQ/52Q8FdhVHFgKCsPLlirxP9lwJWF2wY/9+lSffX0
         9bRTaRhg7X+J5bZvZLJ/PbUiWq1EiQzblRPoW8h95zCB1+/9aZ1mohzFdnusSn8pP4qQ
         mWKDhP2QAWQ6TWiqeVTDTqcB70bfwe+d3izE7WGHGb08hiOyzf0yMJPxBYKR5IPXGUqi
         r4xrwK34avLwijDa2V6z4DiPFfr1GD28B98sVPV1UPL1gEbVJ5wsICkUnU59rfUPsWZe
         7Bqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KFbBr90gefR+1Pl+HlupC3oRKy8nqU/RjzeqFiPeQ3o=;
        b=77WQigumU7npmPlhfxFoEnXn+2WVrXBoAfBB6uA6dacOamyip4GHeBukpBL7fT6dGv
         2S5rsmtYSGAlAPtjI75tG6t2K5+m7ze9n+d4hcEso3ByoDCJTT/PIQy6/uQS5cz5bHj5
         ejfm3mLeMNG2cEugwNq2U3KRZdz3DKO1pq2wt22kb/zv5SMxc4VtjSLOTDw1M1iNAyW+
         eO4FVLrDgkVQK4Or91g9jtlIGsaGEPQntGFbjZyRHYfpFGYI6YNBnfCGwFAZ3dE/J0Fw
         fe6JSzPK3gGjiT9Xxq9NR3mYK5f4MGZKSPEIveypn/ee+Sn9j6lC02CO8mGOwIVdJ88E
         5n4g==
X-Gm-Message-State: AOAM532+7suhDLcMtWmi+K9cjPgfcvNWA6NW2ERIthOQ8mOFTVxPBhKt
        IqFpmkH5oNBe4MN8nPREh4a8KLwpDLY=
X-Google-Smtp-Source: ABdhPJzID7l6m8Fx9/aG/fU+oOSFrCd+5fwfQFqWvtei+GtvUD1cazlNjaFE8U3c5NvHThysAURm2A==
X-Received: by 2002:a17:90b:4c03:: with SMTP id na3mr4453829pjb.62.1638332638147;
        Tue, 30 Nov 2021 20:23:58 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id n71sm22891407pfd.50.2021.11.30.20.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:23:57 -0800 (PST)
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
Subject: [PATCH bpf-next v3 07/10] selftests/bpf: Add test for epoll BPF iterator
Date:   Wed,  1 Dec 2021 09:53:30 +0530
Message-Id: <20211201042333.2035153-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211201042333.2035153-1-memxor@gmail.com>
References: <20211201042333.2035153-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5763; h=from:subject; bh=Eob8InaX8B/ObiQ95zseeNHtxkxkQ3RBO6zFLubC6DQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhpvYy03VQ7tWIC+yeXaQVoRmDO93wh9RiLBW4dXQc h8xiWuGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYab2MgAKCRBM4MiGSL8RyvwHD/ sH3KfyWnQIr0qyiTdcwU7gQSuemMMK2ff/t/3zEY4kJgspMBM5/pvRkLCeUjgCyHIX61gdjrhl/V9o AEQajN5ims0gbtAHUCs2je0xaqOahxLBMPScNKUvUn/ouX+e3sC1L5FtarUScae5ZgzN0UCc2sUDxS 7NN9FCpujgWvBmSk0dprEGGizTNF/e8HRPCVjXX/pNA1Gk+H9Ld9l/tWuGU64jeNaW2i0xeDj5/PIX nLp7750Bs2sfh7+JnOGcgaE/km4RurnhG2dzbi5AMISIFLO3/TtHBa2es7mu6U2UcpuV0viuMTopb1 s8A+qMyQN9MrYF0MhQWdohJ9aMDvxGMGZhSr8OEaru4E+c45be0go+3dV5JT+CvHjjQm8hsxnnfFKL QyCN2VnOudggdvbCNeYGk7BoY042EWFD4qb0VtYjuHzx+nrMT9B8Ouu47QXAaBOJm8WdFXSwe6Q7Jz FuyOsfp6rQ0/ahv7o7hEoaKeRFJ86PaA0IqEbzADLVvsqhiM8qUnWFU9Q+CFlRy6rHNQvu6DPgluMK Udc8+/RbYccQX5KurMC4AoEIrb8lvL20x2RBALRdmIlsajCTIjTwnkTkRa/cXG+/jpz2MiPyI56Ll6 WqvQ+P0N8hQoB1PWWYhCGpG5aXGQANcSuiLlRuicGVxG7bHGt0IawNq6vg7w==
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
index 13ea2eaed032..cc0555c5b373 100644
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
2.34.1

