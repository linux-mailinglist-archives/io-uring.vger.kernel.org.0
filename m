Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496315AD4B2
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 16:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbiIEOXh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 10:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbiIEOXb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 10:23:31 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89513B958
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 07:23:30 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x73so4593261ede.10
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 07:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=KkamG207Zpuat8/NcFbS1peIilUkfg9ZIppCPTBY7PM=;
        b=M8abwmP3Yl6ZlPlzN4PM5KSDFNw2Uwtc0k+6+FQhZC+K/Q/aZkMxA9cHR9o3y7gCtt
         Ah8IPbtjhklFoMwVEX+FwRp508hnH6WCkWwFDWFlaWuXrx7bklccf31WR2OZqYWbcw+9
         BTn5/+m62FCyX4QRwSkCfOKgW7r4qCxuadGluDZhUDYYYEVkr4rTOPi5/pvYRdRavHGZ
         k4Yjh2XFQVn3tAhnGl2t+T96m5vY3OGLbltmYXpjqWhOU8CC9ffVm/HFxMAkjsncIrwR
         BFaEnkXUDUatOlWVCNoZlIsreZvyqeR5ZzOHp94sdf3OzVp2F+C+PBQH52r3KD9RmQ5K
         Ufog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KkamG207Zpuat8/NcFbS1peIilUkfg9ZIppCPTBY7PM=;
        b=bdw5DPYUVL6kxpeV8WJisuEwQZlf8NNBzcga4yLLlZh6kFaDHCAhdBOQe9IkSgfN9O
         TuW8QSQRB6EEE/Gq6ZmX47379PYo/WbXKmUjJCPUrKfQsOUd0VAIqBkNqRwDnTujSHKS
         3E8CvJ4SdCXUehhrlUcLYKU/r9hoCjSkpeg6dVXNoa1a9KFhvw/yg6XLRiym9LDimoO7
         X1w8gvCt6r40tqYMaorLeg+oydEduRoMFdGWDDoA94p4DTpbPfnWSlYkWXhmAd9YrJKc
         FcLQwGfnb2Mtpskhrf7mUSIots8HbCX0ckyse56ivmFZetqaVrNly/xSDsca3YyjHO8C
         albw==
X-Gm-Message-State: ACgBeo2y8Umq6qGn7/8S3LKDoIrP1kqdHCCcFFuBQPMyB5QdEpDtfEIS
        uxP8tf5ExsxuwyIo+P8xhH/GsCTgU/U=
X-Google-Smtp-Source: AA6agR5nSTftqjNsqlXnOspb5cMK+7vrasOsFlLXb9v/HZg/NGX+ReMGxRCPy0XH3UOJjKXkTwcLmQ==
X-Received: by 2002:a05:6402:50ca:b0:447:3355:76e3 with SMTP id h10-20020a05640250ca00b00447335576e3mr43335482edb.72.1662387809036;
        Mon, 05 Sep 2022 07:23:29 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a118])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709064bca00b0074182109623sm5168799ejv.39.2022.09.05.07.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 07:23:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 4/4] tests/zc: name buffer flavours
Date:   Mon,  5 Sep 2022 15:21:06 +0100
Message-Id: <f4ceecede6399ba722c8e73312e0e0755f53a8a6.1662387423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662387423.git.asml.silence@gmail.com>
References: <cover.1662387423.git.asml.silence@gmail.com>
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

Remove duplicating tests and pass a buf index instead of dozens of
flags to specify the buffer we want to use.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 60 +++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index bfe4cf7..2efbcf9 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -51,8 +51,16 @@
 	#define ARRAY_SIZE(a) (sizeof(a)/sizeof((a)[0]))
 #endif
 
+enum {
+	BUF_T_NORMAL,
+	BUF_T_SMALL,
+	BUF_T_NONALIGNED,
+	BUF_T_LARGE,
+	__BUT_T_MAX,
+};
+
 static char *tx_buffer, *rx_buffer;
