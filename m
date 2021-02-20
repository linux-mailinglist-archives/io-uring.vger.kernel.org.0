Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD8B3205E4
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 16:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBTPV6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 10:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhBTPV5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 10:21:57 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95445C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 07:21:16 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n10so10448638wmq.0
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 07:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SWOaD4NsqVwJRXiYYtYWvj/cz48+vKgKLdTunqhZ2po=;
        b=KRz4kAKAtzAIGZviOWxJZ9p5ntBhpX2NFQoPCLl8XNYDmy1l5LQqFI9hui3PDALz9t
         a0haVThV2YlfdMFVQo01aGyZ6W/NecRb/Yx9BnbqKCpTMQ9L3qxNn7eN32ALVa5zr/OD
         rmlGyqPL+/NVS7+b8Gs7hnw090Owt0H23+7zhhVGxSTCWFVJb7g8m5Z5YG5VpP6QKsy1
         PIA0hls1AcKZCeK/a3QwLiSuQwU23e+fTdE6hEzV9ezP/wQ0wZXNMHZirX7RPRwF1SPQ
         wK0h5tV6C2undEYIbswQb8IoSgrNcPhhDza8wjx7wp6IrPukFSQnxPS/+hreh9/0qj4F
         LXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SWOaD4NsqVwJRXiYYtYWvj/cz48+vKgKLdTunqhZ2po=;
        b=fK6HxH9Agqopp9ImDkrUwuB8LQnIDeIxmKvZx3QZCMxV53xu3T3cX3OeSQmzsBAezI
         Oz87ddkc8EHY0sT61Ss6UTYn2vlDZnpZ2ciI0UW1OhxRah02yFGkjYsuo9UK/7xP1oQ7
         Lc4dYvOzeE+t8thYw20hg1K35zw7nKt0eST/5UcJgrs9lwj+lO+hLOSf0aTa77tsgPx0
         FzM9or0Mn1E9hfehHES6nkrzVZhrujO0Sj3y2jXQMg4hnPZHjKLeW2KEMrxb/JklcqSJ
         VjmOXEP6L/JPe9JHTQrUvN4Lbblec9ISvpdz5oKINHtvBsktjnGSr8AFkwmnhFLjbZ/m
         xiXg==
X-Gm-Message-State: AOAM530d14tcB2nLy1bl4jRSxg1R6F8CA46qQjvI2fmjgRn0MZLk4BKg
        IC44oaFmxVqHaA+mdT2pU9w=
X-Google-Smtp-Source: ABdhPJxYTalc1GrjXb/Ki0iEmIxV8jOoZte2xxSeAercb8OP9qTCWrANvX6TVfgvgX46Lw08cvhrGA==
X-Received: by 2002:a05:600c:21c6:: with SMTP id x6mr12355667wmj.124.1613834473743;
        Sat, 20 Feb 2021 07:21:13 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 2sm19756625wre.24.2021.02.20.07.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 07:21:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: run task_work on io_uring_register()
Date:   Sat, 20 Feb 2021 15:17:18 +0000
Message-Id: <0b6e6404ad89752523d3428669ec089cd540327c.1613834133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613834133.git.asml.silence@gmail.com>
References: <cover.1613834133.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do run task_work before io_uring_register(), that might make a first
quiesce round much nicer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ff8f50d3cf44..f2fdebaf28fe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10212,6 +10212,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 
 	ctx = f.file->private_data;
 
+	io_run_task_work();
+
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
 	mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

