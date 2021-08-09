Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C713E4536
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhHIMFb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbhHIMFa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:30 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F8DC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q11so2881882wrr.9
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AB3upIntrJ65wiSIy6kov8vqOyn0PMqeWwxCxSDz/0c=;
        b=ZApCkUpe0kG6N/UwI1vFYdDKIO6QANflH75Vzdamo+3YgXI9xXY167+LLw7x9SfKJK
         tlOK3QlkR1KnWKaoG7E2fPZ6rZw4V7ZxvwsqxH10XATX9V+9bpCED5tzatC7yZHG9Aor
         zljvDK1e6o9krSuhMVNplNuHtoLEycP5/RyIU6H/zDX3y4rEd/rlhLPj5KxgSzKlXMbm
         UzyICCGIk/ulbfC1WAoyq+zfPDWM2uTd5PO7A5txKtU0cCZ/ytOyIZVuXONO53KQ2J3v
         XPiOzfo1aYESJ1rjDGzAQReRnvrdU2VwEdQ9voTd7XPL2eSWXBd4pzy16cylhcNuXWW1
         SSfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AB3upIntrJ65wiSIy6kov8vqOyn0PMqeWwxCxSDz/0c=;
        b=tOD3hK978NtZTs3WVkisCbXJkhBPcQtp3R8WNfBX5nXeochms/35yGx82MN5PYrERf
         xwFzTXx5eK2VAdZAW48cgPu6VxJRHV3mWLSs7VBLOwECepjvP14YkUTE+5uslU/TCDWB
         NDlRTSHIjRljGjE2lDpQ8lJkUnmvu5BUIkm2j116YSsPaZVIM3DiUK3tkis/fXExY8RE
         Vnmkh8jhNzK4GObAgGfTxl0y/4wxSzf2cAkKJFBA7L5b6JUAN2CXqSIWaNkF1/goYWHz
         hvhfl37wOna+nZ1JYLL36woL/kqkFh6XtKhqhIvlU9yiBYxY3OD/IdipD737BswbpnQ4
         8OKw==
X-Gm-Message-State: AOAM533mlz4SfNuCCfVlWBvxgVLFK6FH5FYlSXU49vLgigvQbeNlKAdF
        G262/MDkea7DX5C6eKGVRTI=
X-Google-Smtp-Source: ABdhPJz+hqzhAlnxmacn6KMW/jQkIzb2y8UTw/Kvtbc12puZtz/GAfK3TRIz4/7kXSQgFUPwrSdu8Q==
X-Received: by 2002:a5d:6451:: with SMTP id d17mr7559350wrw.154.1628510709038;
        Mon, 09 Aug 2021 05:05:09 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/28] io_uring: remove unnecessary PF_EXITING check
Date:   Mon,  9 Aug 2021 13:04:06 +0100
Message-Id: <fc14297e8441cd8f5d1743a2488cf0df09bf48ac.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We prefer nornal task_works even if it would fail requests inside. Kill
a PF_EXITING check in io_req_task_work_add(), task_work_add() handles
well dying tasks, i.e. return error when can't enqueue due to late
stages of do_exit().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8f18af509afd..ba1df6ae6024 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2003,8 +2003,6 @@ static void io_req_task_work_add(struct io_kiocb *req)
 	if (test_bit(0, &tctx->task_state) ||
 	    test_and_set_bit(0, &tctx->task_state))
 		return;
-	if (unlikely(tsk->flags & PF_EXITING))
-		goto fail;
 
 	/*
 	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
@@ -2017,7 +2015,7 @@ static void io_req_task_work_add(struct io_kiocb *req)
 		wake_up_process(tsk);
 		return;
 	}
-fail:
+
 	clear_bit(0, &tctx->task_state);
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	node = tctx->task_list.first;
-- 
2.32.0

