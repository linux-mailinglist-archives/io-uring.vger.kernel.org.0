Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E373B5019
	for <lists+io-uring@lfdr.de>; Sat, 26 Jun 2021 22:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhFZUni (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Jun 2021 16:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFZUni (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Jun 2021 16:43:38 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B57C061574
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:14 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id k30-20020a05600c1c9eb02901d4d33c5ca0so2729395wms.3
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YZKi4/8WqeeInSnYQNFbgXIu+Xt//ZL5FkUNXVwGNnY=;
        b=KVnm+emsg0FfVnS6AWnCnxTIOgp9JKkOKIRtuciihGNbxfbf3TceGrOLDpEvCECHr+
         oD2P/ezYlmYROgiEjxFs1N9rGVrdowPo81aMEpxNPttavgd0g+WlUILL9UTNLglT9ieY
         Eh4filQkqp5edQWuNTIgOOqCnBqhKiuwpmO54jPfbJvOHUki/ktBN41DIbiF8/c3GJuJ
         ym+vy1RfHbOwOVWzDkSaEjj8JR9urA7ERs6dh9IW30lj/Jftmn3xqwvbRDsX2Y7CgCPv
         KQfO5/SQeqb8q6my8BM6ru7WulWz05u28dv7hD/Q+mp4PtSH+r5A6Ss/2T7RxIDRXnpJ
         9ODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YZKi4/8WqeeInSnYQNFbgXIu+Xt//ZL5FkUNXVwGNnY=;
        b=OyniWZSptfbWVSvXFVWwmqtoxcjRFTlpbBowETSz1p5cd/SYoBml17asXsWzf5uY9H
         ZTEFrtFQm6COjNAdTAiRuGhCs5rUwgvECeqPkHxOABPuTJpdjyidLAfMhnEplCf0yxDI
         lIfpTxVhhrpChPGdlMDT97BpJDZWnwfwXJeIdPBtnr42P8rhbdwZ2Elacfe9X5rXke7C
         CSUe/2NqLY8y4+YWtnr6WSU3tN4wM57opbWuFyayqKhVnX1MX0Y5weYvlCSqzBNQdUK1
         AYn2peoEiP7Qt2wmnh2rB/l5rQwdjZS9Lh5/8E3rVlyT+A3XEWEBE8kWpLw7U7P+4iQ6
         QDvA==
X-Gm-Message-State: AOAM5320B6rx5txWbY84H6zSQUIKuoWjrdSiw3Uz+Vi7njgpWFI4wlwu
        sXbKzkrB96sRSzL4VFDrzwDU4MyHdviDDg==
X-Google-Smtp-Source: ABdhPJz1kIVrHeoyeI3dWHP6/6c9NrosYXCc+kfMPKTnPHFT+I6JJfqaDHF/eggzDXrClUx2vG1Ngg==
X-Received: by 2002:a7b:c846:: with SMTP id c6mr17561324wml.182.1624740073134;
        Sat, 26 Jun 2021 13:41:13 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.84])
        by smtp.gmail.com with ESMTPSA id b9sm11272613wrh.81.2021.06.26.13.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 13:41:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/6] io_uring: mainstream sqpoll task_work running
Date:   Sat, 26 Jun 2021 21:40:45 +0100
Message-Id: <24eb5e35d519c590d3dffbd694b4c61a5fe49029.1624739600.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624739600.git.asml.silence@gmail.com>
References: <cover.1624739600.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

task_works are widely used, so place io_run_task_work() directly into
the main path of io_sq_thread(), and remove it from other places where
it's not needed anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0822e01e2d71..f10cdb92f771 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7064,7 +7064,6 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 		cond_resched();
 		mutex_lock(&sqd->lock);
 	}
-	io_run_task_work();
 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 }
 
@@ -7093,7 +7092,6 @@ static int io_sq_thread(void *data)
 			if (io_sqd_handle_event(sqd))
 				break;
 			timeout = jiffies + sqd->sq_thread_idle;
-			continue;
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
@@ -7103,9 +7101,10 @@ static int io_sq_thread(void *data)
 			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
+		if (io_run_task_work())
+			sqt_spin = true;
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
-			io_run_task_work();
 			cond_resched();
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
@@ -7113,7 +7112,7 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!io_sqd_events_pending(sqd) && !io_run_task_work()) {
+		if (!io_sqd_events_pending(sqd) && !current->task_works) {
 			bool needs_sched = true;
 
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-- 
2.32.0

