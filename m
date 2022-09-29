Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072055EEA6A
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 02:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiI2AFE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 20:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiI2AFD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 20:05:03 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF06DF4D
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:05:01 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u16-20020a05600c211000b003b5152ebf09so2258628wml.5
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=dxX5/rXeLjku7BfLtox9Zy/kAxNAfz5xG0/Ffg3rAMA=;
        b=CKYsv6gI9JA4TDg3VL9JvkW++Pbkh6BUHt5Gt9FV/7RkfsIwizKNHqzLY0vXe8swY+
         rK4Mc2ScOTpfnBpJ1B1UHtodHdc2A8q/TW4O49VnfPyQ/Cn0S/E71qeubnDv62+O0kLB
         o9bNxUjhJ+zxDGiv4RoghxIi3+I6ejLUuMFBzfKgtYhQf3evcmnrKcdiQDUQnT3IfK1Q
         bzIOozh7E/xYdZv3EGpAfUmW8ouBXTrIUD/f7/+Azhj2J+eIel+8NbfYrqgCCkVJEIQR
         4kNeUhTOOOCDnF+2YYHhf6I5eb0XS3b49EinzvK5T9K7MaP0Jm1Hpwmb+LTNVJuIuqJ9
         bIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=dxX5/rXeLjku7BfLtox9Zy/kAxNAfz5xG0/Ffg3rAMA=;
        b=DOVtIngEgFmA6IoRkceQgLKH9y0NxW+D0rShZktynrnbBpzer+K/+Wkg2ipSNv/c6f
         IPlPbZbSheJG+YbKbKtz12kgYP6RvIvHRQv2v7KnfIDtsUeQ2KBt1YDWlJYddnIMtyCs
         5v7wlQ/EA6T4SXFMmUyBP60XjMEm8nABWhUbo8K/plIGtI/L/kfXhPRaMJyZgH8lYaIz
         /lZdgBtW/86wegiDXGfzxUKTTPUwLNUQqTXnywngvlxnigj0gRtU2KnEbVVYXj0qsrqu
         NrvjXAX2Aj66+8lIMTtatUiceE4MPnZPIsrqkUZ7K3OVVOGzZdKGKqDWaRvoZSIKjTL+
         qBKw==
X-Gm-Message-State: ACrzQf3JWs6t77egQIOrUTZaQTA4AcBWODRHmFoquGo3xQHCVbAc27Kn
        j8KrQIf0BBGL/ALXH4oVhsIUD4Jkg5U=
X-Google-Smtp-Source: AMsMyM4M1rsyfeSLuQRWiie24tKNzwH7vrOwxzAeOTvIbuAMuS/Nd0kG2bL4JcEBsuzkXtQtKk69WQ==
X-Received: by 2002:a7b:cb41:0:b0:3b3:34d6:189f with SMTP id v1-20020a7bcb41000000b003b334d6189fmr8653536wmj.6.1664409899662;
        Wed, 28 Sep 2022 17:04:59 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c4e8e00b003b47e75b401sm3284705wmq.37.2022.09.28.17.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 17:04:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 4/4] tests: add tests for retries with long iovec
Date:   Thu, 29 Sep 2022 01:03:52 +0100
Message-Id: <2a1e442706e07c9bf6cc4ccb06cd6c5fe2e4c04a.1664409593.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1664409593.git.asml.silence@gmail.com>
References: <cover.1664409593.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 58 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index b51f421..adf730d 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -44,6 +44,7 @@
 #define HOST	"127.0.0.1"
 #define HOSTV6	"::1"
 
+#define MAX_IOV 32
 #define CORK_REQS 5
 #define RX_TAG 10000
 #define BUFFER_OFFSET 41
@@ -257,6 +258,8 @@ struct send_conf {
 	bool use_sendmsg;
 	bool tcp;
 	bool zc;
+	bool iovec;
+	bool long_iovec;
 	int buf_index;
 	struct sockaddr_storage *addr;
 };
