Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37A2605532
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiJTBvJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiJTBvI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:51:08 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B4415F33A
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:06 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g27so27795779edf.11
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRQtCk7Ki/s2LTufrmyrcMa+mDhtGP7QbQWXDREApAo=;
        b=BWjWJRZ+AuSTXTUFeH1hRQZwIjJrIb1UyOaX8GlHsMifr+gHR1dgx9yK15s4Z8xVTS
         GlLH09lbmALFAhQhmamDkvHw3zyk3jmHeVanV74lraVT3PtxlVJbMGCKAU6NmlNT85KR
         ZePconhYDXQPkv3O1A1Q9zaValyuJwyNbWhiX9IuwjJqbIpjf47yJ7ovQbLU0FhGGgNd
         bHmENhKMyhohcMmnAF/lNsu5SYg3dbS9a4WtOf3CI/OVCfK7WgAnrw0QiOjwFKdYaQmI
         5UQqsO/U0q/vDcmpyrhv0DBb8ZgYaCkFke/A+VJ4Yb9gvCOqQNmipSs7Y/3lyLVOCFB7
         HDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRQtCk7Ki/s2LTufrmyrcMa+mDhtGP7QbQWXDREApAo=;
        b=aS5wprpL24lZTKcSf6iGLNLGSh03cS1KjWtQvCaNjvPvG2aHUwUNMcUTQmS4N0zJvd
         gbRv97ON7BsO/RUJZe1qvvrmFi+ucVNZW5eZQEx4KJPaLLcZk1UxoptKBVARdG3CdYc/
         Yu+VGRkVFoIa2zTfFPRrQnNyKrIwMvmNqdCexBhZUMmuC8GIALJ1ClHdh2MDWel7Nq+D
         UqiJjORbVnnk6VstzQdniwrVRTlBgcfPEWpH+xQPR8S2Y+YXVh+ZgIUQrXYvT12Ci7ri
         v+Jm+869lDvSsQeehyqaiGKYxM7JGhROrQGGMj+zXbmMVyRNjeksK7BrH72deQ1CK0dJ
         DgCQ==
X-Gm-Message-State: ACrzQf2z8qXH/ZS1POTzrhEaUqcCvWdObX6/UZoVgWI9yGsuunRUL2gC
        ZH7yx/W1TRjFBVg/jDe60cnppZkDok4=
X-Google-Smtp-Source: AMsMyM5zS1FZ8RQlXNgINyYtBJpD9Wa+OOCy1akMHCfuXJjB/rSiboA+c74dAzgsKz36SuXnllNzLg==
X-Received: by 2002:aa7:d357:0:b0:45b:dab5:9789 with SMTP id m23-20020aa7d357000000b0045bdab59789mr10292852edr.222.1666230664427;
        Wed, 19 Oct 2022 18:51:04 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a50ff0d000000b00451319a43dasm11318420edu.2.2022.10.19.18.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:51:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing for-next 4/5] tests: add tests for retries with long iovec
Date:   Thu, 20 Oct 2022 02:49:54 +0100
Message-Id: <d9ee8940c64cdcf890dd54d792cb810ad68ac186.1666230529.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666230529.git.asml.silence@gmail.com>
References: <cover.1666230529.git.asml.silence@gmail.com>
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
index 646a895..010bf50 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -44,6 +44,7 @@
 #define HOST	"127.0.0.1"
 #define HOSTV6	"::1"
 
+#define MAX_IOV 32
 #define CORK_REQS 5
 #define RX_TAG 10000
 #define BUFFER_OFFSET 41
@@ -262,6 +263,8 @@ struct send_conf {
 	bool use_sendmsg;
 	bool tcp;
 	bool zc;
+	bool iovec;
+	bool long_iovec;
 	int buf_index;
 	struct sockaddr_storage *addr;
 };
@@ -269,7 +272,7 @@ struct send_conf {
 static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
 			     struct send_conf *conf)
 {
-	struct iovec iov[CORK_REQS];
+	struct iovec iov[MAX_IOV];
 	struct msghdr msghdr[CORK_REQS];
 	const unsigned zc_flags = 0;
 	struct io_uring_sqe *sqe;
@@ -281,6 +284,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[conf->buf_index].iov_base;
 
+	assert(MAX_IOV >= CORK_REQS);
+
 	if (conf->addr) {
 		sa_family_t fam = ((struct sockaddr_in *)conf->addr)->sin_family;
 
@@ -322,16 +327,46 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
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
@@ -428,7 +463,9 @@ static int test_inet_send(struct io_uring *ring)
 			return 1;
 		}
 
-		for (i = 0; i < 512; i++) {
+		for (i = 0; i < 2048; i++) {
+			bool regbuf;
+
 			conf.buf_index = i & 3;
 			conf.fixed_buf = i & 4;
 			conf.addr = (i & 8) ? &addr : NULL;
@@ -437,10 +474,15 @@ static int test_inet_send(struct io_uring *ring)
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
@@ -459,7 +501,7 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 			if (!client_connect && conf.addr == NULL)
 				continue;
-			if (conf.use_sendmsg && (conf.mix_register || conf.fixed_buf || !has_sendmsg))
+			if (conf.use_sendmsg && (regbuf || !has_sendmsg))
 				continue;
 			if (msg_zc_set && !conf.zc)
 				continue;
-- 
2.38.0

