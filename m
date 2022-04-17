Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC9B504756
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 11:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiDQJMj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 05:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiDQJMi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 05:12:38 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD58C2980A
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:10:02 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bv19so22330081ejb.6
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5v41q7iaO4lrha7xAUR7AqIJI9lESnp30FmpNgldaJc=;
        b=e9toSemrjP7iBWK8C9R5vabInxBffZVidVNh1xs7PnXR05SjCNZhsW0mjJj3wfIUpK
         rPYAfyc6KNYaHnGvyTsRHlkY/8njEEDeWl8tFnfSoWEO6b7PgPc4nbwLWUjerQrnyPZ3
         Y+jKFn0sB48O0MAbouyZ0XRmlX4EJxr2Rq4cluXH92BkK+YRtiMk9GT8irgn54SXP4bN
         1bOIpDCePUR9EYMK2bjiTwyn5TdyjjfJEldmoUzB6OjZAYArCauhREgFE6PJbWAw0vOK
         TTHPynRz+hfCKYt8z5zusBZVPbuCE4mzrqT2Kw3etJnqC5J9w4TsRmkXBPAr3+/n0dwo
         G4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5v41q7iaO4lrha7xAUR7AqIJI9lESnp30FmpNgldaJc=;
        b=2vSkKv/QQQuz/Pkh85zT/UFNOarWaVxsnTKkgqjw1z7jAxXAS3oN50utWKqlJrXL8t
         vij3zw26DrZ6z15GA0QkdRtNogH5vOly6+UzdN2l87As3i9rccOs2IcE5DgBa3AgwCoW
         b+uuDQ2VWdsp6vCSZULPxQhOUTngumTWNyMjsPHgeyas+gwOE/jVSLyNuhz9gE0z5QJ9
         UlmvdxJkqjEkrvvDour4TjxaOn7chgsjOc6l2tAdkaILF+8zeCKvpEBLguf7P1kA3OOz
         SO/kQwcuwR7J7rCX19qlHxvH3WC9JbQtr5pFM8a1TZNYBWTbdjSNi+863T9CY+uwXw0Y
         7/HA==
X-Gm-Message-State: AOAM530W9OtDnFEFy2ZHxZrwtuXE/ibnyc1ITm0BWuz76ptMa1o3oFNo
        XXie2bhP+fhW8MnMnWKFyeX2V/pKJdQ=
X-Google-Smtp-Source: ABdhPJxAudlEhCDYfeB4tbtNyQEES+A99hIBSA5Ylfm3tXDgVfxsdgXtlmMbIZDP2UdC+PL3p5jo+A==
X-Received: by 2002:a17:906:c14b:b0:6da:b30d:76a0 with SMTP id dp11-20020a170906c14b00b006dab30d76a0mr5015122ejc.279.1650186601104;
        Sun, 17 Apr 2022 02:10:01 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id bw3-20020a170906c1c300b006e88cdfbc32sm3423746ejb.45.2022.04.17.02.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 02:10:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/3] tests: extend scm cycle breaking tests
Date:   Sun, 17 Apr 2022 10:09:24 +0100
Message-Id: <bf406c7d141b46f1fa94e72b9ba853dd72f27561.1650186365.git.asml.silence@gmail.com>
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

Add a test with file ref dependency, which is actually checks that the
files are removed and put.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/ring-leak.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/test/ring-leak.c b/test/ring-leak.c
index f8f043c..5b739ad 100644
--- a/test/ring-leak.c
+++ b/test/ring-leak.c
@@ -131,12 +131,84 @@ static int test_iowq_request_cancel(void)
 	ret = read(fds[0], buffer, 10);
 	if (ret < 0)
 		perror("read");
+	close(fds[0]);
+	return 0;
+}
+
+static int test_scm_cycles(bool update)
+{
+	char buffer[128];
+	struct io_uring ring;
+	int i, ret;
+	int sp[2], fds[2], reg_fds[4];
+
+	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
+		perror("Failed to create Unix-domain socket pair\n");
+		return 1;
+	}
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret < 0) {
+		fprintf(stderr, "failed to init io_uring: %s\n", strerror(-ret));
+		return ret;
+	}
+	if (pipe(fds)) {
+		perror("pipe");
+		return -1;
+	}
+	send_fd(sp[0], ring.ring_fd);
+
+	/* register an empty set for updates */
+	if (update) {
+		for (i = 0; i < 4; i++)
+			reg_fds[i] = -1;
+		ret = io_uring_register_files(&ring, reg_fds, 4);
+		if (ret) {
+			fprintf(stderr, "file_register: %d\n", ret);
+			return ret;
+		}
+	}
+
+	reg_fds[0] = fds[0];
+	reg_fds[1] = fds[1];
+	reg_fds[2] = sp[0];
+	reg_fds[3] = sp[1];
+	if (update) {
+		ret = io_uring_register_files_update(&ring, 0, reg_fds, 4);
+		if (ret != 4) {
+			fprintf(stderr, "file_register: %d\n", ret);
+			return ret;
+		}
+	} else {
+		ret = io_uring_register_files(&ring, reg_fds, 4);
+		if (ret) {
+			fprintf(stderr, "file_register: %d\n", ret);
+			return ret;
+		}
+	}
+
+	close(fds[1]);
+	close(sp[0]);
+	close(sp[1]);
+
+	/* should unregister files and close the write fd */
+	io_uring_queue_exit(&ring);
+
+	/*
+	 * We're trying to wait for the ring to "really" exit, that will be
+	 * done async. For that rely on the registered write end to be closed
+	 * after ring quiesce, so failing read from the other pipe end.
+	 */
+	ret = read(fds[0], buffer, 10);
+	if (ret < 0)
+		perror("read");
+	close(fds[0]);
 	return 0;
 }
 
 int main(int argc, char *argv[])
 {
 	int sp[2], pid, ring_fd, ret;
+	int i;
 
 	if (argc > 1)
 		return 0;
@@ -147,6 +219,18 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	for (i = 0; i < 2; i++) {
+		bool update = !!(i & 1);
+
+		ret = test_scm_cycles(update);
+		if (ret) {
+			fprintf(stderr, "test_scm_cycles() failed %i\n",
+				update);
+			return 1;
+		}
+		break;
+	}
+
 	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
 		perror("Failed to create Unix-domain socket pair\n");
 		return 1;
-- 
2.35.2