@@ -264,7 +267,7 @@ struct send_conf {
 static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
 			     struct send_conf *conf)
 {
-	struct iovec iov[CORK_REQS];
+	struct iovec iov[MAX_IOV];
 	struct msghdr msghdr[CORK_REQS];
 	const unsigned zc_flags = 0;
 	struct io_uring_sqe *sqe;
@@ -276,6 +279,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[conf->buf_index].iov_base;
 
+	assert(MAX_IOV >= CORK_REQS);
+
 	if (conf->addr) {
 		sa_family_t fam = ((struct sockaddr_in *)conf->addr)->sin_family;
 
@@ -317,16 +322,46 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 				io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)conf->addr,
 							    addr_len);
 		} else {
+			struct iovec *io;
+			int iov_len;
+
 			if (conf->zc)
 				io_uring_prep_sendmsg_zc(sqe, sock_client, &msghdr[i], msg_flags);
 			else
 				io_uring_prep_sendmsg(sqe, sock_client, &msghdr[i], msg_flags);
 
+			if (!conf->iovec) {
+				io = &iov[i];
+				iov_len = 1;
+				iov[i].iov_len = cur_size;
+				iov[i].iov_base = buf + i * chunk_size;
+			} else {
+				char *it = buf;
+				int j;
+
+				assert(nr_reqs == 1);
+				iov_len = conf->long_iovec ? MAX_IOV : 4;
+				io = iov;
+
+				for (j = 0; j < iov_len; j++)
+					io[j].iov_len = 1;
+				/* first want to be easily advanced */
+				io[0].iov_base = it;
+				it += io[0].iov_len;
+				/* this should cause retry */
+				io[1].iov_len = chunk_size - iov_len + 1;
+				io[1].iov_base = it;
+				it += io[1].iov_len;
+				/* fill the rest */
+				for (j = 2; j < iov_len; j++) {
+					io[j].iov_base = it;
+					it += io[j].iov_len;
+				}
+			}
+
 			memset(&msghdr[i], 0, sizeof(msghdr[i]));
-			iov[i].iov_len = cur_size;
-			iov[i].iov_base = buf + i * chunk_size;
-			msghdr[i].msg_iov = &iov[i];
-			msghdr[i].msg_iovlen = 1;
+			msghdr[i].msg_iov = io;
+			msghdr[i].msg_iovlen = iov_len;
 			if (conf->addr) {
 				msghdr[i].msg_name = conf->addr;
 				msghdr[i].msg_namelen = addr_len;
@@ -423,7 +458,9 @@ static int test_inet_send(struct io_uring *ring)
 			return 1;
 		}
 
-		for (i = 0; i < 512; i++) {
+		for (i = 0; i < 2048; i++) {
+			bool regbuf;
+
 			conf.buf_index = i & 3;
 			conf.fixed_buf = i & 4;
 			conf.addr = (i & 8) ? &addr : NULL;
@@ -432,10 +469,15 @@ static int test_inet_send(struct io_uring *ring)
 			conf.force_async = i & 64;
 			conf.use_sendmsg = i & 128;
 			conf.zc = i & 256;
+			conf.iovec = i & 512;
+			conf.long_iovec = i & 1024;
 			conf.tcp = tcp;
+			regbuf = conf.mix_register || conf.fixed_buf;
 
+			if (conf.iovec && (!conf.use_sendmsg || regbuf || conf.cork))
+				continue;
 			if (!conf.zc) {
-				if (conf.mix_register || conf.fixed_buf)
+				if (regbuf)
 					continue;
 				/*
 				* Non zerocopy send w/ addr was added together with sendmsg_zc,
@@ -454,7 +496,7 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 			if (!client_connect && conf.addr == NULL)
 				continue;
-			if (conf.use_sendmsg && (conf.mix_register || conf.fixed_buf || !has_sendmsg))
+			if (conf.use_sendmsg && (regbuf || !has_sendmsg))
 				continue;
 
 			ret = do_test_inet_send(ring, sock_client, sock_server, &conf);
-- 
2.37.2

