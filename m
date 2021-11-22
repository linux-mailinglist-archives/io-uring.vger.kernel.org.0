Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830B34597F8
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 23:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhKVW52 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 17:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhKVW5V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 17:57:21 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0920EC061574;
        Mon, 22 Nov 2021 14:54:13 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id y7so15450211plp.0;
        Mon, 22 Nov 2021 14:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eZz/i/LW/pYopHevV0UZkgBAZImgYdtC2F2e/9PEk9U=;
        b=AdDdLNU7XyI+BGSi7FA85aclwzQMdZ/bI6OurYqcqYTExE2OvviWbNZhbCNnhw3nR5
         +pN1uVVSITe4yy97KEjnoZiv/t+VFnM/Hap+bcLQYVy3X1wWnaoIy0MXXC13SIAigcGI
         mk6vTmPqyZKKA2gz2qXkCHCC9VWSDnRda9nnDukBN6QwA0J0AR6wg7Z+BDi4FAGXlOiB
         j6KU5lfeYTSyAlx0V0iCiJE0KRaBWOTnTA7H++JiN/SnB+vJJTcGN+Df8VPkbwY0O0JT
         MJB42/OmitwwNWopbugEGLEeFW2PcHgKXNKSVQ90TNs0hodMVPpPCwolhiwwrPLEgiTc
         MDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZz/i/LW/pYopHevV0UZkgBAZImgYdtC2F2e/9PEk9U=;
        b=4A3U8kOsaV5CGXRAdbOD6wOuD8yx9AP7fdIwiM8DKj3vQnz5JRAcrdYYtmKtIADm4z
         Xxx8TRs/QKBUn7SbiqJyPeXHvWqL56Y3w8lcz/7iuSZGJGY8EJwS+1Dqe07qr7BbpC4r
         EjpXhDOEkpB+k5j50HNXuJvEd5vSqVvpUpLp2Nqe4JAe5g30bQNaRBRqfh1nd8ley4GO
         MExdIP3BeWkd4qwDExTDoPRDtgVBzY0I4hhPTfsPaPd+rPdiKgTiv9hVAmOL8RCBOc3Q
         Qr4Yt+DpgyJE0L88QYJ8pdsXRHvy0iOLGf7GgmjCgLZ5bEt/2JEG9Hmm47jr9CQWOBpO
         hhwA==
X-Gm-Message-State: AOAM531Un+zDNPn6XxbKt1E+A/Df3+/WFs0lkJmA+o9M8fch4vcD+KCO
        i+1vrQPz+D7jBtj8VAoPScsj2VCkevE=
X-Google-Smtp-Source: ABdhPJyOmlQPIlKjWbA5AxRKnGAZnr8K8j9+YPSInHCHgJLxdaGpzxcefhttMp9XEc+LZ02Gy2rEVg==
X-Received: by 2002:a17:902:d4d0:b0:141:c13d:6c20 with SMTP id o16-20020a170902d4d000b00141c13d6c20mr507350plg.44.1637621652388;
        Mon, 22 Nov 2021 14:54:12 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id c10sm3588081pgk.84.2021.11.22.14.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:54:12 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v2 06/10] selftests/bpf: Add test for io_uring BPF iterators
