Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3275BFCD8
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIULUt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiIULUs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382A6FA3F
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:45 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id bq9so9348408wrb.4
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ap2H0ruFKwI5eh8H8ZEfrhtrnIj5BqPVQCmUv7B2rCA=;
        b=g7W5eSDwC1uF+d0O9+bmHMKQhjzy/PA5bLVlTYhZpgAZsaCgfwdxmQ4oCQwpgDLfZu
         GxRURsnm6mjdbf1bg7nWk2v36VqX6RBCqPMfJYzZ1XO1ew4xvVAs00m4ZRVqibhhK2i7
         1vVD9stKNlPXqkI/AtLcCCKJo435Vj80m5rHmzqB/cDnhtBoFhtZppHzXI5Wap/cZa/U
         dMxmalDOuYvW8a2NgfJLzbfe3PDbKkMTJpTZ1nyxKnuSYjGkGoFeLwhFhYsJ1XyApHHS
         8V1JMX7sUHkYssjnj4SyycRcs6/RM5Pov1TOJ51Jvu3EM7LgA8BtMcQt9TBgJ5KKdEpo
         7gqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ap2H0ruFKwI5eh8H8ZEfrhtrnIj5BqPVQCmUv7B2rCA=;
        b=gXjacFdd3CZ+i+WYfNjtKMYj0pSJqIxfl9nSRmCVOO0hbMYFG9apMcmUfv/Zn7GyNN
         ydMnc359dyf7QUlJ25khb3N3gmw2VAzZJrMZQwON5ERZ4uqm3Pm1J2Za/EHOpSx85rFR
         0vQmYvnzbMLrl5DHyQR3N6OWnyBAFnn5gu4zijhu3RCxGmZ76nPrBAQU3OvUfIXtvJTG
         U4qq5D4jOqxJYi3MlC/DX4vjMjBjfaTusrtj6NdywwCC1oeDvER708gWt4oYSwKo8cae
         laOrmo1L9Bib8TKZOjzVkPo+z7i+0L7ZC3c6NcF6T0iw71C8L/jE45fQzvIk2rHX0u6W
         Yh5Q==
X-Gm-Message-State: ACrzQf3EepNvFSyynNXLZYUIzGEN6e2gCn6qAAK6RTVH1AbMzziDUUI3
        P6vG3y9BelJ9+B321sCWnUpZBeZ7rss=
X-Google-Smtp-Source: AMsMyM6zYF7LZD0WXGbAE9XZvzFseVXrgpBy4NQiE8iQySaWCwIcoICT1XzjYALdFLGkGw4AjjT4dQ==
X-Received: by 2002:a5d:457b:0:b0:22b:24d6:1a9f with SMTP id a27-20020a5d457b000000b0022b24d61a9fmr1423887wrc.201.1663759243844;
        Wed, 21 Sep 2022 04:20:43 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/9] io_uring/net: don't lose partial send/recv on fail
Date:   Wed, 21 Sep 2022 12:17:48 +0100
Message-Id: <a4ff95897b5419356fca9ea55db91ac15b2975f9.1663668091.git.asml.silence@gmail.com>
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

Just as with rw, partial send/recv may end up in
io_req_complete_failed() and loose the result, make sure we return the
number of bytes processed.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 10 ++++++++++
 io_uring/net.h   |  2 ++
 io_uring/opdef.c |  4 ++++
 3 files changed, 16 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 84df6d4253b7..e86a82ef4fbf 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1093,6 +1093,16 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+void io_sendrecv_fail(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	int res = req->cqe.res;
+
+	if (req->flags & REQ_F_PARTIAL_IO)
+		res = sr->done_io;
+	io_req_set_res(req, res, req->cqe.flags);
+}
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
diff --git a/io_uring/net.h b/io_uring/net.h
index d744a0a874e7..109ffb3a1a3f 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -43,6 +43,8 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags);
 int io_recv(struct io_kiocb *req, unsigned int issue_flags);
 
+void io_sendrecv_fail(struct io_kiocb *req);
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_accept(struct io_kiocb *req, unsigned int issue_flags);
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 788393ec3ff4..8d8a0f9bb5b6 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -158,6 +158,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_sendmsg,
 		.prep_async		= io_sendmsg_prep_async,
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
+		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
@@ -176,6 +177,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_recvmsg,
 		.prep_async		= io_recvmsg_prep_async,
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
+		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
@@ -318,6 +320,7 @@ const struct io_op_def io_op_defs[] = {
 #if defined(CONFIG_NET)
 		.prep			= io_sendmsg_prep,
 		.issue			= io_send,
+		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
@@ -333,6 +336,7 @@ const struct io_op_def io_op_defs[] = {
 #if defined(CONFIG_NET)
 		.prep			= io_recvmsg_prep,
 		.issue			= io_recv,
+		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.37.2

