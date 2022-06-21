Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4574553ED1
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 01:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354574AbiFUXBP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 19:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353965AbiFUXBO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 19:01:14 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9C02AE31
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 16:01:12 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id i81-20020a1c3b54000000b0039c76434147so10048760wma.1
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 16:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3n8cR1jyiLtvKt85781uU9I+x3oanxTHrlGgjHJZt0U=;
        b=j8oG2VNzFN+F2fEpSxXK/CPjjvzRM+e67WWlKhjcGjtuYePO1WcGdzzbvAj0IO8Bso
         QgE4yN/WIvnJ1hmJt+VADuGBV8HLrwwYMP/EOSlwYIii3k2qxIt3pai4xOtDv3O5RGTO
         ltpRcHWaQyTOkVLs4GI356xpU0T4g4h5PDWhrlL4weYyf13WDLmOU42pRaIwahGWR96Q
         HQUPCLzL29MPA+e/AeJLrKb9kgL2yvyQMOzqArsYmq58KpJbDCGlcpbTlLktgXYeOnuj
         CIt5/vI5npJUlXEDRhS9rMIaPC2Dv1nYlujtyKQQh6W2oaS1IPh8zIyq+AcSkaFXmb+f
         AaZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3n8cR1jyiLtvKt85781uU9I+x3oanxTHrlGgjHJZt0U=;
        b=di2jm0TNj1L2zsmwNwj1ZkqIQejTQ1AnrbKowB3mK4PFYUl5ayA8YUtS0qVzdc8dk5
         pciI2TTENOGGF0hUcFPczwj2Mhaj+fnZIUIWoUjdHphtzjo0PQpRuvJHxyqIKz2z4gNg
         rBlsgmM4PPOpiKHA3rb6c5mvDpZXj8yiLEjuEx8eW9KAn67btDwC8+QprU8R1PaX4ww5
         2LG4fJISile7EBmRIqXAgT8ipQtEb4tJ9DEEQNsSbtSpV0DfB9w8yHzLZm0MyZ0t9/ko
         +/58i6xOc/f/3l5KRQRRgde9AM+MkpNaLJ+SOEPA5zDUFKOzTlXkr0Syu+VbbwxZwSwU
         RJTg==
X-Gm-Message-State: AJIora+5dIMbirGI3hST7jGrAOJ4P1uzF9NuVxqEC+ALbidVFP4VnWaG
        qsp5IB+duCkfagT+q6P3zWInaOc6vFo1MRG8
X-Google-Smtp-Source: AGRyM1uYzpGWX9uTK1SAfTqtu+sA2EYJ+CjOcrwUnSKjuPGEdHDhQTD8QOfnBjkT45B+e6bisd5sow==
X-Received: by 2002:a05:600c:1e0b:b0:3a0:2965:b315 with SMTP id ay11-20020a05600c1e0b00b003a02965b315mr235559wmb.125.1655852470601;
        Tue, 21 Jun 2022 16:01:10 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id q2-20020a05600000c200b0021b8ea5c7bdsm7630462wrx.42.2022.06.21.16.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 16:01:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 2/3] io_uring: fix wrong arm_poll error handling
Date:   Wed, 22 Jun 2022 00:00:36 +0100
Message-Id: <a6c84ef4182c6962380aebe11b35bdcb25b0ccfb.1655852245.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655852245.git.asml.silence@gmail.com>
References: <cover.1655852245.git.asml.silence@gmail.com>
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

Leaving ip.error set when a request was punted to task_work execution is
problematic, don't forget to clear it.

Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d5ea3c6167b5..cb719a53b8bd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7145,6 +7145,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		if (unlikely(ipt->error || !ipt->nr_entries)) {
 			poll->events |= EPOLLONESHOT;
 			req->apoll_events |= EPOLLONESHOT;
+			ipt->error = 0;
 		}
 		__io_poll_execute(req, mask, poll->events);
 		return 0;
-- 
2.36.1

