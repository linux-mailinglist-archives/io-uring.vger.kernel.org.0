Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D6B452A36
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 07:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbhKPGCH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240227AbhKPGBn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:01:43 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1172DC061195;
        Mon, 15 Nov 2021 21:42:55 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id n85so17091529pfd.10;
        Mon, 15 Nov 2021 21:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NxCD8KaiHPLXnkvOJl2UV/cBQmsXSELbPufgXpoN6c4=;
        b=dj9LMKUBAI720gAvYXAxTU9ey2qecgjPnCqd7O+HcwRhM8PTLCjGoUsT6eenbFthSf
         2i9koZE9d+bTFhaf56Gyjc3rxtMTz7/cZS6BO48SQ+1EwQWNITAK3EQtccoDiwG8gofX
         pZ6dW+s2/9AMUodaZn8D1iXUrLMLY/qRtG7jIQjSMwLCFJMCGSzef/wL6whe1If+1eHn
         6QU2XFIF9feLcGXR3JFDab5kKhMul3U2KDUEbMU+XO7zb1x3rA7eYHiMdCFmeHkcO0ta
         DR+8mZvXwVCHCuZWbl2wxyroM0asZhktF0CENiTN+hom45hTC4xE5uWWuxCm2cCv7kdN
         BkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NxCD8KaiHPLXnkvOJl2UV/cBQmsXSELbPufgXpoN6c4=;
        b=Z+qZNcFp7Stpa0R7owvIci/cvnSlMwz3ENFmPAAS65z3/WHHtYUCgLjj8R0RSyvwB5
         BgC3WzKAwnrVwqafkHZLQ8Vm1/T+YWZpbWnqjaJs5TvWdIB/GMJwoqDF7yvXFLq1XvDT
         EZ7/kluxNUcJKKwnvzMXC7yC7+5SweuFWqmiU4WvUwvPOWZaeaFZ4MdokB9hv/2rjOSR
         n2/vj/kUKias4EvvKRVT5iEm4+SanZn1XQEIYFx2WBWrzsmTYTeKGlg2F2iBdHezK9q8
         nbCQPSspMOMQCdiVOAL15C1wvjP404fyU9AOLTg6gjwHzHokbjc7TSDODcDrsswyDSun
         wSuw==
X-Gm-Message-State: AOAM532NFBXQAMoTdJvIQbsOQ2vHuxkvGhk0OKKoQ+2t85BCsWAgAJlq
        nFxwxUusXoIe6RuGkIHjxw1xI2FixoE=
X-Google-Smtp-Source: ABdhPJxq7PocpHAbxYMQqbVhz9RI9mAGzp8d9bN7B6WY3qIBeeqxcCGdlHxXoUXHNeVMiehBqxJjNw==
X-Received: by 2002:a05:6a00:a8e:b0:47b:a658:7f4d with SMTP id b14-20020a056a000a8e00b0047ba6587f4dmr37797412pfl.82.1637041374376;
        Mon, 15 Nov 2021 21:42:54 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id h196sm291525pfe.216.2021.11.15.21.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:42:54 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v1 5/8] selftests/bpf: Add test for io_uring BPF iterators
