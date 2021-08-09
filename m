Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70F33E4543
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhHIMFn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHIMFm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:42 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220C5C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:22 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u15so10427665wmj.1
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HQYIGRNxxpmmMZtSNoDz3Aky9sEkmlcax50N2eJKWF4=;
        b=ZJQ0HqPTXNDxD8j8jgyFAHTycNSt9BhnNnJcXTg7ncSKw4Qq0RzVsFVHWA6bpeqQ7f
         sMqvPdQy3hy6Bmz7cf+qD0tLw5bgsnLcHaNodKocEV1w7M+vXgtO3k8QPsS+Q51gCSMa
         EvVBC0Ew6QNj8IozZ7NJfYy+JLBDD+AGBTZojhysDwGSeVbvTspdI6O2yf7dNFh9qTzL
         DZMt6OA6/emH4XmLHIIvGhbcQuVNevRa0WHRnAgo4xrUMqGod6km7e8FwXgOIvsme14f
         vocGVwIJ1bGhE9cYdtFtGX0Bl1Eyuwr4x/xMFRHLyIEtgHm3st+KP6MGZlDkLv3CCJjE
         j1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HQYIGRNxxpmmMZtSNoDz3Aky9sEkmlcax50N2eJKWF4=;
        b=cuKK8CHIChjt0C/prT7gvjk0o/Qf77qD/J0MoWq0kK8Ge6b9+Lg0VoRRsHU8SQCETz
         Tk1w7S0CsSsrKNIIvVomq7ZqLi8/haxa63I3cZP6MZ41HnTE9W9xWtvcS8+Oq62V/dGk
         R2OH0lAtVOXekjCknlxXhBkTelxVZaIUdu/1txKA0f9jjUM5wOR6Cjh3mgkqO7/edGJ6
         4i5FPu7rz9b9eCfaYsH8/u+Ha+ZI5dYOnx0fSJ39U2Y/XlIX/Caa0D4A8634bGuoNpoz
         FpR4SVeA6nzZckG66rj+/HHCIaIJqkF/mkc2oXkiuufDyYMkCP485ip4QrXeRfCXHPcL
         sBVg==
X-Gm-Message-State: AOAM530L9UctvbkVSY7UM0GNQmcw6DdxsL/fzCJ9BiFLNDc4N/72IHh0
        osOQk0sbe6Jw4pOSxjBmF+Y=
X-Google-Smtp-Source: ABdhPJyHW941uvg1lyWsy3xd2D7kTGxBnO8IOWZUwX/36kChMGAnwTbVusioli7Vmy6rd1W33QxIig==
X-Received: by 2002:a05:600c:cc:: with SMTP id u12mr16174584wmm.63.1628510720846;
        Mon, 09 Aug 2021 05:05:20 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 19/28] io_uring: drop exec checks from io_req_task_submit
Date:   Mon,  9 Aug 2021 13:04:19 +0100
Message-Id: <be8707049f10df9d20ca03dc4ca3316239b5e8e0.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case of on-exec io_uring cancellations, tasks already wait for all
submitted requests to get completed/cancelled, so we don't need to check
for ->in_execve separately.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba0c61d42802..3c5c4cf73d1c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2043,7 +2043,7 @@ static void io_req_task_submit(struct io_kiocb *req)
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
-	if (!(req->task->flags & PF_EXITING) && !req->task->in_execve)
+	if (likely(!(req->task->flags & PF_EXITING)))
 		__io_queue_sqe(req);
 	else
 		io_req_complete_failed(req, -EFAULT);
-- 
2.32.0

