Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DFB66CB12
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbjAPRKP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbjAPRJf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:09:35 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5997D2885B
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:04 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q10so8741668wrs.2
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hfmfq9bEE+y3Nlnna5Y2xYfaeIGiWD0pI3kCVAp4pI4=;
        b=QnRqGPzz9UVYY9OhHQl7JuCporK4n3hn/i/AYzvcgK0lnRvI3cBGTib031h0zqp+WR
         Re+R80dxnaNtcPOH0xDUY8o+QIjSZRm5HVntSLKYOGQZiYWxg92O98D+px+jg8rKIMAc
         De4CxmireQUtTbEMQjOGUEPkllCWkJwVUJ+U9mVyH81eVTzdCYu57TSKf0yN9qaF6FJz
         hvvYgihrIi6P11OHZzr5qu6RBDSMkrLINg8XEPpE0PgzymJVL5T+dQHOdV3IVJvCJygj
         gsa1LooThqePE316e1EfTT64B/K9p1cm0qzRYfhmxEoDdflm1MIk2BV+uQefKpTV9bVv
         j20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hfmfq9bEE+y3Nlnna5Y2xYfaeIGiWD0pI3kCVAp4pI4=;
        b=P6YIipMIZnqaaqp6vMzgRseYmcIyq71Mt21H+p8bgcFrhzEIfKWf9+12O3AnrVFYj/
         +wE/OSSIs/Izjs2g4xcnL/ZC40xHtu4swzxa8izoa9TbPltCRVYMK8SPDxJXLy8EGRcG
         c/hYXSFLTf0+X1RC1AWa+apvw2zE14sVHcvNwXPMl25ifRXBlRLukwjkPtZSQcW1vK+X
         nlipeWFuByHXE6cS80PL35kr8lTzn4wDjWkKZuTfHu2mdXdBl8DUqhGjX/ewkIEhI3Al
         IHnhENhKE6vAGQz4tafWW3QpZim46opFvdNb8+/NvCJjSRt/1rraXsu536YxGg820RYA
         /Blw==
X-Gm-Message-State: AFqh2kp48R+/TKoAQn1Z3Ex43ycUNWP8ukWBdENfkoKoOdoPlNO48nFy
        tXAj1n+ZUq6tYGKS4YqUx8hPpQrlF/0=
X-Google-Smtp-Source: AMrXdXvQ6a81R4CmDvgWqgSlLNq4tHGcYxv20pWCbr/b4m0EU8t0zdDQvMW+0v2yH3IPdlEtL3RxyA==
X-Received: by 2002:adf:b608:0:b0:2bd:d76f:23eb with SMTP id f8-20020adfb608000000b002bdd76f23ebmr7921203wre.29.1673887802782;
        Mon, 16 Jan 2023 08:50:02 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d62c7000000b002bbeda3809csm20872372wrv.11.2023.01.16.08.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:50:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/5] io_uring: optimise ctx flags layout
Date:   Mon, 16 Jan 2023 16:49:00 +0000
Message-Id: <bbe8ca4705704690319d65e45845f9fc9d35f420.1673887636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673887636.git.asml.silence@gmail.com>
References: <cover.1673887636.git.asml.silence@gmail.com>
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

There may be different cost for reeading just one byte or more, so it's
benificial to keep ctx flag bits that we access together in a single
byte. That affected code generation of __io_cq_unlock_post_flush() and
removed one memory load.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index cc0cf0705b8f..0efe4d784358 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -196,17 +196,17 @@ struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
 		unsigned int		flags;
-		unsigned int		compat: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		restricted: 1;
 		unsigned int		off_timeout_used: 1;
 		unsigned int		drain_active: 1;
-		unsigned int		drain_disabled: 1;
 		unsigned int		has_evfd: 1;
-		unsigned int		syscall_iopoll: 1;
 		/* all CQEs should be posted only by the submitter task */
 		unsigned int		task_complete: 1;
+		unsigned int		syscall_iopoll: 1;
 		unsigned int		poll_activated: 1;
+		unsigned int		drain_disabled: 1;
+		unsigned int		compat: 1;
 
 		enum task_work_notify_mode	notify_method;
 		struct io_rings			*rings;
-- 
2.38.1

