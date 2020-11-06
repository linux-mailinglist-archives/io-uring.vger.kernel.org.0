Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9ED2A969A
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgKFNDm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbgKFNDm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:03:42 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C524FC0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:03:41 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 33so1239411wrl.7
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eNu1kI46NB+HOv+v4AeDn9U0RjHJKjwXraNV5mv+310=;
        b=Vu+uFf17MsND8lePc4O6YR5LWbwF/e6zXwh0Z07tRr1BHdbccKrlHOqtMQNeaEMrd4
         7i9FRI/xHOGGtd1i3ea7un7yeT02TXx2Oyd83UNgldPf5xIEtyEpxXfHGQgW1i+7GVQX
         M9oyFnyHvLvj0+rqPcTVkRgcQjpZVab6KJo7vtwbUFLOr2p4Hz/5A0rrAjLr39YTGi0Z
         PieivQAZKqY9fqvCGMEitSwtu7gDksSwg1X8rHRnUWvW2DzVfR2o3G+0AvnOnTzY4wjh
         Nw+lYwGfDLwEUZ7LtZB/3ZmraV4m5f/W7eXlLYJ/3Jc+VvpQcEAZjpLQdgM4lJh31aQW
         2ZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eNu1kI46NB+HOv+v4AeDn9U0RjHJKjwXraNV5mv+310=;
        b=PeY7wF8RnXCJa8Ll1t3le1Pv9gexyPoHqE6lyoABwcHMDBKdXuGmm3UV+FdWv/6L5x
         Wy6ZKNFwB93uAOmBxk+8tyXU4Sp8XKLqmw8rcWfpHo0vbz2vhbLZNGB7a87gbCNVNJ9b
         bOcd4SSEN5fe5a1FpQBFBoWYd6Is2zWaxhec+C/Rce56mb85a0Ix6CM/f7KCq9XfPGtm
         5mOuIXZMm6wC/vATMdZ0A+eJgM5m8cJjEn/9A+Yi8mHSlFJVJchxq2JB7EikGyOuEupi
         6eO7Rqf3xtVFY1M6uF6Dglp2y9PnZGvbkEd/0schu8qAaaS/5zEZM/dCknhdLwcbNcxN
         nvOQ==
X-Gm-Message-State: AOAM533OheNu6BiKDYs8YIlHvrzE7pl61yXpo5gz66OjtmtAHe6VP6Fn
        Z43KenIcMmw49K0FnycoDnl7CHvWZic=
X-Google-Smtp-Source: ABdhPJxTSeJO5zMIAI3FOPfhSHbJsDnbcGne2+O2gQGk5WX9akQ/YeS+hbvWp8sXtljBfuT/NhIuIw==
X-Received: by 2002:adf:c14c:: with SMTP id w12mr2742715wre.40.1604667820311;
        Fri, 06 Nov 2020 05:03:40 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id e5sm1931839wrw.93.2020.11.06.05.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:03:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/6] io_uring: simplify io_task_match()
Date:   Fri,  6 Nov 2020 13:00:21 +0000
Message-Id: <604ca562af130b879a4cfa4de6b11ef7d3b8dd7b.1604667122.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1604667122.git.asml.silence@gmail.com>
References: <cover.1604667122.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If IORING_SETUP_SQPOLL is set all requests belong to the corresponding
SQPOLL task, so skip task checking in that case and always match.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 568ece369a1a..74bb5cb9697c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1562,11 +1562,7 @@ static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
 
 	if (!tsk || req->task == tsk)
 		return true;
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (ctx->sq_data && req->task == ctx->sq_data->thread)
-			return true;
-	}
-	return false;
+	return (ctx->flags & IORING_SETUP_SQPOLL);
 }
 
 /*
-- 
2.24.0

