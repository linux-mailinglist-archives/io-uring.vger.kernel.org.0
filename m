Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CF936E902
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 12:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhD2Kr5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 06:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhD2Kr5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 06:47:57 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3571DC06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 03:47:09 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z6so5113779wrm.4
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 03:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YLbCIZ7upN4Xw4/tJs2piw+qjLeSKTkZ4paYOXT2Gu4=;
        b=YT/3okDnpdnxqXZctBrtDyyhDumtA5+Fgdr8VJyozIrs90r1Lqq/hMQfx/xQZT9IEF
         emmA3p84JRMKZzO7km0jfAzUEJzCxtEmO+aeR3+O/oHLDz8WYa2cGeaWXUXag/0zwMUT
         eb5w4ZXvUEYGyjqvilT/WzemeiZLm0zVNoquWXpTvTdg3QRQF4uLJDMmImFtSKg2gmBU
         hVn36MHkj97XjCtURS2F60qYjBuZOjMomN9+3neSEdWnJYV9PQlAxx8+sb1ujr2OUJbJ
         BKRWyfWtjbwtGxnmxadTzponkzOEUQ/QVFaw+HzoCGUWhP95mighzfmoNKunhN5kOqxq
         1dlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YLbCIZ7upN4Xw4/tJs2piw+qjLeSKTkZ4paYOXT2Gu4=;
        b=Zm3RhoqyQr594TlAxOzx2Rq/Mpvtbl1shTk0c+p9FgU0utIDY/BXyRf/0avGRxICOp
         xUPMp3Ffss6ZiJ53Xg3cnKmy219Y9rzRFvqCfitCZHErXSFxqdK2eWbKqb+skbygDkhe
         l8KiAvmp2Oelx5LCM1PmG5/3IjvqR3OzABCFKbaqqEM3038sKaoG+BVirS1M1NYmiiUT
         RTx9gx7fxvgBmiw+yyi4++ObUANd5f6R/dGD1T3L9th8Nidr/WQE6eYknCw9Lx9VKCtn
         JwUUgUNs+VVNHrAENMreo0q9hu1uFo2jRo0t3E+YU/d59IQ/d61sw/G87mc4regfSQ/M
         bV4g==
X-Gm-Message-State: AOAM530zpFCSRL7pMwia/Glvux9Wp3HwswcHOjavnJ9t1y8hefIcjMcu
        A1XC1Ol3U0nyXw6uHl6SsK7ZgJzlyxc=
X-Google-Smtp-Source: ABdhPJx7UzSLvM/gTacaFxtts5Y54qON7UkDv82EsVkdh3mzDljZ7GPi7uW5sKS/FyuwPNhe39VSjQ==
X-Received: by 2002:adf:ed4b:: with SMTP id u11mr34028492wro.293.1619693227979;
        Thu, 29 Apr 2021 03:47:07 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id t14sm4396443wrz.55.2021.04.29.03.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 03:47:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com
Subject: [PATCH] io_uring: fix unchecked error in switch_start()
Date:   Thu, 29 Apr 2021 11:46:48 +0100
Message-Id: <c4c06e2f3f0c8e43bd8d0a266c79055bcc6b6e60.1619693112.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_rsrc_node_switch_start() can fail, don't forget to check returned
error code.

Reported-by: syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com
Fixes: eae071c9b4cef ("io_uring: prepare fixed rw for dynanic buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 43b00077dbd3..fe549b58fa64 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9624,7 +9624,9 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 	/* always set a rsrc node */
-	io_rsrc_node_switch_start(ctx);
+	ret = io_rsrc_node_switch_start(ctx);
+	if (ret)
+		goto err;
 	io_rsrc_node_switch(ctx, NULL);
 
 	memset(&p->sq_off, 0, sizeof(p->sq_off));
-- 
2.31.1

