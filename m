Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBFA43058C
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 01:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhJPXKI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 19:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbhJPXKH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 19:10:07 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E5DC061766
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:07:58 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t16so53773065eds.9
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iIYXLR/hqB3bqEoUXQbJtt06+EzxaMoBCftjqwlAf9g=;
        b=AbbRmjrEYJ8jgzTdB8nmU+MsEXvDgFvPatKZftt7siSiHRxptTOuq/EmSty3m3Ut62
         uB0R9hXWTMFvqc2po3xrK7cGJsdkcfjHfrMaNEcKX7GNcTWGgXSzFvPC65Yigg1r2f6e
         Ay++NijTmzUlSY3MRKxzzRYU2fk7ttChxJaEqfUtEDcKYMobMA3Yxifde0MevCrcQYjn
         JrKn64Gcqr7ZRWIcOcihPOzFKGbZHGOvdpLukxa5dYALWstOkv4KW7uwRZQWLB9SEFk9
         ut4EThUA8wp1L9dhyhWvL6bCaS/sNB3eu2Fpv1j5R5pwlO1y4qwKkZurL/v0x1DrD9bE
         nt4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iIYXLR/hqB3bqEoUXQbJtt06+EzxaMoBCftjqwlAf9g=;
        b=t7qdUL+/4jWTfGDwz09EGotSOlV49OHGkYeYmhou3/Xsvrlw0L5oWTDMuDPQTuace2
         ZLig6J3pdzrBCsz9vMUHIFKGA7lToPbQKrkfV0Uanc1sPP1X48pzqhgev7Kd2H4uR9iE
         0TSPWYYeuX4SnP0v25D+QlpatJ+bgmRvx4j5/X62NvG+1Dr+QMJyc5CAVUE31H7IqcKD
         zG9YI3xyBszhDfV/ED/fc3zjKNDDIaCJNZhRJQZRP9JgyGZsmI/J6MytNqOPmnuuKI52
         Qxv2tMQignqxwxlNQHkyNYQX0XdFv3+SWotRluer+jxx43ZrxYLTgWoLmSpvj2apvZCY
         TfXw==
X-Gm-Message-State: AOAM531VmEqi2F2L7SxOWqLMfXDkQbDq0p2hlp8TY/aLJRYvppYV4kRd
        3vlJO2aspmj2Ve97CKOPiZ1BFNWXsaIcEA==
X-Google-Smtp-Source: ABdhPJxDonRV0GglV8izywP4w0hdSap6cun8tigxi+3zXzo01Ttvuvg2l/yEep8ofxrO59QDjttMlA==
X-Received: by 2002:a17:906:520b:: with SMTP id g11mr17727840ejm.502.1634425677391;
        Sat, 16 Oct 2021 16:07:57 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.201])
        by smtp.gmail.com with ESMTPSA id q14sm6791217eji.63.2021.10.16.16.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 16:07:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring: arm poll for non-nowait files
Date:   Sun, 17 Oct 2021 00:07:08 +0100
Message-Id: <9d06f3cb2c8b686d970269a87986f154edb83043.1634425438.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634425438.git.asml.silence@gmail.com>
References: <cover.1634425438.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't check if we can do nowait before arming apoll, there are several
reasons for that. First, we don't care much about files that don't
support nowait. Second, it may be useful -- we don't want to be taking
away extra workers from io-wq when it can go in some async. Even if it
will go through io-wq eventually, it make difference in the numbers of
workers actually used. And the last one, it's needed to clean nowait in
future commits.

[kernel test robot: fix unused-var]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce9a1b89da3f..14566d1bf174 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5591,7 +5591,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
-	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
@@ -5601,7 +5600,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		return IO_APOLL_ABORTED;
 
 	if (def->pollin) {
-		rw = READ;
 		mask |= POLLIN | POLLRDNORM;
 
 		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
@@ -5609,14 +5607,9 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
 			mask &= ~POLLIN;
 	} else {
-		rw = WRITE;
 		mask |= POLLOUT | POLLWRNORM;
 	}
 
-	/* if we can't nonblock try, then no point in arming a poll handler */
-	if (!io_file_supports_nowait(req, rw))
-		return IO_APOLL_ABORTED;
-
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;
-- 
2.33.0

