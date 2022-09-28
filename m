Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4CD5EDB29
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 13:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiI1LHi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 07:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiI1LHB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 07:07:01 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1874CFFA48
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 04:04:06 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x18so19205187wrm.7
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 04:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=D6FZLh4CObYRBQVaOo1yXaxqOpUAqdHJB/+HnubEIVw=;
        b=n5L1GeyH+Msn+h4uU71vAN+W8jDNVKMdL73n3W287ezwC2dRkHRhln2S5iA8XaUERo
         f8suskn81JpSa7atuxK6gJ3hS+j9U6vxnO9LfVR8cmlBjyFjW6QlYG5UgAfc2i7bzW3S
         tvMWKiUNRKMqfmh49bTNO5HE/IgUwspVcC//w7MHpo/kzdt0tvm1lOpiU+/rn8+D64FC
         UGXbP7bA4rNNtJdyukfiAaT/wbWE3uVBtFgYw6xpR74zYcne5Pef3A9hIb346he1oFDb
         /xUxTcHDj5tDYNhTddUV7jmIwrFJjvguKR6WahsqLuYD4iWNUnkdl9PTQKZ/Ff1+z3vh
         HR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=D6FZLh4CObYRBQVaOo1yXaxqOpUAqdHJB/+HnubEIVw=;
        b=xas41Yp+DhUWVXgL4N385vy5eiukq0d9pts3A3JgvPeiwFuBRQOyVMzYA/9qUmNn2s
         fULZfB5r/qiCzRz+npgds5W80OfXopHHtnZPU9fUeBG4b2mmhcfF5LxVsF/Q7tneBcsg
         4rK3pFmY8QvrwjGR5f/MfnWZay0LEq4n8SniwikFnWRDiHV2y8cSU2Kc6HlR4kNV0FVF
         NXf2D08Ry1BOYqtuYrGnaB4+Zy47O8EzdtnTYCKQpQMjjvqt3w553DN8EPPjjcvOHesN
         alJOkaUub5Spcu3CRwdnCRLphhTcO2lrbXog6MvepzdwbXrzQq/2YZ8vgoBBGiomg8Tn
         ELGA==
X-Gm-Message-State: ACrzQf1+bfo5tb+2q6OQZdRWLeltfPkHvjnQBNvhUtMscoEFOCZ/7CVy
        EkK/YagtoAJ9szVLnbyxbFKNS4MggRU=
X-Google-Smtp-Source: AMsMyM4fwF6ziEbxzdwv7Ccg9d6uu1cLPDAq/U1R/76S0tJkgTrndqFhEUbLC5Q9KHamFz5mZXPhkA==
X-Received: by 2002:adf:bc13:0:b0:228:6d28:d489 with SMTP id s19-20020adfbc13000000b002286d28d489mr19153120wrg.668.1664363043142;
        Wed, 28 Sep 2022 04:04:03 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id t15-20020a5d42cf000000b00228c483128dsm4654460wrr.90.2022.09.28.04.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 04:04:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/1] liburing: add more zc helpers
Date:   Wed, 28 Sep 2022 12:02:58 +0100
Message-Id: <25a5e4ff7c480cf5c68be2e223a2fa9787ee6283.1664361932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Add a helper for zc sendmsg and also for zc send with registered buffers
(aka fixed).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 19 +++++++++++++++++++
 test/send-zerocopy.c   |  3 +--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 902f26a..1d04923 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -746,6 +746,25 @@ static inline void io_uring_prep_send_zc(struct io_uring_sqe *sqe, int sockfd,
 	sqe->ioprio = zc_flags;
 }
 
+static inline void io_uring_prep_send_zc_fixed(struct io_uring_sqe *sqe,
+						int sockfd, const void *buf,
+						size_t len, int flags,
+						unsigned zc_flags,
+						unsigned buf_index)
+{
+	io_uring_prep_send_zc(sqe, sockfd, buf, len, flags, zc_flags);
+	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+	sqe->buf_index = buf_index;
+}
+
+static inline void io_uring_prep_sendmsg_zc(struct io_uring_sqe *sqe, int fd,
+					    const struct msghdr *msg,
+					    unsigned flags)
+{
+	io_uring_prep_sendmsg(sqe, fd, msg, flags);
+	sqe->opcode = IORING_OP_SENDMSG_ZC;
+}
+
 static inline void io_uring_prep_send_set_addr(struct io_uring_sqe *sqe,
 						const struct sockaddr *dest_addr,
 						__u16 addr_len)
diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 88578e0..31d66e3 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -301,8 +301,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 				io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)addr,
 							    addr_len);
 		} else {
-			io_uring_prep_sendmsg(sqe, sock_client, &msghdr[i], msg_flags);
-			sqe->opcode = IORING_OP_SENDMSG_ZC;
+			io_uring_prep_sendmsg_zc(sqe, sock_client, &msghdr[i], msg_flags);
 
 			memset(&msghdr[i], 0, sizeof(msghdr[i]));
 			iov[i].iov_len = cur_size;
-- 
2.37.2

