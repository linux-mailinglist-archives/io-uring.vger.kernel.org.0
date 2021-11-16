Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3270452A3F
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 07:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239556AbhKPGCf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240252AbhKPGBo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:01:44 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF592C04A402;
        Mon, 15 Nov 2021 21:43:00 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id r130so17138598pfc.1;
        Mon, 15 Nov 2021 21:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V4/reK9eDSJ60XjxkKKa4zy03IzWT9nBfESfKcYyf04=;
        b=GRVqm+SZdDdHB12BlbxiItHoN6sCkL47u9sM2PYCprpn2ATAaMTBLJ5iuBlZezgoU5
         mSwQ+i5H5mmndJCgMJJG/QEc9uVS/FtwAhs7kw3lfksPKJnUDxW9OlfK5H8kwFnGF9BW
         MxNvY6G+Up2gGgc5TGmy5jys4wU0OpzSNjrXf1VuP+AsyjPXUXI0F7m3ziEBQ0Op6M4Z
         1ohZPY/omKXNh8WMYTDqz2JnPPGH6mRNAXQf5UzwlvOl4+/van31sEduV+PwHVPzlVAX
         L1dGluhpUypUyRZI77meksrdWH9Tm1TSwS8JtelpPwF6EhfG3NXAyt1x7d7UBAn97ivw
         w3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V4/reK9eDSJ60XjxkKKa4zy03IzWT9nBfESfKcYyf04=;
        b=xNHBtFbvbXXZEUCYtrr0wuGSV7Ho6HnwqUDdrQPxhW/Fyhi+Yjb74qzIMaRpxKl64k
         SvA7fZhhB8f2R/YES7xWlExPw0V5IyfBW9GBU4HAq2Kw+90AFFU5peZ+iwOsErnSeaSC
         MUvkizsiqTn2ZFhUOKyZzgJZlDSyACINUU7E8FW/f7nMO1zNdCqYLzP3rPIxQVG7iAQ3
         2cwVcrB4NgyTmb8JQbGkev1bCX3A4YAvgidAIEqGPX3CX75WUpiP/fAV8NZLdwopvxdf
         4WWCPVeF7OjXiMPSOJH3A4Cw3rc7o/Y1pTwMquDfNMPIoXZuhgYqXhVCp9zj4ZC0WtIY
         TwQw==
X-Gm-Message-State: AOAM531ndu8Jwn6nDPC77d56iOYB9Men7Q2udWuwuTGXyfpF4F4VwHzW
        h79aF8eKyZFt5VRGkeWf1I+y28tnc70=
X-Google-Smtp-Source: ABdhPJz2tgyxpi3FNkGKmAzOfdZYkYwFUDJN0bb/JI5CPJ6f8fFkp0nUeQUnkn7aYO+eYxJZpaMRQQ==
X-Received: by 2002:a65:6388:: with SMTP id h8mr3163938pgv.94.1637041380137;
        Mon, 15 Nov 2021 21:43:00 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id 130sm17173265pfu.170.2021.11.15.21.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:42:59 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v1 7/8] selftests/bpf: Test partial reads for io_uring, epoll iterators
Date:   Tue, 16 Nov 2021 11:12:36 +0530
Message-Id: <20211116054237.100814-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116054237.100814-1-memxor@gmail.com>
References: <20211116054237.100814-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4142; h=from:subject; bh=mxVmYFKFc0knu3iGLQkyTonHs8thee+ZDz+UE2gs73o=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhk0S786C7TvJZRQU4B8/yCgav7Dp9RApqxGlxKiqj qzsyO5SJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZNEuwAKCRBM4MiGSL8RyucrD/ 9uriAEGOR2B8L5vXP9r13DHstYRKHWRHjy08Fj5FfjCUTyd8tdbG9QjsNV2vkv7hSD+PO2Vf5Rx1Pf zmegncP4pD1h5oGgq8fqGGHfHtXxoY6//Vcd2AttByNLQ3xsarHR1f2YaviYZEXYNZufWOwP47JpcK EcgVITTqFPTtsPeqaXoCq4TzOJ+VIgfAEB84KvGFr36vw6UOfsMNwIgoUVYH1LDfkB07ByHuXXGdv9 oPKC5uYHP6toUmEKPjl1pWXGp7dI2MzQf/PpQSKKAueh/zPhzlzKZY5d25j29Z/PjtCpaF3gyL+8sb K9Ny25oAygXltNhiNkNCSnYjYX5RryxXqmdQ/occelTuw0pJG1lcXv4io5gkAkRySN6rVv/PU9mXxv UIMQSjRpMXD6rxk+rMT2QDbSzIgvMVkw7oiHPw2j1gUoyPJBMLV0gWBpR4stBuPwoOO8jVErZ4PskN BL0NZh7cA4ZgT44hg902y7q8FNGux8a3fJicTRkXXHdCyIHpY3VcJcclv9j6ThccMYzyibTC0o+C9H uA8mi0qXXmZBtMbqIA0lCnoeXRsi3bkoyY18GRYh4D7l4pvUU5nLOeQwaoO0en12sKbGeQF56oVKX/ X0s3F7xTZbqM11kLwJdUQe7d2d73SORMv1v1TX2WIldowebxni5K26Qpc3rQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ensure that the output is consistent in face of partial reads that
return to userspace and then resume again later. To this end, we do
reads in 1-byte chunks, which is a bit stupid in real life, but works
well to simulate interrupted iteration. This also tests case where
seq_file buffer is consumed (after seq_printf) on interrupted read
before iterator invoked BPF prog again.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 33 ++++++++++++-------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 45e186385f9a..c27f3e10211c 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -72,13 +72,13 @@ static void do_dummy_read(struct bpf_program *prog)
 	bpf_link__destroy(link);
 }
 
