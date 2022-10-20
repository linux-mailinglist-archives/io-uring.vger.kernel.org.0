Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A71605531
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiJTBvI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiJTBvH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:51:07 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3833015A94F
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:05 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g27so27795741edf.11
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ub88FywDu/eXdG3lLXCfpl1aayVyR5vajjvg/EkU7D0=;
        b=c1s+QO69bAJsj2YPg+YYnR4Px/gthTJCY0Mqm2N41JNX/6TryFRITTJqqT79BbgOn2
         V8TiVhzpqAZAHL0VFjR6civYcOd3nn75IPtJ9/y7bmKHv6YgC6hN4rfmYF130mZhoPlT
         JbfoJu420IFlx0sdGpwEDEr7D8zO5ceK4uI1Nxtn+4jN0Sj2gXMNhlAo4+e4tlEbRxxW
         sCjOZ8k+sBNGuRsLmteILggRWASFR+baCoeRATc1noxonfLn6q32qDszJcAuPfXagK03
         IoPboz1nPCDXmoswzz2JeeJXFJTqqUaZPkhc2r1vjKCNFeUIcqfiOkYzA6N7j3bfwH+e
         6txw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ub88FywDu/eXdG3lLXCfpl1aayVyR5vajjvg/EkU7D0=;
        b=DYl9/9DGbAr0ky1kcyG2rjd9GIUDHAevFWQI4cb6uu6nZjYCURpQpxKgUq5vh+XheA
         PVCaTV/Ob+TaDjUzqDi3fhzgD2tgoiNn2ZrxH9fqSqn5GFK2LmQzw5698igE47xVOwUU
         XEPQ1cnQ+f5C2zWSSQwByLJ6x90iRhBETGwLFJ+/kfqonPU1zrJbp1b5iLnoZarpMXhd
         GH5dQJOkNKYRmdk1EsYMtILlM8yEj8cW/DdAx7zK4bMPlybhiEkVTiBiJzdtDJxPlZ4w
         OSVTeuvFuHG9I59WFYeS9YLL3eYxXGQr+NuPFwgABjvJPdQpQR3SQQRCUqWMeTshu7XA
         qAvA==
X-Gm-Message-State: ACrzQf07S3H0YDFzxH3JAhJiUtoOqnOvqmvBQ4/F3+idzkAIvBdOHJ/G
        mmIDq5c26Zhz95+QeUZfmhCK6oVlG+M=
X-Google-Smtp-Source: AMsMyM46WbPK5gNQhKIdgjsFew9ZpJ0hbVukIfdlBjj/NZBm7yaJyO8/hPiYAaOgQnhJi1GPh+3Tgg==
X-Received: by 2002:a05:6402:ca5:b0:459:3fb0:c157 with SMTP id cn5-20020a0564020ca500b004593fb0c157mr9791563edb.389.1666230663343;
        Wed, 19 Oct 2022 18:51:03 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a50ff0d000000b00451319a43dasm11318420edu.2.2022.10.19.18.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:51:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing for-next 3/5] tests: add non-zc tests in send-zerocopy.c
Date:   Thu, 20 Oct 2022 02:49:53 +0100
Message-Id: <5d3f1be7afe67c2fcff8bcf63c686928477476b6.1666230529.git.asml.silence@gmail.com>
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

We don't have good tests for normal non-zerocopy paths. Add them to
test_inet_send(), which covers lots of different cases. We can move
it into send_recv.c or so later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index a69279a..646a895 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -261,6 +261,7 @@ struct send_conf {
 	bool force_async;
 	bool use_sendmsg;
 	bool tcp;
+	bool zc;
 	int buf_index;
 	struct sockaddr_storage *addr;
 };
@@ -305,8 +306,14 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
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
@@ -315,7 +322,10 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
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
@@ -418,7 +428,7 @@ static int test_inet_send(struct io_uring *ring)
 			return 1;
 		}
 
-		for (i = 0; i < 256; i++) {
+		for (i = 0; i < 512; i++) {
 			conf.buf_index = i & 3;
 			conf.fixed_buf = i & 4;
 			conf.addr = (i & 8) ? &addr : NULL;
@@ -426,8 +436,19 @@ static int test_inet_send(struct io_uring *ring)
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
@@ -440,6 +461,8 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 			if (conf.use_sendmsg && (conf.mix_register || conf.fixed_buf || !has_sendmsg))
 				continue;
+			if (msg_zc_set && !conf.zc)
+				continue;
 
 			ret = do_test_inet_send(ring, sock_client, sock_server, &conf);
 			if (ret) {
-- 
2.38.0

