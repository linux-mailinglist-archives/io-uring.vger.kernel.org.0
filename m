Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2446C54B383
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243940AbiFNOh5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244406AbiFNOhw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:52 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3499219C
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:50 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id z9so4776054wmf.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5N7TMgeWBdRzVUyrDSTUAGo45ogYC2r5XYPpUezh63w=;
        b=J94+M8NILMZkczmn1c5tz1B/8X7icYh05Y1xq6TaueAkB/j6whH4JTD8/8O2uW4ozy
         5lUCUoloLcgYKGw1rrhGrRKrNgO78+DgqoiNjpYzei1FBeBhdaAQ+yhdA12EufZqx2fW
         jGTTHCrNXBYRBbSluZ4qHJMPAggYRX7j+8LhaZDWI8N8VBBZxjSL1+OISGclfoCBTaD5
         HgCn71UzN6Mam5/8GbDyKGSY7xO95vvdmqCWyU3/yhbSTGMpxPGEi4uYz+DU3jgEREWx
         YeffSegZ1czRkfIbSvk+17uoue98ozshq/JObRqBjew903h/KdXe1CvJyKjqDwTE8YJL
         985g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5N7TMgeWBdRzVUyrDSTUAGo45ogYC2r5XYPpUezh63w=;
        b=riX1t9YdbpCq7BZRnC3k8Ar2qlwBv2ZNgBtXcxQu1GaYMK6cZ53dqpKqmWG2VSyTIY
         JO41uHbFnuwzbQydtAkG+ap91iFr2lG+n7EvNR0XYPici5I+5sVYRxAUQm70GydSx4qT
         iWsrGk0YFny/KEnHZGZJqcmKlBPrp3rKCP+W9Qf1v1hnAqCFF37zSlNGxPwnWfXnJDKn
         h64jZH23MY8hZUvov7TT/BlR4ifAaIN8yl+8O9LTLipbWaOf14RQYN0w5Cm6ZlwEVd73
         k8KYgtfk7dmgOR/9VM3AA5Um0WcFtYdVwSiOFLpGUzYDqsloHbPU2Bbl0p64iCq/1yVV
         uvHw==
X-Gm-Message-State: AOAM533mZUF5IwwX5gwwdLdxlhJVw83Oe/qf/nJDogoEIDoVZ+Bh3b7B
        JiSPwf7URVDILqlLG40kIIkwiwsXNfO66A==
X-Google-Smtp-Source: ABdhPJynDUvNYJbnElnh9nxo+PC5Cehb6b4LWmAFO9AedcdeOr4npCNeozZbkKw/Ov7JgZxYDZldew==
X-Received: by 2002:a05:600c:1990:b0:39c:81f0:a882 with SMTP id t16-20020a05600c199000b0039c81f0a882mr4518161wmq.72.1655217469180;
        Tue, 14 Jun 2022 07:37:49 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 09/25] io_uring: never defer-complete multi-apoll
Date:   Tue, 14 Jun 2022 15:36:59 +0100
Message-Id: <9ce557af28d199cb03cd24db65fad6579a2e9c2b.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Luckily, nnobody completes multi-apoll requests outside the polling
functions, but don't set IO_URING_F_COMPLETE_DEFER in any case as
there is nobody who is catching REQ_F_COMPLETE_INLINE, and so will leak
requests if used.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d895f70977b0..1fb93fdcfbab 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2149,7 +2149,7 @@ int io_poll_issue(struct io_kiocb *req, bool *locked)
 	io_tw_lock(req->ctx, locked);
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -EFAULT;
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+	return io_issue_sqe(req, IO_URING_F_NONBLOCK);
 }
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
-- 
2.36.1

