Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6E74216ED
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbhJDTFo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbhJDTFo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:44 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B64C06174E
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:54 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id f9so6317252edx.4
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hx3jOcDULwbI0GK5aZUJPlbRJvr0sh72VIL4zxYOsDg=;
        b=ddgWYTUNPcohFUIcW42ehzY9dNYiAdkyD2ZJ6BCICSKk2vGDQ2Sovu0tQLvpNQdJkJ
         Iaohf4qlwJwZHoIz5kbHYBoSnc7C19HCE80Ce3D+DXM0Ljj27aGVuMUkB1l8D+HH5eLM
         qP9ZhLwS7ANokzuIixuqWUC74R0dEc7cr9YXH9PlFoESv5n1dUnoVbQg8xIJaxqKG/Xn
         VHha4tF9odTjz3bCeFzNvtQYa9BrThVTzSuql4ht5gkfCWaUF5XgNJFNoxRuD+PhVasx
         6MjU834ANlaB0evK9y5v+tSkh6ooiFS/PFsqG4rzt5r+5itF/3mxiX4cAABRTZOU5A2d
         wdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hx3jOcDULwbI0GK5aZUJPlbRJvr0sh72VIL4zxYOsDg=;
        b=WNpOsgfO9yVHL2tNncsv65u8FGAj0Okfm9BIjysvLJ03yGS5Npc7xRUVZXfwpgrTPg
         geLB28jA2B/HzSHN9I7BgOU9bDdy3yTqYMn6GV/J+gz3WoOiud2C54jcuBKGZAW32xYA
         CEUeocchGu/yP3FFy5KhhLNSoO68IcmJMkN7hsn3Ja9MguUWw2/I1xTOCRKIx3YEUszz
         JTBXS2gHGQA5nNM/oAynjUpzxSL+FHT/6094i3VVeKcygQaBOGtS2imGWNiicQ7Mq8c6
         +WPtNOyWIZl4hHtVi5GElJWdtXR3+LdV4po/G9Fn3Z8FJ3Yms6xaY4AbRXAcpLEv4qDC
         O0jg==
X-Gm-Message-State: AOAM533dQbMYVW1XkgJ8yb+WVlDoLmK3L7l7FoG3aDloJ2xLE+B8yUuD
        h8T0PGajIPP0xw80pzL3cPTtlxkfQ+8=
X-Google-Smtp-Source: ABdhPJxVcy/MCs4NtQ+wZQ5fIEgaxFDzydiWpUItMvbwLVcXc3GPGiP0+wEyvucyskjU83GTmulLLQ==
X-Received: by 2002:aa7:cc8b:: with SMTP id p11mr19940928edt.30.1633374233322;
        Mon, 04 Oct 2021 12:03:53 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 06/16] io_uring: don't wake sqpoll in io_cqring_ev_posted
Date:   Mon,  4 Oct 2021 20:02:51 +0100
Message-Id: <b49dab27b64cf11f4c50f2f90dcaac123430e05d.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_cqring_ev_posted() doesn't need to wake SQPOLL, it's either done by
userspace or with task_work, but no action is required on request
completion. Rip off bits waking it up in io_cqring_ev_posted().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 377c1cfd5d06..56c0f7f1610f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1619,8 +1619,6 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 	 */
 	if (wq_has_sleeper(&ctx->cq_wait))
 		wake_up_all(&ctx->cq_wait);
-	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
-		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
 	if (waitqueue_active(&ctx->poll_wait))
-- 
2.33.0

