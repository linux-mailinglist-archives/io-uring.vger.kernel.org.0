Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152866BD06C
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 14:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCPNKp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 09:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCPNKo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 09:10:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DB6BE5CB
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:10:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id cn21so7646594edb.0
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678972241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QyfneUT+SjMny0CadPKeiA7DRNDesUT0wPNiLGUlBjI=;
        b=YGpcaDqmjVtCYLGQvocIYqqys4d2mVn2T2iSKXD5j7a/qiluUczfXk6oW2xkUEfcAj
         w4C/iiMSfiUU8DaoIxVKphU2RpzyOFbBMMFYJxh0KdJWUJ8dkS7VKGOi6d9tx/sIn6eG
         qfe6u8IFIwfXG1ox4+qEmmzuB/DFPJQbkryaU3Y9ufNscG+cEeaDD4Az7RpLkLWwKLv+
         eIidZlRJBJpQSDKu2Clbyu7Kn+NGrMgYYpuxH4EVqLwwQVpSYB30/BIR0paGw/+Lp+ys
         PQLiJVoacbbc5ep5aVtG7uMMzAWMRBgPg13gzrTy68hmh7in3gSdcYMCCPzx+ByfIUN0
         QqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678972241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QyfneUT+SjMny0CadPKeiA7DRNDesUT0wPNiLGUlBjI=;
        b=XNLj7nb7LYeHIHJ1E+aqt0XNZAlyfCeFhjG0jZSC8NebfeQw/zrZFtUqKE2XWfY43V
         AZai+VZWT8gz9rtoVkp+cE9FJ6UZ6OPZG3qZKKglgXW4ZQLZ5IrYO3J+km5iEPykiAFh
         J1e92VokTcvHhd4DSVOVVmYUXgJulkCagltcqy6obLKBaRVH4FmshfQwG17c0q9KkJ/j
         saYxlqFlmcj5KJE79e6OlNo9kBdTNFJroeRMQqNXr2ibiHgKnfNp9pq6Nkk0pVDXdbud
         qakIqrgcCEUAhScZAIyNnvu6m5OL9wBsgeW77LKTx1JXp1GZ1yzc1nJoOcTHIAYrhPM7
         +59Q==
X-Gm-Message-State: AO0yUKVJpK5UU432Ca5hl8tn60DIAUxgNeYZXyvCK5f6mhcEZu/P/qY8
        MV8FMxCOMgcqxl20qtNlHIId026vTv0=
X-Google-Smtp-Source: AK7set+o1AxPqDX0tusemm2BKz6LCYSbFI8EEGFJBp+zsoQ9YbhktBJl7ZHvkxeJwu3brCGlRYZBwQ==
X-Received: by 2002:a17:907:6746:b0:92b:e1ff:be30 with SMTP id qm6-20020a170907674600b0092be1ffbe30mr11075265ejc.4.1678972241104;
        Thu, 16 Mar 2023 06:10:41 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7abd])
        by smtp.gmail.com with ESMTPSA id n18-20020a170906701200b00927f6c799e6sm3814967ejj.132.2023.03.16.06.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 06:10:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/2] test: test fd msg-ring allocating indexes
Date:   Thu, 16 Mar 2023 13:09:21 +0000
Message-Id: <4f10e4213360871087bfb94f1e37c207c0f4ca51.1678968783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1678968783.git.asml.silence@gmail.com>
References: <cover.1678968783.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fd msg-ring requests supports IORING_FILE_INDEX_ALLOC, add a test for
that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/fd-pass.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/test/fd-pass.c b/test/fd-pass.c
index f3ede77..0c981fb 100644
--- a/test/fd-pass.c
+++ b/test/fd-pass.c
@@ -80,6 +80,14 @@ static int test(const char *filename, int source_fd, int target_fd)
 		fprintf(stderr, "register files failed %d\n", ret);
 		return T_EXIT_FAIL;
 	}
+	if (target_fd == IORING_FILE_INDEX_ALLOC) {
+		/* we want to test installing into a non-zero slot */
+		ret = io_uring_register_file_alloc_range(&dring, 1, 1);
+		if (ret) {
+			fprintf(stderr, "io_uring_register_file_alloc_range %d\n", ret);
+			return T_EXIT_FAIL;
+		}
+	}
 
 	/* open direct descriptor */
 	sqe = io_uring_get_sqe(&sring);
@@ -102,8 +110,14 @@ static int test(const char *filename, int source_fd, int target_fd)
 
 	/* send direct descriptor to destination ring */
 	sqe = io_uring_get_sqe(&sring);
-	io_uring_prep_msg_ring_fd(sqe, dring.ring_fd, source_fd, target_fd,
-					USER_DATA, 0);
+	if (target_fd == IORING_FILE_INDEX_ALLOC) {
+		io_uring_prep_msg_ring_fd_alloc(sqe, dring.ring_fd, source_fd,
+						USER_DATA, 0);
+	} else {
+
+		io_uring_prep_msg_ring_fd(sqe, dring.ring_fd, source_fd,
+					  target_fd, USER_DATA, 0);
+	}
 	io_uring_submit(&sring);
 
 	ret = io_uring_wait_cqe(&sring, &cqe);
@@ -111,7 +125,7 @@ static int test(const char *filename, int source_fd, int target_fd)
 		fprintf(stderr, "wait cqe failed %d\n", ret);
 		return T_EXIT_FAIL;
 	}
-	if (cqe->res) {
+	if (cqe->res < 0) {
 		if (cqe->res == -EINVAL && !no_fd_pass) {
 			no_fd_pass = 1;
 			return T_EXIT_SKIP;
@@ -131,6 +145,17 @@ static int test(const char *filename, int source_fd, int target_fd)
 		fprintf(stderr, "bad user_data %ld\n", (long) cqe->res);
 		return T_EXIT_FAIL;
 	}
+	if (cqe->res < 0) {
+		fprintf(stderr, "bad result %i\n", cqe->res);
+		return T_EXIT_FAIL;
+	}
+	if (target_fd == IORING_FILE_INDEX_ALLOC) {
+		if (cqe->res != 1) {
+			fprintf(stderr, "invalid allocated index %i\n", cqe->res);
+			return T_EXIT_FAIL;
+		}
+		target_fd = cqe->res;
+	}
 	io_uring_cqe_seen(&dring, cqe);
 
 	/* now verify we can read the sane data from the destination ring */
@@ -201,6 +226,12 @@ int main(int argc, char *argv[])
 		ret = T_EXIT_FAIL;
 	}
 
+	ret = test(fname, 1, IORING_FILE_INDEX_ALLOC);
+	if (ret == T_EXIT_FAIL) {
+		fprintf(stderr, "test failed 1 ALLOC\n");
+		ret = T_EXIT_FAIL;
+	}
+
 	unlink(fname);
 	return ret;
 }
-- 
2.39.1

