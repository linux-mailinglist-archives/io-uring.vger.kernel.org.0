Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F945ADB1C
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 00:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiIEWIQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 18:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiIEWIO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 18:08:14 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBFA5723B
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 15:08:12 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bz13so9473271wrb.2
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 15:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=+6GKmuMBvxvZ7P18wLcMpxJrZ6oY37ClDCfrGbE2Lhw=;
        b=pUBbrQd2bZq2aR3lK4jg7v7EXO3guqtqKRm+4jbJz7BdTtL/JzeF2B+6DI9nS1AEud
         sJEH23ZKH3X1wsXwZsSnx9by8wDMD/e4CGWXHkcZGJlkgk8/kQH2ck5gaTu8wmReW0+I
         996EDk6aaZITGDn5DBcPyZmMSAHXlmVEKG3ehVZAUEONABn3cBCFo26mGu5Hm3T2W74P
         DpZwOTzJoNYbwGSXGbx05ujwcN32wVqBUKHjz9C2EzYohs4pyZF6tq1guw6teoY23ja6
         9+jM+KZoDU3YQhgAKvQFI443RFr4dp+ugtvADmAVp8u0ZqJbf/vYgSXnZvYcXGQHzXRM
         heLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+6GKmuMBvxvZ7P18wLcMpxJrZ6oY37ClDCfrGbE2Lhw=;
        b=KR5PBIDViNSbeSf+BQ25dpovuCHUmk4hIhAXnQs7aLKAAsSCtEM1gfm1s1c8tNEsgQ
         gCtvFz5oZBateqOorXgLfRbuIW5Wm4hkybrR10K3g0lLPIAapx2iSM+cb2exFHmF2i9w
         Z/RliUz03yPkgo8+NaesdI6VMazs6H7yaRVMt1hrylie4I98UGAGT9vmm5M10NDOs6qO
         NJvF2NS13ZlO1z/7xXASioW2PPZYwUrNsvs9IPR2Y7UFV0T7EDox6LqbR5Ixq0x2yOh/
         BiTWgXfRzgL822gdF0XlJsdTAYgH73alkBtPg0rxBPVtYBjlbsJty5N16oOpuX5WKJ35
         cdmQ==
X-Gm-Message-State: ACgBeo1W64m50wle4bj+MVu+yTi3Vi+UQkplmZojGfMt0hqbOmdpH2CH
        +IK0WgSPfZ7y3LXxG4N59rc5XLryxp4=
X-Google-Smtp-Source: AA6agR6CgnO3rar6OPy7vyltQfnYUwGEo6/j/0rkQJ3RK1rdtSY2CuWF2yCOb1GplVEegrJSy2y6OQ==
X-Received: by 2002:a5d:6f19:0:b0:228:d8e8:3ac8 with SMTP id ay25-20020a5d6f19000000b00228d8e83ac8mr169227wrb.101.1662415690875;
        Mon, 05 Sep 2022 15:08:10 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id z7-20020a05600c0a0700b003a5c1e916c8sm33791067wmp.1.2022.09.05.15.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 15:08:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 1/5] tests/zc: move send size calc into do_test_inet_send
Date:   Mon,  5 Sep 2022 23:05:58 +0100
Message-Id: <e9e818b93fd3c0f969ebf1c4a0869edaadb161dd.1662404421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662404421.git.asml.silence@gmail.com>
References: <cover.1662404421.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 8714b6f..0a8531e 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -238,7 +238,7 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
 
 static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
 			     bool fixed_buf, struct sockaddr_storage *addr,
-			     size_t send_size, bool cork, bool mix_register,
+			     bool small_send, bool cork, bool mix_register,
 			     int buf_idx, bool force_async)
 {
 	const unsigned zc_flags = 0;
@@ -246,13 +246,13 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	struct io_uring_cqe *cqe;
 	int nr_reqs = cork ? 5 : 1;
 	int i, ret, nr_cqes;
+	size_t send_size = small_send ? 137 : buffers_iov[buf_idx].iov_len;
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[buf_idx].iov_base;
 	pid_t p;
 	int wstatus;
 
-	assert(send_size <= buffers_iov[buf_idx].iov_len);
 	memset(rx_buffer, 0, send_size);
 
 	for (i = 0; i < nr_reqs; i++) {
@@ -394,7 +394,7 @@ static int test_inet_send(struct io_uring *ring)
 		for (i = 0; i < 256; i++) {
 			bool fixed_buf = i & 1;
 			struct sockaddr_storage *addr_arg = (i & 2) ? &addr : NULL;
-			size_t size = (i & 4) ? 137 : 4096;
+			bool small_send = i & 4;
 			bool cork = i & 8;
 			bool mix_register = i & 16;
 			bool aligned = i & 32;
@@ -406,8 +406,7 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 			if (large_buf) {
 				buf_idx = 2;
-				size = buffers_iov[buf_idx].iov_len;
-				if (!aligned || !tcp)
+				if (!aligned || !tcp || small_send)
 					continue;
 			}
 			if (!buffers_iov[buf_idx].iov_base)
@@ -420,7 +419,7 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 
 			ret = do_test_inet_send(ring, sock_client, sock_server, fixed_buf,
-						addr_arg, size, cork, mix_register,
+						addr_arg, small_send, cork, mix_register,
 						buf_idx, force_async);
 			if (ret) {
 				fprintf(stderr, "send failed fixed buf %i, conn %i, addr %i, "
@@ -535,8 +534,8 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-	buffers_iov[0].iov_base = tx_buffer;
-	buffers_iov[0].iov_len = 8192;
+	buffers_iov[0].iov_base = tx_buffer + 4096;
+	buffers_iov[0].iov_len = 4096;
 	buffers_iov[1].iov_base = tx_buffer + BUFFER_OFFSET;
 	buffers_iov[1].iov_len = 8192 - BUFFER_OFFSET - 13;
 
-- 
2.37.2

