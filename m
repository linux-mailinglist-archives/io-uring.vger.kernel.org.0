Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12ADC26918B
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgINQbb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 12:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgINQ0I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 12:26:08 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8415C06178B
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:07 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id a19so105432ilq.10
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=210/esXBpcQ81FnwB14NVVrED+udY/8GQjymUvVa4Ys=;
        b=zz5mPiZ2KTTuFM3JYWM+N0FmCyAKihBtI9T9TUgO9/dzCCiXClzXhkLSr7NMPdQ5Qr
         JEpp/d4IRXJhutqXbVEqR/9IKyqRZ6kZcd5wfTvUzQHxssxHtKH8MCbLaNoCxw5yLHgr
         KRYBFOOkpV38HoeG4LPFuRF9X8DlpC59n9spA0Zrvy+mmmt0Ue3dx4+Zt73otQRfFzFD
         v3Zt3Axl7JMLSGTwO2wfyU4CMOyKXlGc/yF/3u/FoGRmmWM6DvWfaUUkBr/OBw62//nu
         GK3YWGhjfwK+1UPTuyvSg0nuWt9adp+YiWX61UegR/HwiHntuG90/EVplXw0ccwf8eBs
         gPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=210/esXBpcQ81FnwB14NVVrED+udY/8GQjymUvVa4Ys=;
        b=jQqOZQB+0RSjPzycIzqDEPA1gcml+A/ClXoMHtGCjE3kZlBJJFmr5AwoUKGt5BTc1V
         p1Zt+8M5T4Ad2F7U1J6r2JyevVlHWLiV9g9LctC150yE49d57QYsaPaTu5ZTi6W8BGZ6
         FBnVgsUkvzMRg2ZUTAwhJgYiaxXpxhQC1ssC99Pydzb+BC53OQTafcdrl1QV2+wi/82g
         pKGEZEJXX6gLCDnv5FH6VHG9tYYsPyyuDct73R+9/6nfh8AKxgncIxY81SB1BhXKhpr9
         XW4qurFXsnvDSttuwNRm4ogBD++zD6eht1uhN7JDH1aDPF05GWQm4Ek54ejvzM2xNH4D
         9U9g==
X-Gm-Message-State: AOAM531OAxHU7Isjf2FayFh6JkfU0oJpZJWe0bawdQZpeMy9YoG+DDP7
        vN4P5xZvTOxE6ydqEl9UyPYRED2niJJgIa7c
X-Google-Smtp-Source: ABdhPJyNtPJZliU36OLS80F4OdI1Ib1ed91NmBoK9MZB81SU85X3zMFmUBMYy32OBI0oR8t0aExEfg==
X-Received: by 2002:a92:9115:: with SMTP id t21mr11568814ild.33.1600100766973;
        Mon, 14 Sep 2020 09:26:06 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm7032261ilq.29.2020.09.14.09.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:26:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: drop 'ctx' ref on task work cancelation
Date:   Mon, 14 Sep 2020 10:25:52 -0600
Message-Id: <20200914162555.1502094-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914162555.1502094-1-axboe@kernel.dk>
References: <20200914162555.1502094-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If task_work ends up being marked for cancelation, we go through a
cancelation helper instead of the queue path. In converting task_work to
always hold a ctx reference, this path was missed. Make sure that
io_req_task_cancel() puts the reference that is being held against the
ctx.

Fixes: 6d816e088c35 ("io_uring: hold 'ctx' reference around task_work queue + execute")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be9d628e7854..01756a131be6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1787,8 +1787,10 @@ static void __io_req_task_cancel(struct io_kiocb *req, int error)
 static void io_req_task_cancel(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 
 	__io_req_task_cancel(req, -ECANCELED);
+	percpu_ref_put(&ctx->refs);
 }
 
 static void __io_req_task_submit(struct io_kiocb *req)
-- 
2.28.0

