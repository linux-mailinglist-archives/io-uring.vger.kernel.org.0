Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEBA468793
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 21:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhLDUxa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 15:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhLDUxa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 15:53:30 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3ABFC061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 12:50:03 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id u1so13411447wru.13
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 12:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pBDiJuBesGkI/74BWQjzmA+8NCGeoGwJJacLXJ58R1o=;
        b=guEh+J6zxUP9ISa1DMYHkyaDngpXeUByBpsdXFmureyJnVkJriX/+Zv5xO4MaV315z
         fJdDGPEKUpp1Wjtw4YnhzTDY7PzsG3LM27McG+waBjdPYFlSlPxCTGtB2Fxq5/mr38hw
         W1WET4FskVanGKOm06BW7XwL9YgZRJl6XXRr+2erXmQ3zDvGUVutoaSTcIXHPwW7GUOV
         RS/NezfKaH6ViV35AS2jy3ENL+9Mxb16mr3ivMTzIkQ8Jt34BcKLfJ9+/dnQ4udKMolZ
         fKEPSfzNCZy1czEAi8jzsmQYRXFQ3kucTpkRUbYX+doydYX32X0eHcQF2WBhvjYaHBM4
         Zkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pBDiJuBesGkI/74BWQjzmA+8NCGeoGwJJacLXJ58R1o=;
        b=SRSSCd2b2qKMGWupDH2lC9pvLGmL4rXWhDJ4el/WIdOWAKO7ERev7ee8gNCsN5VKNm
         s6+J1+YHPhKIaTRk+vsDtzRFM3XOkFfOilsEGzYyRKBFKpQr8oP+yNBxBzdxiW4Kz1IH
         b9MOGX3pTaTRpWU+XiE3tpZHuFJV/MdUSN/ZP01dtLZgBqY5rgJfMpK2W4anqnHPX1zZ
         8oQzwYL4JwVG8H2gaDLeXIKP3ar1hm56yOxUqhGI6Fk3/9g4fetGYxWWcHZl+C/sc5tU
         brBqijfAmIQV3SsYS9maXbmlvJF6Tg1djAvEnUu7mLpg6k4/QBQQ49UlN6vY/kpZsSsA
         mQKA==
X-Gm-Message-State: AOAM530NxXKEYzJPKoEURID1Ns/G48vfd5xRwBmG9fHMuF4qG1ioBHR3
        FeFd4fR2q8Q4nPY4QzuQ55TKrl002+w=
X-Google-Smtp-Source: ABdhPJwoI/ZSJbnfkmbVWglzI5/YBiFN6HNtYjAihiTiFUGNIHsTJjof2Iv2lCQrueR1v7NfYerzrA==
X-Received: by 2002:a5d:4ece:: with SMTP id s14mr32215211wrv.371.1638651001918;
        Sat, 04 Dec 2021 12:50:01 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id k187sm8393143wme.0.2021.12.04.12.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 12:50:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring: reuse io_req_task_complete for timeouts
Date:   Sat,  4 Dec 2021 20:49:30 +0000
Message-Id: <d649e243edd88c26e2af2e38b96ff9d9b7b655fc.1638650836.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638650836.git.asml.silence@gmail.com>
References: <cover.1638650836.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With kbuf unification io_req_task_complete() is now a generic function,
use it for timeout's tw completions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea7a0daa0b3b..1265dc1942eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5953,15 +5953,6 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static void io_req_task_timeout(struct io_kiocb *req, bool *locked)
-{
-	struct io_timeout_data *data = req->async_data;
-
-	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
-		req_set_fail(req);
-	io_req_complete_post(req, -ETIME, 0);
-}
-
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -5976,7 +5967,11 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 		atomic_read(&req->ctx->cq_timeouts) + 1);
 	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
-	req->io_task_work.func = io_req_task_timeout;
+	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
+		req_set_fail(req);
+
+	req->result = -ETIME;
+	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 	return HRTIMER_NORESTART;
 }
-- 
2.34.0

