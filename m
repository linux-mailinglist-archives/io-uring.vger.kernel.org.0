Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB6A5EEA69
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 02:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiI2AFD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 20:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiI2AFC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 20:05:02 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD045F7CB
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:05:00 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id t4so9430386wmj.5
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=L1kxNzLQaK1IY8b/qMyFN3J9URSi5UM5DNdbwJp5icI=;
        b=X01vdj95udgTRMKqyL8pvBkFbxoheLThUk78gxAGtgUqH2okb0jY4K292zkdhg74r0
         LHSeuz4Ign6gpWji64c4/XP5PxoLgkngsOqgkUMAwH/5R0/ra1lEPzBpmGmSXPwb3XMT
         lSmXgvCsK98VMgrDgVB3+5JhCBmYr0jg4c7pR4LB877V80D+W2y8KEhp856JEbHYoTjZ
         Ake2s3TT4lsoPXA/EN0Gxd0hKVCmGhqiPkmaMzyBXkuamXcRGYEHbJzq7z/b8ddBOneQ
         DhMI4Wu1vWuexeux9XHVPbpvzbsLLxEWC6TnIHxT+bwinpetalW5fDKVjYr3skOYAjWB
         IXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=L1kxNzLQaK1IY8b/qMyFN3J9URSi5UM5DNdbwJp5icI=;
        b=5hvh8SURHk5lUPnbgfXuNydPFz3608vl0s3OP9UO64GnmHkjFR08vIRXXWv4qxFbpx
         flnCZmBCYFG/QwAapKPXKJ1jJMTDeW/KEs8+LsjuWDhya7O895ifziJo8xDCdjKS8yf5
         p07zblVcfc1Nalx5rDwwOIEs9Z72tNEQnNkTYCMkOwhs06y49nz7T8xd+U+CnEQH6fZJ
         1JUPdJZ5kobPBzsZ6sRG6Bz4jYtBEnBScU1Om4IB5U10tCvZLI6HCuvKle0kyH2+TYcb
         ix8FRcbENBtre/M8Yu1SQj629zrjilXa9Nv+PLmm77l3RtOGg1d+70AdqnOaG2n/Ihv5
         YO5w==
X-Gm-Message-State: ACrzQf3txA9MCCA5fm2k8vWEJgZ3V8vqz3jFONl8eTQnVchmq2Wpp9WP
        iqbGJ0RXsqdgd9r7l6hrngiOfPhK3pY=
X-Google-Smtp-Source: AMsMyM5JjrKwEXgKNmmliN1EIOZEOI8YjK573OLVM4RE9TMSftAFJJ6qKwRb7RcAqiY3b7kRn3tPGA==
X-Received: by 2002:a05:600c:1e08:b0:3b4:8fef:d63c with SMTP id ay8-20020a05600c1e0800b003b48fefd63cmr8485192wmb.158.1664409898480;
        Wed, 28 Sep 2022 17:04:58 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c4e8e00b003b47e75b401sm3284705wmq.37.2022.09.28.17.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 17:04:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/4] tests: add non-zc tests in send-zerocopy.c
Date:   Thu, 29 Sep 2022 01:03:51 +0100
Message-Id: <b0b32241eb599b1fb01704b99fa142c3c3cb449e.1664409593.git.asml.silence@gmail.com>
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

We don't have good tests for normal non-zerocopy paths. Add them to
test_inet_send(), which covers lots of different cases. We can move
it into send_recv.c or so later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index cdf71ea..b51f421 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -256,6 +256,7 @@ struct send_conf {
 	bool force_async;
 	bool use_sendmsg;
 	bool tcp;
+	bool zc;
 	int buf_index;
 	struct sockaddr_storage *addr;
 };
@@ -300,8 +301,14 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		sqe = io_uring_get_sqe(ring);
 
 		if (!conf->use_sendmsg) {
-			io_uring_prep_send_zc(sqe, sock_client, buf + i * chunk_size,
-					      cur_size, msg_flags, zc_flags);
+			if (conf->zc) {
+				io_uring_prep_send_zc(sqe, sock_client, buf + i * chunk_size,
+						      cur_size, msg_flags, zc_flags);
+			} else {
+				io_uring_prep_send(sqe, sock_client, buf + i * chunk_size,
+						      cur_size, msg_flags);
+			}
+
 			if (real_fixed_buf) {
 				sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
 				sqe->buf_index = conf->buf_index;
@@ -310,7 +317,10 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 				io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)conf->addr,
 							    addr_len);
 		} else {
-			io_uring_prep_sendmsg_zc(sqe, sock_client, &msghdr[i], msg_flags);
+			if (conf->zc)
+				io_uring_prep_sendmsg_zc(sqe, sock_client, &msghdr[i], msg_flags);
+			else
+				io_uring_prep_sendmsg(sqe, sock_client, &msghdr[i], msg_flags);
 
 			memset(&msghdr[i], 0, sizeof(msghdr[i]));
 			iov[i].iov_len = cur_size;
@@ -413,7 +423,7 @@ static int test_inet_send(struct io_uring *ring)
 			return 1;
 		}
 
-		for (i = 0; i < 256; i++) {
+		for (i = 0; i < 512; i++) {
 			conf.buf_index = i & 3;
 			conf.fixed_buf = i & 4;
 			conf.addr = (i & 8) ? &addr : NULL;
@@ -421,8 +431,19 @@ static int test_inet_send(struct io_uring *ring)
 			conf.mix_register = i & 32;
 			conf.force_async = i & 64;
 			conf.use_sendmsg = i & 128;
+			conf.zc = i & 256;
 			conf.tcp = tcp;
 
+			if (!conf.zc) {
+				if (conf.mix_register || conf.fixed_buf)
+					continue;
+				/*
+				* Non zerocopy send w/ addr was added together with sendmsg_zc,
+				* skip if we the kernel doesn't support it.
+				*/
+				if (conf.addr && !has_sendmsg)
+					continue;
+			}
 			if (conf.buf_index == BUF_T_LARGE && !tcp)
 				continue;
 			if (!buffers_iov[conf.buf_index].iov_base)
-- 
2.37.2