Date:   Tue, 16 Nov 2021 11:12:34 +0530
Message-Id: <20211116054237.100814-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116054237.100814-1-memxor@gmail.com>
References: <20211116054237.100814-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10072; h=from:subject; bh=eMb/lQU8qKhODY9ILUiWixTNYnj2WoiakRkQyzvXpRU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhk0S6UV/NukBUm77oBDytNGrgkMltKKtqdGy4l9R8 GNuM0t2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZNEugAKCRBM4MiGSL8RyszpEA C8X5u0HNoe4RDIwcWxn9hoMz6pZnl2Wk5f3DB/QI3sa4PtG7whXr3I5/bET9/2cHGjc0bksOhTZSwl JUpPoorJHKvarTxMhWqEdPStXkvd8iVHlOOQ+t97jq5Jyn8UqNsWAPrga8Ik2YpSnE64r0bZU+Chz+ uBf1sf7N9fC3hPzIifHsjZCkY6bSCDp9tQPqmkD931JP2pOUsDlOkfODfqn7WPhDzxxFinQFGKWPlB Y/26EA9kC1ZJEeF9IYQ4omFJCfYPRiNdbGEMljf8CxKxEW0T2at/vOVT+9vT+pP4UBGnsKdU+mQpZd HpZssIIqZCZFzCRUJ6z5AAMMmWadNE8k0fsXwV1fW5xu5OMfTEzW5NZx9U3EfbFwnZ1Aq9Co3B7wY2 1Bx5Byvv0XRfaHKq3QI9MrdtDYAY6wb8TCy72XTIz5yhaTBgeLQ2SEyd3fFp8XXXGpS7jTZFmAbeiA 3z5GVPya0KDasYB67DmTTpptermcCQiOEd8sQ0BY6f1071HDoWFhih8yhntL8bFou7it1YADEQR6RA OEKGTChbSpMXuyKnkPm2289yAtVVdY6ez0TEKjnRQ7Y6NajPskAcdTre6WY2uMH81wkKblRDaz9HlV kvQWOfF7njEGUcPNpRPTVev+dEE3qRRiFEZRtl7E306Ccp7Jzjn1keVRGR9w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This exercises the io_uring_buf and io_uring_file iterators, and tests
sparse file sets as well.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 226 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_io_uring.c   |  50 ++++
 2 files changed, 276 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 3e10abce3e5a..baf11fe2f88d 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -1,6 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+#include <sys/mman.h>
 #include <test_progs.h>
+#include <linux/io_uring.h>
+
 #include "bpf_iter_ipv6_route.skel.h"
 #include "bpf_iter_netlink.skel.h"
 #include "bpf_iter_bpf_map.skel.h"
@@ -26,6 +29,7 @@
 #include "bpf_iter_bpf_sk_storage_map.skel.h"
 #include "bpf_iter_test_kern5.skel.h"
 #include "bpf_iter_test_kern6.skel.h"
+#include "bpf_iter_io_uring.skel.h"
 
 static int duration;
 
@@ -1239,6 +1243,224 @@ static void test_task_vma(void)
 	bpf_iter_task_vma__destroy(skel);
 }
 
