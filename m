Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F865504757
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 11:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiDQJMj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 05:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbiDQJMi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 05:12:38 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D262980B
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:10:03 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bv19so22330104ejb.6
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iVc7wpSAVHRCsLgIOjeY2cxoPwGnEH78NuWW/7/6OBY=;
        b=ZevE4E/SP5Iv7wSO5EcxjhwgQVzsFskVcHKFaEhpZkce6Tv8rHz6Tk+OIh/rxfnL0K
         crR9TmjXAPre8D3PUyx2cK249IEfn+RgC8Py3OO6t8iO5iuL6qrODNQigO86MC9hsTtD
         AvjRwP5JmFcO3HQLY5GnhGGO37zk8w9vuhfkQvg7Yz24T1eK21orKLH0ji/lagx4UZQZ
         nWqafghXmSMmlfIRmQkedjlLyun57MczJUQ+NMwFbHmHFqprfiByM8S6VBqFJ1UQpxhF
         b1melDm6sD3/i9v9uEGui3c3yBEF57qkUlDCAQ57vN6nPMmwlnGSWN0S00EJKD2LU1F+
         q/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iVc7wpSAVHRCsLgIOjeY2cxoPwGnEH78NuWW/7/6OBY=;
        b=C80PE4NiXT547FOfujBi1vnuZFm9p6ls+HCYtV8I/23n10LO9WWQ1TqjBiZBvxpgyR
         Xcpq9hOi7+LZSXtMcbTR+dFF+AjfMYmJVU4vm2N/DXOph6LfgUV4g4kzFvmA0az/i5JM
         U6rf9vfWisevfZfBSefSNtu3WaoTgZOXH/NZo6pLV10E6l8w/D1TUXZwBV+eGi1+dyZQ
         FnUWCmpxepcZGNgSmNOatihvNn/hx7mJuWq2QEyvzmg6rweQSJCbdFgKrebALwwLPTIo
         sLNiVXECd6syjeogl2IZnL147ZqVsltE2lpyFZ7QsaX/hU+d8N+whC4vbvgcJFLZ3D0l
         UrdA==
X-Gm-Message-State: AOAM530zp9VevQ945+x8YQ+/nkXMLv+MLk4GyLxSPzEW8/mMHYr941ny
        msCll5kRPrWhLdkZJB0CxQAxgh/H8YI=
X-Google-Smtp-Source: ABdhPJyAXPNjcjQJrwNaMSM7U5fD2rnAj6hDM9jLOhHkuIesz/ZSqz3PcbwLqKDS1Ru4HIf/E40Umg==
X-Received: by 2002:a17:907:7b99:b0:6ec:9746:b5b5 with SMTP id ne25-20020a1709077b9900b006ec9746b5b5mr5203905ejc.392.1650186601893;
        Sun, 17 Apr 2022 02:10:01 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id bw3-20020a170906c1c300b006e88cdfbc32sm3423746ejb.45.2022.04.17.02.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 02:10:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/3] tests: add more file registration tests
Date:   Sun, 17 Apr 2022 10:09:25 +0100
Message-Id: <d50933f8313050ee43353a1f0f368df9f9ea00c0.1650186365.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650186365.git.asml.silence@gmail.com>
References: <cover.1650186365.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tests for file registration failing in the middle of the fd set, and
mixing files that need and don't SCM accounting + checking for
underflows.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/file-register.c | 95 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/test/file-register.c b/test/file-register.c
index bd15408..ee2fdcd 100644
--- a/test/file-register.c
+++ b/test/file-register.c
@@ -745,7 +745,90 @@ static int test_fixed_removal_ordering(void)
 	return 0;
 }
 
+/* mix files requiring SCM-accounting and not in a single register */
+static int test_mixed_af_unix(void)
+{
+	struct io_uring ring;
+	int i, ret, fds[2];
+	int reg_fds[32];
+	int sp[2];
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret < 0) {
+		fprintf(stderr, "failed to init io_uring: %s\n", strerror(-ret));
+		return ret;
+	}
+	if (pipe(fds)) {
+		perror("pipe");
+		return -1;
+	}
+	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
+		perror("Failed to create Unix-domain socket pair\n");
+		return 1;
+	}
+
+	for (i = 0; i < 16; i++) {
+		reg_fds[i * 2] = fds[0];
+		reg_fds[i * 2 + 1] = sp[0];
+	}
 
+	ret = io_uring_register_files(&ring, reg_fds, 32);
+	if (!ret) {
+		fprintf(stderr, "file_register: %d\n", ret);
+		return ret;
+	}
+
+	close(fds[0]);
+	close(fds[1]);
+	close(sp[0]);
+	close(sp[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+static int test_partial_register_fail(void)
+{
+	char buffer[128];
+	struct io_uring ring;
+	int ret, fds[2];
+	int reg_fds[5];
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret < 0) {
+		fprintf(stderr, "failed to init io_uring: %s\n", strerror(-ret));
+		return ret;
+	}
+	if (pipe(fds)) {
+		perror("pipe");
+		return -1;
+	}
+
+	/*
+	 * Expect register to fail as it doesn't support io_uring fds, shouldn't
+	 * leave any fds referenced afterwards.
+	 */
+	reg_fds[0] = fds[0];
+	reg_fds[1] = fds[1];
+	reg_fds[2] = -1;
+	reg_fds[3] = ring.ring_fd;
+	reg_fds[4] = -1;
+	ret = io_uring_register_files(&ring, reg_fds, 5);
+	if (!ret) {
+		fprintf(stderr, "file_register: %d\n", ret);
+		return ret;
+	}
+
+	/* ring should have fds referenced, can close them */
+	close(fds[1]);
+
+	/* confirm that fds[1] is actually close and to ref'ed by io_uring */
+	ret = read(fds[0], buffer, 10);
+	if (ret < 0)
+		perror("read");
+	close(fds[0]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
 
 int main(int argc, char *argv[])
 {
@@ -854,5 +937,17 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	ret = test_mixed_af_unix();
+	if (ret) {
+		printf("test_mixed_af_unix failed\n");
+		return 1;
+	}
+
+	ret = test_partial_register_fail();
+	if (ret) {
+		printf("test_partial_register_fail failed\n");
+		return ret;
+	}
+
 	return 0;
 }
-- 
2.35.2

