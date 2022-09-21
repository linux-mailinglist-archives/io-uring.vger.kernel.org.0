Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2E75BFCDA
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiIULUw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiIULUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:49 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D3B71982
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:48 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id t4so273409wmj.5
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=WcE3jJFUvPSbz2D9hJex+1tGIl6RRjHpabbeEgpovDQ=;
        b=BpWAQldyn2iBOZOrZMCe5W4G9xcGvnx9O5I70h7aYtVZwD3GoJuFiof+xuIEe7KIhO
         WQDgE9lZrDWNVgxoC7OH/MjXfWcqyq/q3MnX6hcFWsPjVYOjZDG9lMrruLuQ7AR0L5up
         0p+ph4IyAtTOlFKV+NiKDHE1vqxffKz1Grf+qjnUaxlQwd3xSI0zlqv7otqen0h4gvHK
         lNIe/4kV26zwGOsEBDMTZzV6kiC+EgY/3NXYqrMkwVZZAehfObmRha73CRqKICpCOY6M
         fbtJFmViA0LUws9xIZ7PDV+zb5qtIt1/B1JshP/mTnfydJndfbqhPntBf6nB7yXEP1gT
         MbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=WcE3jJFUvPSbz2D9hJex+1tGIl6RRjHpabbeEgpovDQ=;
        b=iGvZLNf5Oiu9Mlom5Y2PzgpphCs4Mbv13kvlo16mjeWUBg3g2P0bJqBF3Bit4MgtIj
         yZVXjcdM/yY+XWnnRXby08y9zaLdRq50tN+EswSGmgTLuCBHzQgiEoVziuZUEHVfC3gQ
         zkCup517HBU6znqhtQZCFs//PspN4Q4TDZocxm8h80hraZJ4NyopJR/FP3rKl1kAP7RI
         x4kkmacm51FgHDLwJj4WnsRzF73W24FN3E7W8UnV9nkDJu8l5mCe5cpo9C8Xi59D9LdK
         R5vst5lvSBjXub5GqHb0E2SIYYf8K24EmlFJRtwGHscRNnaiRvo7A+yZ4Atccz2dhWxj
         oByQ==
X-Gm-Message-State: ACrzQf1t2JlW8CswjiaHkJv03TNX7RcD2C1srz+j/wFkuGckT3vG3NY9
        lh19NQmfwqVXl3o0O+bZ0uZEQFN/snI=
X-Google-Smtp-Source: AMsMyM6lMSLy8cClEsrcrpoTSqew8AFgJ9L0M7ATVgl/FN1n68OFJ7R/S9TPMwyXYWCDiADvM6j6Dg==
X-Received: by 2002:a05:600c:3b94:b0:3b4:9cdc:dbd4 with SMTP id n20-20020a05600c3b9400b003b49cdcdbd4mr5603781wms.159.1663759245966;
        Wed, 21 Sep 2022 04:20:45 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/9] io_uring/net: refactor io_setup_async_addr
Date:   Wed, 21 Sep 2022 12:17:50 +0100
Message-Id: <6bfa9ab810d776853eb26ed59301e2536c3a5471.1663668091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663668091.git.asml.silence@gmail.com>
References: <cover.1663668091.git.asml.silence@gmail.com>
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

Instead of passing the right address into io_setup_async_addr() only
specify local on-stack storage and let the function infer where to grab
it from. It optimises out one local variable we have to deal with.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 5e7fadefe2d5..a190e022a9de 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -196,17 +196,18 @@ int io_sendzc_prep_async(struct io_kiocb *req)
 }
 
 static int io_setup_async_addr(struct io_kiocb *req,
-			      struct sockaddr_storage *addr,
+			      struct sockaddr_storage *addr_storage,
 			      unsigned int issue_flags)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *io;
 
-	if (!addr || req_has_async_data(req))
+	if (!sr->addr || req_has_async_data(req))
 		return -EAGAIN;
 	io = io_msg_alloc_async(req, issue_flags);
 	if (!io)
 		return -ENOMEM;
-	memcpy(&io->addr, addr, sizeof(io->addr));
+	memcpy(&io->addr, addr_storage, sizeof(io->addr));
 	return -EAGAIN;
 }
 
@@ -1000,7 +1001,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct sockaddr_storage __address, *addr = NULL;
+	struct sockaddr_storage __address;
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
 	struct iovec iov;
@@ -1021,20 +1022,19 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		if (req_has_async_data(req)) {
 			struct io_async_msghdr *io = req->async_data;
 
-			msg.msg_name = addr = &io->addr;
+			msg.msg_name = &io->addr;
 		} else {
 			ret = move_addr_to_kernel(zc->addr, zc->addr_len, &__address);
 			if (unlikely(ret < 0))
 				return ret;
 			msg.msg_name = (struct sockaddr *)&__address;
-			addr = &__address;
 		}
 		msg.msg_namelen = zc->addr_len;
 	}
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_addr(req, addr, issue_flags);
+		return io_setup_async_addr(req, &__address, issue_flags);
 
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		ret = io_import_fixed(WRITE, &msg.msg_iter, req->imu,
@@ -1065,14 +1065,14 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_addr(req, addr, issue_flags);
+			return io_setup_async_addr(req, &__address, issue_flags);
 
 		if (ret > 0 && io_net_retry(sock, msg.msg_flags)) {
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
-			return io_setup_async_addr(req, addr, issue_flags);
+			return io_setup_async_addr(req, &__address, issue_flags);
 		}
 		if (ret < 0 && !zc->done_io)
 			zc->notif->flags |= REQ_F_CQE_SKIP;
-- 
2.37.2