+static int sys_io_uring_setup(u32 entries, struct io_uring_params *p)
+{
+	return syscall(__NR_io_uring_setup, entries, p);
+}
+
+static int io_uring_register_bufs(int io_uring_fd, struct iovec *iovs, unsigned int nr)
+{
+	return syscall(__NR_io_uring_register, io_uring_fd,
+		       IORING_REGISTER_BUFFERS, iovs, nr);
+}
+
+static int io_uring_register_files(int io_uring_fd, int *fds, unsigned int nr)
+{
+	return syscall(__NR_io_uring_register, io_uring_fd,
+		       IORING_REGISTER_FILES, fds, nr);
+}
+
+static unsigned long long page_addr_to_pfn(unsigned long addr)
+{
+	int page_size = sysconf(_SC_PAGE_SIZE), fd, ret;
+	unsigned long long pfn;
+
+	if (page_size < 0)
+		return 0;
+	fd = open("/proc/self/pagemap", O_RDONLY);
+	if (fd < 0)
+		return 0;
+
+	ret = pread(fd, &pfn, sizeof(pfn), (addr / page_size) * 8);
+	close(fd);
+	if (ret < 0)
+		return 0;
+	/* Bits 0-54 have PFN for non-swapped page */
+	return pfn & 0x7fffffffffffff;
+}
+
+void test_io_uring_buf(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	char rbuf[4096], buf[4096] = "B\n";
+	union bpf_iter_link_info linfo;
+	struct bpf_iter_io_uring *skel;
+	int ret, fd, i, len = 128;
+	struct io_uring_params p;
+	struct iovec iovs[8];
+	int iter_fd;
+	char *str;
+
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	skel = bpf_iter_io_uring__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "bpf_iter_io_uring__open_and_load"))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(iovs); i++) {
+		iovs[i].iov_len	 = len;
+		iovs[i].iov_base = mmap(NULL, len, PROT_READ | PROT_WRITE,
+					MAP_ANONYMOUS | MAP_SHARED, -1, 0);
+		if (iovs[i].iov_base == MAP_FAILED)
+			goto end;
+		len *= 2;
+	}
+
+	memset(&p, 0, sizeof(p));
+	fd = sys_io_uring_setup(1, &p);
+	if (!ASSERT_GE(fd, 0, "io_uring_setup"))
+		goto end;
+
+	linfo.io_uring.io_uring_fd = fd;
+	skel->links.dump_io_uring_buf = bpf_program__attach_iter(skel->progs.dump_io_uring_buf,
+								 &opts);
+	if (!ASSERT_OK_PTR(skel->links.dump_io_uring_buf, "bpf_program__attach_iter"))
+		goto end_close_fd;
+
+	ret = io_uring_register_bufs(fd, iovs, ARRAY_SIZE(iovs));
+	if (!ASSERT_OK(ret, "io_uring_register_bufs"))
+		goto end_close_fd;
+
+	/* "B\n" */
+	len = 2;
+	str = buf + len;
+	for (int j = 0; j < ARRAY_SIZE(iovs); j++) {
+		ret = snprintf(str, sizeof(buf) - len, "%d:0x%lx:%zu\n", j,
+			       (unsigned long)iovs[j].iov_base,
+			       iovs[j].iov_len);
+		if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
+			goto end_close_fd;
+		len += ret;
+		str += ret;
+
+		ret = snprintf(str, sizeof(buf) - len, "`-PFN for bvec[0]=%llu\n",
+			       page_addr_to_pfn((unsigned long)iovs[j].iov_base));
+		if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
+			goto end_close_fd;
+		len += ret;
+		str += ret;
+	}
+
+	ret = snprintf(str, sizeof(buf) - len, "E:%zu\n", ARRAY_SIZE(iovs));
+	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
+		goto end_close_fd;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.dump_io_uring_buf));
+	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
+		goto end_close_fd;
+
+	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
+	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer"))
+		goto end_close_iter;
+
+	ASSERT_OK(strcmp(rbuf, buf), "compare iterator output");
+
+	puts("=== Expected Output ===");
+	printf("%s", buf);
+	puts("==== Actual Output ====");
+	printf("%s", rbuf);
+	puts("=======================");
+
+end_close_iter:
+	close(iter_fd);
+end_close_fd:
+	close(fd);
+end:
+	while (i--)
+		munmap(iovs[i].iov_base, iovs[i].iov_len);
+	bpf_iter_io_uring__destroy(skel);
+}
+
+void test_io_uring_file(void)
+{
+	int reg_files[] = { [0 ... 7] = -1 };
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	char buf[4096] = "B\n", rbuf[4096] = {}, *str;
+	union bpf_iter_link_info linfo = {};
+	struct bpf_iter_io_uring *skel;
+	int iter_fd, fd, len = 0, ret;
+	struct io_uring_params p;
+
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	skel = bpf_iter_io_uring__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "bpf_iter_io_uring__open_and_load"))
+		return;
+
+	/* "B\n" */
+	len = 2;
+	str = buf + len;
+	ret = snprintf(str, sizeof(buf) - len, "B\n");
+	for (int i = 0; i < ARRAY_SIZE(reg_files); i++) {
+		char templ[] = "/tmp/io_uringXXXXXX";
+		const char *name, *def = "<none>";
+
+		/* create sparse set */
+		if (i & 1) {
+			name = def;
+		} else {
+			reg_files[i] = mkstemp(templ);
+			if (!ASSERT_GE(reg_files[i], 0, templ))
+				goto end_close_reg_files;
+			name = templ;
+			ASSERT_OK(unlink(name), "unlink");
+		}
+		ret = snprintf(str, sizeof(buf) - len, "%d:%s%s\n", i, name, name != def ? " (deleted)" : "");
+		if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
+			goto end_close_reg_files;
+		len += ret;
+		str += ret;
+	}
+
+	ret = snprintf(str, sizeof(buf) - len, "E:%zu\n", ARRAY_SIZE(reg_files));
+	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
+		goto end_close_reg_files;
+
+	memset(&p, 0, sizeof(p));
+	fd = sys_io_uring_setup(1, &p);
+	if (!ASSERT_GE(fd, 0, "io_uring_setup"))
+		goto end_close_reg_files;
+
+	linfo.io_uring.io_uring_fd = fd;
+	skel->links.dump_io_uring_file = bpf_program__attach_iter(skel->progs.dump_io_uring_file,
+								  &opts);
+	if (!ASSERT_OK_PTR(skel->links.dump_io_uring_file, "bpf_program__attach_iter"))
+		goto end_close_fd;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.dump_io_uring_file));
+	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
+		goto end;
+
+	ret = io_uring_register_files(fd, reg_files, ARRAY_SIZE(reg_files));
+	if (!ASSERT_OK(ret, "io_uring_register_files"))
+		goto end_iter_fd;
+
+	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
+	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer(iterator_fd, buf)"))
+		goto end_iter_fd;
+
+	ASSERT_OK(strcmp(rbuf, buf), "compare iterator output");
+
+	puts("=== Expected Output ===");
+	printf("%s", buf);
+	puts("==== Actual Output ====");
+	printf("%s", rbuf);
+	puts("=======================");
+end_iter_fd:
+	close(iter_fd);
+end_close_fd:
+	close(fd);
+end_close_reg_files:
+	for (int i = 0; i < ARRAY_SIZE(reg_files); i++) {
+		if (reg_files[i] != -1)
+			close(reg_files[i]);
+	}
+end:
+	bpf_iter_io_uring__destroy(skel);
+}
+
 void test_bpf_iter(void)
 {
 	if (test__start_subtest("btf_id_or_null"))
@@ -1299,4 +1521,8 @@ void test_bpf_iter(void)
 		test_rdonly_buf_out_of_bound();
 	if (test__start_subtest("buf-neg-offset"))
 		test_buf_neg_offset();
+	if (test__start_subtest("io_uring_buf"))
+		test_io_uring_buf();
+	if (test__start_subtest("io_uring_file"))
+		test_io_uring_file();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c b/tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c
new file mode 100644
index 000000000000..caf8bd0bf8d4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+
+SEC("iter/io_uring_buf")
+int dump_io_uring_buf(struct bpf_iter__io_uring_buf *ctx)
+{
+	struct io_mapped_ubuf *ubuf = ctx->ubuf;
+	struct seq_file *seq = ctx->meta->seq;
+	unsigned int index = ctx->index;
+
+	if (!ctx->meta->seq_num)
+		BPF_SEQ_PRINTF(seq, "B\n");
+
+	if (ubuf) {
+		BPF_SEQ_PRINTF(seq, "%u:0x%lx:%lu\n", index, (unsigned long)ubuf->ubuf,
+			       (unsigned long)ubuf->ubuf_end - ubuf->ubuf);
+		BPF_SEQ_PRINTF(seq, "`-PFN for bvec[0]=%lu\n",
+			       (unsigned long)bpf_page_to_pfn(ubuf->bvec[0].bv_page));
+	} else {
+		BPF_SEQ_PRINTF(seq, "E:%u\n", index);
+	}
+	return 0;
+}
+
+SEC("iter/io_uring_file")
+int dump_io_uring_file(struct bpf_iter__io_uring_file *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	unsigned int index = ctx->index;
+	struct file *file = ctx->file;
+	char buf[256] = "";
+
+	if (!ctx->meta->seq_num)
+		BPF_SEQ_PRINTF(seq, "B\n");
+	/* for io_uring_file iterator, this is the terminating condition */
+	if (ctx->ctx->nr_user_files == index) {
+		BPF_SEQ_PRINTF(seq, "E:%u\n", index);
+		return 0;
+	}
+	if (file) {
+		bpf_d_path(&file->f_path, buf, sizeof(buf));
+		BPF_SEQ_PRINTF(seq, "%u:%s\n", index, buf);
+	} else {
+		BPF_SEQ_PRINTF(seq, "%u:<none>\n", index);
+	}
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.33.1

