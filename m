Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AEB4645EE
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 05:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346597AbhLAE1y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 23:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346606AbhLAE1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 23:27:38 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECFFC06175A;
        Tue, 30 Nov 2021 20:24:01 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id s37so12537553pga.9;
        Tue, 30 Nov 2021 20:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/GG26fljeFe9x6wzQv8DNbXQNyp/pOqmJex7xSjYwQY=;
        b=SnJBUkTHcfWk6urUJMXJzXclIQBnC03ctgh2DcPP4EvvRRWbxLtOPIQbY9ehhmUIo6
         JIofsap0RTaSSRNEsvdf2drwr4IWqIGCeahfgCWOUMtu2UtFEumIr8mqIfHa0sXyHG6O
         iTULkA/H3DFGKAFuGkLGGh/g+5qWBTPRGUQznCERwhz7hdQO6fS7B0Pc8+R3suWySvXR
         PniLlgrUKlAUNz0LQTFf+N9BthY80KchPRjsmcTz18Yu9vo/jOFtpJ5+SGf8RG4C+oqy
         f6F8RUbfBljHq1tLfqn/JbnUF+zoN+1KfFZYuVptQ8SpHG50P8EIKCw4qjOdRAIQuByY
         DCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/GG26fljeFe9x6wzQv8DNbXQNyp/pOqmJex7xSjYwQY=;
        b=1qihPktxkVCuF8NURhMgof9KWIQOm7ChqFINhHIsODpuvDRWUcsmALz45GmDfIrE3X
         G4e33Uwn0ZHVnmT0cqIzokKoGg+mDM9X+0/uuLrl0yxgLaOMht5gu36F7Aqe3duNbHFD
         k7yQslxdw+eH0VZw0XmS5aYvIzzkCeFfWbTmZhfUO7zf/1wJhJA708hyy4rp3yIMHvsF
         wLproyKjOxVDbqZVG+L/d0YF8KM+832trSxfMj7OzKc6yasq1hyRoTIehuKrOHp0XzV4
         QdA0JLVsBUrV0ciBntIXja1NODvqaEtzD/YXd1C8msTwnLvrJolyar2KZZgVYumFc1W3
         p2bQ==
X-Gm-Message-State: AOAM531tg1/zTIquPFRXZy9ZvFwYEuugnHbqoDQ2YSemm4+jE8f6adxt
        WEqTbi6TFxW8njmeGLiX3xweXpHKaCY=
X-Google-Smtp-Source: ABdhPJzzZpX3Lrd931VgUe8gGDP/OUZQWzFevWu/CavZhJvUCF5YDd7DWx9Ma0rJZRvjQxIJhFjMUA==
X-Received: by 2002:a65:4bc6:: with SMTP id p6mr2812040pgr.544.1638332641147;
        Tue, 30 Nov 2021 20:24:01 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id qe2sm4538986pjb.42.2021.11.30.20.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:24:00 -0800 (PST)
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
Subject: [PATCH bpf-next v3 08/10] selftests/bpf: Test partial reads for io_uring, epoll iterators
Date:   Wed,  1 Dec 2021 09:53:31 +0530
Message-Id: <20211201042333.2035153-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211201042333.2035153-1-memxor@gmail.com>
References: <20211201042333.2035153-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4120; h=from:subject; bh=aaB79qIuMMM7CbUZq9r3qLVaIyomUA09O47gys8VzJY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhpvYyIvWjAWHOYOzMoD2ZREvPrPxvUqFa24X82mna LbuaSzaJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYab2MgAKCRBM4MiGSL8RypZIEA CR3mW3w4TBLpLOUaxrQ2T2UfBGffRRTxgV3Vo4MoGuYCOpdoYiSKh0FAQd38pZZ9i7K/X0T1+uBC0q 14ezpGDLl1SbiXNe4KZzqBQ6UWN1Q3G7kgOSdwYtir9Z9uDTTZ+GNCVlyhaB6Ut1eZmsvQhYXA/VMf XVXsgGaJfcjhg1NrUZqDD90sfaPLAH085IavERpfNOK3FUw2Vis8SDpGHtVLj+dS9lboxdXpehGk2K GGqvdEews0VF9uRivLIz8rd/w6pactdirOTZjQqTn0GbkIU84sDLAMUeXcyt9IJl9BTG9BBmiJsFTc TbqTjJts04aUEZ/3JSpCv5ULYsrnQ89nHedL91pvqCAnyqtBBky4KgWb/bn0HaJqyAFC9RnkcCFjLG ogBePSCceufxFl2joHm36v5o4JuL8RzRCeccDFocvcOTEPHhto4LuGSm7Eeql1+TGTln5QeO+xqgID 7J3/io4Sq+j5Xfd+36jLo1AL/SKWH7V5stF8uxWT0+vsCMcuHezb4FhoVETOuwvpQthyDWRClMAiRt 5uVTcfGvdoXv1WkgKput9St+Ozk6cjPkHLCUKu4IfM9DmevmZhRfH2opJYcAX+pfJSdHzMXb336Lcr E+RgbOPWq66u43PvyHRL5WP8xt4ULQAuQctpFKNTjHRIFEvqE5DQ023hRKaQ==
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
index cc0555c5b373..3a07fdf31874 100644
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
2.34.1