Date:   Tue, 23 Nov 2021 04:23:48 +0530
Message-Id: <20211122225352.618453-7-memxor@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211122225352.618453-1-memxor@gmail.com>
References: <20211122225352.618453-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10827; h=from:subject; bh=kxGPKIv67E1/n+m11jdziOrgwqJ5F4bn7WE5AYofjKY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhnBrL6LM8NFigs+Kn+EQ1mc+HyeU9K+wFutqBdQTb QNTJZU6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZwaywAKCRBM4MiGSL8RyonlEA C67wEFtLrD91zVdY+J8t3iMwQbF5f65M6iA+o5yRQv9xhWGzY/4yDiiZ7R9qd/id3wgN2lW7zsj3zo JvyPqdv4RAJK8ykp9/b3pQKPQqgq4FCaeVKCbz4Nr2XK8Un4q7mgGW13Azv7DfdhhuJqVN9DFatKq7 u2/gMGwgxZCplBWPhLf3enFv+OEHtcQOpS27rcEWhdoNM5Tzz3d0CQMMTpI6sJyK7tvGp22lBoXx4c gbmA7tfGPiZechuyhQQAPUEMUX4A9VkieZs8E7l2aTcfyBu+DMtws3eUsFSyLM2jK/Uol/4Chp4Vos wiBSfGgSEA0JbSjlSC81wSKF2RhHKggRS/DPJMOeKi3O6yqzcoJt0/C1COy5OI+or40rNM+8Zja50G 3c75N0Uzpnb/sok9ia4oBZ5GTnfYJ1g8NqAibeIuHZtsSeg/hI8zg+MLms0dOhVV8jWH6Nx0+PUXDp K/6bs18ES0hVWLUn5lZgVV+k8YTneSZx+4Uj0Qn0a3UdzHhdXuVX/WkiX09xhrtGg+b7HAhXU8CFWa xJ4W3Cqmg7jCAXaHVpGPfZxCVgi5wUbmtpQ1cWv2hyEbpjaNx2PTAJfI8U69n0X5Q+fAGmSHidsVdf qPbFpJeHlaCM0saeE/0cwoDDFWmuJC/cqApFNk+eNfz4CB5y4qlWqte2Xkfg==
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
 .../selftests/bpf/prog_tests/bpf_iter.c       | 251 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_io_uring.c   |  50 ++++
 2 files changed, 301 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 3e10abce3e5a..d21121d62458 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -1,6 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+#include <sys/stat.h>
+#include <sys/mman.h>
 #include <test_progs.h>
+#include <linux/io_uring.h>
+
 #include "bpf_iter_ipv6_route.skel.h"
 #include "bpf_iter_netlink.skel.h"
 #include "bpf_iter_bpf_map.skel.h"
@@ -26,6 +30,7 @@
 #include "bpf_iter_bpf_sk_storage_map.skel.h"
 #include "bpf_iter_test_kern5.skel.h"
 #include "bpf_iter_test_kern6.skel.h"
+#include "bpf_iter_io_uring.skel.h"
 
 static int duration;
 
@@ -1239,6 +1244,248 @@ static void test_task_vma(void)
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
+static int io_uring_inode_match(int link_fd, int io_uring_fd)
+{
+	struct bpf_link_info linfo = {};
+	__u32 info_len = sizeof(linfo);
+	struct stat st;
+	int ret;
+
+	ret = fstat(io_uring_fd, &st);
+	if (ret < 0)
+		return -errno;
+
+	ret = bpf_obj_get_info_by_fd(link_fd, &linfo, &info_len);
+	if (ret < 0)
+		return -errno;
+
+	ASSERT_EQ(st.st_ino, linfo.iter.io_uring.inode, "io_uring inode matches");
+	return 0;
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
+	if (!ASSERT_OK(io_uring_inode_match(bpf_link__fd(skel->links.dump_io_uring_buf), fd), "inode match"))
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
+	if (!ASSERT_OK(strcmp(rbuf, buf), "compare iterator output")) {
+		puts("=== Expected Output ===");
+		printf("%s", buf);
+		puts("==== Actual Output ====");
+		printf("%s", rbuf);
+		puts("=======================");
+	}
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
+	if (!ASSERT_OK(io_uring_inode_match(bpf_link__fd(skel->links.dump_io_uring_file), fd), "inode match"))
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
+	if (!ASSERT_OK(strcmp(rbuf, buf), "compare iterator output")) {
+		puts("=== Expected Output ===");
+		printf("%s", buf);
+		puts("==== Actual Output ====");
+		printf("%s", rbuf);
+		puts("=======================");
+	}
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
@@ -1299,4 +1546,8 @@ void test_bpf_iter(void)
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
2.34.0

