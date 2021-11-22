Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B364597FD
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 23:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhKVW5f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 17:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhKVW52 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 17:57:28 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABB4C061574;
        Mon, 22 Nov 2021 14:54:18 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so482787pjc.4;
        Mon, 22 Nov 2021 14:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZuwyt+Y+4UQRZDTE6VtW15hsN/SCV8zV6qhcm9x7FM=;
        b=TaYppKIjGc4gpYNPPjDJ56F8KjjWLXMJ3WQFPpeOwx8ktZEUZwHGrM/a6Nf0pZEhbf
         oGLBBsbHtZE2FD9rbDZVvD3xNYctH9nyR/Qm2G/CJoqQjSTXU27tX1t12sn/cu5jhHtV
         8cjfaEvx4X9C3NUOjDdJ2DvBI2yLaq6M/D++ktwsYg7OHnVymJrphv+kQN8Ue1d7vnmY
         Lg/XFQabFjMSEyhLp/rZwIbQw4ApLi2MUUhGAyFsNAdxbVBi4DZmvnx44LOn2l+GY3cC
         p/QX0rBDBy/zT2UQtzmrHIMKW4zrBCDzhU5H4QP0em1yK4L82T6iW5srwFXdpGFlbcXr
         /hWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZuwyt+Y+4UQRZDTE6VtW15hsN/SCV8zV6qhcm9x7FM=;
        b=1tR08hytAx0SgS6yjuM0hgKBu1YEiObn3zKyxGFiVFb+KkexzjiCx/83i1SpGIW7RT
         uD7OdkXhNoMg/BaX0yWo80x9kGzoYVRf38/6GOB/SkzsdqqxYBDOcHvRBU5Svu+WyyVj
         v94KMvpGVaicJyV7gKXftdsCDJzO9vtjZ58jFHTHeTTPEImWmHRzAZiPBxh+gBioNqMg
         jtGGnMUekbIqyZwmnXJBAChpN5jEN8Us7c0j6VrpnLIUBfhl927Kiv5LNlml52Dc+it8
         IBVRoU+aUbYqZrXmoBtKxPfIYrQ4WWt9ui5noGIsKDJMzGOt3GnQJDZWnPTJFT3j1mVt
         YNww==
X-Gm-Message-State: AOAM530hXvjQkiiQqhNVFPeiuI3QF/GcF9mGzLQIduTERjKbTvAYy3US
        S4e1Kq4tOIvU3yPmkhXAt37SvtsUxOE=
X-Google-Smtp-Source: ABdhPJz7xp4/3KJeIimufNvobLHlPjPPVRcmHj8sNO7wRM6XVqcJjBb48wwe4XXSYoS3iH1BrcLLpw==
X-Received: by 2002:a17:90b:1d0e:: with SMTP id on14mr36398251pjb.119.1637621658246;
        Mon, 22 Nov 2021 14:54:18 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id o16sm10700034pfu.72.2021.11.22.14.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:54:18 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v2 08/10] selftests/bpf: Test partial reads for io_uring, epoll iterators
Date:   Tue, 23 Nov 2021 04:23:50 +0530
Message-Id: <20211122225352.618453-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211122225352.618453-1-memxor@gmail.com>
References: <20211122225352.618453-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4120; h=from:subject; bh=4JGBx8JjpHH7oyNohjtBYSdYYGQ+zVIqYnuCTh5qHs8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhnBrMZOhXqrnAI1QC53VXLf0cXttDgsEWQxgxa1tK lxvtmWGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZwazAAKCRBM4MiGSL8RyrlvEA CxZKWosDm1hIKrpqx56T55Cz47L8Y6MtQUqq+VBttYvHEB/tZ3ym58nQXns+j69uF3SCp8Her+V27V lHiDnlON37PPWfPlJysSFDIfxTLY9raxAqTgMDQdt5PBRmnmmZTEx4262bJ1AzwnWxsCq3qW2ctkgh fia18SvR/j8fKO4O/d+vGMEpfGOljvyK7bcZ+y9rLY89a69o4XwB2T7GiB65j04xXNT9IYfJRl/2nQ izT3QppDlmGn5OGBriTIBt1Jlc6U0vpevhedgU9IbavK9q7KSIdJAe6QLxqY1jCkcqKP7YZJ+AFaeJ zncDdAn9xKOrjcnrSBbGb+8vwIJzRK+3a7Cpd5o68NjTYxh7fmRtM5sxpKeTXtu/72LjQK0WlXF1+/ la7QnXVAUVJfzQFzgjS4xXvkkFWOK7cxvoJCmvxlwXWdZmsXCuhH+3m2Q98yMgRgeNUvokrgD5VJbc KogKcRPD5RpeowIr29Pfmnf80L3L1hDqq/XgtqJ6y6XQtiFhyhHd90RkD7Wqioz3CeosS7Jq7E5PqQ zaOrz4Yz6jRyR3dWMQuVtVY66qSAM9GSg/PcEdDKHCK135NzdLZPo+uTKZuTbR06T8vhYg0NwFk+xB Wqq/uoRwNEpvuAyoCtGESwQELYMDyxeWQRgr2A/XDoaSXs1D9EZLqPBHO7IQ==
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
index 7fb995deb22d..c7343a3f5155 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -73,13 +73,13 @@ static void do_dummy_read(struct bpf_program *prog)
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
@@ -89,6 +89,11 @@ static int read_fd_into_buffer(int fd, char *buf, int size)
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
@@ -1301,7 +1306,7 @@ static int io_uring_inode_match(int link_fd, int io_uring_fd)
 	return 0;
 }
 
-void test_io_uring_buf(void)
+void test_io_uring_buf(bool partial)
 {
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
 	char rbuf[4096], buf[4096] = "B\n";
@@ -1375,7 +1380,7 @@ void test_io_uring_buf(void)
 	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
 		goto end_close_fd;
 
-	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
+	ret = __read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf), partial);
 	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer"))
 		goto end_close_iter;
 
@@ -1396,7 +1401,7 @@ void test_io_uring_buf(void)
 	bpf_iter_io_uring__destroy(skel);
 }
 
-void test_io_uring_file(void)
+void test_io_uring_file(bool partial)
 {
 	int reg_files[] = { [0 ... 7] = -1 };
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
@@ -1464,7 +1469,7 @@ void test_io_uring_file(void)
 	if (!ASSERT_OK(ret, "io_uring_register_files"))
 		goto end_iter_fd;
 
-	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
+	ret = __read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf), partial);
 	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer(iterator_fd, buf)"))
 		goto end_iter_fd;
 
@@ -1488,7 +1493,7 @@ void test_io_uring_file(void)
 	bpf_iter_io_uring__destroy(skel);
 }
 
-void test_epoll(void)
+void test_epoll(bool partial)
 {
 	const char *fmt = "B\npipe:%d\nsocket:%d\npipe:%d\nsocket:%d\nE\n";
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
@@ -1554,7 +1559,7 @@ void test_epoll(void)
 	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf), "snprintf"))
 		goto end_iter_fd;
 
-	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
+	ret = __read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf), partial);
 	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer"))
 		goto end_iter_fd;
 
@@ -1666,9 +1671,15 @@ void test_bpf_iter(void)
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
2.34.0

