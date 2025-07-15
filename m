Return-Path: <io-uring+bounces-8677-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15487B05095
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 07:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 404DF1AA50AB
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 05:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F982D3217;
	Tue, 15 Jul 2025 05:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="DHS0+cly"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA9535975;
	Tue, 15 Jul 2025 05:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556005; cv=none; b=Ay2agAcX3egmjmVCwYdXH5J/sBGl129eJALbukfW60GtrxeEHq9NxgZHn5oQhCPUbb8ulBV4lAr3E3vr8DEEQB2lb1zh72YvGq8bL3tatTcgdpnM7KHc+jwC2lxLzYh9E6TdVIojLqjfBO3ZetPjCyz2Ddgk63X+Oxvti8COJlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556005; c=relaxed/simple;
	bh=WAWa2xKLVGTmrGvKn2wWInzanbVsdNjrixT7OQNpvbw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u2ross00D1JKnV4Ch3YZV/RLbfPLIfOYuPoWDOGmHXhRoEbde5Xwwd/Nhq2kH9VAMYiUttmXcTCGeGxeZagGsPKHEMH/WE4EOFF9DNy1T8LbunuEDIA2HGc2U0saskHKtR/WH1NpwkndWW73ibXt6SHtChikg0PEliO5NReWA60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=DHS0+cly; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752555996;
	bh=WAWa2xKLVGTmrGvKn2wWInzanbVsdNjrixT7OQNpvbw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=DHS0+clyZVv+weZAlTt5AaGtsH85O4gCIN8jFS5RxBH9kZ8HSouzsTMYMFfv9cddv
	 /M9VNqyNZ+kr1NKBPDd/hqToNalTLQ/kimJ0ezceIKtfkL5eqIhiE9hzAByvQ5by6I
	 xOCKbyL7X4VS1NjQV/3YDZYtKnQutBTBxBmdjcfcCYAqIA09TWjBGs1mAC411W7Va8
	 AVbwB00MVcnp8d5T66l9mWqhouOCe6620HsOsMar7eQI+HXEW97ogT9oAymv6oJ3D8
	 UidXrWRPPeOsi7a3AqcjvGQjjxOfVbi4Mqpj8KycE0xrIg1FyJ93cz1pNpho60E43d
	 hgOKzb8ODUYSA==
Received: from server-vie001.gnuweeb.org (unknown [192.168.57.1])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 35BFB2109A36;
	Tue, 15 Jul 2025 05:06:36 +0000 (UTC)
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing 1/3] Revert "test/io_uring_register: kill old memfd test"
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Tue, 15 Jul 2025 12:06:27 +0700
Message-Id: <20250715050629.1513826-2-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250715050629.1513826-1-alviro.iskandar@gnuweeb.org>
References: <20250715050629.1513826-1-alviro.iskandar@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 732bf609b670631731765a585a68d14ed3fdc9b7.

Bring back `CONFIG_HAVE_MEMFD_CREATE` and the associated memfd test
to resolve Android build failures caused by:

  93d3a7a70b4a ("examples/zcrx: udmabuf backed areas")

It added a call to `memfd_create()`, which is unavailable on some
Android toolchains, leading to the following build error:

```
  zcrx.c:111:10: error: call to undeclared function 'memfd_create'; ISO C99 and \
  later do not support implicit function declarations \
  [-Wimplicit-function-declaration]
    111 |         memfd = memfd_create("udmabuf-test", MFD_ALLOW_SEALING);
        |                 ^
```

This reversion is a preparation step for a proper fix by ensuring
`memfd_create()` usage is guarded and portable. Issue #620 was
initially unclear, but we now suspect it stemmed from improper
compiler/linker flag combinations.

Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 configure                |  19 +++++++
 test/io_uring_register.c | 119 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+)

diff --git a/configure b/configure
index 552f8ae..3c95214 100755
--- a/configure
+++ b/configure
@@ -379,6 +379,22 @@ if compile_prog "" "" "has_ucontext"; then
 fi
 print_config "has_ucontext" "$has_ucontext"
 
+##########################################
+# check for memfd_create(2)
+has_memfd_create="no"
+cat > $TMPC << EOF
+#include <sys/mman.h>
+int main(int argc, char **argv)
+{
+  int memfd = memfd_create("test", 0);
+  return 0;
+}
+EOF
+if compile_prog "-Werror=implicit-function-declaration" "" "has_memfd_create"; then
+  has_memfd_create="yes"
+fi
+print_config "has_memfd_create" "$has_memfd_create"
+
 ##########################################
 # Check NVME_URING_CMD support
 nvme_uring_cmd="no"
