Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB69D5ADB20
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 00:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiIEWIS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 18:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiIEWIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 18:08:17 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDDD52478
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 15:08:15 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t7so7849293wrm.10
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 15:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ZdoJFONLECkquhpfAoDXLsgpqQvHhQguLo+f31RzLwY=;
        b=ZEh8JVWLRTB8ABe8vT4YRioE1GuVwt9jT0qNvDu62nogl3cR3PaVK0US5zamhzQDey
         o9+wX4Vb0I43tyyQird6cdFXuKoz0bqqDOosQa8rE8t0w1AUD7awxqO1CIB2IiBFxIhW
         bo5INRIZuDBptoKDSdy8oAFXmJVsUYv3mLBSfnJmMrbAPKaasnT9kDwJb6iNhdTzB7KK
         tILskpruAMMfW+1rWKc1p5Cn/0cJNl64xAYQeTt1yidWkREwlP5IB43AL2R2Y4fzMqFN
         HcCcqWrZiV9PeGO36uw2W0T9H1FhtKOQMfFmHkUZ+oPXf1njODMseByHHuQ/oVMx8LWA
         QSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZdoJFONLECkquhpfAoDXLsgpqQvHhQguLo+f31RzLwY=;
        b=aJnqmw+an0ax+NKhaad/XsTM78AAeaK2SN+KSZFekITNHGVKrHz3sgX08pTFTr1X4K
         zG4K0BlDjA1Q36fOxjYyp5ADysbdfa6ZdTPCVY/mQQeKkKnaNzx8abVsYrF7r+Z5Uws9
         sKPinLoxXK6Ez4ldgLVy72dnRWOMfQp+olBp2f+zx6jAacNCG/nHDqKOK9UeuCG/6rnx
         ss75eysUYb+5zYWq3qDJEKfUqTCq5xiSFuudAeXZ49TXi1YWp2tEHO5qRtWsS8Z784i+
         kIEbdua8f5ndcs79PHeNhL5g/7qWVhgbPyTdr2SnlazSlZyW8kByVqaQ7nWpJqybGyGV
         kW+g==
X-Gm-Message-State: ACgBeo0ro5seldGE5c0ZKaL0/C5zIqeh/TOP3EtB/M6/NmaQeOOTiMgt
        1OyDkJaIXjdEc589tDSQ+luwHi8hDa0=
X-Google-Smtp-Source: AA6agR45Tj9xbFCnYkiqqct4V3RuWRWHA5aGUYNhTGK+8YIRjmQ9PynOhFdMyMWrJMjEB6ubZq2vMQ==
X-Received: by 2002:adf:ed81:0:b0:226:a509:14b6 with SMTP id c1-20020adfed81000000b00226a50914b6mr25284237wro.150.1662415693906;
        Mon, 05 Sep 2022 15:08:13 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id z7-20020a05600c0a0700b003a5c1e916c8sm33791067wmp.1.2022.09.05.15.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 15:08:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 4/5] tests/zc: name buffer flavours
Date:   Mon,  5 Sep 2022 23:06:01 +0100
Message-Id: <0ad14b1b4cf74ab503c32e945e150dbcbf678961.1662404421.git.asml.silence@gmail.com>
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

Remove duplicating tests and pass a buf index instead of dozens of
flags to specify the buffer we want to use.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 59 +++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index bfe4cf7..f996f22 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -51,8 +51,15 @@
 	#define ARRAY_SIZE(a) (sizeof(a)/sizeof((a)[0]))
 #endif
 
+enum {
+	BUF_T_NORMAL,
+	BUF_T_SMALL,
+	BUF_T_NONALIGNED,
+	BUF_T_LARGE,
+};
+
 static char *tx_buffer, *rx_buffer;
-static struct iovec buffers_iov[3];
+static struct iovec buffers_iov[4];
 
 static bool check_cq_empty(struct io_uring *ring)
 {
@@ -238,7 +245,7 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
 
 static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
 			     bool fixed_buf, struct sockaddr_storage *addr,
-			     bool small_send, bool cork, bool mix_register,
+			     bool cork, bool mix_register,
 			     int buf_idx, bool force_async)
 {
 	const unsigned zc_flags = 0;
@@ -246,7 +253,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	struct io_uring_cqe *cqe;
 	int nr_reqs = cork ? 5 : 1;
 	int i, ret, nr_cqes;
-	size_t send_size = small_send ? 137 : buffers_iov[buf_idx].iov_len;
+	size_t send_size = buffers_iov[buf_idx].iov_len;
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[buf_idx].iov_base;
@@ -371,23 +378,17 @@ static int test_inet_send(struct io_uring *ring)
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
@@ -397,8 +398,8 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 
 			ret = do_test_inet_send(ring, sock_client, sock_server, fixed_buf,
-						addr_arg, small_send, cork, mix_register,
-						buf_idx, force_async);
+						addr_arg, cork, mix_register,
+						buf_flavour, force_async);
 			if (ret) {
 				fprintf(stderr, "send failed fixed buf %i, conn %i, addr %i, "
 					"cork %i\n",
@@ -498,8 +499,8 @@ int main(int argc, char *argv[])
 	tx_buffer = aligned_alloc(4096, len);
 	rx_buffer = aligned_alloc(4096, len);
 	if (tx_buffer && rx_buffer) {
-		buffers_iov[2].iov_base = tx_buffer;
-		buffers_iov[2].iov_len = len;
+		buffers_iov[BUF_T_LARGE].iov_base = tx_buffer;
+		buffers_iov[BUF_T_LARGE].iov_len = len;
 	} else {
 		printf("skip large buffer tests, can't alloc\n");
 
@@ -512,10 +513,12 @@ int main(int argc, char *argv[])
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

