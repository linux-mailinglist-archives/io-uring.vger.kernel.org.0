Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEC2504804
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 16:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiDQOcw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 10:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiDQOcv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 10:32:51 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4104813F9F
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 07:30:16 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id v15so14988291edb.12
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 07:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L/O2E7Cy7r+Q5VE7SuuJ2AxkqBuE9EF5sUVv+9UQ2t4=;
        b=cXJS8p7czYQFhO/adVXecJmTU8do1Z7rVPQUhDE+UWZH7jpkcKdoZ36jwAaXGapBwH
         CyPY94l6yYa/ug4toFucd62M3jNY/kRZM2huga8JWBC1mCmQXVQvh2lfHY462yBLsPjm
         WOQrSwFFCH8grh2bWp6P4ww5fG+HODtDLiMct1AYLEPjyHEq3C63jzYTDMfc8XC/SCaz
         NQPd6qwvJN4HogQQsyXkxqPF2o49OCkJLqHtlRb1IGxwoGsXRtApRCbBAv++8nu59p2N
         U44CEulxYXoh5jEquCqt5A2jiZIOIKTrFHC/dSzMSGBAKVVm54blRC13QoOJbX1aZmEN
         cSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L/O2E7Cy7r+Q5VE7SuuJ2AxkqBuE9EF5sUVv+9UQ2t4=;
        b=JF162fQJ27sKJ4cns+qtotEcDboJxyr+6+EunyFvGe1AWNKooZlgA208zLMNy6zjzb
         p9ZAJCPqEIuCO380kk9U0HmBs2nfXcFr1aelww1KOVNqd1ivSPOMfCHdX7QV3vGwLnhk
         vHDCJbbBrDLZW++k2vSWv//e5jsmShzBIWaWt5vtolAcGXIa+Lx8LK5d0E5+udd+IBQ8
         lK7fTfZcFaZPmG5Kmb/7djOdXnnp4Vz8e+azNKb39Qh2k1StJP0IF/SfqR0qqdc/hc3k
         2TQxdQlqt5+s54UuvJsfOdrFjQRCRKTJbFK8PuKHp9c/H+9dv7C270/7IKueOoLtYGRi
         qd3w==
X-Gm-Message-State: AOAM532vFs6X5awIRIc2maRtb4Gj3UxLr/6rec2WXFPC8iWq9X5qIJuK
        vmdcRFD3iv+avEdnHOrqdRV3iNKkpyw=
X-Google-Smtp-Source: ABdhPJwSteDyjW9IvzNK/fOvuKV8oLhgK5JW1LMrh2CKfS9zkRw/wQe4vnYBwREcd5/wY3+gi/iDBw==
X-Received: by 2002:a05:6402:5114:b0:423:5bc2:1154 with SMTP id m20-20020a056402511400b004235bc21154mr8124221edd.116.1650205814698;
        Sun, 17 Apr 2022 07:30:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.82])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b006d5eca5c9cfsm3649601ejo.191.2022.04.17.07.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 07:30:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 1/1] tests: add more file registration tests
Date:   Sun, 17 Apr 2022 15:29:27 +0100
Message-Id: <b868cdd8d996a53a196e9cfb8807d07d318ef876.1650205541.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
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

v2: fix test_mixed_af_unix() error checks
    fix test_partial_register_fail()'s wrong return codes

 test/file-register.c | 95 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/test/file-register.c b/test/file-register.c
index bd15408..6889dbf 100644
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
+
+	ret = io_uring_register_files(&ring, reg_fds, 32);
+	if (ret) {
+		fprintf(stderr, "file_register: %d\n", ret);
+		return ret;
+	}
 
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
+		fprintf(stderr, "file_register unexpectedly succeeded\n");
+		return 1;
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

