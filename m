Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D0320F47D
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbgF3MWf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733305AbgF3MWf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:22:35 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB20C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:34 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so20322377ejq.6
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dpPIoBNnz9DbcuHH0snhUCYQ/Gwe0jVd7xH0kSWeBZo=;
        b=dpEjW99zAHx08B8kKQTwDRe3zIqg+s1gc5oRHJPOj6BGJP26ynNQ7qRMVvOHKVHVQN
         c74p3EUzuLiMJXwbm351JjSC1UbxKB77Oh86kH+v3n31NjAWXgrKvTteGoJ71qWcZ6v3
         gKD1HTwJqyENzO5aNp3nf6wBIV6X3FCctU/llR6l/s0LkWnOUjIxBZEsChDze6rfxEv+
         Ima6qZqGQ9ucNKvCj9XND1QcUAtC8Z6/Htpwokf31zHr3ViXkGgCau351QZXgV8Mt0fT
         X3qzoY0ChBKGWY3qNEDGH3Okg9TfLuWDUJhlS3KfWyYx0E7J1tvvZmzt8GgYpMrsIHZa
         Q7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dpPIoBNnz9DbcuHH0snhUCYQ/Gwe0jVd7xH0kSWeBZo=;
        b=LS9Zwsnz9c9ippJ0o7gTzTzxSTpU4xhSDfUMZMd7ozYO6tLP7PYdYW/VammRwYLbk3
         AzPx55Ttn+sYwIe/5KvNJxWiVjGHy0ktE5WjXGVf+5UKSkETmSd+yaM5m9OAu8fiAkZy
         C7nX8GesQAqcqK8WwmjbY32LMUK2UHls7QLes62w9OzV9zimwCEGd/SW5dlOYY27dW2e
         g9HxkE8QVKqe7wF3Q80JW3nj3831INe48WcjRc/akevQIUkMqw7S7fPNYvBHfVnbbgUa
         xyzuQ8vn7oR6puUnO8iQlDkC5eg0ng+ykXMoRbexkb6T/+EBZfxRirWFB/fxsGBcM0IQ
         7YuA==
X-Gm-Message-State: AOAM533mxdXcdXB3qPE03T5A+abL6o9sAcGhcnfPE7BzNkEPJ+xC7ZDE
        cjyG50/tLYvnWhP/YwRUA6c=
X-Google-Smtp-Source: ABdhPJyJOH9hyrbases1pCfr8You441um+zs8EhUz4E9XPjioJ7juDjKZ/DKUto1M9nVR8Eac1GHMQ==
X-Received: by 2002:a17:906:7a46:: with SMTP id i6mr17376189ejo.475.1593519753680;
        Tue, 30 Jun 2020 05:22:33 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y2sm2820069eda.85.2020.06.30.05.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:22:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/8] io_uring: fix ignoring eventfd in iopoll
Date:   Tue, 30 Jun 2020 15:20:38 +0300
Message-Id: <14ff6dc22b0413f401de83f068a2813fcd63b184.1593519186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593519186.git.asml.silence@gmail.com>
References: <cover.1593519186.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_cqring_ev_posted() also signals eventfd, and nothing prohibits
having eventfd with IOPOLL. The problem is that it will be ignored
in io_iopoll_complete() in non IORING_SETUP_SQPOLL case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 96fcdd189ac0..776f593a5bf3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1926,9 +1926,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	spin_lock_irq(&ctx->completion_lock);
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
-
-	if (ctx->flags & IORING_SETUP_SQPOLL)
-		io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx);
 	io_req_free_batch_finish(ctx, &rb);
 
 	if (!list_empty(&again))
-- 
2.24.0

