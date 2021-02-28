Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D243274BE
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhB1WJi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhB1WJh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:09:37 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACFCC061756
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:08:56 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id n4so11194102wmq.3
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NZ3Am0bAPmyxV3aDvy71KLcqCVtOCGijRJbxRZPPjds=;
        b=sqSBgB2aHHDyKUF5Mvo8Jq8vv5L3X9MhOhxlSsWNG2h4p1laWNGO8LdaZXhlvApoZd
         jr2QfJLHk+WlsUsk/dbX/tW4aaacGCIPd1gkXskA4GaRVU+IIrFuSU0TWVcblobjbbnB
         ZKXLPhmj7SuglXJhnGzfqLD0IquIQte+EiCtjfGRtMSsu5elZXV+33JLvXAvJJDBVoeW
         Z2o42SMeHm3RyvoQhJfgRbJ/pRX7xNXBoyFDZdf+ppBtInwyiGZLmGzV45N7vlztvk77
         MnH9nSEkjFCp3YDJ/SfwvGr3un/5QBkIear09fBQr1KfJr4M4Wo5TyScUGJgK6GnQKvh
         tbyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NZ3Am0bAPmyxV3aDvy71KLcqCVtOCGijRJbxRZPPjds=;
        b=bddEyomdghGvJLLHYFBYr+V2OsitRWUmwC0U6WxL9aEZJB1zg365hOBVjcM5b3tcCj
         9p8BG7DwsTvg709yFqNdQ8PF/4LG0MroneqRay6oZJ6hwVAwHuduM3xNmzpW4DZw+MLZ
         KNH4pTFQDS1UqcnJtv/xoWQ5y0eGcxoxbyFK+2IMo4n1/EX+IzqS8L167T8Kqk3x59e6
         ztOSQ5A+YLMFu4FkkIXhgrWDvPxvv7pbaC6+YWCqUMZBGkfs8Vd6JYL/mWzSfWFRDBfa
         dVkl6l6egTk7c3QrV/TzTlvI/TG6M+mTXsRElXDnXqi/ujqTpw35u6wvi6cDnw1BjLBx
         QCWg==
X-Gm-Message-State: AOAM531wNGVADUTwhkwh38j7jPf9W5EjCmpjkytw6TvBFWdpWENEsaxm
        6C98UOep2ueXJHugjUUve/pBZxZ1SunWFw==
X-Google-Smtp-Source: ABdhPJzu27bPTHKx0bOIvGpbNNJWDKIQudNRtubWLeohc8yFL9QFX0QJRQJ6G2J7jfkRVlBIF/Nyfg==
X-Received: by 2002:a05:600c:4ba2:: with SMTP id e34mr12688784wmp.121.1614550135429;
        Sun, 28 Feb 2021 14:08:55 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id w4sm19780396wmc.13.2021.02.28.14.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:08:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: replace cmpxchg in fallback with xchg
Date:   Sun, 28 Feb 2021 22:04:54 +0000
Message-Id: <446223e20253334e0bea08a0d21a42daba8d916c.1614549667.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614549667.git.asml.silence@gmail.com>
References: <cover.1614549667.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_run_ctx_fallback() can use xchg() instead of cmpxchg(). It's faster
and faster.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 365e75b53a78..42b675939582 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8489,15 +8489,11 @@ static int io_remove_personalities(int id, void *p, void *data)
 
 static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 {
-	struct callback_head *work, *head, *next;
+	struct callback_head *work, *next;
 	bool executed = false;
 
 	do {
-		do {
-			head = NULL;
-			work = READ_ONCE(ctx->exit_task_work);
-		} while (cmpxchg(&ctx->exit_task_work, work, head) != work);
-
+		work = xchg(&ctx->exit_task_work, NULL);
 		if (!work)
 			break;
 
-- 
2.24.0

