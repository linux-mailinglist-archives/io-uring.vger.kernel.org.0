Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F33A5BFCDC
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiIULVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiIULUw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:52 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9286676448
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:50 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id n10so9264290wrw.12
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=NdzOesns5PuSMPMWnlJY/dJaslxGRHBwKePVvzuqK0k=;
        b=C2C1+ZWel8AHGalCk5QzGBmlxhg1P0wqu94SsjeCKHUqdGhKfwcUxOEdCpGn4TDCn4
         oNGSXRSOkEzgIZ/R4WPQvyxMHrXLAl6vmZB2E/j+i9fVudS0UZVNG1iRiIEeNgLoLpfP
         PIhIHujt2QFXEXJdHAyOM7jLoZB8wYMqy3mujeotSnI3NZPjwsyGrso+KwdsuVxPnVwk
         Pl+lcSNM2xG4JXx9jnJhTTThnSvK5OhKMAJCtAbYnel70MWP10RvOnMXoKe1jddAV+/h
         m51w8IknEYihZkO2D6SWHpLAt6ciC5KTvha3IIqqaeKswlxiYA1xrmpvt+t+Q6X2I+eS
         cXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=NdzOesns5PuSMPMWnlJY/dJaslxGRHBwKePVvzuqK0k=;
        b=AQUzZExzt133LXJ8dd0klAwKtRZ16yciE5rkBE4tcclIfSH8/Lb645DxH2Krbw/NX1
         FTHJgzUPe7+U8Yyh3yrDnEFyNI9Q1dAqZ1otcF14ZzPc2f06vQQs3av25DHenERJMurw
         ItQF2jBaaCZ0FOHdJMUsfHuyciTMM2/BS0QDA8Amn0PTRKvlF2RI4WACwdAFHQZ6mR8e
         JMVVb32Sfsq8evKAThbfvcQwvhaWv3nEP6YNCyWJmCGvmytwWFbp+tu2ne4lIzWNEJig
         6cqGMmUqzCdlu3nUQbMSkC2GJx8FuA1sQahh8mhyTla26KFmiTK3nVYksU5JuysdEKlK
         t9iw==
X-Gm-Message-State: ACrzQf1prrefdiuugO/f0gmxWAQpkqgYwGdQBvwbqLMXPpvtA18lFmtV
        8UWsKhx1hBjasIQEykVuZ2Md8LGXHTY=
X-Google-Smtp-Source: AMsMyM4gAj3Ctg//m9XNfCS02xs8tA/05xq9rkYTmddIiiyD4pibe4sixBbDpZBX3IMQqua7F7dyig==
X-Received: by 2002:a05:6000:1866:b0:228:e373:ad68 with SMTP id d6-20020a056000186600b00228e373ad68mr16414791wri.605.1663759249895;
        Wed, 21 Sep 2022 04:20:49 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 8/9] io_uring/net: combine fail handlers
Date:   Wed, 21 Sep 2022 12:17:53 +0100
Message-Id: <e0eba1d577413aef5602cd45f588b9230207082d.1663668091.git.asml.silence@gmail.com>
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

Merge io_send_zc_fail() into io_sendrecv_fail(), saves a few lines of
code and some headache for following patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 31 ++++++++++++++++---------------
 io_uring/net.h   |  1 -
 io_uring/opdef.c |  2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 06c132edfd91..4bcc2675001f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -192,6 +192,7 @@ int io_send_prep_async(struct io_kiocb *req)
 	io = io_msg_alloc_async_prep(req);
 	if (!io)
 		return -ENOMEM;
+	io->free_iov = NULL;
 	ret = move_addr_to_kernel(zc->addr, zc->addr_len, &io->addr);
 	return ret;
 }
@@ -208,6 +209,7 @@ static int io_setup_async_addr(struct io_kiocb *req,
 	io = io_msg_alloc_async(req, issue_flags);
 	if (!io)
 		return -ENOMEM;
+	io->free_iov = NULL;
 	memcpy(&io->addr, addr_storage, sizeof(io->addr));
 	return -EAGAIN;
 }
@@ -1119,26 +1121,25 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 void io_sendrecv_fail(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *io;
 	int res = req->cqe.res;
 
 	if (req->flags & REQ_F_PARTIAL_IO)
 		res = sr->done_io;
-	io_req_set_res(req, res, req->cqe.flags);
-}
-
-void io_send_zc_fail(struct io_kiocb *req)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	int res = req->cqe.res;
-
-	if (req->flags & REQ_F_PARTIAL_IO) {
-		if (req->flags & REQ_F_NEED_CLEANUP) {
-			io_notif_flush(sr->notif);
-			sr->notif = NULL;
-			req->flags &= ~REQ_F_NEED_CLEANUP;
-		}
-		res = sr->done_io;
+	if ((req->flags & REQ_F_NEED_CLEANUP) &&
+	    req->opcode == IORING_OP_SEND_ZC) {
+		/* preserve notification for partial I/O */
+		if (res < 0)
+			sr->notif->flags |= REQ_F_CQE_SKIP;
+		io_notif_flush(sr->notif);
+		sr->notif = NULL;
 	}
+	if (req_has_async_data(req)) {
+		io = req->async_data;
+		kfree(io->free_iov);
+		io->free_iov = NULL;
+	}
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
diff --git a/io_uring/net.h b/io_uring/net.h
index 337541f25b79..45558e2b0a83 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -59,7 +59,6 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags);
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_send_zc_cleanup(struct io_kiocb *req);
-void io_send_zc_fail(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
 #else
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 36590f9ab37b..e9fd940c2ee1 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -500,7 +500,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_send_zc,
 		.prep_async		= io_send_prep_async,
 		.cleanup		= io_send_zc_cleanup,
-		.fail			= io_send_zc_fail,
+		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.37.2