@@ -539,6 +555,9 @@ fi
 if test "$array_bounds" = "yes"; then
   output_sym "CONFIG_HAVE_ARRAY_BOUNDS"
 fi
+if test "$has_memfd_create" = "yes"; then
+  output_sym "CONFIG_HAVE_MEMFD_CREATE"
+fi
 if test "$nvme_uring_cmd" = "yes"; then
   output_sym "CONFIG_HAVE_NVME_URING"
 fi
diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index b53a67d..f08f0ca 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -32,6 +32,17 @@ static int pagesize;
 static rlim_t mlock_limit;
 static int devnull;
 
+#if !defined(CONFIG_HAVE_MEMFD_CREATE)
+#include <sys/syscall.h>
+#include <linux/memfd.h>
+
+static int memfd_create(const char *name, unsigned int flags)
+{
+	return (int)syscall(SYS_memfd_create, name, flags);
+}
+#endif
+
+
 static int expect_fail(int fd, unsigned int opcode, void *arg,
 		       unsigned int nr_args, int error, int error2)
 {
@@ -466,6 +477,113 @@ static int __test_poll_ringfd(int ring_flags)
 	return status;
 }
 
+static int test_shmem(void)
+{
+	const char pattern = 0xEA;
+	const int len = 4096;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	struct iovec iov;
+	int memfd, ret, i;
+	char *mem;
+	int pipefd[2] = {-1, -1};
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret)
+		return 1;
+
+	if (pipe(pipefd)) {
+		perror("pipe");
+		return 1;
+	}
+	memfd = memfd_create("uring-shmem-test", 0);
+	if (memfd < 0) {
+		fprintf(stderr, "memfd_create() failed %i\n", -errno);
+		return 1;
+	}
+	if (ftruncate(memfd, len)) {
+		fprintf(stderr, "can't truncate memfd\n");
+		return 1;
+	}
+	mem = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, memfd, 0);
+	if (!mem) {
+		fprintf(stderr, "mmap failed\n");
+		return 1;
+	}
+	for (i = 0; i < len; i++)
+		mem[i] = pattern;
+
+	iov.iov_base = mem;
+	iov.iov_len = len;
+	ret = io_uring_register_buffers(&ring, &iov, 1);
+	if (ret) {
+		if (ret == -EOPNOTSUPP) {
+			fprintf(stdout, "memfd registration isn't supported, "
+					"skip\n");
+			goto out;
+		}
+
+		fprintf(stderr, "buffer reg failed: %d\n", ret);
+		return 1;
+	}
+
+	/* check that we can read and write from/to shmem reg buffer */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_write_fixed(sqe, pipefd[1], mem, 512, 0, 0);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit write failed\n");
+		return 1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0 || cqe->user_data != 1 || cqe->res != 512) {
+		fprintf(stderr, "reading from shmem failed\n");
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* clean it, should be populated with the pattern back from the pipe */
+	memset(mem, 0, 512);
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read_fixed(sqe, pipefd[0], mem, 512, 0, 0);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit write failed\n");
+		return 1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0 || cqe->user_data != 2 || cqe->res != 512) {
+		fprintf(stderr, "reading from shmem failed\n");
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	for (i = 0; i < 512; i++) {
+		if (mem[i] != pattern) {
+			fprintf(stderr, "data integrity fail\n");
+			return 1;
+		}
+	}
+
+	ret = io_uring_unregister_buffers(&ring);
+	if (ret) {
+		fprintf(stderr, "buffer unreg failed: %d\n", ret);
+		return 1;
+	}
+out:
+	io_uring_queue_exit(&ring);
+	close(pipefd[0]);
+	close(pipefd[1]);
+	munmap(mem, len);
+	close(memfd);
+	return 0;
+}
+
 static int test_poll_ringfd(void)
 {
 	int ret;
@@ -526,6 +644,7 @@ int main(int argc, char **argv)
 	/* uring poll on the uring fd */
 	status |= test_poll_ringfd();
 
+	status |= test_shmem();
 	if (status)
 		fprintf(stderr, "FAIL\n");
 
-- 
Alviro Iskandar Setiawan


