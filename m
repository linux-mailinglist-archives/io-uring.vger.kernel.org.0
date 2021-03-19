Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D90C34234A
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhCSR1E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhCSR0w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:26:52 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86E3C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:51 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e9so9888104wrw.10
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yUcl80kmpKVwE/jyNmxG84xPJ0LkZuTVRWb59q53aNU=;
        b=XN6W7Gl+vLgkCgAtlTmGo+s90+VIb09K129q9UEGm/lWUAlN0f3An2prDDSYyEdtza
         kRSDQFITgoxhuk2h+j5aMVsxIa8FKl1NQWnqeYni89QLL5OuBUhj6vz/3pHJK/sUuHmo
         2U0LzfJ27vJrObV7WTTOYguIo7Bdoowg4K/q5YhALQAz/WnLUUa7k9zkaiFJ7ZDAzQ4E
         w04n+UmBdBfy9LbWYDkF+84tYeb9ZQlXCSVju08nTDDl7XxqQI2dE8FSpgCCV75WU/NV
         cWxKbOlfNbF8TbvLcQ95+wj9fRI7MHpgBAlEl3mPHlKZ7//xLToj1pBGk1uJSMrXvdcW
         h6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yUcl80kmpKVwE/jyNmxG84xPJ0LkZuTVRWb59q53aNU=;
        b=rdE3L9hutWMB7+dEf1vojt0jTMnAeKxtnDfz+iN0fwkm75LV3eQziVkVrEcHsraKzG
         YPBMSx8H04vV3R+wd07+ySdaZl/oYznK+DpVjIhIyHwDMtja2brmvCJx1n7RPZlKaiKo
         kGWKSX/gK2jZlM28LWxc47sDg9GxqJDnVe8Ubct136XVr1t/GQwdKyTFq+jNLc3Yk5f/
         LHNkB2YRx+rQvvHvgMRAzIWbv6J0eJlY0XhI9Wzt3sWxDZRzym/HDnB4ZH6zPe9jsYo9
         yzcqxactHC2TZAry/gu3GGQIZHUjmNcCsAHd/p9bau2B1ryCn3s9hR3GP7MMtvoNUhzk
         /XlQ==
X-Gm-Message-State: AOAM533wPhQvI7p1xyRWvYfX2MRWeiRlj573JfDjThr6PSEH2HoM0bMV
        EUcLXjRVhMXEeL6/wpnaCQdjOlBC4JyD4Q==
X-Google-Smtp-Source: ABdhPJwPciEZWrbWmAgTm4symJ+9PUQlU/riwqlPi7qKZ4ElggpSjUMVK00IDEYB2sBZXP1vclxZvQ==
X-Received: by 2002:a5d:6810:: with SMTP id w16mr5704585wru.333.1616174810531;
        Fri, 19 Mar 2021 10:26:50 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/16] io_uring: don't take ctx refs in task_work handler
Date:   Fri, 19 Mar 2021 17:22:29 +0000
Message-Id: <14f1b174e005c525fd2cb54d9c35cbf10d469a78.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__tctx_task_work() guarantees that ctx won't be killed while running
task_works, so we can remove now unnecessary ctx pinning for internally
armed polling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5aa71304f25e..8ef8809b851f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4864,7 +4864,6 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 
 	req->result = mask;
 	req->task_work.func = func;
-	percpu_ref_get(&req->ctx->refs);
 
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
@@ -4961,8 +4960,6 @@ static void io_poll_task_func(struct callback_head *cb)
 		if (nxt)
 			__io_req_task_submit(nxt);
 	}
-
-	percpu_ref_put(&ctx->refs);
 }
 
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
@@ -5069,7 +5066,6 @@ static void io_async_task_func(struct callback_head *cb)
 
 	if (io_poll_rewait(req, &apoll->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
-		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
@@ -5085,7 +5081,6 @@ static void io_async_task_func(struct callback_head *cb)
 	else
 		__io_req_task_cancel(req, -ECANCELED);
 
-	percpu_ref_put(&ctx->refs);
 	kfree(apoll->double_poll);
 	kfree(apoll);
 }
-- 
2.24.0

