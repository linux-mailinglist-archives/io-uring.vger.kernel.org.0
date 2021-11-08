Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5804497E6
	for <lists+io-uring@lfdr.de>; Mon,  8 Nov 2021 16:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbhKHPPL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Nov 2021 10:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241011AbhKHPNt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Nov 2021 10:13:49 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80346C06122C
        for <io-uring@vger.kernel.org>; Mon,  8 Nov 2021 07:10:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x15so32560216edv.1
        for <io-uring@vger.kernel.org>; Mon, 08 Nov 2021 07:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ul6XdfgMfHpq3WzmBOzb+vAyv5IQLq99/Xw23AELREY=;
        b=aBGdMlnxXi67odT9itmMgpLmC2jZByeDoUFtwHmvmXJcC/pZqAgakMoyVXpoo6XqaD
         kaopc9j0qIViSzHbMjscfppnundbOgI3kICiwBHQYoZEJgRO3miI50SrxL2Q6VB4e4LX
         KA01WvOE8HD3IAnGhpf98BD5LOfXfs1VoFgjdyq4yfbO3g3Ij5AhoxTDZs9fq7LrtDhe
         V7WNXOPCHD3s02c92aqeUcyFAfCXHrHqGyUCuKr+Ng5XnT6pIz9YSH40v7tIvvtTLHxL
         n2s55ocNMcnkXCEPBIrg0JFmkWlkideJIhJJNBV/9wfG+IUZh672Wet78ZjSzFK7UQBq
         WPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ul6XdfgMfHpq3WzmBOzb+vAyv5IQLq99/Xw23AELREY=;
        b=iNDrC4fci3AV8s6nwH8/xSpQA7C+XNVOxsz06fjI3AqvtZCj5cQuXVVyhdsDat8nk/
         ElDYj8rY7AKFYs0U3cSKgAon2GTLcgI89PU++xXDN/FTGm70O2NrW+iMY/qKWpWfqghq
         ENgwBVVJw7o3qiTSGjALNR7P515nFo+nFe+CvBpibnerQ5Sw8fK6MtpvyFVGWsO1ZP6n
         H4Jvui7yEXbzk/Ke4f9ze8XGTFkYHs6GCcrFuhHxAS5XMAM/0EHvTRxR2NSdQA1zKNhE
         9wCTMMIyYsAC7wYwqwv9D+xqHg00SObMbtw7zyMDGLmAmY6X5ShT6m+GsBe1kaVQQYng
         eL/w==
X-Gm-Message-State: AOAM531e/zGIRAeCm68DbSEkW2atKpDqIkp+y+lpDUeLN6j/ZFy6SRLL
        6WTQtGPStkItx9TfycZCqfzSs7M2eFs=
X-Google-Smtp-Source: ABdhPJz4J5AxCrsxsxoJJV18WBBzoT1AiXhAPrzmgJT49hoObk4NS5oeCAE5KlLC8aFW10pFY6oqRQ==
X-Received: by 2002:a05:6402:40ce:: with SMTP id z14mr374181edb.294.1636384210683;
        Mon, 08 Nov 2021 07:10:10 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.239])
        by smtp.gmail.com with ESMTPSA id h7sm9285288edt.37.2021.11.08.07.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 07:10:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Beld Zhang <beldzhang@gmail.com>
Subject: [PATCH 1/1] io_uring: honour zeroes as io-wq worker limits
Date:   Mon,  8 Nov 2021 15:10:03 +0000
Message-Id: <1b222a92f7a78a24b042763805e891a4cdd4b544.1636384034.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we pass in zero as an io-wq worker number limit it shouldn't
actually change the limits but return the old value, follow that
behaviour with deferred limits setup as well.

Cc: stable@kernel.org # 5.15
Reported-by: Beld Zhang <beldzhang@gmail.com>
Fixes: e139a1ec92f8d ("io_uring: apply max_workers limit to all future users")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ac1bc8ac4666..b07196b4511c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10791,7 +10791,9 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 
 	BUILD_BUG_ON(sizeof(new_count) != sizeof(ctx->iowq_limits));
 
-	memcpy(ctx->iowq_limits, new_count, sizeof(new_count));
+	for (i = 0; i < ARRAY_SIZE(new_count); i++)
+		if (new_count[i])
+			ctx->iowq_limits[i] = new_count[i];
 	ctx->iowq_limits_set = true;
 
 	if (tctx && tctx->io_wq) {
-- 
2.33.1