-static struct iovec buffers_iov[3];
+static struct iovec buffers_iov[__BUT_T_MAX];
 
 static bool check_cq_empty(struct io_uring *ring)
 {
@@ -238,7 +246,7 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
 
 static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
 			     bool fixed_buf, struct sockaddr_storage *addr,
-			     bool small_send, bool cork, bool mix_register,
+			     bool cork, bool mix_register,
 			     int buf_idx, bool force_async)
 {
 	const unsigned zc_flags = 0;
@@ -246,7 +254,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	struct io_uring_cqe *cqe;
 	int nr_reqs = cork ? 5 : 1;
 	int i, ret, nr_cqes;
-	size_t send_size = small_send ? 137 : buffers_iov[buf_idx].iov_len;
+	size_t send_size = buffers_iov[buf_idx].iov_len;
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[buf_idx].iov_base;
@@ -371,23 +379,17 @@ static int test_inet_send(struct io_uring *ring)
 			return 1;
 		}
 
-		for (i = 0; i < 256; i++) {
-			bool fixed_buf = i & 1;
-			struct sockaddr_storage *addr_arg = (i & 2) ? &addr : NULL;
-			bool small_send = i & 4;
-			bool cork = i & 8;
-			bool mix_register = i & 16;
-			bool aligned = i & 32;
-			bool large_buf = i & 64;
-			int buf_idx = aligned ? 0 : 1;
-			bool force_async = i & 128;
-
-			if (large_buf) {
-				buf_idx = 2;
-				if (!aligned || !tcp || small_send || cork)
-					continue;
-			}
-			if (!buffers_iov[buf_idx].iov_base)
+		for (i = 0; i < 128; i++) {
+			int buf_flavour = i & 3;
+			bool fixed_buf = i & 4;
+			struct sockaddr_storage *addr_arg = (i & 8) ? &addr : NULL;
+			bool cork = i & 16;
+			bool mix_register = i & 32;
+			bool force_async = i & 64;
+
+			if (buf_flavour == BUF_T_LARGE && !tcp)
+				continue;
+			if (!buffers_iov[buf_flavour].iov_base)
 				continue;
 			if (tcp && cork)
 				continue;
@@ -397,8 +399,8 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 
 			ret = do_test_inet_send(ring, sock_client, sock_server, fixed_buf,
-						addr_arg, small_send, cork, mix_register,
-						buf_idx, force_async);
+						addr_arg, cork, mix_register,
+						buf_flavour, force_async);
 			if (ret) {
 				fprintf(stderr, "send failed fixed buf %i, conn %i, addr %i, "
 					"cork %i\n",
@@ -498,8 +500,8 @@ int main(int argc, char *argv[])
 	tx_buffer = aligned_alloc(4096, len);
 	rx_buffer = aligned_alloc(4096, len);
 	if (tx_buffer && rx_buffer) {
-		buffers_iov[2].iov_base = tx_buffer;
-		buffers_iov[2].iov_len = len;
+		buffers_iov[BUF_T_LARGE].iov_base = tx_buffer;
+		buffers_iov[BUF_T_LARGE].iov_len = len;
 	} else {
 		printf("skip large buffer tests, can't alloc\n");
 
@@ -512,10 +514,12 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-	buffers_iov[0].iov_base = tx_buffer + 4096;
-	buffers_iov[0].iov_len = 4096;
-	buffers_iov[1].iov_base = tx_buffer + BUFFER_OFFSET;
-	buffers_iov[1].iov_len = 8192 - BUFFER_OFFSET - 13;
+	buffers_iov[BUF_T_NORMAL].iov_base = tx_buffer + 4096;
+	buffers_iov[BUF_T_NORMAL].iov_len = 4096;
+	buffers_iov[BUF_T_SMALL].iov_base = tx_buffer;
+	buffers_iov[BUF_T_SMALL].iov_len = 137;
+	buffers_iov[BUF_T_NONALIGNED].iov_base = tx_buffer + BUFFER_OFFSET;
+	buffers_iov[BUF_T_NONALIGNED].iov_len = 8192 - BUFFER_OFFSET - 13;
 
 	ret = io_uring_queue_init(32, &ring, 0);
 	if (ret) {
-- 
2.37.2

