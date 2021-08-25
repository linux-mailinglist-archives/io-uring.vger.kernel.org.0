Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF3E3F7CDF
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242497AbhHYTxH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 15:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbhHYTxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 15:53:07 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA6BC061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:52:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id g135so261188wme.5
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7wlyBzepVtGnDKIVnYIiKSvOM2KbK3jKsaByg/HT3Lk=;
        b=AcfOilARCZOxW/bMKc9ki3baJbdnRbsLktL2u1XXykMZf+QpKmGH4DIpAI2kY3hRyB
         OPhocW3gFZcX82fIu/q3i+iEhW6dVqmUikmyZVv5JD1nP7plCqLvgZtVzwwJI7rQ5NiX
         fcmGXOIiPBJXuhBxeYydIldt9b598IxvPiQw/Dktttt3UCsdURKxsBPK40OSkdNjmVtA
         SamueT9THw5dk2TtgDvZFeQWmUEoZGg6GDE0tg2xsIehOoYKgBXjxPRpZEpL5VxOEhPT
         a1/ugQRvkGQh3w5NRyBgJytKQj07vJOkUE1QcmxihRd3Vsg7WqcXxBAONZxE42R2tLl/
         ggcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wlyBzepVtGnDKIVnYIiKSvOM2KbK3jKsaByg/HT3Lk=;
        b=s5+gEY6RylW6m+fCfgswamsRM9dO53ZFMHXAbHp1Ntv2c5JWfkDirxPk9ZQIbKs3+D
         2rI9Kdl4bBznTGAtnBfYqa4CzuXfDd8yaQ26bQiY9QJBE1NCDpGNolwxkHZWUi42GIJC
         de+IWPe+jNv/h1g/mnB1XMUSRKtT4MBhQz/0d9gxEClKj8+k67Wp/EhCeel9Oncz78Bv
         tjd5gZ7bEB41K7pqinuaJI51BN8WHd095cHpZ2MExZPCSMuw5lDLyJNhxoh+e8D/OGn+
         5IzXrs1wsq5c2iIxCBVQ47y8Kr9Hd0MEa6qNL1m4fCGNDHyXe9NwbQ9sHR+HUajJPNbj
         Ky2A==
X-Gm-Message-State: AOAM5327vBa0MwSkSU7crEghcskVJEhe470wALtxTnkJ8ErTpJgc1RJp
        9xIz8PIRxXxaGDU+92/hbx4=
X-Google-Smtp-Source: ABdhPJwEIXBLuT9a3DJf5ZyxlUZNmNslhUPat79EgrFMajJ3Oq2hzr3y4eEduLVMXy2EaTL1tWTUWw==
X-Received: by 2002:a7b:c956:: with SMTP id i22mr5170301wml.82.1629921139696;
        Wed, 25 Aug 2021 12:52:19 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id m12sm820386wrq.29.2021.08.25.12.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 12:52:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: clarify io_req_task_cancel() locking
Date:   Wed, 25 Aug 2021 20:51:39 +0100
Message-Id: <71099083835f983a1fd73d5a3da6391924da8300.1629920396.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629920396.git.asml.silence@gmail.com>
References: <cover.1629920396.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's too easy to forget and misjudge about synchronisation in
io_req_task_cancel(), add a comment clarifying it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 15728e63d6f9..712605fd04c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2138,7 +2138,7 @@ static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	/* ctx is guaranteed to stay alive while we hold uring_lock */
+	/* not needed for normal modes, but SQPOLL depends on it */
 	io_tw_lock(ctx, locked);
 	io_req_complete_failed(req, req->result);
 }
@@ -2147,7 +2147,6 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	io_tw_lock(ctx, locked);
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (likely(!(req->task->flags & PF_EXITING)))
-- 
2.32.0