-static int read_fd_into_buffer(int fd, char *buf, int size)
+static int __read_fd_into_buffer(int fd, char *buf, int size, size_t chunks)
 {
 	int bufleft = size;
 	int len;
 
 	do {
-		len = read(fd, buf, bufleft);
+		len = read(fd, buf, chunks ?: bufleft);
 		if (len > 0) {
 			buf += len;
 			bufleft -= len;
@@ -88,6 +88,11 @@ static int read_fd_into_buffer(int fd, char *buf, int size)
 	return len < 0 ? len : size - bufleft;
 }
 
+static int read_fd_into_buffer(int fd, char *buf, int size)
+{
+	return __read_fd_into_buffer(fd, buf, size, 0);
+}
+
 static void test_ipv6_route(void)
 {
 	struct bpf_iter_ipv6_route *skel;
@@ -1281,7 +1286,7 @@ static unsigned long long page_addr_to_pfn(unsigned long addr)
 	return pfn & 0x7fffffffffffff;
 }
 
-void test_io_uring_buf(void)
+void test_io_uring_buf(bool partial)
 {
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
 	char rbuf[4096], buf[4096] = "B\n";
@@ -1352,7 +1357,7 @@ void test_io_uring_buf(void)
 	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
 		goto end_close_fd;
 
-	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
+	ret = __read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf), partial);
 	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer"))
 		goto end_close_iter;
 
@@ -1374,7 +1379,7 @@ void test_io_uring_buf(void)
 	bpf_iter_io_uring__destroy(skel);
 }
 
-void test_io_uring_file(void)
+void test_io_uring_file(bool partial)
 {
 	int reg_files[] = { [0 ... 7] = -1 };
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
@@ -1439,7 +1444,7 @@ void test_io_uring_file(void)
 	if (!ASSERT_OK(ret, "io_uring_register_files"))
 		goto end_iter_fd;
 
-	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
+	ret = __read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf), partial);
 	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer(iterator_fd, buf)"))
 		goto end_iter_fd;
 
@@ -1463,7 +1468,7 @@ void test_io_uring_file(void)
 	bpf_iter_io_uring__destroy(skel);
 }
 
-void test_epoll(void)
+void test_epoll(bool partial)
 {
 	const char *fmt = "B\npipe:%d\nsocket:%d\npipe:%d\nsocket:%d\nE\n";
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
@@ -1529,7 +1534,7 @@ void test_epoll(void)
 	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf), "snprintf"))
 		goto end_iter_fd;
 
-	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
+	ret = __read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf), partial);
 	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer"))
 		goto end_iter_fd;
 
@@ -1641,9 +1646,15 @@ void test_bpf_iter(void)
 	if (test__start_subtest("buf-neg-offset"))
 		test_buf_neg_offset();
 	if (test__start_subtest("io_uring_buf"))
-		test_io_uring_buf();
+		test_io_uring_buf(false);
 	if (test__start_subtest("io_uring_file"))
-		test_io_uring_file();
+		test_io_uring_file(false);
 	if (test__start_subtest("epoll"))
-		test_epoll();
+		test_epoll(false);
+	if (test__start_subtest("io_uring_buf-partial"))
+		test_io_uring_buf(true);
+	if (test__start_subtest("io_uring_file-partial"))
+		test_io_uring_file(true);
+	if (test__start_subtest("epoll-partial"))
+		test_epoll(true);
 }
-- 
2.33.1

