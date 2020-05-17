Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481871D6790
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgEQLDi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgEQLDi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:03:38 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E5AC061A0C;
        Sun, 17 May 2020 04:03:37 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f18so6738678lja.13;
        Sun, 17 May 2020 04:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3RI3nTeGIBwQ/1Ws9FKW/ljvkj9NFjQzGBubXAfLqHk=;
        b=X5y2+NgiTSCimiE90I7pmJJxGAjeEQvQmlWfTjVhjKpDIsF5FMuCTfgaGDu8sGJZlN
         IKTPzNXFJugAcGYJf9gQPw39o2/zH1zkQO9YoB1EKKl8fpJtEOHqqPRfnpmvZhOrvLVR
         +pTvUR3ViWwIPYhJpnTPP1FeQKzvJLMGjb70DErUEB89l9vlCiVBXCSCL5yEmBrgMsay
         0sMkrJVy9sZFHIVo629Np0HMd+hKQGkzyDSnO0+475xyte4yyUl4ulviEQljdiAKrqXB
         0VDFwlNPISdZDNDB4JbRz8xzhDz6XoNBKtVC1qxzUNk/cLWlvWuRfPnr932YOBpVLWOT
         TT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3RI3nTeGIBwQ/1Ws9FKW/ljvkj9NFjQzGBubXAfLqHk=;
        b=FndYKerdgh7zml+MXx6OsQyLET5uPLupTHV9Mzj7oMBpdj0wAoN0lvCP6uLJkPJ2iZ
         94nPkWjG4yhKkC0PgSSZaOJj5bNwmmxe0I7qG+7hwGFTEKt7EvSZ1rbcdTbmUtYXpkhW
         W6RaWXnd0aJFKJIdqc23Rt2/BFgndR7mAmrrLjUiS3GD/pp9iUccqk0V5uOyclrdqJHZ
         Vo4Rb3PNftVpRppD3+bm3Ovz3Z/nIFCmi2Yfn36kk7HuBAhPuM6BBsv2wckWm7+7IAtl
         wOkfwsBL5bQe2PF/DY5/nhvx6w/IJkESlHynrbgZhLG/IX55cL76/daEsZndL/sjIarT
         4KmA==
X-Gm-Message-State: AOAM5323RgqiRpH3thXMOZ24OD5dJg1qwO++0Wf7i295r6QjamWtc6LS
        jGqrFZYJS/qNPUvOGgiebEY=
X-Google-Smtp-Source: ABdhPJyU3WNvcUuDiB69f0JzKYZgVD8iC+mLVdfsz6JCTnflqChc0Y59IgFyAyFWmlNBHlmCregf5A==
X-Received: by 2002:a2e:3012:: with SMTP id w18mr7576567ljw.55.1589713416166;
        Sun, 17 May 2020 04:03:36 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w25sm1080333lfn.42.2020.05.17.04.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:03:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io_uring: don't prepare DRAIN reqs twice
Date:   Sun, 17 May 2020 14:02:11 +0300
Message-Id: <bb206ef92fd1323e8adbe7fc71aca019897c9597.1589712727.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589712727.git.asml.silence@gmail.com>
References: <cover.1589712727.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If req->io is not NULL, it's already prepared. Don't do it again,
it's dangerous.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a19120345e4..9e81781d7632 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5098,12 +5098,13 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!req_need_defer(req) && list_empty_careful(&ctx->defer_list))
 		return 0;
 
-	if (!req->io && io_alloc_async_ctx(req))
-		return -EAGAIN;
-
-	ret = io_req_defer_prep(req, sqe);
-	if (ret < 0)
-		return ret;
+	if (!req->io) {
+		if (io_alloc_async_ctx(req))
+			return -EAGAIN;
+		ret = io_req_defer_prep(req, sqe);
+		if (ret < 0)
+			return ret;
+	}
 
 	spin_lock_irq(&ctx->completion_lock);
 	if (!req_need_defer(req) && list_empty(&ctx->defer_list)) {
-- 
2.24.0

